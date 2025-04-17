import 'package:flutter/material.dart';
import 'package:samay_admin_plan/constants/global_variable.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_firestore_helper/samay_fb.dart';
import 'package:samay_admin_plan/models/image_model/image_model.dart';

class SamayProvider with ChangeNotifier {
  List<ImageModel> _superCateImageList = [];
  List<ImageModel> get getSupetCateImageList => _superCateImageList;

  late ImageModel hairImg;
  late ImageModel skinImg;
  late ImageModel maniPediImg;
  late ImageModel nailImg;
  late ImageModel makeUpImg;
  late ImageModel massageImg;

  // Getters to access the images
  ImageModel get getHairImg => hairImg;
  ImageModel get getSkinImg => skinImg;
  ImageModel get getManiPediImg => maniPediImg;
  ImageModel get getNailImg => nailImg;
  ImageModel get getMakeUpImg => makeUpImg;
  ImageModel get getMassageImg => massageImg;

//! Image Super category images for firebase
  // Fetch log images with error handling
  Future<void> getSuperCateImagePro() async {
    try {
      _superCateImageList = await SamayFB.instance.getSuperCateimageFB();
      // if (_superCateImageList.isNotEmpty) {
      //
      // } else {
      //   print("Super category image list is empty");
      // }
      print("Get all Image");
      notifyListeners();
    } catch (e) {
      print("Error fetching Super category images: $e");
    }
  }

  // Set log images (e.g., main logo, cartoon) with error handling
  Future<void> setImagePro() async {
    try {
      if (_superCateImageList.isNotEmpty) {
        for (var imageModel in _superCateImageList) {
          if (imageModel.name == GlobalVariable.supCatHair) {
            hairImg = imageModel;
          } else if (imageModel.name == GlobalVariable.supCatSkin) {
            skinImg = imageModel;
          } else if (imageModel.name == GlobalVariable.supCatManiPedi) {
            maniPediImg = imageModel;
          } else if (imageModel.name == GlobalVariable.supCatNail) {
            nailImg = imageModel;
          } else if (imageModel.name == GlobalVariable.supCatMakeUp) {
            makeUpImg = imageModel;
          } else if (imageModel.name == GlobalVariable.supCatMassage) {
            massageImg = imageModel;
          }
        }
        notifyListeners();
      } else {
        print("No images available to set from the super category image list.");
      }
    } catch (e) {
      print("Error setting super category images: $e");
    }
  }

  Future<void> callbackSamayPro() async {
    await getSuperCateImagePro();
    // setImagePro();
  }
}
