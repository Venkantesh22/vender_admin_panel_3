// ignore_for_file: avoid_print, no_leading_underscores_for_local_identifiers, prefer_final_fields, unnecessary_null_comparison

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:samay_admin_plan/constants/global_variable.dart';
import 'package:samay_admin_plan/features/product/widget/branch_filter.dart';
import 'package:samay_admin_plan/features/product/widget/sub_cate.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_firestore_helper/product_fb.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_storage_helper/product_storage_fb.dart';
import 'package:samay_admin_plan/models/Product/Product_Model/product_model.dart';
import 'package:samay_admin_plan/models/Product/brand_model/brand_model.dart';
import 'package:samay_admin_plan/models/Product/product%20category%20model/product_category_model.dart';
import 'package:samay_admin_plan/models/Product/product_branch_model.dart/product_branch_model.dart';
import 'package:samay_admin_plan/models/Product/product_sub_category_model/product_sub_category_model.dart';

class ProductProvider with ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

//! --------- BRAND FUNCTION ---------------

  List<BrandModel> _brandList = [];
  List<BrandModel> get getBrandList => _brandList;

  BrandModel? _selectBrandModel;
  BrandModel? get getSelectBrandModel => _selectBrandModel;

  //Get all Brand Model
  Future<void> getListOfBrandModelPro() async {
    String samayId = GlobalVariable.samayCollectionId;
    _brandList = await ProductFb.instance.getListOfProductBrand(samayId);
    _brandList.sort((a, b) => a.order.compareTo(b.order));
    print("Length of Brand ${_brandList.length}");
    notifyListeners();
  }

  //  select Brand
  void updateSelectBrand(BrandModel value) {
    _selectBrandModel = value;
    print("Select Brand: ${_selectBrandModel!.name}");
    notifyListeners();
  }

  //! ---------  CATEGORY FUNCTION ---------------

  BrandCategoryModel? _selectBrandCategoryModel;
  BrandCategoryModel? get getSelectBrandCategoryModel =>
      _selectBrandCategoryModel;

  List<BrandCategoryModel> _productCategoryList = [];
  List<BrandCategoryModel> get getProductCategoryList => _productCategoryList;

  bool _isCategoryLoading = false;
  bool get isCategoryLoading => _isCategoryLoading;

  // Get the list  Category of brand
  Future<void> getListOfProductCategoryListPro() async {
    setCategoryLoading(true);
    try {
      String samayId = GlobalVariable.samayCollectionId;
      _productCategoryList =
          await ProductFb.instance.getListOfBrandCategory(samayId);
      _productCategoryList.sort((a, b) => a.order.compareTo(b.order));
      print("Length of Category ${_productCategoryList.length}");
    } finally {
      setCategoryLoading(false);
    }
    notifyListeners();
  }

  // update a select category
  void updateSelectBrandCateModel(BrandCategoryModel brandCategoryModel) {
    _selectBrandCategoryModel = brandCategoryModel;
    print("Select Category Model is ${_selectBrandCategoryModel!.name}");
    notifyListeners();
  }

  // When you start loading categories:
  void setCategoryLoading(bool value) {
    _isCategoryLoading = value;
    notifyListeners();
  }

