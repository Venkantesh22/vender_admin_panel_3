import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_storage_helper/product_storage_fb.dart';
import 'package:samay_admin_plan/models/Product/Product_Model/product_model.dart';
import 'package:samay_admin_plan/models/Product/brand_model/brand_model.dart';
import 'package:samay_admin_plan/models/Product/product%20category%20model/product_category_model.dart';
import 'package:samay_admin_plan/models/Product/product_branch_model.dart/product_branch_model.dart';
import 'package:samay_admin_plan/models/Product/product_sub_category_model/product_sub_category_model.dart';

class ProductFb {
  static ProductFb instance = ProductFb();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //! --------- BRAND FUNCTION ---------------
  Future<List<BrandModel>> getListOfProductBrand(String samayId) async {
    try {
      final querySnapshot = await _firebaseFirestore
          .collection('Samay')
          .doc(samayId)
          .collection('product_brands')
          .get();

      return querySnapshot.docs
          .map((doc) => BrandModel.fromJson(doc.data()))
          .toList();
    } on Exception catch (e) {
      // TODO
      print("Error getListOfProductBrand() brand: $e");

      rethrow;
    }
  }

  //! --------- BRAND CATEGORY FUNCTION ---------------

  Future<List<BrandCategoryModel>> getListOfBrandCategory(
    String samayId,
  ) async {
    try {
      final querySnapshot = await _firebaseFirestore
          .collection('Samay')
          .doc(samayId)
          .collection("productCategory")
          .get();

      return querySnapshot.docs
          .map((doc) => BrandCategoryModel.fromJson(doc.data()))
          .toList();
    } on Exception catch (e) {
      // TODO
      print("Error getListOfBrandCategory() brand: $e");

      rethrow;
    }
  }

  //! --------- BRAND SUB-CATEGORY FUNCTION ---------------

  // get list Sub category by Id of category
  Future<List<ProductSubCateModel>> getListOfProductSubCategoryFb(
      String samayId, String categoryId) async {
    try {
      final querySnapshot = await _firebaseFirestore
          .collection('Samay')
          .doc(samayId)
          .collection("productCategory")
          .doc(categoryId)
          .collection("productSubCategory")
          .get();

      return querySnapshot.docs
          .map((doc) => ProductSubCateModel.fromJson(doc.data()))
          .toList();
    } on Exception catch (e) {
      // TODO
      print("Error getListOfBrandSubCategory() brand: $e");

      rethrow;
    }
  }

  //! --------- PRODUCT BRANCH FUNCTION ---------------

  // get list Sub category by Id of category
  Future<List<ProductBranchModel>> getListOfProductBranchFb(
      String samayId, String categoryId, String subCategoryId) async {
    try {
      final querySnapshot = await _firebaseFirestore
          .collection('Samay')
          .doc(samayId)
          .collection("productCategory")
          .doc(categoryId)
          .collection("productSubCategory")
          .doc(subCategoryId)
          .collection("branch")
          .get();

      return querySnapshot.docs
          .map((doc) => ProductBranchModel.fromJson(doc.data()))
          .toList();
    } on Exception catch (e) {
      // TODO
      print("Error getListOfProductBranchFb() product: $e");
      rethrow;
    }
  }

  //! --------- PRODUCT  FUNCTION ---------------
// add new product
  Future<ProductModel> addNewProductFB(
      ProductModel productModel, Uint8List image) async {
    try {
      DocumentReference reference = await _firebaseFirestore
          .collection('SalonProduct')
          // .doc(productModel.salonId)
          // .collection("salonProductSave")
          .doc();
      String? imgUrl =
          await ProductStorageFb.instance.uploadProductImageToStorage(
        reference.id,
        productModel.name,
        image,
      );

      ProductModel updateProduct = productModel.copyWith(
        id: reference.id,
        imgUrl: imgUrl!,
      );
      await reference.set(updateProduct.toJson());
      return updateProduct;
    } catch (e) {
      print("Error in addNewProduct() product: $e");
      rethrow;
    }
  }

// get  product List
  Future<List<ProductModel>> getListOfProductFB(String samayId) async {
    try {
      final querySnapshot =
          await _firebaseFirestore.collection('SalonProduct').get();

      return querySnapshot.docs
          .map((doc) => ProductModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print("Error in getListOfProduct() product: $e");
      rethrow;
    }
  }
}
