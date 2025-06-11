import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/global_variable.dart';
import 'package:samay_admin_plan/models/image_model/image_model.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';
import 'package:samay_admin_plan/provider/samay_provider.dart';
import 'package:samay_admin_plan/provider/service_provider.dart';

class InitializeDefaultCategory {
  static InitializeDefaultCategory instance = InitializeDefaultCategory();

  void createDefaultCategory(BuildContext context,
      ServiceProvider serviceProvider, AppProvider appProvider) {
    serviceProvider.initializeCategory(
        "Hair Cut",
        appProvider.getSalonInformation.id,
        GlobalVariable.supCatHair,
        GlobalVariable.serviceAtBoth,
        context);
    serviceProvider.initializeCategory(
        "Beard",
        appProvider.getSalonInformation.id,
        GlobalVariable.supCatHair,
        GlobalVariable.serviceAtBoth,
        context);
    serviceProvider.initializeCategory(
        "Threading",
        appProvider.getSalonInformation.id,
        GlobalVariable.supCatSkin,
        GlobalVariable.serviceAtBoth,
        context);
    serviceProvider.initializeCategory(
        "Hari Wash",
        appProvider.getSalonInformation.id,
        GlobalVariable.supCatHair,
        GlobalVariable.serviceAtBoth,
        context);
    serviceProvider.initializeCategory(
        "Head Massage",
        appProvider.getSalonInformation.id,
        GlobalVariable.supCatMassage,
        GlobalVariable.serviceAtBoth,
        context);
    serviceProvider.initializeCategory(
        "Hair Styling",
        appProvider.getSalonInformation.id,
        GlobalVariable.supCatHair,
        GlobalVariable.serviceAtBoth,
        context);
    serviceProvider.initializeCategory(
        "Hair Spa",
        appProvider.getSalonInformation.id,
        GlobalVariable.supCatHair,
        GlobalVariable.serviceAtBoth,
        context);
    serviceProvider.initializeCategory(
        "Hair Color",
        appProvider.getSalonInformation.id,
        GlobalVariable.supCatHair,
        GlobalVariable.serviceAtBoth,
        context);
    serviceProvider.initializeCategory(
        "Hair Texture",
        appProvider.getSalonInformation.id,
        GlobalVariable.supCatHair,
        GlobalVariable.serviceAtBoth,
        context);
    serviceProvider.initializeCategory(
        "Facial",
        appProvider.getSalonInformation.id,
        GlobalVariable.supCatHair,
        GlobalVariable.serviceAtBoth,
        context);
    serviceProvider.initializeCategory(
        "Facial",
        appProvider.getSalonInformation.id,
        GlobalVariable.supCatSkin,
        GlobalVariable.serviceAtBoth,
        context);
    serviceProvider.initializeCategory(
        "Bleach",
        appProvider.getSalonInformation.id,
        GlobalVariable.supCatSkin,
        GlobalVariable.serviceAtBoth,
        context);
    serviceProvider.initializeCategory(
        "Clean Up",
        appProvider.getSalonInformation.id,
        GlobalVariable.supCatSkin,
        GlobalVariable.serviceAtBoth,
        context);
    serviceProvider.initializeCategory(
        "Waxing",
        appProvider.getSalonInformation.id,
        GlobalVariable.supCatSkin,
        GlobalVariable.serviceAtBoth,
        context);
    serviceProvider.initializeCategory(
        "D Tan",
        appProvider.getSalonInformation.id,
        GlobalVariable.supCatSkin,
        GlobalVariable.serviceAtBoth,
        context);
    serviceProvider.initializeCategory(
        "Pedicure",
        appProvider.getSalonInformation.id,
        GlobalVariable.supCatManiPedi,
        GlobalVariable.serviceAtBoth,
        context);
    serviceProvider.initializeCategory(
        "Manicure",
        appProvider.getSalonInformation.id,
        GlobalVariable.supCatManiPedi,
        GlobalVariable.serviceAtBoth,
        context);
    serviceProvider.initializeCategory(
        "Massage",
        appProvider.getSalonInformation.id,
        GlobalVariable.supCatMassage,
        GlobalVariable.serviceAtBoth,
        context);
    serviceProvider.initializeCategory(
        "Body Polish",
        appProvider.getSalonInformation.id,
        GlobalVariable.supCatSkin,
        GlobalVariable.serviceAtBoth,
        context);
    serviceProvider.initializeCategory(
        "Nail",
        appProvider.getSalonInformation.id,
        GlobalVariable.supCatNail,
        GlobalVariable.serviceAtBoth,
        context);
    serviceProvider.initializeCategory(
        "Makeup",
        appProvider.getSalonInformation.id,
        GlobalVariable.supCatMakeUp,
        GlobalVariable.serviceAtBoth,
        context);
    serviceProvider.initializeCategory(
        "Bridal Package",
        appProvider.getSalonInformation.id,
        GlobalVariable.supCatMakeUp,
        GlobalVariable.serviceAtBoth,
        context);
    serviceProvider.initializeCategory(
        "Party Makeup",
        appProvider.getSalonInformation.id,
        GlobalVariable.supCatMakeUp,
        GlobalVariable.serviceAtBoth,
        context);
  }

  void createDefaultSuperCategory(BuildContext context,
      ServiceProvider serviceProvider, AppProvider appProvider) async {
    SamayProvider samayProvider =
        Provider.of<SamayProvider>(context, listen: false);

    List<ImageModel> superCateImage = samayProvider.getSupetCateImageList;

    serviceProvider.initializeSuperCategory(
        GlobalVariable.supCatHair,
        appProvider.getSalonInformation.id,
        samayProvider.getHairImg.image,
        GlobalVariable.serviceAtBoth,
        context);
    serviceProvider.initializeSuperCategory(
        GlobalVariable.supCatSkin,
        appProvider.getSalonInformation.id,
        samayProvider.getSkinImg.image,
        GlobalVariable.serviceAtBoth,
        context);
    serviceProvider.initializeSuperCategory(
        GlobalVariable.supCatManiPedi,
        appProvider.getSalonInformation.id,
        samayProvider.getManiPediImg.image,
        GlobalVariable.serviceAtBoth,
        context);
    serviceProvider.initializeSuperCategory(
        GlobalVariable.supCatNail,
        appProvider.getSalonInformation.id,
        samayProvider.getNailImg.image,
        GlobalVariable.serviceAtBoth,
        context);
    serviceProvider.initializeSuperCategory(
        GlobalVariable.supCatMakeUp,
        appProvider.getSalonInformation.id,
        samayProvider.getMakeUpImg.image,
        GlobalVariable.serviceAtBoth,
        context);
    serviceProvider.initializeSuperCategory(
        GlobalVariable.supCatMassage,
        appProvider.getSalonInformation.id,
        samayProvider.getMassageImg.image,
        GlobalVariable.serviceAtBoth,
        context);
    serviceProvider.initializeSuperCategory(
        GlobalVariable.supCatOther,
        appProvider.getSalonInformation.id,
        "",
        GlobalVariable.serviceAtBoth,
        context);
  }
}