//! --------- SUB-CATEGORY FUNCTION ---------------
  ProductSubCateModel? _selectSubCategory;
  ProductSubCateModel? get getSelectSubCategory => _selectSubCategory;

  bool _productSubCategoryLoading = false;
  bool get getProductSubCategoryLoading => _productSubCategoryLoading;

  List<ProductSubCateModel> _productSubCategoryList = [];
  List<ProductSubCateModel> get getProductSubCategoryList =>
      _productSubCategoryList;

  // get List of Sub category of Category id
  Future<void> getListOfProductSubCategoryPro(String categoryId) async {
    try {
      updateProductSubCategoryLoading(true);
      final samayId =
          GlobalVariable.samayCollectionId; // Use the correct variable
      if (samayId == null || samayId.isEmpty) {
        throw Exception("Samay Collection ID is not set.");
      }
      print("Sub -category $categoryId");
      _productSubCategoryList = await ProductFb.instance
          .getListOfProductSubCategoryFb(samayId, categoryId);
      _productSubCategoryList.sort((a, b) => a.order.compareTo(b.order));
      print("Sub category list : -${_productSubCategoryList.length}");
      notifyListeners();
    } finally {
      updateProductSubCategoryLoading(false);
    }
  }

  //update a Loading of Sub - category
  void updateProductSubCategoryLoading(bool value) {
    _productSubCategoryLoading = value;
    notifyListeners();
  }

  // update a select Sub - category
  void updateSelectSubCategoryPro(ProductSubCateModel value) {
    _selectSubCategory = value;
    print("Select Sub-category :- ${value.name}");
    notifyListeners();
  }

  //! --------- SUB-CATEGORY BRANCH FUNCTION PRO ---------------

  ProductBranchModel? _selectProductBranchModel;
  ProductBranchModel? get getSelectProductBranchModel =>
      _selectProductBranchModel;

  bool _productBranchLoading = false;
  bool get getProductBranchLoading => _productBranchLoading;

  List<ProductBranchModel> _productBranchModelList = [];
  List<ProductBranchModel> get getProductBranchModelList =>
      _productBranchModelList;

  // get List of Brach of Category id
  Future<void> getListOfProductBranchPro(
      String categoryId, String subCategoryId) async {
    try {
      updateProductBranchLoading(true);
      final samayId =
          GlobalVariable.samayCollectionId; // Use the correct variable
      if (samayId == null || samayId.isEmpty) {
        throw Exception("Samay Collection ID is not set.");
      }
      _productBranchModelList = await ProductFb.instance
          .getListOfProductBranchFb(samayId, categoryId, subCategoryId);
      print(
          "_productBranchModelList length : ${_productBranchModelList.length}");
      notifyListeners();
    } catch (e) {
      print("Error in getListOfProductBranchPro() $e");
    } finally {
      updateProductBranchLoading(false);
    }
  }

  // update a select branch
  void updateSelectBranchPro(ProductBranchModel value) {
    _selectProductBranchModel = value;
    print("Select branch :- ${_selectProductBranchModel!.name}");
    notifyListeners();
  }

  //update a Loading of branch
  void updateProductBranchLoading(bool value) {
    _productBranchLoading = value;
    notifyListeners();
  }

  //! --------- PRODUCT FUNCTION PRO ---------------
  ProductModel? selectProductModel;
  ProductModel? get getSelectProductModel => selectProductModel;

  List<ProductModel> _productList = [];
  List<ProductModel> get getProductList => _productList;

// add new product
  Future<void> addNewProductPro(
      ProductModel productModel, Uint8List selectImage) async {
    try {
      final samayId =
          GlobalVariable.samayCollectionId; // Use the correct variable
      if (samayId == null || samayId.isEmpty) {
        throw Exception("Samay Collection ID is not set.");
      }
      ProductModel newProductModel =
          await ProductFb.instance.addNewProductFB(productModel, selectImage);
      _productList.add(newProductModel);
      notifyListeners();
    } catch (e) {
      print("Error addNewProductPro() $e ");
    }
  }

// get List  of product

  Future<void> getListProductPro(String salonId) async {
    try {
      final _samayId =
          GlobalVariable.samayCollectionId; // Use the correct variable

      _productList = await ProductFb.instance.getListOfProductFB(salonId);
      _productList
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      _productFilterList = List.from(_productList)
        ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      notifyListeners();
    } catch (e) {
      print("Error getListProductPro() $e ");
    }
  }

  // get update product by id
  Future<void> updateProductPro(
      ProductModel productModel, Uint8List? updateImage) async {
    try {
      final _samayId =
          GlobalVariable.samayCollectionId; // Use the correct variable
      if (updateImage != null) {
        String? updateImgUrl = await ProductStorageFb.instance
            .updateProductImage(updateImage, productModel.imgUrl, productModel);

        ProductModel updateProductModel = productModel.copyWith(
          imgUrl: updateImgUrl,
        );

        await _firebaseFirestore
            .collection('SalonProduct')
            .doc(productModel.id)
            .update(updateProductModel.toJson());
        // Update the brand in _brandList
        int index =
            _productList.indexWhere((e) => e.id == updateProductModel.id);
        if (index != -1) {
          _productList[index] = updateProductModel;
        }
      } else {
        await _firebaseFirestore
            .collection('SalonProduct')
            .doc(productModel.id)
            .update(productModel.toJson());
        // Update the brand in _brandList
        int index = _productList.indexWhere((e) => e.id == productModel.id);
        if (index != -1) {
          _productList[index] = productModel;
        }
      }

      notifyListeners();
    } catch (e) {
      print("Error updateProductPro() $e ");
    }
  }

  // delete product by id
  Future<void> deleteProductByIdPro(ProductModel productModel) async {
    try {
      final _samayId =
          GlobalVariable.samayCollectionId; // Use the correct variable

      await ProductStorageFb.instance
          .deleteImageFromFirebase(productModel.imgUrl);
      await _firebaseFirestore
          .collection('SalonProduct')
          .doc(productModel.id)
          .delete();
      _productList.removeWhere((product) => product.id == productModel.id);
      notifyListeners();
    } catch (e) {
      print("Error deleteProductByIdPro() $e ");
    }
  }

  // update select ProductModel
  void updateSelectProductModel(ProductModel productModel) {
    selectProductModel = productModel;
    print("Select Product Model: ${selectProductModel!.name}");
    notifyListeners();
  }

