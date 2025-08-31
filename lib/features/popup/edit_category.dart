import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/models/category_model/category_model.dart';
import 'package:samay_admin_plan/provider/service_provider.dart';
import 'package:samay_admin_plan/utility/dimension.dart';
import 'package:samay_admin_plan/widget/customauthbutton.dart';
import 'package:samay_admin_plan/widget/text_box/customtextfield.dart';

class EditCategoryPopup extends StatefulWidget {
  final CategoryModel? categoryModel;
  const EditCategoryPopup({
    super.key,
    required this.categoryModel,
  });

  @override
  State<EditCategoryPopup> createState() => _EditCategoryPopupState();
}

class _EditCategoryPopupState extends State<EditCategoryPopup> {
  late TextEditingController _categoryController;
  late String? _serviceFor;

  @override
  void initState() {
    super.initState();
    _categoryController = TextEditingController(
      text: widget.categoryModel?.categoryName,
    );
    _serviceFor = widget.categoryModel?.serviceFor;
  }

  @override
  void dispose() {
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ServiceProvider serviceProvider = Provider.of<ServiceProvider>(context);
    final List<String> serviceForList = ["Male", "Female", "Both"];

    // Determine dialog width based on screen size
    double dialogWidth = MediaQuery.of(context).size.width * 0.8;
    if (ResponsiveLayout.isMoAndTab(context)) {
      dialogWidth = MediaQuery.of(context).size.width * 0.95;
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
                  'Edit Category',
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
                : dialogWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormCustomTextField(
              controller: _categoryController,
              title: "Category Name",
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
                items: serviceForList.map((String value) {
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
                      ? Dimensions.dimensionNo100
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
                      ? Dimensions.dimensionNo100
                      : Dimensions.dimensionNo150,
              text: "Save",
              ontap: () {
                try {
                  showLoaderDialog(context);

                  bool isVaildated =
                      addNewCategoryVaildation(_categoryController.text);

                  if (isVaildated) {
                    CategoryModel categoryModel = widget.categoryModel!
                        .copyWith(
                            categoryName: _categoryController.text.trim(),
                            serviceFor: _serviceFor);
                    serviceProvider.updateSingleCategoryPro(categoryModel);

                    Navigator.of(context, rootNavigator: true).pop();
                    Navigator.of(context, rootNavigator: true).pop();
                  }
                } catch (e) {
                  Navigator.of(context, rootNavigator: true).pop();
                  showBottomMessageError(
                      "Error editing Category: ${e.toString()}", context);
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
