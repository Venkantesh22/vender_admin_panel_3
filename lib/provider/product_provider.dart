// ignore_for_file: avoid_print, no_leading_underscores_for_local_identifiers

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:samay_admin_plan/constants/global_variable.dart';
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
      _productSubCategoryList = await ProductFb.instance
          .getListOfProductSubCategoryFb(samayId, categoryId);
      print("Sub category list : -${_productSubCategoryList.length}");
      notifyListeners();
    } catch (e) {
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

  Future<void> getListProductPro() async {
    try {
      final _samayId =
          GlobalVariable.samayCollectionId; // Use the correct variable

      _productList = await ProductFb.instance.getListOfProductFB(_samayId);
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

      await _firebaseFirestore
          .collection('SalonProduct')
          .doc(productModel.id)
          .delete();
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
}