//! -------------------- FILTERS FUNCTION FOR PRODUCT-----------------------------
//! -------------------- FILTERS FUNCTION FOR PRODUCT-----------------------------
//!---------------------------- Category function ---------------------

  List<BrandCategoryModel> _selectCategoryListFilter = [];
  List<BrandCategoryModel> get getSelectCategoryListFilter =>
      _selectCategoryListFilter;

  void addSelectCategoryListFilterPro(BrandCategoryModel brandCategoryModel) {
    _selectCategoryListFilter.add(brandCategoryModel);
    print(
        "Select category  : ${brandCategoryModel.name}  ${_selectCategoryListFilter.length}");
    notifyListeners();
  }

  void removeSelectCategoryListFilterPro(
      BrandCategoryModel brandCategoryModel) {
    _selectCategoryListFilter
        .removeWhere((cate) => cate.id == brandCategoryModel.id);

    print(
        "remove category  : ${brandCategoryModel.name}  ${_selectCategoryListFilter.length}");
    notifyListeners();
  }

  //!------------------- Sub-Category function filter -------------------
  List<ProductSubCateModel> _selectSubCategoryListFilter = [];
  List<ProductSubCateModel> get getSelectSubCategoryListFilter =>
      _selectSubCategoryListFilter;

  List<SubCateFilter> _subCateModelListFilter = [];
  List<SubCateFilter> get getSubCateModelListFilter => _subCateModelListFilter;

  bool _isSubCategoryLoadingFilter = false;
  bool get getIsSubCategoryLoadingFilter => _isSubCategoryLoadingFilter;

  Future<void> fetchSubCateListFilterPro(
      BrandCategoryModel brandCategoryModel) async {
    try {
      updateSubCateFilterLoading(true);
      await getListOfProductSubCategoryPro(brandCategoryModel.id);

      SubCateFilter _subCate = SubCateFilter(
          brandCategoryModel: brandCategoryModel,
          subCateList: _productSubCategoryList
            ..sort((a, b) {
              // Check if any of the names is "other"
              if (a.name.toLowerCase() == "other" &&
                  b.name.toLowerCase() != "other") {
                return 1; // "Other" goes after all other items
              } else if (a.name.toLowerCase() != "other" &&
                  b.name.toLowerCase() == "other") {
                return -1; // Non-"Other" comes before "Other"
              } else {
                // Normal alphabetical sorting for all other items
                return a.name.toLowerCase().compareTo(b.name.toLowerCase());
              }
            }));
      _subCateModelListFilter.add(_subCate);
      print("_subCateModelListFilter:- ${_subCateModelListFilter.length} ");

      updateSubCateFilterLoading(false);
      notifyListeners();
    } catch (e) {
      print("Error fetchSubCateListFilterPro() $e ");
    }
  }

  // Remove all SubCategory of cateId for list of _subCategoryListFilter
  void removeAllSubCateForList(String cateId) {
    updateSubCateFilterLoading(true);

    // _subCategoryListFilter
    //     .removeWhere((subCate) => subCate.categoryId == cateId);
    _subCateModelListFilter
        .removeWhere((subCate) => subCate.brandCategoryModel.id == cateId);
    print("_subCateModelListFilter:- ${_subCateModelListFilter.length} ");

    updateSubCateFilterLoading(false);
    notifyListeners();
  }

// add single sub-cate to list of _selectSubCategoryListFilter
  void addSelectSubCategoryListFilterPro(
      ProductSubCateModel productSubCateModel) {
    _selectSubCategoryListFilter.add(productSubCateModel);
    print(
        "Select sub-category  : ${productSubCateModel.name}  ${_selectSubCategoryListFilter.length}");
    notifyListeners();
  }

