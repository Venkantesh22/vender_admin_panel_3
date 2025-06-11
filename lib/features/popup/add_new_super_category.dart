// ignore_for_file: no_leading_underscores_for_local_identifiers

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

class AddNewSuperCategory extends StatefulWidget {
  const AddNewSuperCategory({super.key});

  @override
  State<AddNewSuperCategory> createState() => _AddNewSuperCategoryState();
}

class _AddNewSuperCategoryState extends State<AddNewSuperCategory> {
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    ServiceProvider serviceProvider = Provider.of<ServiceProvider>(context);

    // Dropdown options for "service for"
    final List<String> _serviceForList = ["Male", "Female", "Both"];
    String? _serviceFor = _serviceForList.last; // Default value

    final TextEditingController _superCategoryController =
        TextEditingController();

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
                  'Add New Super-Category',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormCustomTextField(
              controller: _superCategoryController,
              title: "Super Category",
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: Dimensions.dimenisonNo8),
              child: Text(
                "Select Service For",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: Dimensions.dimenisonNo18,
                  fontFamily: GoogleFonts.roboto().fontFamily,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.15,
                ),
              ),
            ),
            SizedBox(
              width: Dimensions.dimenisonNo200,
              child: DropdownButtonFormField<String>(
                hint: Text(
                  'Select for',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: Dimensions.dimenisonNo12,
                    fontFamily: GoogleFonts.roboto().fontFamily,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.40,
                  ),
                ),
                value: _serviceFor,
                items: _serviceForList.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _serviceFor = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a Service for';
                  }
                  return null;
                },
              ),
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

                  bool isVaildated = addNewSuperCategoryVaildation(
                      _superCategoryController.text, context);

                  if (isVaildated) {
                    serviceProvider.addNewSuperCategoryPro(
                      appProvider.getAdminInformation.id,
                      appProvider.getSalonInformation.id,
                      _superCategoryController.text.trim(),
                      _serviceFor!,
                      context,
                    );
                    Navigator.of(context, rootNavigator: true).pop();
                    showBottonMessage(
                        "New Super-Category add Successfully", context);
                  }
                  Navigator.of(context, rootNavigator: true).pop();
                } catch (e) {
                  Navigator.of(context, rootNavigator: true).pop();
                  showBottonMessageError(
                      "Error create new Super-Category ${e.toString()}",
                      context);
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
