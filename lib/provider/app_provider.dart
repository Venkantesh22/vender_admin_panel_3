// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/constants/global_variable.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_firestore_helper/samay_fb.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_storage_helper/firebase_storage_helper.dart';
import 'package:samay_admin_plan/models/admin_model/admin_models.dart';
import 'package:samay_admin_plan/models/image_model/image_model.dart';
import 'package:samay_admin_plan/models/salon_form_models/salon_infor_model.dart';
import 'package:flutter/material.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';

class AppProvider with ChangeNotifier {
  SalonModel? _salonModel;
  SalonModel get getSalonInformation => _salonModel!;

  AdminModel? _adminModel;
  AdminModel get getAdminInformation => _adminModel!;

  List<ImageModel> _logImageList = [];
  List<ImageModel> get getLogImageList => _logImageList;

  // Log images
  // late ImageModel _logo;
  // ImageModel get getLogo => _logo;

  late ImageModel _cartoon;
  ImageModel get getcartoon => _cartoon;

  bool _isDarkMode = true;
  bool get isDarkMode => _isDarkMode;

  ThemeMode _themeMode = ThemeMode.dark; // Initialize with a default value
  ThemeMode get themeMode => _themeMode; // Getter for themeMode

  void toggleThemeMode() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners(); // Notify listeners when theme mode changes
  }

//! Image logo images for firebase
  // Fetch log images with error handling
  // Future<void> getLogImagePro() async {
  //   try {
  //     _logImageList = await SamayFB.instance.logimageFB();
  //     if (_logImageList.isNotEmpty) {
  //       notifyListeners();
  //     } else {
  //       print("Log image list is empty");
  //     }
  //   } catch (e) {
  //     print("Error fetching log images: $e");
  //   }
  // }

  // Set log images (e.g., main logo, cartoon) with error handling
  // Future<void> setImagePro() async {
  //   try {
  //     if (_logImageList.isNotEmpty) {
  //       for (var imageModel in _logImageList) {
  //         if (imageModel.name == "main_logo") {
  //           _logo = imageModel;
  //         }
  //         if (imageModel.name == "cartoon") {
  //           _cartoon = imageModel;
  //         }
  //       }
  //       notifyListeners();
  //     } else {
  //       print("No images available to set from log image list");
  //     }
  //   } catch (e) {
  //     print("Error setting log images: $e");
  //   }
  // }

  // Combined function to handle callback and update after images are fetched
  Future<void> callBackFunction() async {
    try {
      // await getLogImagePro(); // Fetch log images

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        // await setImagePro(); // Set log images after build phase completes
      });
    } catch (e) {
      print("Error in callback function: $e");
    }
  }

  // Add a Salon infor to firebase
  Future<void> addsalonInfoForm(
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
    SalonModel salonModel = await FirebaseFirestoreHelper.instance.addSalon(
        image,
        salonName,
        email,
        mobile,
        whatApp,
        salonType,
        description,
        address,
        city,
        state,
        country,
        pinCode,
        openTime,
        closeTime,
        instagram,
        facebook,
        googleMap,
        linked,
        context);
    GlobalVariable.salonID = salonModel.id;
    notifyListeners();
  }

// Fetch a Salon infor
  Future<void> getSalonInfoFirebase() async {
    _salonModel =
        await FirebaseFirestoreHelper.instance.getSalonInformationFB();
    notifyListeners();
  }

// Fetch a Admin infor
  Future<void> getAdminInfoFirebase() async {
    Map<String, dynamic>? adminData =
        await FirebaseFirestoreHelper.instance.getAdminInformation();
    if (adminData != null) {
      _adminModel = AdminModel.fromJson(
        adminData,
      );
      notifyListeners();
    }
  }

// Update a Salon infor
  Future<bool> updateSalonInfoFirebase(
    BuildContext context,
    SalonModel salonModel, {
    Uint8List? image,
  }) async {
    if (image == null) {
      // showLoaderDialog(context);

      _salonModel = salonModel;
      await FirebaseFirestore.instance
          .collection("admins")
          .doc(_adminModel!.id)
          .collection('salon')
          .doc(_salonModel!.id)
          .set(_salonModel!.toJson());
      // Navigator.of(context, rootNavigator: true).pop();
      // Navigator.of(context).pop();
      showMessage("Successfully updated ${GlobalVariable.salon} profile");
      print(
          " ########################Salon update ###############################################################");
      notifyListeners();
      return true;
    } else {
      showLoaderDialog(context);
      _salonModel = salonModel;
      String? uploadImageUrl = await FirebaseStorageHelper.instance
          .uploadSalonImageToStorage(
              salonModel.id,
              "${GlobalVariable.salon}${salonModel.name}${salonModel.id}images",
              image);
      salonModel.image = uploadImageUrl;
      await FirebaseFirestore.instance
          .collection("admins")
          .doc(_adminModel!.id)
          .collection('salon')
          .doc(_salonModel!.id)
          .set(_salonModel!.toJson());
      Navigator.of(context, rootNavigator: true).pop();
      // Navigator.of(context).pop();
      notifyListeners();

      // showMessage("Successfully updated ${GlobalVariable.salon} profile");
      return true;
    }
  }

// Update a Admin infor
  Future<bool> updateAdminInfoPro(
    BuildContext context,
    AdminModel adminModel, {
    Uint8List? image,
  }) async {
    if (image == null) {
      showLoaderDialog(context);

      _adminModel = adminModel;
      await FirebaseFirestore.instance
          .collection("admins")
          .doc(_adminModel!.id)
          .set(_adminModel!.toJson());
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.of(context).pop();
      return true;
    } else {
      showLoaderDialog(context);
      _adminModel = adminModel;
      String? uploadImageUrl = await FirebaseStorageHelper.instance
          .updateAdminImage(image, adminModel.image!, _adminModel!);

      _adminModel!.image = uploadImageUrl!;
      await FirebaseFirestore.instance
          .collection("admins")
          .doc(_adminModel!.id)
          .set(_adminModel!.toJson());
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.of(context).pop();
      notifyListeners();

      // showMessage("Successfully updated ${GlobalVariable.salon} profile");
      return true;
    }
  }
}