// remove single sub-cate from list of _selectSubCategoryListFilter

  void removeSelectSubCategoryFilterListPro(
      ProductSubCateModel productSubCateModel) {
    _selectSubCategoryListFilter
        .removeWhere((cate) => cate.id == productSubCateModel.id);
    print(
        "remove  sub-category  : ${productSubCateModel.name}  ${_selectSubCategoryListFilter.length}");
    notifyListeners();
  }

  //update a Loading of Sub_category
  void updateSubCateFilterLoading(bool value) {
    _isSubCategoryLoadingFilter = value;
    notifyListeners();
  }

  //!------------------- Branch function filter -------------------

  List<ProductBranchModel> _selectBranchListFilter = [];
  List<ProductBranchModel> get getSelectBranchListFilter =>
      _selectBranchListFilter;

  List<BranchModelFilter> _branchModelFilterList = [];
  List<BranchModelFilter> get getBranchModelFilterList =>
      _branchModelFilterList;

  bool _isBranchLoadingFilter = false;
  bool get getIsBranchLoadingFilter => _isBranchLoadingFilter;

  Future<void> fetchBranchListFilter(
      String cateId, ProductSubCateModel productSubCateModel) async {
    try {
      updateBranchFilterLoading(true);

      await getListOfProductBranchPro(cateId, productSubCateModel.id);
      BranchModelFilter branch = BranchModelFilter(
          productSubCateModel: productSubCateModel,
          productBranchModelList: _productBranchModelList
            ..sort((a, b) {
              // Check if any of the names is "other"
              if (a.name.toLowerCase() == "other" &&
                  b.name.toLowerCase() != "other") {
                return 1; // "Other" goes after all other items
              } else if (a.name.toLowerCase() != "other" &&
                  b.name.toLowerCase() == "other") {
                return -1; // Non-"Other" comes before "Other"
              } else {
                // Normal alphabetical sorting for all other items
                return a.name.toLowerCase().compareTo(b.name.toLowerCase());
              }
            }));
      _branchModelFilterList.add(branch);

      print(
          " -------_branchModelFilterList:- ${_branchModelFilterList.length} ");

      updateBranchFilterLoading(false);
      notifyListeners();
    } catch (e) {
      print("Error fetchBranchListFilter() $e ");
    }
  }

  // Remove all Branch of SubCategoryID for list of _branchListFilter
  void removeAllBranchForList(String subCateId) {
    updateBranchFilterLoading(true);
    _branchModelFilterList
        .removeWhere((branch) => branch.productSubCateModel.id == subCateId);
    updateBranchFilterLoading(false);
    notifyListeners();
  }

// add single Branch to list of _branchListFilter
  void addSelectBranchListFilterPro(ProductBranchModel productBranchModel) {
    _selectBranchListFilter.add(productBranchModel);
    print(
        "Select branch  : ${productBranchModel.name}  ${_selectBranchListFilter.length}");
    notifyListeners();
  }

// remove single Branch from list of _branchListFilter

  void removeSelectBranchFilterListPro(ProductBranchModel productBranchModel) {
    _selectBranchListFilter
        .removeWhere((cate) => cate.id == productBranchModel.id);
    print(
        "remove  branch  : ${productBranchModel.name}  ${_selectBranchListFilter.length}");
    notifyListeners();
  }

//update a Loading of branch
  void updateBranchFilterLoading(bool value) {
    _isBranchLoadingFilter = value;
    notifyListeners();
  }

  //! --------- BRAND FUNCTION FILTER ---------------
  // User a (BRAND FUNCTION) functions
  List<BrandModel> _selectBrandModelFilterList = [];
  List<BrandModel> get getSelectBrandModelList => _selectBrandModelFilterList;

  // add single Brand to list of _selectBrandModelFilterList
  void addSelectBrandListFilterPro(BrandModel brandModel) {
    _selectBrandModelFilterList.add(brandModel);
    print(
        "Select brand  : ${brandModel.name}  ${_selectBrandModelFilterList.length}");
    notifyListeners();
  }

// remove single Brand from list of _branchListFilter

  void removeSelectBrandFilterListPro(BrandModel brandModel) {
    _selectBrandModelFilterList
        .removeWhere((brand) => brand.id == brandModel.id);
    print(
        "remove  branch  : ${brandModel.name}  ${_selectBrandModelFilterList.length}");
    notifyListeners();
  }

//! Visible is available or not

  bool _isVisibleProduct = true;
  bool get getIsVisibleProduct => _isVisibleProduct;

//update visible status of product
  void updateVisibleProductFilterPro(bool value) {
    _isVisibleProduct = value;
    print("_isVisibleProduct :- $_isVisibleProduct");
    notifyListeners();
  }

