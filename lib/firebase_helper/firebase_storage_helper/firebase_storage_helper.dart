import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/models/admin_model/admin_models.dart';
import 'package:samay_admin_plan/models/salon_form_models/salon_infor_model.dart';

class FirebaseStorageHelper {
  static FirebaseStorageHelper instance = FirebaseStorageHelper();
  final FirebaseStorage _storage = FirebaseStorage.instance;

//!--- add Admin Profile Image---------
  Future<String?> uploadAdminProfileImageToStorage(
      String imageName, String folderName, Uint8List selectedImage) async {
    try {
      Reference imageRef = _storage
          .ref(" salon /admin/admin_Profile/$folderName/$imageName.jpg");
      UploadTask task = imageRef.putData(
          selectedImage, SettableMetadata(contentType: 'image/jpeg'));
      TaskSnapshot snapshot = await task;
      String imageUrl = await snapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      showMessage("Error uploading image: ${e.toString()}");
      print("Error uploading image: $e");
      return null;
    }
  }

  // update admin Profile Image
  Future<String?> updateAdminImage(
      Uint8List newImagePath, String oldImageUrl, AdminModel adminModel) async {
    // First, delete the old image if it exists
    if (oldImageUrl.isNotEmpty) {
      await deleteImageFromFirebase(oldImageUrl);
    }

    String? imageUrl = await uploadAdminProfileImageToStorage(
      adminModel.name,
      adminModel.id,
      newImagePath,
    );

    return imageUrl;
  }

//!--- add Salon Profile Image--------------
  Future<String?> uploadSalonImageToStorage(
      String imageName, String folderName, Uint8List selectedImage) async {
    try {
      Reference imageRef = _storage
          .ref("salon/Salon_Profile/salon_Profile/$folderName/$imageName.jpg");
      UploadTask task = imageRef.putData(
          selectedImage, SettableMetadata(contentType: 'image/jpeg'));
      TaskSnapshot snapshot = await task;
      String imageUrl = await snapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      showMessage("Error uploading image: ${e.toString()}");
      print("Error uploading image: $e");
      return null;
    }
  }

  // update salon Profile Image
  Future<String?> updateProfileImage(
      Uint8List newImagePath, String oldImageUrl, SalonModel salonModel) async {
    // First, delete the old image if it exists
    if (oldImageUrl.isNotEmpty) {
      await deleteImageFromFirebase(oldImageUrl);
    }

    // Then upload the new image

    String? imageUrl = await uploadSalonImageToStorage(
      salonModel.name,
      salonModel.id,
      newImagePath,
    );

    return imageUrl;
  }

//!--- add Salon log Image--------------
  Future<String?> uploadSalonLogImageToStorage(
      String imageName, String folderName, Uint8List selectedImage) async {
    try {
      Reference imageRef =
          _storage.ref("salon/Salon_Profile/log/$folderName/$imageName.jpg");
      UploadTask task = imageRef.putData(
          selectedImage, SettableMetadata(contentType: 'image/jpeg'));
      TaskSnapshot snapshot = await task;
      String imageUrl = await snapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      showMessage("Error uploading image: ${e.toString()}");
      print("Error uploading image: $e");
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
