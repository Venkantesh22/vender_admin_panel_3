// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/features/popup/edit_super_category_pop.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:samay_admin_plan/models/super_cate/super_cate.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';
import 'package:samay_admin_plan/provider/service_provider.dart';
import 'package:samay_admin_plan/utility/dimension.dart';

class SuperCateImage extends StatefulWidget {
  final SuperCategoryModel superCategoryModel;

  const SuperCateImage({
    super.key,
    required this.superCategoryModel,
  });

  @override
  State<SuperCateImage> createState() => _SuperCateImageState();
}

class _SuperCateImageState extends State<SuperCateImage> {
  final bool _hasImageError = false;

  void deleteSuperCategory(
      ServiceProvider serviceProvider, AppProvider appProvider) async {
    () async {
      showDeleteAlertDialog(
        context,
        "Delete Super-Category",
        "Do you want to delete ${widget.superCategoryModel.superCategoryName} Super-Category",
        () async {
          try {
            showLoaderDialog(context);
            await serviceProvider
                .deleteSingleSuperCategoryPro(widget.superCategoryModel);

            Navigator.of(context, rootNavigator: true).pop();

            await serviceProvider
                .getSuperCategoryListPro(appProvider.getSalonInformation.id);

            if (serviceProvider.getCategoryList.isNotEmpty) {
              serviceProvider
                  .selectCategory(serviceProvider.getCategoryList[0]);
            }

            Navigator.of(context).pop();
            showBottomMessage(
                "Successfully deleted ${widget.superCategoryModel.superCategoryName}",
                context);
          } catch (e) {
            Navigator.of(context).pop();
            showBottomMessageError(
                "Error deleting ${widget.superCategoryModel.superCategoryName}",
                context);
          }
        },
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    ServiceProvider serviceProvider = Provider.of<ServiceProvider>(context);
    AppProvider appProvider = Provider.of<AppProvider>(context);
    String? superCateImgUrl;

    // Check if image URL exists
    if (widget.superCategoryModel.imgUrl != null &&
        widget.superCategoryModel.imgUrl!.isNotEmpty) {
      superCateImgUrl = widget.superCategoryModel.imgUrl;
    } else {
      superCateImgUrl = null;
    }

    return superCateImgWeb(
        context, superCateImgUrl, serviceProvider, appProvider);
  }

  Container superCateImgWeb(BuildContext context, String? superCateImgUrl,
      ServiceProvider serviceProvider, AppProvider appProvider) {
    return Container(
      margin: EdgeInsets.all(Dimensions.dimensionNo12),
      height: ResponsiveLayout.isMoAndTab(context)
          ? 220
          : MediaQuery.of(context).size.height / 1.5,
      width: ResponsiveLayout.isMoAndTab(context)
          ? 200
          : MediaQuery.of(context).size.width / 4.5,
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.all(ResponsiveLayout.isMobile(context)
          ? Dimensions.dimensionNo8
          : Dimensions.dimensionNo12),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(Dimensions.dimensionNo12),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.dimensionNo12),
            child: superCateImgUrl != null
                ? Image.network(
                    superCateImgUrl,
                    fit: ResponsiveLayout.isMoAndTab(context)
                        ? BoxFit.cover
                        : BoxFit.fitHeight,
                    width: double.infinity,
                    height: double.infinity,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      // While loading, display a gray container
                      return Container(
                        color: Colors.grey,
                        width: double.infinity,
                        height: double.infinity,
                      );
                    },
                    errorBuilder: (BuildContext context, Object error,
                        StackTrace? stackTrace) {
                      return Container(color: Colors.grey);
                    },
                  )
                : Container(color: Colors.grey),
          ),

          // Delete button
          Align(
              alignment: Alignment.topLeft,
              child: PopupMenuButton<int>(
                  icon: const Icon(Icons.more_vert, color: Colors.black),
                  onSelected: (value) {
                    if (value == 0) {
                      showDialog(
                        context: context,
                        builder: (context) => EditSuperCategoryPopup(
                          superCategoryModel: widget.superCategoryModel,
                        ),
                      );
                    }
                    if (value == 1) {
                      showDeleteAlertDialog(
                        context,
                        "Delete Super-Category",
                        "Do you want to delete ${widget.superCategoryModel.superCategoryName} Super-Category",
                        () async {
                          try {
                            showLoaderDialog(context);
                            // await serviceProvider.deleteSingleSuperCategoryPro(
                            //     widget.superCategoryModel);
                            bool val = await FirebaseFirestoreHelper.instance
                                .deleteSingleSuperCategoryFb(
                                    widget.superCategoryModel);

                            await serviceProvider.getSuperCategoryListPro(
                                appProvider.getSalonInformation.id);

                            if (serviceProvider.getCategoryList.isNotEmpty) {
                              serviceProvider.selectCategory(
                                  serviceProvider.getCategoryList[0]);
                            }

                            Navigator.of(context, rootNavigator: true)
                                .pop(); // Close loader/dialog
                            Navigator.of(context, rootNavigator: true)
                                .pop(); // Close loader/dialog
                            showBottomMessage(
                              "Successfully deleted ${widget.superCategoryModel.superCategoryName}",
                              context,
                            );
                          } catch (e) {
                            Navigator.of(context, rootNavigator: true).pop();
                            showBottomMessageError(
                              "Error deleting ${widget.superCategoryModel.superCategoryName}",
                              context,
                            );
                          }
                        },
                      );
                    }
                  },
                  itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 0,
                          child: Row(
                            children: [
                              Icon(Icons.edit_square, color: Colors.black),
                              SizedBox(width: 8),
                              Text("Edit"),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 1,
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red),
                              SizedBox(width: 8),
                              Text("Delete"),
                            ],
                          ),
                        ),
                      ])),

          // Category name
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(bottom: Dimensions.dimensionNo20),
              child: Text(
                widget.superCategoryModel.superCategoryName,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveLayout.isMoAndTab(context)
                      ? Dimensions.dimensionNo14
                      : Dimensions.dimensionNo18,
                  fontWeight: ResponsiveLayout.isMoAndTab(context)
                      ? FontWeight.bold
                      : FontWeight.w600,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