//! Stock is available or not

  String? _stockStatusFilter;
  String? get getStockStatusFilter => _stockStatusFilter;

  //update Stock status of product for filter

  void updateStockProductFilterPro(String? value) {
    _stockStatusFilter = value;
    print("_stockStatusFilter :- $_stockStatusFilter");
    notifyListeners();
  }

  //! ------- PRODUCT FILTER APPLY BUTTON FUNCTIONS  -----------------
  List<ProductModel> _productFilterList = [];
  List<ProductModel> get getProductFilterList => _productFilterList;

  bool filterApplyLoading = false;
  bool get getFilterApplyLoading => filterApplyLoading;

  void applyFilterPro() {
    // Start with all products
    updateFilterLoadingPro(true);
    _productFilterList = List.from(_productList);

    // 1. Category filter
    if (_selectCategoryListFilter.isNotEmpty) {
      final catIds = _selectCategoryListFilter.map((c) => c.id).toSet();
      _productFilterList =
          _productFilterList.where((p) => catIds.contains(p.cateId)).toList();
    }

    // 2. Sub‑category filter
    if (_selectSubCategoryListFilter.isNotEmpty) {
      final subIds = _selectSubCategoryListFilter.map((s) => s.id).toSet();
      _productFilterList = _productFilterList
          .where((p) => subIds.contains(p.subCateId))
          .toList();
    }

    // 3. Branch filter
    if (_selectBranchListFilter.isNotEmpty) {
      final branchIds = _selectBranchListFilter.map((b) => b.id).toSet();
      _productFilterList = _productFilterList
          .where((p) => branchIds.contains(p.branchId))
          .toList();
    }

    // 4. Brand filter
    if (_selectBrandModelFilterList.isNotEmpty) {
      final brandIds = _selectBrandModelFilterList.map((b) => b.id).toSet();
      _productFilterList = _productFilterList
          .where((p) => brandIds.contains(p.brandID))
          .toList();
    }

    // 5. Visibility filter ("visible" or "hidden")
    if (_isVisibleProduct != null) {
      if (_isVisibleProduct == true) {
        _productFilterList =
            _productFilterList.where((p) => p.visibility == true).toList();
      } else if (_isVisibleProduct == false) {
        _productFilterList =
            _productFilterList.where((p) => p.visibility == false).toList();
      }
      // you can add an 'inStock' branch similarly, or default case
    }

    // 6. Stock filter (override everything when out-of-stock)
    if (_stockStatusFilter != null) {
      if (_stockStatusFilter == GlobalVariable.outOfStock) {
        _productFilterList =
            _productFilterList.where((p) => p.stockQuantity == 0).toList();
      } else if (_stockStatusFilter == GlobalVariable.lowStock) {
        _productFilterList = _productFilterList
            .where((p) => p.stockQuantity > 0 && p.stockQuantity <= 10)
            .toList();
      }
      // you can add an 'inStock' branch similarly, or default case
    }
    _resetSearch();
    updateFilterLoadingPro(false);

    notifyListeners();
  }

  void updateFilterLoadingPro(bool value) {
    filterApplyLoading = value;
    print("filterApplyLoading :- $filterApplyLoading");
    notifyListeners();
  }

  //!--------------- SEARCH PRODUCT FUNCTION ---------------

  String _searchQuery = '';
  String? get getSearchQuery => _searchQuery;

  List<ProductModel> _productFilterSearchList = [];
  List<ProductModel> get getProductFilterSearchList => _productFilterSearchList;

  void applySearch(String query) {
    _searchQuery = query.trim().toLowerCase();

    if (_searchQuery.isEmpty) {
      // No query → show all filtered products
      _productFilterSearchList = List.from(_productFilterList);
    } else {
      _productFilterSearchList = _productFilterList.where((product) {
        return product.name.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    notifyListeners(); // if in a provider
    // or setState((){}) if in a stateful widget
  }

  // Call this once after loading or after applyFilterPro()
  void _resetSearch() {
    _productFilterSearchList = List.from(_productFilterList);
    applySearch(_searchQuery);
    notifyListeners();
  }

  //! FILTER BUTTON

  void reSetFilterPro() {
    _stockStatusFilter = null;
    _isVisibleProduct = true;
    // branch
    _selectBranchListFilter = [];
    _branchModelFilterList = [];
    _isBranchLoadingFilter = false;

    // Sub-category
    _selectSubCategoryListFilter = [];
    _subCateModelListFilter = [];
    _isSubCategoryLoadingFilter = false;

    // Category
    _selectCategoryListFilter = [];
    _selectBrandCategoryModel = null;
    _isCategoryLoading = false;

    // brand
    _selectBrandModelFilterList = [];
    _selectBrandModel = null;

    _productFilterList = List.from(_productList);
    updateFilterLoadingPro(false);
    applySearch(_searchQuery);

    notifyListeners();
  }
}
