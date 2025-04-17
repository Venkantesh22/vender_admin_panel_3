// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

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
      String email, String password, BuildContext context) async {
    try {
      showLoaderDialog(context);
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.of(context, rootNavigator: true).pop();
      return true;
    } on FirebaseAuthException catch (error) {
      Navigator.of(context, rootNavigator: true).pop();
      showMessage(error.code.toString());
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

      // Create admin account
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Upload image to storage
      String uidOfCreateUser = userCredential.user!.uid;

      TimeStampModel _timeStampModel = TimeStampModel(
          id: uidOfCreateUser,
          dateAndTime: GlobalVariable.today,
          updateBy: "vender");

      // No Plan is add
      SamayMembership samayMembership = SamayMembership(
        id: uidOfCreateUser,
        name: "NO",
        description: "NO",
        price: 0.0,
        durationInDays: 0,
        isActive: false,
      );

      final adminData = AdminModel(
        id: uidOfCreateUser,
        name: name,
        email: email,
        number: int.parse(number),
        password: password,
        timeStampModel: _timeStampModel,
        samayMembershipModel: samayMembership,
        // isSalonProfileCreate: false,
      );

      String? uploadImageUrl =
          await FirebaseStorageHelper.instance.uploadAdminProfileImageToStorage(
        adminData.name,
        adminData.id,
        selectedImage,
      );

      await _auth.currentUser?.updateDisplayName(adminData.name);
      await _auth.currentUser?.updatePhotoURL(uploadImageUrl);

      // Save admin data to Firestore
      adminData.image = uploadImageUrl!; // Make sure image URL is included
      await _firestore
          .collection("admins")
          .doc(adminData.id)
          .set(adminData.toJson());

      // Navigator.of(context, rootNavigator: true).pop();
      return true;
    } on FirebaseAuthException catch (error) {
      Navigator.of(context, rootNavigator: true).pop();
      debugPrint(error.code.toString());
      showMessage(error.code.toString());
      return false;
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      debugPrint(e.toString());
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
