import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_firestore_helper/setting_fb.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_firestore_helper/user_order_fb.dart';
import 'package:samay_admin_plan/models/category_model/category_model.dart';
import 'package:samay_admin_plan/models/salon_setting_model/salon_setting_model.dart';
import 'package:samay_admin_plan/models/save_date/save_appointment_date.dart';
import 'package:samay_admin_plan/models/service_model/service_model.dart';
import 'package:samay_admin_plan/models/super_cate/super_cate.dart';

class ServiceProvider extends ChangeNotifier {
  List<CategoryModel> _categoryList = [];
  List<SuperCategoryModel> _superCategoryList = [];
  List<SuperCategoryModel> get getSuperCategoryList => _superCategoryList;

  List<ServiceModel> _servicesList = [];
  CategoryModel? _selectedCategory;
  CategoryModel? _category;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<CategoryModel> get getCategoryList => _categoryList;

  List<ServiceModel> get getserviceList => _servicesList;
  CategoryModel? get selectedCategory => _selectedCategory;
  CategoryModel? get getCategory => _category;

  SettingModel? _settingModel;
  SettingModel? get getSettingModel => _settingModel;

  // GST Apply flag
  bool _isGSTApply = false;
  bool get getIsGSTApply => _isGSTApply;

  SaveDateModel? _saveDateModel;
  SaveDateModel? get getSaveDateModel => _saveDateModel;
  List<SaveDateModel> appointDate = [];

  //Select Super category

  // String? _selectSuperCate;
  // String? get getSelectSuperCate => _selectSuperCate;

  SuperCategoryModel? _selectSuperCategoryModel;
  SuperCategoryModel? get getSelectSuperCategoryModel =>
      _selectSuperCategoryModel;

// Fatch Appointment date
  Future<void> fetchAppointmentDatePro(String adminId, String salonId) async {
    appointDate =
        await UserBookingFB.instance.getAppointmentDate(adminId, salonId);
    notifyListeners();
  }

//Fatch Setting for Firebase
  Future<void> fetchSettingPro(String salonId) async {
    _settingModel = await SettingFb.instance.fetchSettingFromFB(salonId);
    _isGSTApply = _settingModel!.gstNo.length == 15 ? true : false;
    notifyListeners();
  }

//! -------------- Super Cetegory Pro -------------------
//Function to fatch CategoryList
  Future<void> getSuperCategoryListPro(String salonId) async {
    _superCategoryList = await FirebaseFirestoreHelper.instance
        .getSuperCategoryListFirebase(salonId);
    notifyListeners();
  }

  // Create Default categories.
  Future<SuperCategoryModel?> initializeSuperCategory(
    String superCategoryName,
    String salonId,
    String imgUrl,
    String serviceFor,
    BuildContext context,
  ) async {
    SuperCategoryModel superCategoryModel = await FirebaseFirestoreHelper
        .instance
        .initializeSuperCategoryCollection(
            superCategoryName, salonId, imgUrl, serviceFor, context);
    _superCategoryList.add(superCategoryModel);
    print("Length is  ${_categoryList.length}");
    notifyListeners();
    return superCategoryModel;
  }

  //Function to create new category to List
  void addNewSuperCategoryPro(
    String adminId,
    String salonId,
    String superCategoryName,
    String sericeFor,
    BuildContext context,
  ) async {
    SuperCategoryModel superCategoryModel =
        await FirebaseFirestoreHelper.instance.addNewSuperCategoryFirebase(
            adminId, salonId, superCategoryName, sericeFor, context);
    _superCategoryList.add(superCategoryModel);
    notifyListeners();
  }

  // Update a single Category
  void updateSingleSuperCategoryPro(
      SuperCategoryModel superCategoryModel) async {
    await FirebaseFirestoreHelper.instance
        .updateSingleSuperCategoryFirebase(superCategoryModel);

    // Find the index and update the item
    int index = _superCategoryList
        .indexWhere((element) => element.id == superCategoryModel.id);
    if (index != -1) {
      _superCategoryList[index] = superCategoryModel;
    }

    notifyListeners();
  }

  //Delete singleCategory
  // This funtcion give error "DartError: Unexpected null value."
  Future<void> deleteSingleSuperCategoryPro(
      SuperCategoryModel supercateoryModel) async {
    bool val = await FirebaseFirestoreHelper.instance
        .deleteSingleSuperCategoryFb(supercateoryModel);
    if (val) {
      _superCategoryList.removeWhere(
        (element) => element.id == supercateoryModel.id,
      );
    }
    notifyListeners();
  }

