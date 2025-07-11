// !create a function in firebase_helper
//first upload image then information
// ! call that function in provider
// ! call Provide in screen

// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/constants/global_variable.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_storage_helper/firebase_storage_helper.dart';
import 'package:samay_admin_plan/models/category_model/category_model.dart';
import 'package:samay_admin_plan/models/salon_form_models/salon_infor_model.dart';
import 'package:samay_admin_plan/models/service_model/service_model.dart';
import 'package:samay_admin_plan/models/super_cate/super_cate.dart';
import 'package:samay_admin_plan/models/timestamp_model/timestamp_model.dart';
// import 'package:samay_admin_plan/models/timestamped_model/date_time_model.dart';

class FirebaseFirestoreHelper {
  static FirebaseFirestoreHelper instance = FirebaseFirestoreHelper();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

// Add Salon Information under Admin
  Future<SalonModel> addSalon(
      Uint8List image,
      String salonName,
      String email,
      String mobile,
      String whatApp,
      String salonType,
      String description,
      String address,
      String city,
      String state,
      String country,
      String pinCode,
      TimeOfDay openTime,
      TimeOfDay closeTime,
      String instagram,
      String facebook,
      String googleMap,
      String linked,
      BuildContext context) async {
    try {
      String? adminUid = _auth.currentUser?.uid;

      DocumentReference reference = _firebaseFirestore
          .collection("admins")
          .doc(adminUid)
          .collection("salon")
          .doc();
      DocumentReference referenceTime = _firebaseFirestore
          .collection("admins")
          .doc(adminUid)
          .collection("salon")
          .doc();
      TimeStampModel _timeStampModel = TimeStampModel(
          id: referenceTime.id,
          dateAndTime: GlobalVariable.today,
          updateBy: "vender");

      SalonModel salonModel = SalonModel(
          id: reference.id,
          adminId: adminUid!,
          description: description,
          name: salonName,
          email: email,
          number: int.parse(mobile),
          whatApp: int.parse(whatApp),
          salonType: salonType,
          openTime: openTime,
          closeTime: closeTime,
          address: address,
          city: city,
          state: state,
          country: country,
          pinCode: pinCode,
          instagram: instagram,
          facebook: facebook,
          googleMap: googleMap,
          linked: linked,
          monday: '',
          tuesday: '',
          wednesday: '',
          thursday: '',
          friday: '',
          saturday: '',
          sunday: '',
          timeStampModel: _timeStampModel,
          isSettingAdd: false,
          isAccountValidBySamay: false);
      // upload image of create new folder then upload

      String? uploadImageUrl = await FirebaseStorageHelper.instance
          .uploadSalonImageToStorage(
              salonModel.id,
              "${GlobalVariable.salon}${salonModel.name}${salonModel.id}images",
              image);
      salonModel.image = uploadImageUrl;

      await reference.set(salonModel.toJson());

      return salonModel;
    } catch (e) {
      showMessage(e.toString());
      rethrow; // Ensure the error is still thrown
    }
  }

  //! Get Salon information
// Get salon information

  Future<SalonModel?> getSalonInformationFB() async {
    try {
      CollectionReference salonCollection = await _firebaseFirestore
          .collection("admins")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('salon');
      QuerySnapshot snapshot = await salonCollection.limit(1).get();
      if (snapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = snapshot.docs.first;
        return SalonModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }
      showMessage('fetching salon');
      print("salon data fetching");
    } catch (e) {
      showMessage('Error fetching salon: $e');
    }
    return null;
  }

  Stream<SalonModel?> getSalonInformationFBStream() {
    try {
      return _firebaseFirestore
          .collection("admins")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('salon')
          .limit(1)
          .snapshots()
          .map((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          DocumentSnapshot doc = snapshot.docs.first;
          return SalonModel.fromJson(
              doc.data() as Map<String, dynamic>, doc.id);
        }
        return null; // No salon data available
      });
    } catch (e) {
      showMessage('Error fetching salon: $e');
      return Stream.value(null);
    }
  }

  Future<SalonModel?> getSalonInformationByIdFB(String salonID) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc = await _firebaseFirestore
          .collection("admins")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('salon')
          .doc(salonID)
          .get();
      SalonModel _salonModel =
          SalonModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      showMessage('fetching salon');
      print("salon data fetching");

      return _salonModel;
    } catch (e) {
      showMessage('Error fetching salon: $e');
    }
    return null;
  }

  //! Super-Category Function
