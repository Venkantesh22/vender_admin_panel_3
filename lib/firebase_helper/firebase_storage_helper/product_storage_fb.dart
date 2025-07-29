import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:samay_admin_plan/models/Product/Product_Model/product_model.dart';

class ProductStorageFb {
  static ProductStorageFb instance = ProductStorageFb();
  final FirebaseStorage _storage = FirebaseStorage.instance;

//! --------- PRODUCT FUNCTION ---------------

  // add Product image
  Future<String?> uploadProductImageToStorage(
      String imageName, String folderName, Uint8List selectedImage) async {
    try {
      Reference imageRef = _storage
          .ref("salon/Product/Product_image/$folderName/$imageName.jpg");
      UploadTask task = imageRef.putData(
          selectedImage, SettableMetadata(contentType: 'image/jpeg'));
      TaskSnapshot snapshot = await task;
      String imageUrl = await snapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print("Error uploadProductImageToStorage() image: $e");
      rethrow;
    }
  }

  // update Product image
  Future<String?> updateProductImage(Uint8List newImagePath, String oldImageUrl,
      ProductModel productModel) async {
    try {
      if (oldImageUrl.isNotEmpty) {
        await deleteImageFromFirebase(oldImageUrl);
      }
      String? imageUrl = await uploadProductImageToStorage(
        productModel.id,
        productModel.name,
        newImagePath,
      );
      return imageUrl;
    } catch (e) {
      print("Error updateProductImage image: $e");
      return null;
    }
  }

  //delete image from firebase\
  Future<void> deleteImageFromFirebase(String imageUrl) async {
    try {
      // Create a reference to the file to delete
      final storageRef = FirebaseStorage.instance.refFromURL(imageUrl);

      // Delete the file
      await storageRef.delete();

      print("Image deleted successfully");
    } catch (e) {
      print("Error occurred while deleting the image: $e");
    }
  }
}
