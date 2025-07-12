import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/models/super_cate/super_cate.dart';
import 'package:samay_admin_plan/provider/service_provider.dart';
import 'package:samay_admin_plan/utility/dimension.dart';
import 'package:samay_admin_plan/widget/customauthbutton.dart';
import 'package:samay_admin_plan/widget/text_box/customtextfield.dart';

class EditSuperCategoryPopup extends StatefulWidget {
  final SuperCategoryModel? superCategoryModel;
  const EditSuperCategoryPopup({
    super.key,
    required this.superCategoryModel,
  });

  @override
  State<EditSuperCategoryPopup> createState() => _EditSuperCategoryPopupState();
}

class _EditSuperCategoryPopupState extends State<EditSuperCategoryPopup> {
  late TextEditingController _superCategoryController;
  late String? _serviceFor;

  @override
  void initState() {
    super.initState();
    _superCategoryController = TextEditingController(
      text: widget.superCategoryModel?.superCategoryName,
    );
    _serviceFor = widget.superCategoryModel?.serviceFor;
  }

  @override
  void dispose() {
    _superCategoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ServiceProvider serviceProvider = Provider.of<ServiceProvider>(context);
    final List<String> _serviceForList = ["Male", "Female", "Both"];

    // Determine dialog width based on screen size
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
                  'Edit Super-Category ${widget.superCategoryModel!.serviceFor}',
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
              controller: _superCategoryController,
              title: "Super-Category Name",
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
                value: _serviceFor, // <-- This will select the correct value
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
              buttonWidth: ResponsiveLayout.isMobile(context)
                  ? Dimensions.dimensionNo100
                  : ResponsiveLayout.isTablet(context)
                      ? Dimensions
                          .dimensionNo100 // Smaller button for mobile/tablet
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
                          .dimensionNo100 // Smaller button for mobile/tablet
                      : Dimensions.dimensionNo150,
              text: "Save",
              ontap: () {
                try {
                  showLoaderDialog(context);

                  bool isVaildated =
                      addNewCategoryVaildation(_superCategoryController.text);

                  if (isVaildated) {
                    SuperCategoryModel superCategoryModel =
                        widget.superCategoryModel!.copyWith(
                            superCategoryName:
                                _superCategoryController.text.trim(),
                            serviceFor: _serviceFor);
                    serviceProvider
                        .updateSingleSuperCategoryPro(superCategoryModel);

                    Navigator.of(context, rootNavigator: true).pop();
                    Navigator.of(context, rootNavigator: true).pop();
                  }
                } catch (e) {
                  Navigator.of(context, rootNavigator: true).pop();
                  showBottomMessageError(
                      "Error editing Super-Category: ${e.toString()}", context);
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
