// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/constants/router.dart';
import 'package:samay_admin_plan/features/service_view/screen/edit_service_page.dart';
import 'package:samay_admin_plan/models/category_model/category_model.dart';
import 'package:samay_admin_plan/models/service_model/service_model.dart';
import 'package:samay_admin_plan/provider/service_provider.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimension.dart';
import 'package:samay_admin_plan/widget/pricerow.dart';

class SingleServiceTap extends StatelessWidget {
  final ServiceModel serviceModel;
  final CategoryModel categoryModel;
  final int index;
  const SingleServiceTap({
    super.key,
    required this.serviceModel,
    required this.categoryModel,
    required this.index,
  });

  void _navigateToEditService(BuildContext context) {
    Routes.instance.push(
      widget: EditServicePage(
        index: index,
        serviceModel: serviceModel,
        categoryModel: categoryModel,
      ),
      context: context,
    );
  }

  // Improved delete confirmation with loader and safe context handling
  void _confirmDelete(
      BuildContext context, ServiceProvider serviceProvider) async {
    showDeleteAlertDialog(
      context,
      "Delete Service",
      "Do you want to delete ${serviceModel.servicesName} service?",
      () async {
        showLoaderDialog(context); // Show loading dialog
        try {
          // await FirebaseFirestoreHelper.instance
          //     .deleteServiceFirebase(serviceModel);
          serviceProvider.deletelSingleServicePro(serviceModel);
          Navigator.of(context, rootNavigator: true).pop();

          // Close loading dialog
          if (Navigator.of(context, rootNavigator: true).canPop()) {
            Navigator.of(context, rootNavigator: true).pop();
          }

          showBottomMessage(
            "Successfully deleted ${serviceModel.servicesName}",
            context,
          );
        } catch (e) {
          // Close loading dialog
          if (Navigator.of(context, rootNavigator: true).canPop()) {
            Navigator.of(context, rootNavigator: true).pop();
          }
          showBottomMessageError(
            "Error deleting ${serviceModel.servicesName}: ${e.toString()}",
            context,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ServiceProvider serviceProvider = Provider.of<ServiceProvider>(context);
    Duration serviceDuration =
        Duration(minutes: serviceModel.serviceDurationMin);

    return ResponsiveLayout.isMobile(context)
        ? singleServiceMobileWidget(context, serviceProvider, serviceDuration)
        : singleServiceWebWidget(context, serviceProvider, serviceDuration);
  }

  Container singleServiceMobileWidget(BuildContext context,
      ServiceProvider serviceProvider, Duration serviceDuration) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.dimensionNo10,
        vertical: Dimensions.dimensionNo10,
      ),
      margin: EdgeInsets.only(bottom: Dimensions.dimensionNo10),
      decoration: ShapeDecoration(
        color: AppColor.bgForAdminCreateSec,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1),
          borderRadius: BorderRadius.circular(Dimensions.dimensionNo10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with service title and action menu
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      serviceModel.servicesName,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: Dimensions.dimensionNo18,
                        fontFamily: GoogleFonts.roboto().fontFamily,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.15,
                      ),
                    ),
                    SizedBox(height: Dimensions.dimensionNo5),
                    Text(
                      'Service code: ${serviceModel.serviceCode}',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 124, 118, 118),
                        fontSize: Dimensions.dimensionNo12,
                        fontFamily: GoogleFonts.roboto().fontFamily,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<int>(
                icon: const Icon(Icons.more_vert, color: Colors.black),
                onSelected: (value) {
                  if (value == 0) {
                    _navigateToEditService(context);
                  } else if (value == 1) {
                    _confirmDelete(context, serviceProvider);
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
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Price and duration row
          Row(
            children: [
              PriceRow(serviceModel: serviceModel),
              SizedBox(width: Dimensions.dimensionNo10),
              Icon(
                Icons.watch_later_outlined,
                size: Dimensions.dimensionNo16,
              ),
              SizedBox(width: Dimensions.dimensionNo5),
              Text(
                "${serviceDuration.inHours}h: ${serviceDuration.inMinutes % 60}min",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: Dimensions.dimensionNo14,
                  fontFamily: GoogleFonts.roboto().fontFamily,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Service description
          serviceModel.description == null || serviceModel.description!.isEmpty
              ? const SizedBox()
              : Text(
                  serviceModel.description!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: Dimensions.dimensionNo12,
                    fontFamily: GoogleFonts.roboto().fontFamily,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.15,
                  ),
                ),
        ],
      ),
    );
  }

  Container singleServiceWebWidget(BuildContext context,
      ServiceProvider serviceProvider, Duration serviceDuration) {
    return Container(
      width: Dimensions.dimensionNo500,
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.dimensionNo10,
        vertical: Dimensions.dimensionNo10,
      ),
      child: Container(
        margin: EdgeInsets.only(
            right: ResponsiveLayout.isDesktop(context)
                ? Dimensions.dimensionNo200
                : Dimensions.dimensionNo10),
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.dimensionNo10,
          vertical: Dimensions.dimensionNo10,
        ),
        decoration: ShapeDecoration(
          color: AppColor.bgForAdminCreateSec,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1),
            borderRadius: BorderRadius.circular(Dimensions.dimensionNo10),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row with service title and action menu
            Row(
              children: [
                _buildServiceInfo(),
                const Spacer(),
                PopupMenuButton<int>(
                  icon: const Icon(Icons.more_vert, color: Colors.black),
                  onSelected: (value) {
                    if (value == 0) {
                      _navigateToEditService(context);
                    } else if (value == 1) {
                      _confirmDelete(context, serviceProvider);
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
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Price and duration row
            Row(
              children: [
                SizedBox(
                    width: Dimensions.dimensionNo200,
                    child: PriceRow(serviceModel: serviceModel)),
                SizedBox(width: Dimensions.dimensionNo20),
                Icon(
                  Icons.watch_later_outlined,
                  size: Dimensions.dimensionNo16,
                ),
                SizedBox(width: Dimensions.dimensionNo10),
                Text(
                  "${serviceDuration.inHours}h: ${(serviceDuration.inMinutes % 60).toString().padLeft(2, '0')}min",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: Dimensions.dimensionNo16,
                    fontFamily: GoogleFonts.roboto().fontFamily,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.15,
                  ),
                ),
                SizedBox(width: Dimensions.dimensionNo20),
                Text(
                  "Service for: ${serviceModel.serviceFor}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: Dimensions.dimensionNo16,
                    fontFamily: GoogleFonts.roboto().fontFamily,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.15,
                  ),
                ),
              ],
            ),
            serviceModel.description == null ||
                    serviceModel.description!.isEmpty
                ? const SizedBox()
                : const Divider(),
            serviceModel.description == null ||
                    serviceModel.description!.isEmpty
                ? const SizedBox()
                : Text(
                    serviceModel.description!,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: Dimensions.dimensionNo12,
                      fontFamily: GoogleFonts.roboto().fontFamily,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.15,
                    ),
                  )
          ],
        ),
      ),
    );
  }

  Widget _buildServiceInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          serviceModel.servicesName,
          style: TextStyle(
            color: Colors.black,
            fontSize: Dimensions.dimensionNo20,
            fontFamily: GoogleFonts.roboto().fontFamily,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.04,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: Dimensions.dimensionNo10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Service code: ${serviceModel.serviceCode}',
                style: TextStyle(
                  color: const Color.fromARGB(255, 124, 118, 118),
                  fontSize: Dimensions.dimensionNo14,
                  fontFamily: GoogleFonts.roboto().fontFamily,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: Dimensions.dimensionNo10),
            ],
          ),
        ),
      ],
    );
  }
}
