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
import 'package:samay_admin_plan/utility/dimenison.dart';
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

  // Helper method to navigate to the EditServicePage.
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

  // Helper method to show a delete confirmation dialog.
  void _confirmDelete(BuildContext context, ServiceProvider serviceProvider) {
    showDeleteAlertDialog(
      context,
      "Delete Service",
      "Do you want to delete ${serviceModel.servicesName} Service",
      () async {
        try {
          // Show loader while deleting.
          showLoaderDialog(context);
          await serviceProvider.deletelSingleServicePro(serviceModel);
          // Dismiss the loader and dialog.
          if (Navigator.of(context, rootNavigator: true).canPop()) {
            Navigator.of(context, rootNavigator: true).pop();
          }
          Navigator.of(context, rootNavigator: true).pop();
          showMessage("Successfully deleted ${serviceModel.servicesName}");
        } catch (e) {
          if (Navigator.of(context, rootNavigator: true).canPop()) {
            Navigator.of(context, rootNavigator: true).pop();
          }
          showMessage(
              "Error deleting ${serviceModel.servicesName}: ${e.toString()}");
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ServiceProvider serviceProvider = Provider.of<ServiceProvider>(context);
    Duration serviceDuration =
        Duration(minutes: serviceModel.serviceDurationMin);

    // Use different widgets for mobile and larger screens
    return ResponsiveLayout.isMobile(context)
        ? singleServiceMobileWidget(context, serviceProvider, serviceDuration)
        : singleServiceWebWidget(context, serviceProvider, serviceDuration);
  }

  Container singleServiceMobileWidget(BuildContext context,
      ServiceProvider serviceProvider, Duration serviceDuration) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.dimenisonNo10,
        vertical: Dimensions.dimenisonNo10,
      ),
      margin: EdgeInsets.only(bottom: Dimensions.dimenisonNo10),
      decoration: ShapeDecoration(
        color: AppColor.bgForAdminCreateSec,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1),
          borderRadius: BorderRadius.circular(Dimensions.dimenisonNo10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with service title and action menu
          Row(
            children: [
              Expanded(
                child: Text(
                  serviceModel.servicesName,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: Dimensions.dimenisonNo18,
                    fontFamily: GoogleFonts.roboto().fontFamily,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.15,
                  ),
                ),
              ),
              PopupMenuButton<int>(
                icon: const Icon(Icons.more_vert, color: Colors.black),
                onSelected: (value) {
                  if (value == 0) {
                    // Edit Service
                    _navigateToEditService(context);
                  } else if (value == 1) {
                    // Delete Service
                    _confirmDelete(context, serviceProvider);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 0,
                    child: Row(
                      children: const [
                        Icon(Icons.edit_square, color: Colors.black),
                        SizedBox(width: 8),
                        Text("Edit"),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 1,
                    child: Row(
                      children: const [
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
              SizedBox(width: Dimensions.dimenisonNo10),
              Icon(
                Icons.watch_later_outlined,
                size: Dimensions.dimenisonNo16,
              ),
              SizedBox(width: Dimensions.dimenisonNo5),
              Text(
                "${serviceDuration.inHours}h: ${serviceDuration.inMinutes % 60}min",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: Dimensions.dimenisonNo14,
                  fontFamily: GoogleFonts.roboto().fontFamily,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Service description
          Text(
            serviceModel.description,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(
              color: Colors.black,
              fontSize: Dimensions.dimenisonNo12,
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
      width: Dimensions.dimenisonNo500,
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.dimenisonNo10,
        vertical: Dimensions.dimenisonNo10,
      ),
      child: Container(
        margin: EdgeInsets.only(
            right: ResponsiveLayout.isDesktop(context)
                ? Dimensions.dimenisonNo200
                : Dimensions.dimenisonNo10),
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.dimenisonNo10,
          vertical: Dimensions.dimenisonNo10,
        ),
        height: Dimensions.dimenisonNo200,
        decoration: ShapeDecoration(
          color: AppColor.bgForAdminCreateSec,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1),
            borderRadius: BorderRadius.circular(Dimensions.dimenisonNo10),
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
                      // Edit Service
                      _navigateToEditService(context);
                    } else if (value == 1) {
                      // Delete Service
                      _confirmDelete(context, serviceProvider);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 0,
                      child: Row(
                        children: const [
                          Icon(Icons.edit_square, color: Colors.black),
                          SizedBox(width: 8),
                          Text("Edit"),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 1,
                      child: Row(
                        children: const [
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
                SizedBox(width: Dimensions.dimenisonNo20),
                Icon(
                  Icons.watch_later_outlined,
                  size: Dimensions.dimenisonNo16,
                ),
                SizedBox(width: Dimensions.dimenisonNo10),
                Text(
                  "${serviceDuration.inHours}h: ${serviceDuration.inMinutes % 60}min",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: Dimensions.dimenisonNo16,
                    fontFamily: GoogleFonts.roboto().fontFamily,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.15,
                  ),
                ),
                SizedBox(width: Dimensions.dimenisonNo20),
                // Service For information
                Text(
                  "Service for: ${serviceModel.serviceFor}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: Dimensions.dimenisonNo16,
                    fontFamily: GoogleFonts.roboto().fontFamily,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.15,
                  ),
                ),
              ],
            ),
            const Divider(),
            // Service description
            Text(
              serviceModel.description,
              overflow: TextOverflow.clip,
              style: TextStyle(
                color: Colors.black,
                fontSize: Dimensions.dimenisonNo12,
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

  /// Helper widget to build the service title and service code details.
  Widget _buildServiceInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          serviceModel.servicesName,
          style: TextStyle(
            color: Colors.black,
            fontSize: Dimensions.dimenisonNo20,
            fontFamily: GoogleFonts.roboto().fontFamily,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.04,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: Dimensions.dimenisonNo10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Service code: ${serviceModel.serviceCode}',
                style: TextStyle(
                  color: const Color.fromARGB(255, 124, 118, 118),
                  fontSize: Dimensions.dimenisonNo14,
                  fontFamily: GoogleFonts.roboto().fontFamily,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: Dimensions.dimenisonNo10),
            ],
          ),
        ),
      ],
    );
  }
}
