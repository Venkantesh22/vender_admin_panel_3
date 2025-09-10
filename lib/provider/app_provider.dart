// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/constants/global_variable.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_storage_helper/firebase_storage_helper.dart';
import 'package:samay_admin_plan/models/Product/Product_Model/product_model.dart';
import 'package:samay_admin_plan/models/admin_model/admin_models.dart';
import 'package:samay_admin_plan/models/appoint_model/appoint_model.dart';
import 'package:samay_admin_plan/models/salon_form_models/salon_infor_model.dart';
import 'package:flutter/material.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:samay_admin_plan/models/service_model/service_model.dart';

class AppProvider with ChangeNotifier {
  SalonModel? _salonModel;
  SalonModel get getSalonInformation => _salonModel!;

  AdminModel? _adminModel;
  AdminModel get getAdminInformation => _adminModel!;

  final bool _isDarkMode = true;
  bool get isDarkMode => _isDarkMode;

  ThemeMode _themeMode = ThemeMode.dark; // Initialize with a default value
  ThemeMode get themeMode => _themeMode; // Getter for themeMode

  void toggleThemeMode() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners(); // Notify listeners when theme mode changes
  }

  List<ServiceModel> serviceListFetchID = [];
  List<ServiceModel> get getServiceListFetchID => serviceListFetchID;

  List<ProductModel> productListFetchID = [];
  List<ProductModel> get getProductListFetchID => productListFetchID;

  Map<ProductModel, int> productListWithQty = {};
  Map<ProductModel, int> get getProductListWithQty => productListWithQty;

  AppointModel? selectAppointModel;
  AppointModel? get getSelectAppointModel => selectAppointModel;

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
    Uint8List? imageLogo,
  }) async {
    showLoaderDialog(context);
    try {
      imageLogo != null
          ? print("Logo is provider")
          : print("Logo is not  provider");

      _salonModel = salonModel;

      // Update main image if provided
      if (image != null) {
        String? uploadImageUrl =
            await FirebaseStorageHelper.instance.uploadSalonImageToStorage(
          "${salonModel.id}image",
          "${GlobalVariable.salon}${salonModel.id}Image",
          image,
        );
        salonModel.image = uploadImageUrl;
      }

      // Update logo image if provided
      if (imageLogo != null) {
        String? uploadLogoUrl =
            await FirebaseStorageHelper.instance.uploadSalonLogImageToStorage(
          "${salonModel.id}log",
          "${GlobalVariable.salon}${salonModel.id}Image",
          imageLogo,
        );
        salonModel.logImage = uploadLogoUrl;
      }

      // Update Firestore with the latest salonModel
      await FirebaseFirestore.instance
          .collection("admins")
          .doc(_adminModel!.id)
          .collection('salon')
          .doc(_salonModel!.id)
          .set(_salonModel!.toJson());

      Navigator.of(context, rootNavigator: true).pop(); // Close loader
      showMessage("Successfully updated ${GlobalVariable.salon} profile");
      notifyListeners();
      return true;
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop(); // Ensure loader closes
      showMessage("Failed to update profile: $e");
      return false;
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
          .updateAdminImage(image, adminModel.image, _adminModel!);

      _adminModel = _adminModel?.copyWith(image: uploadImageUrl);
      // _adminModel!.image = uploadImageUrl!;
      await FirebaseFirestore.instance
          .collection("admins")
          .doc(_adminModel!.id)
          .set(_adminModel!.toJson());
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.of(context).pop();
      notifyListeners();

      return true;
    }
  }

  // Fetch appoint Service List by Service id list
  Future<void> fetchServiceListByListId({
    required List<String> serviceIds,
  }) async {
    print("serviceIds length ${serviceIds.length}");

    if (serviceIds != null && serviceIds.isNotEmpty) {
      serviceListFetchID = await FirebaseFirestoreHelper.instance
          .fetchServicesByListIds(serviceIds: serviceIds);
      print("serviceListFetchID length ${serviceListFetchID.length}");
    } else {
      serviceListFetchID = [];
    }
    print("serviceListFetchID length ${serviceListFetchID.length}");
    notifyListeners();
  }

  // Fetch appoint Product List by Product id list

  Future<void> fetchProductListByListId({
    required List<String> productIds,
    required Map<String, int>? productIdQtyMap, // <-- Add this parameter
  }) async {
    productListFetchID.clear(); // Clear previous data
    productListFetchID = await FirebaseFirestoreHelper.instance
        .fetchProductByListIds(productIds: productIds);
    // Clear and update productListWithQty

    productListWithQty.clear();

    if (productIdQtyMap != null) {
      for (final product in productListFetchID) {
        final qty = productIdQtyMap[product.id] ?? 0;
        productListWithQty[product] = qty; // Use a List as key
      }
    }
    notifyListeners();
  }

  //? update select appoint model
  void updateSelectAppointModel(AppointModel appointModel) {
    selectAppointModel = appointModel;
    print("update ${selectAppointModel!.appointmentInfo!.appointmentNo}");
    notifyListeners();
  }

  void updateServiceTOserviceListFetchID({
    required List<ServiceModel> serviceList,
  }) {
    serviceListFetchID = serviceList;
    print(
        "update updateServiceTOserviceListFetchID ${serviceListFetchID.length}");
    notifyListeners();
  }

  void updateProductToProductListWithQty({
    required Map<ProductModel, int> productMap,
  }) {
    productListWithQty = productMap;
    print(
        "update updateProductToProductListWithQty ${productListWithQty.length}");

    notifyListeners();
  }

  //? Fetch single appoint
}
