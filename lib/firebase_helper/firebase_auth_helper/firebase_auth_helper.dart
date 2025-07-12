// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';
import 'package:bcrypt/bcrypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/constants/global_variable.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_storage_helper/firebase_storage_helper.dart';
import 'package:samay_admin_plan/models/SamayMembership/samay_membership_model.dart';
import 'package:samay_admin_plan/models/admin_model/admin_models.dart';
import 'package:samay_admin_plan/models/timestamp_model/timestamp_model.dart';

class FirebaseAuthHelper {
  static FirebaseAuthHelper instance = FirebaseAuthHelper();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  Stream<User?> get getAuthChange => _auth.authStateChanges();

  Future<bool> login(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      // 1) Sign in with FirebaseAuth
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // 2) Fetch the admin document from Firestore
      final uid = _auth.currentUser!.uid;
      final docSnapshot = await _firestore.collection("admins").doc(uid).get();
      final data = docSnapshot.data();

      if (data == null) {
        showBottomMessageError("User record not found", context);
        return false;
      }

      // 3) Extract the stored bcrypt hash and updateBy field
      final String storedHash = data['password'] as String? ?? "";
      // Note: your field is named "timeStampModel" in the document
      final String updatedBy =
          (data['timeStampModel']?['updateBy'] as String?) ?? "";

      // 4) Check the updateBy checkpoint
      if (updatedBy != "vendor") {
        await signOut();
        showBottomMessageError(
          "Invalid vendor login information. Please check your credentials.",
          context,
        );
        return false;
      }

      // 5) Verify the bcrypt hash
      final bool isMatch = BCrypt.checkpw(password, storedHash);
      if (!isMatch) {
        showBottomMessageError("Invalid credentials", context);
        return false;
      }

      // All checks passed
      return true;
    } on FirebaseAuthException catch (err) {
      // Close loader if still open
      showBottomMessageError(err.code, context);
      return false;
    } catch (e) {
      showBottomMessageError(e.toString(), context);
      return false;
    }
  }

  Future<bool> signUp(
    String name,
    String number,
    String email,
    String password,
    Uint8List selectedImage,
    BuildContext context,
  ) async {
    try {
      showLoaderDialog(context);

      // 1) Create account in FirebaseAuth
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      String uid = userCredential.user!.uid;

      // 2) Hash the password with bcrypt
      //    gensalt’s default cost is 10 which is fine for most apps.
      final String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

      // 3) Prepare timestamp & membership as before
      TimeStampModel timestamp = TimeStampModel(
        id: uid,
        dateAndTime: GlobalVariable.today,
        updateBy: "vendor",
      );
      SamayMembership membership = SamayMembership(
        id: uid,
        name: "NO",
        description: "NO",
        price: 0.0,
        durationInDays: 0,
        isActive: false,
      );

      // 4) Build AdminModel with the hashed password
      final admin = AdminModel(
        id: uid,
        name: name,
        email: email,
        number: int.parse(number),
        password: hashedPassword, // ← hashed!
        timeStampModel: timestamp,
        samayMembershipModel: membership,
      );

      // 5) Upload profile image
      final imageUrl = await FirebaseStorageHelper.instance
          .uploadAdminProfileImageToStorage(name, uid, selectedImage);
      admin.image = imageUrl!;

      // 6) Update FirebaseAuth profile (displayName & photoURL)
      await _auth.currentUser?.updateDisplayName(name);
      await _auth.currentUser?.updatePhotoURL(imageUrl);

      // 7) Save admin doc to Firestore
      await _firestore.collection("admins").doc(uid).set(admin.toJson());

      Navigator.of(context, rootNavigator: true).pop();
      return true;
    } on FirebaseAuthException catch (err) {
      Navigator.of(context, rootNavigator: true).pop();
      showMessage(err.code);
      return false;
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      showMessage(e.toString());
      return false;
    }
  }

  Future<bool> signOut() async {
    try {
      await _auth.signOut();
      return true;
    } catch (e) {
      showMessage('Error occurred');
      print(e.toString());
      return false;
    }
  }

  //Forget Password Function
  void resetPassword(String email) async {
    try {
      _auth.sendPasswordResetEmail(email: email);
      showMessage("Password Reset Email has been send!");
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        showMessage(" Invalid email.");
      }
    }
  }
}
