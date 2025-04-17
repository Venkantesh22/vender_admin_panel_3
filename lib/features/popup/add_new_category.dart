// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';
import 'package:samay_admin_plan/provider/service_provider.dart';
import 'package:samay_admin_plan/utility/dimenison.dart';
import 'package:samay_admin_plan/widget/customauthbutton.dart';
import 'package:samay_admin_plan/widget/customtextfield.dart';

class AddNewCategory extends StatelessWidget {
  const AddNewCategory({super.key});

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    ServiceProvider serviceProvider = Provider.of<ServiceProvider>(context);
    final TextEditingController _categoryController = TextEditingController();

    // Determine the dialog width based on screen size
    double dialogWidth = MediaQuery.of(context).size.width * 0.8;
    if (ResponsiveLayout.isMoAndTab(context)) {
      dialogWidth =
          MediaQuery.of(context).size.width * 0.95; // Wider for mobile/tablet
    }

    return AlertDialog(
      titlePadding: EdgeInsets.only(
        left: Dimensions.dimenisonNo10,
        right: Dimensions.dimenisonNo20,
        top: Dimensions.dimenisonNo20,
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: Dimensions.dimenisonNo12,
        vertical: Dimensions.dimenisonNo10,
      ),
      actionsPadding: EdgeInsets.symmetric(
        vertical: Dimensions.dimenisonNo10,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Add New Category in ${serviceProvider.getSelectSuperCategoryModel!.superCategoryName}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: Dimensions.dimenisonNo18,
                    fontFamily: GoogleFonts.roboto().fontFamily,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.15,
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
        ],
      ),
      content: SizedBox(
        width: ResponsiveLayout.isDesktop(context)
            ? Dimensions.dimenisonNo400
            : ResponsiveLayout.isTablet(context)
                ? Dimensions.screenWidthM / 1.7
                : dialogWidth, // Set the dialog width dynamically
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FormCustomTextField(
              controller: _categoryController,
              title: "Category Name",
            ),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomAuthButton(
              buttonWidth: ResponsiveLayout.isMoAndTab(context)
                  ? Dimensions
                      .dimenisonNo110 // Smaller button for mobile/tablet
                  : Dimensions.dimenisonNo150,
              text: "Cancel",
              bgColor: Colors.red,
              ontap: () {
                Navigator.pop(context);
              },
            ),
            CustomAuthButton(
              buttonWidth: ResponsiveLayout.isMobile(context)
                  ? Dimensions.dimenisonNo100
                  : ResponsiveLayout.isTablet(context)
                      ? Dimensions
                          .dimenisonNo110 // Smaller button for mobile/tablet
                      : Dimensions.dimenisonNo150,
              text: "Save",
              ontap: () {
                try {
                  showLoaderDialog(context);

                  bool isVaildated =
                      addNewCategoryVaildation(_categoryController.text);

                  if (isVaildated) {
                    serviceProvider.addNewCategoryPro(
                      appProvider.getAdminInformation.id,
                      appProvider.getSalonInformation.id,
                      _categoryController.text.trim(),
                      serviceProvider
                          .getSelectSuperCategoryModel!.superCategoryName,
                      context,
                    );
                    Navigator.of(context, rootNavigator: true).pop();
                    showBottonMessage(
                        "New Category added Successfully", context);
                  }
                  Navigator.of(context, rootNavigator: true).pop();
                } catch (e) {
                  Navigator.of(context, rootNavigator: true).pop();
                  showBottonMessageError(
                      "Error creating new Category: ${e.toString()}", context);
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
