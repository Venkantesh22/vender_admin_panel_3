import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/models/category_model/category_model.dart';
import 'package:samay_admin_plan/provider/service_provider.dart';
import 'package:samay_admin_plan/utility/dimenison.dart';
import 'package:samay_admin_plan/widget/customauthbutton.dart';
import 'package:samay_admin_plan/widget/customtextfield.dart';

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
  @override
  Widget build(BuildContext context) {
    ServiceProvider serviceProvider = Provider.of<ServiceProvider>(context);
    final TextEditingController _categoryController =
        TextEditingController(text: widget.categoryModel?.categoryName);

    // Determine dialog width based on screen size
    double dialogWidth =
        MediaQuery.of(context).size.width * 0.8; // Default for web
    if (ResponsiveLayout.isMoAndTab(context)) {
      dialogWidth =
          MediaQuery.of(context).size.width * 0.95; // Wider for mobile/tablet
    }

    return AlertDialog(
      titlePadding: EdgeInsets.only(
        left: Dimensions.dimenisonNo20,
        right: Dimensions.dimenisonNo20,
        top: Dimensions.dimenisonNo20,
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: Dimensions.dimenisonNo20,
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
                  'Edit Category',
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
              buttonWidth: ResponsiveLayout.isMobile(context)
                  ? Dimensions.dimenisonNo100
                  : ResponsiveLayout.isTablet(context)
                      ? Dimensions
                          .dimenisonNo100 // Smaller button for mobile/tablet
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
                          .dimenisonNo100 // Smaller button for mobile/tablet
                      : Dimensions.dimenisonNo150,
              text: "Save",
              ontap: () {
                try {
                  showLoaderDialog(context);

                  bool isVaildated =
                      addNewCategoryVaildation(_categoryController.text);

                  if (isVaildated) {
                    CategoryModel categoryModel = widget.categoryModel!
                        .copyWith(
                            categoryName: _categoryController.text.trim());
                    serviceProvider.updateSingleCategoryPro(categoryModel);

                    Navigator.of(context, rootNavigator: true).pop();
                    Navigator.of(context, rootNavigator: true).pop();

                    // showInforAlertDialog(
                    //   context,
                    //   "Successfully Edited the Category",
                    //   "Category is edited successfully. Reload the page to see changes.",
                    // );
                  }
                } catch (e) {
                  Navigator.of(context, rootNavigator: true).pop();
                  showBottonMessageError(
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
