import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';
import 'package:samay_admin_plan/provider/service_provider.dart';
import 'package:samay_admin_plan/utility/dimension.dart';
import 'package:samay_admin_plan/widget/customauthbutton.dart';
import 'package:samay_admin_plan/widget/text_box/customtextfield.dart';

class AddNewBrandProduct extends StatefulWidget {
  const AddNewBrandProduct({super.key});

  @override
  State<AddNewBrandProduct> createState() => _AddNewBrandProductState();
}

class _AddNewBrandProductState extends State<AddNewBrandProduct> {
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    ServiceProvider serviceProvider = Provider.of<ServiceProvider>(context);

    // Dropdown options for "service for"
    final List<String> serviceForList = ["Male", "Female", "Both"];
    String? serviceFor = serviceForList.last; // Default value

    final TextEditingController superCategoryController =
        TextEditingController();

    // Determine the dialog width based on screen size
    double dialogWidth = MediaQuery.of(context).size.width * 0.8;
    if (ResponsiveLayout.isMoAndTab(context)) {
      dialogWidth =
          MediaQuery.of(context).size.width * 0.95; // Wider for mobile/tablet
    }

    return AlertDialog(
      titlePadding: EdgeInsets.only(
        left: Dimensions.dimensionNo10,
        right: Dimensions.dimensionNo20,
        top: Dimensions.dimensionNo20,
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: Dimensions.dimensionNo12,
        vertical: Dimensions.dimensionNo10,
      ),
      actionsPadding: EdgeInsets.symmetric(
        vertical: Dimensions.dimensionNo10,
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
                    fontSize: Dimensions.dimensionNo18,
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
            ? Dimensions.dimensionNo400
            : ResponsiveLayout.isTablet(context)
                ? Dimensions.screenWidthM / 1.7
                : dialogWidth, // Set the dialog width dynamically
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormCustomTextField(
              controller: superCategoryController,
              title: "Super Category",
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: Dimensions.dimensionNo8),
              child: Text(
                "Select Service For",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: Dimensions.dimensionNo18,
                  fontFamily: GoogleFonts.roboto().fontFamily,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.15,
                ),
              ),
            ),
            SizedBox(
              width: Dimensions.dimensionNo200,
              child: DropdownButtonFormField<String>(
                hint: Text(
                  'Select for',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: Dimensions.dimensionNo12,
                    fontFamily: GoogleFonts.roboto().fontFamily,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.40,
                  ),
                ),
                value: serviceFor,
                items: serviceForList.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    serviceFor = newValue!;
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
                      .dimensionNo110 // Smaller button for mobile/tablet
                  : Dimensions.dimensionNo150,
              text: "Cancel",
              bgColor: Colors.red,
              ontap: () {
                Navigator.pop(context);
              },
            ),
            CustomAuthButton(
              buttonWidth: ResponsiveLayout.isMobile(context)
                  ? Dimensions.dimensionNo100
                  : ResponsiveLayout.isTablet(context)
                      ? Dimensions
                          .dimensionNo110 // Smaller button for mobile/tablet
                      : Dimensions.dimensionNo150,
              text: "Save",
              ontap: () {
                try {
                  showLoaderDialog(context);

                  // bool isVaildated = AddNewBrandProductVaildation(
                  //     _superCategoryController.text, context);

                  // if (isVaildated) {
                  //   serviceProvider.AddNewBrandProductPro(
                  //     appProvider.getAdminInformation.id,
                  //     appProvider.getSalonInformation.id,
                  //     _superCategoryController.text.trim(),
                  //     _serviceFor!,
                  //     context,
                  //   );
                  //   Navigator.of(context, rootNavigator: true).pop();
                  //   showBottomMessage(
                  //       "New Super-Category add Successfully", context);
                  // }
                  Navigator.of(context, rootNavigator: true).pop();
                } catch (e) {
                  Navigator.of(context, rootNavigator: true).pop();
                  showBottomMessageError(
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