// initializeSuperCategoryCollection a Category
  Future<SuperCategoryModel> initializeSuperCategoryCollection(
    String superCategoryName,
    String salonId,
    String imgUrl,
    String serviceFor,
    BuildContext context,
  ) async {
    try {
      String? adminUid = FirebaseAuth.instance.currentUser?.uid;

      DocumentReference reference = _firebaseFirestore
          .collection("admins")
          .doc(adminUid)
          .collection("salon")
          .doc(salonId)
          .collection("supercategory")
          .doc();

      SuperCategoryModel superCategoryModel = SuperCategoryModel(
        id: reference.id,
        superCategoryName: superCategoryName,
        salonId: salonId,
        adminId: adminUid!,
        imgUrl: imgUrl,
        serviceFor: serviceFor,
      );

      await reference.set(superCategoryModel.toJson());
      return superCategoryModel;
    } catch (e) {
      showMessage("Error create Category ${e.toString()}");
      rethrow; // Ensure the error is still thrown
    }
  }

  // Add new super Category
  Future<SuperCategoryModel> addNewSuperCategoryFirebase(
    String adminId,
    String salonId,
    String superCategoryName,
    String sericeFor,
    BuildContext context,
  ) async {
    try {
      DocumentReference reference = _firebaseFirestore
          .collection("admins")
          .doc(adminId)
          .collection("salon")
          .doc(salonId)
          .collection("supercategory")
          .doc();

      SuperCategoryModel superCategoryModel = SuperCategoryModel(
        id: reference.id,
        superCategoryName: superCategoryName,
        salonId: salonId,
        haveData: false,
        adminId: adminId,
        serviceFor: sericeFor,
      );

      await reference.set(superCategoryModel.toJson());
      return superCategoryModel;
    } catch (e) {
      showBottomMessageError(
          "Error create new Super-Category ${e.toString()}", context);
      print("Error create new Super-Category ${e.toString()} ");
      rethrow; // Ensure the error is still thrown
    }
  }

  //Update a Super Category
  Future<void> updateSingleSuperCategoryFirebase(
      SuperCategoryModel superCateModel) async {
    try {
      String? adminUid = FirebaseAuth.instance.currentUser?.uid;
      await _firebaseFirestore
          .collection("admins")
          .doc(adminUid)
          .collection("salon")
          .doc(superCateModel.salonId)
          .collection("supercategory")
          .doc(superCateModel.id)
          .update(superCateModel.toJson());
    } catch (e) {
      print("Error : when update Super Category $e");
    }
  }

  //Delete Single Super Category
  Future<bool> deleteSingleSuperCategoryFb(
      SuperCategoryModel superCateModel) async {
    try {
      String? adminUid = FirebaseAuth.instance.currentUser?.uid;
      await _firebaseFirestore
          .collection("admins")
          .doc(adminUid)
          .collection("salon")
          .doc(superCateModel.salonId)
          .collection("supercategory")
          .doc(superCateModel.id)
          .delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Get category List
  Future<List<SuperCategoryModel>> getSuperCategoryListFirebase(
      String salonId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore
              .collection("admins")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('salon')
              .doc(salonId)
              .collection("supercategory")
              .get();
      List<SuperCategoryModel> superCateList = querySnapshot.docs
          .map((e) => SuperCategoryModel.fromJson(e.data()))
          .toList();
      return superCateList;
    } catch (e) {
      print("Error while get category List ${e.toString()}");
      rethrow;
    }
  }

  //! Category Function

// initializeCategoryCollection a Category
  Future<CategoryModel> initializeCategoryCollection(
    String categoryName,
    String salonId,
    String superCategoryName,
    String serviceFor,
    BuildContext context,
  ) async {
    try {
      String? adminUid = FirebaseAuth.instance.currentUser?.uid;

      DocumentReference reference = _firebaseFirestore
          .collection("admins")
          .doc(adminUid)
          .collection("salon")
          .doc(salonId)
          .collection("category")
          .doc();

      CategoryModel categoryModel = CategoryModel(
          id: reference.id,
          categoryName: categoryName,
          salonId: salonId,
          superCategoryName: superCategoryName,
          serviceFor: serviceFor);

      await reference.set(categoryModel.toJson());
      return categoryModel;
    } catch (e) {
      showMessage("Error create Category ${e.toString()}");
      rethrow; // Ensure the error is still thrown
    }
  }

// Add new Category
  Future<CategoryModel> addNewCategoryFirebase(
    String adminId,
    String categoryName,
    String salonId,
    String superCategoryName,
    String serviceFor,
    BuildContext context,
  ) async {
    try {
      DocumentReference reference = _firebaseFirestore
          .collection("admins")
          .doc(adminId)
          .collection("salon")
          .doc(salonId)
          .collection("category")
          .doc();

      CategoryModel categoryModel = CategoryModel(
          id: reference.id,
          categoryName: categoryName,
          salonId: salonId,
          superCategoryName: superCategoryName,
          haveData: false,
          serviceFor: serviceFor);

      await reference.set(categoryModel.toJson());
      return categoryModel;
    } catch (e) {
      rethrow; // Ensure the error is still thrown
    }
  }

//Update a Category
  Future<void> updateSingleCategoryFirebase(CategoryModel categoryModel) async {
    try {
      String? adminUid = FirebaseAuth.instance.currentUser?.uid;
      await _firebaseFirestore
          .collection("admins")
          .doc(adminUid)
          .collection("salon")
          .doc(categoryModel.salonId)
          .collection("category")
          .doc(categoryModel.id)
          .update(categoryModel.toJson());
    } catch (e) {
      print("Error : when update Category $e");
    }
  }

//Delete Single Category
  Future<bool> deleteSingleCategoryFb(CategoryModel categoryModel) async {
    try {
      String? adminUid = FirebaseAuth.instance.currentUser?.uid;
      await _firebaseFirestore
          .collection("admins")
          .doc(adminUid)
          .collection("salon")
          .doc(categoryModel.salonId)
          .collection("category")
          .doc(categoryModel.id)
          .delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<CategoryModel>> getCategoryListFirebase(
      String salonId, String superCategoryName) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore
              .collection("admins")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('salon')
              .doc(salonId)
              .collection("category")
              .where("superCategoryName", isEqualTo: superCategoryName)
              .get();

      if (querySnapshot.docs.isEmpty) {
        print(
            "No category data found for superCategoryName: $superCategoryName");
        return [];
      }

      List<CategoryModel> categoryList = querySnapshot.docs
          .map((doc) => CategoryModel.fromJson(doc.data()))
          .toList();
      return categoryList;
    } catch (e) {
      print("Error while getting category List: ${e.toString()}");
      // Optionally, you could rethrow or return an empty list if an error occurs.
      return [];
    }
  }

//!   Service Function
// Add Service to firebase Information under Admin/salon/category/services
  Future<ServiceModel> addServiceFirebase(
    String adminId,
    String salonId,
    String categoryId,
    String categoryName,
    String superCategoryName,
    String servicesName,
    String serviceCode,
    double price,
    double originalPrice,
    double discountInPer,
    double discountAmount,
    int serviceDurationMin,
    String description,
    String serviceFor,
  ) async {
    DocumentReference reference = _firebaseFirestore
        .collection("admins")
        .doc(adminId)
        .collection("salon")
        .doc(salonId)
        .collection("category")
        .doc(categoryId)
        .collection("service")
        .doc();

    ServiceModel addserviceModel = ServiceModel(
      salonId: salonId,
      categoryId: categoryId,
      categoryName: categoryName,
      superCategoryName: superCategoryName,
      id: reference.id,
      servicesName: servicesName,
      serviceCode: serviceCode,
      price: price,
      originalPrice: originalPrice,
      discountInPer: discountInPer,
      discountAmount: discountAmount,
      serviceDurationMin: serviceDurationMin,
      description: description,
      serviceFor: serviceFor,
    );

    await reference.set(addserviceModel.toJson());
    return addserviceModel;
  }

//Update Single Service for firebase
  Future<bool> updateSingleServiceFirebae(ServiceModel serviceModel) async {
    String? adminUid = FirebaseAuth.instance.currentUser?.uid;

    await _firebaseFirestore
        .collection("admins")
        .doc(adminUid)
        .collection("salon")
        .doc(serviceModel.salonId)
        .collection("category")
        .doc(serviceModel.categoryId)
        .collection("service")
        .doc(serviceModel.id)
        .update(serviceModel.toJson());
    return true;
  }

//Delete Single Service for firebase
  Future<bool> deleteServiceFirebase(ServiceModel serviceModel) async {
    try {
      String? adminUid = FirebaseAuth.instance.currentUser?.uid;

      await _firebaseFirestore
          .collection("admins")
          .doc(adminUid)
          .collection("salon")
          .doc(serviceModel.salonId)
          .collection("category")
          .doc(serviceModel.categoryId)
          .collection("service")
          .doc(serviceModel.id)
          .delete();
      return true;
    } catch (e) {
      return false;
    }
  }

//! Get Admin information
// Get Admin information
  Future<Map<String, dynamic>?> getAdminInformation() async {
    try {
      DocumentSnapshot doc = await _firebaseFirestore
          .collection('admins')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      }
    } catch (e) {
      showMessage('Error fetching admin info: ${e.toString()}');
      print('Error fetching admin info: $e');
    }
    return null;
  }
}