  void selectSuperCatePro(SuperCategoryModel value) {
    _selectSuperCategoryModel = value;
  }

//! --------------  Cetegory Pro -------------------

//Function to fatch CategoryList
  Future<void> getCategoryListPro(
      String salonId, String superCategoryName) async {
    _categoryList = await FirebaseFirestoreHelper.instance
        .getCategoryListFirebase(salonId, superCategoryName);
    notifyListeners();
  }

  // Create Default categories.
  Future<CategoryModel?> initializeCategory(
    String categoryName,
    String salonId,
    String superCategoryName,
    String serviceFor,
    BuildContext context,
  ) async {
    CategoryModel categoryModel = await FirebaseFirestoreHelper.instance
        .initializeCategoryCollection(
            categoryName, salonId, superCategoryName, serviceFor, context);
    _categoryList.add(categoryModel);
    print("Length is  ${_categoryList.length}");
    notifyListeners();
    return categoryModel;
  }

//Function to create new category to List
  void addNewCategoryPro(
    String adminId,
    String salonId,
    String categoryName,
    String superCategoryName,
    String serviceFor,
    BuildContext context,
  ) async {
    CategoryModel categoryModel = await FirebaseFirestoreHelper.instance
        .addNewCategoryFirebase(adminId, categoryName, salonId,
            superCategoryName, serviceFor, context);
    _categoryList.add(categoryModel);
    notifyListeners();
  }

  //Function to fatch services
  Stream<List<ServiceModel>> getServicesListFirebase(
    String salonId,
    String categoryId,
  ) {
    return FirebaseFirestore.instance
        .collection("admins")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('salon')
        .doc(salonId)
        .collection("category")
        .doc(categoryId)
        .collection("service")
        .snapshots()
        .map((snapshots) => snapshots.docs
            .map((doc) => ServiceModel.fromJson(doc.data()))
            .toList());
  }

  // Update a Single Services
  void updateSingleServicePro(ServiceModel serviceModel) async {
    bool _val = await FirebaseFirestoreHelper.instance
        .updateSingleServiceFirebae(serviceModel);

    // Find the index and update the item
    int index =
        _servicesList.indexWhere((element) => element.id == serviceModel.id);
    if (index != -1) {
      _servicesList[index] = serviceModel;
    }
  }

//Delete Single Services
  Future<void> deletelSingleServicePro(ServiceModel serviceModel) async {
    bool val = await FirebaseFirestoreHelper.instance
        .deleteServiceFirebase(serviceModel);
    if (val) {
      _servicesList.removeWhere((element) => element.id == serviceModel.id);
      notifyListeners();
    }
  }

  Future<void> callBackFunction(String salonId) async {
    await getSuperCategoryListPro(salonId);
    // await getCategoryListPro(salonId);
    getServicesListFirebase;
    notifyListeners();
  }

  //! Category Function

  void selectCategory(CategoryModel category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Update a single Category
  void updateSingleCategoryPro(CategoryModel categoryModel) async {
    await FirebaseFirestoreHelper.instance
        .updateSingleCategoryFirebase(categoryModel);
    // Find the index and update the item
    int index =
        _categoryList.indexWhere((element) => element.id == categoryModel.id);
    if (index != -1) {
      _categoryList[index] = categoryModel;
    }

    notifyListeners();
  }

//Delete singleCategory
  Future<void> deleteSingleCategoryPro(CategoryModel categoryModel) async {
    bool val = await FirebaseFirestoreHelper.instance
        .deleteSingleCategoryFb(categoryModel);
    if (val) {
      _categoryList.remove(categoryModel);
    }
    notifyListeners();
  }

  // Add new services .
  Future<void> addSingleServicePro(
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
    int hours,
    int min,
    String description,
    String serviceFor,
  ) async {
    int _serviceDurationMin = 0;
    Duration _serviceDurMin = Duration(hours: hours, minutes: min);
    ServiceModel serviceModel =
        await FirebaseFirestoreHelper.instance.addServiceFirebase(
      adminId,
      salonId,
      categoryId,
      categoryName,
      superCategoryName,
      servicesName,
      serviceCode,
      price,
      originalPrice,
      discountInPer,
      discountAmount,
      _serviceDurMin.inMinutes,
      description,
      serviceFor,
    );
    _servicesList.add(serviceModel);
    notifyListeners();
  }

  Future<void> callBackServicePro(String salonId) async {
    fetchSettingPro(salonId);
    // fetchVenderPaymentDetailsPro(salonId);
  }
}
