import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/models/category_model/category_model.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';
import 'package:samay_admin_plan/provider/service_provider.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimenison.dart';
import 'package:samay_admin_plan/widget/customauthbutton.dart';
import 'package:samay_admin_plan/widget/customtextfield.dart';

class AddServiceForm extends StatefulWidget {
  final CategoryModel categoryModel;
  const AddServiceForm({
    Key? key,
    required this.categoryModel,
  }) : super(key: key);

  @override
  State<AddServiceForm> createState() => _AddServiceFormState();
}

class _AddServiceFormState extends State<AddServiceForm> {
  // TextEditingControllers for form fields
  final TextEditingController _serviceController = TextEditingController();
  final TextEditingController _serviceCodeController = TextEditingController();
  final TextEditingController _priceController =
      TextEditingController(); // Final price after discount
  final TextEditingController _originalPriceController =
      TextEditingController();
  final TextEditingController _discountInPer =
      TextEditingController(text: "0.0");
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _minController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Dropdown options for "service for"
  final List<String> _serviceForList = ["Male", "Female", "Both"];
  String? _serviceFor;

  double discountAmount = 0.0;

  @override
  void initState() {
    super.initState();
    // Add listeners to recalculate final price when original price or discount percentage changes.
    _originalPriceController.addListener(_updateFinalPrice);
    _discountInPer.addListener(_updateFinalPrice);
  }

  @override
  void dispose() {
    _serviceController.dispose();
    _serviceCodeController.dispose();
    _priceController.dispose();
    _originalPriceController.dispose();
    _discountInPer.dispose();
    _hoursController.dispose();
    _minController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Function to update final price based on original price and discount percentage.
  void _updateFinalPrice() {
    double originalPrice =
        double.tryParse(_originalPriceController.text) ?? 0.0;
    double discountPercentage = double.tryParse(_discountInPer.text) ?? 0.0;
    double finalPrice =
        originalPrice - (originalPrice * discountPercentage / 100);
    // Update the final price controller's text (formatted to two decimals).
    _priceController.text = finalPrice.toStringAsFixed(2);
  }

  void discountAmountFun() {
    discountAmount = double.tryParse(_originalPriceController.text)! -
        double.tryParse(_priceController.text)!;
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve providers if needed
    // final appProvider = Provider.of<AppProvider>(context);
    // final serviceProvider = Provider.of<ServiceProvider>(context);

    return Scaffold(
      backgroundColor: ResponsiveLayout.isMoAndTab(context)
          ? AppColor.bgForAdminCreateSec
          : AppColor.bgForAdminCreateSec,
      body: SingleChildScrollView(
        child: Container(
          width: ResponsiveLayout.isDesktop(context)
              ? Dimensions.screenWidth / 1.5
              : null,
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.dimenisonNo30,
            vertical: Dimensions.dimenisonNo30,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with title and close button
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Add New Service in ${widget.categoryModel.categoryName} Category',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: Dimensions.dimenisonNo24,
                        fontFamily: GoogleFonts.roboto().fontFamily,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.15,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const Divider(),
              SizedBox(height: Dimensions.dimenisonNo20),
              // Service Name field
              FormCustomTextField(
                controller: _serviceController,
                title: "Service name",
              ),
              SizedBox(height: Dimensions.dimenisonNo20),
              // Service Code field
              FormCustomTextField(
                controller: _serviceCodeController,
                title: "Enter 4-Digit service code",
              ),
              SizedBox(height: Dimensions.dimenisonNo10),

              // Price fields: Original Price, Discount Percentage, and Final Price.
              Wrap(
                spacing: Dimensions.dimenisonNo20,
                runSpacing: Dimensions.dimenisonNo20,
                children: [
                  // Original Price field
                  SizedBox(
                    width: Dimensions.dimenisonNo200,
                    child: FormCustomTextField(
                      controller: _originalPriceController,
                      title: "Original Price",
                    ),
                  ),
                  // Discount Percentage field
                  SizedBox(
                    width: Dimensions.dimenisonNo230,
                    child: FormCustomTextField(
                      requiredField: false,
                      controller: _discountInPer,
                      title: "Discount (%)",
                    ),
                  ),
                  // Final Price field (read-only, updated in real time)
                  SizedBox(
                    width: Dimensions.dimenisonNo200,
                    child: FormCustomTextField(
                      requiredField: false,
                      controller: _priceController,
                      title: "Final Price",
                      readOnly: true,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: Dimensions.dimenisonNo20,
              ),
              // Time duration and Service For fields
              Wrap(
                spacing: Dimensions.dimenisonNo20,
                runSpacing: Dimensions.dimenisonNo12,
                children: [
                  // Time Duration Column
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Time duration',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: Dimensions.dimenisonNo18,
                          fontFamily: GoogleFonts.roboto().fontFamily,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.15,
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(width: Dimensions.dimenisonNo10),
                          HeadingText('Timing'),
                          SizedBox(width: Dimensions.dimenisonNo10),
                          SizedBox(
                            height: Dimensions.dimenisonNo30,
                            width: Dimensions.dimenisonNo50,
                            child: _TextFormTime(" HH ", _hoursController),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.dimenisonNo10),
                            child: Text(
                              ':',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: Dimensions.dimenisonNo20,
                                fontFamily: GoogleFonts.roboto().fontFamily,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.15,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: Dimensions.dimenisonNo30,
                            width: Dimensions.dimenisonNo50,
                            child: _TextFormTime(" MM ", _minController),
                          ),
                          SizedBox(width: Dimensions.dimenisonNo10),
                        ],
                      ),
                    ],
                  ),
                  // SizedBox(width: Dimensions.dimenisonNo30),
                  // Service For Dropdown Column
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeadingText('Select for'),
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
                ],
              ),
              SizedBox(height: Dimensions.dimenisonNo10),

              // Service Description field
              FormCustomTextField(
                maxline: 4,
                controller: _descriptionController,
                title: "Service Description",
              ),
              SizedBox(height: Dimensions.dimenisonNo10),
              // Save Button with error handling and loader management
              CustomAuthButton(
                text: "Save",
                ontap: () async {
                  // Show loader dialog
                  showLoaderDialog(context);
                  try {
                    // Validate form fields
                    bool isValidated = addNewServiceVaildation(
                      _serviceController.text,
                      _serviceCodeController.text,
                      _priceController.text,
                      _minController.text,
                    );

                    if (!isValidated) {
                      showMessage("Please fill all required fields correctly.");
                      return;
                    }

                    // Parse and validate numeric fields
                    double? originalPrice =
                        double.tryParse(_originalPriceController.text);
                    double? discountPercentage =
                        double.tryParse(_discountInPer.text);
                    double? finalPrice = double.tryParse(_priceController.text);
                    int hours = int.tryParse(_hoursController.text) ??
                        0; // Default to 0 if null or invalid
                    int? minutes = int.tryParse(_minController.text);

                    if (originalPrice == null ||
                        discountPercentage == null ||
                        finalPrice == null) {
                      showMessage(
                          "Please enter valid numeric values for price and discount.");
                      return;
                    }

                    if (minutes == null) {
                      showMessage(
                          "Please enter valid numeric values for time duration.");
                      return;
                    }

                    discountAmountFun();

                    // Retrieve provider data
                    final appProvider =
                        Provider.of<AppProvider>(context, listen: false);
                    final serviceProvider =
                        Provider.of<ServiceProvider>(context, listen: false);

                    // Add new service via provider method
                    await serviceProvider.addSingleServicePro(
                      appProvider.getAdminInformation.id,
                      appProvider.getSalonInformation.id,
                      widget.categoryModel.id,
                      widget.categoryModel.categoryName,
                      serviceProvider
                          .getSelectSuperCategoryModel!.superCategoryName,
                      _serviceController.text.trim(),
                      _serviceCodeController.text.trim(),
                      finalPrice,
                      originalPrice,
                      discountPercentage,
                      discountAmount,
                      hours,
                      minutes,
                      _descriptionController.text.trim(),
                      _serviceFor!,
                    );

                    // Update category status if required
                    if (widget.categoryModel.haveData == false) {
                      final updatedCategory =
                          widget.categoryModel.copyWith(haveData: true);
                      serviceProvider.updateSingleCategoryPro(updatedCategory);
                      final updateSuperCate = serviceProvider
                          .getSelectSuperCategoryModel!
                          .copyWith(haveData: true);
                      serviceProvider
                          .updateSingleSuperCategoryPro(updateSuperCate);
                    }

                    // Show success message and close form
                    showMessage("New Service added Successfully");
                    Navigator.of(context).pop(); // Close the form screen
                  } catch (e) {
                    debugPrint("Error adding service: ${e.toString()}");
                    showMessage("Error adding service: ${e.toString()}");
                  } finally {
                    // Ensure loader dialog is dismissed
                    if (Navigator.of(context, rootNavigator: true).canPop()) {
                      Navigator.of(context, rootNavigator: true).pop();
                    }
                  }
                },
              ),
              // CustomAuthButton(
              //   text: "Save",
              //   ontap: () async {
              //     // Show loader dialog
              //     showLoaderDialog(context);
              //     try {
              //       // Validate form fields
              //       bool isValidated = addNewServiceVaildation(
              //         _serviceController.text,
              //         _serviceCodeController.text,
              //         _priceController.text,
              //         _minController.text,
              //       );

              //       if (!isValidated) {
              //         showMessage("Please fill all required fields correctly.");
              //         return;
              //       }
              //       discountAmountFun();

              //       // Retrieve provider data
              //       final appProvider =
              //           Provider.of<AppProvider>(context, listen: false);
              //       final serviceProvider =
              //           Provider.of<ServiceProvider>(context, listen: false);

              //       // Add new service via provider method
              //       await serviceProvider.addSingleServicePro(
              //         appProvider.getAdminInformation.id,
              //         appProvider.getSalonInformation.id,
              //         widget.categoryModel.id,
              //         widget.categoryModel.categoryName,
              //         serviceProvider
              //             .getSelectSuperCategoryModel!.superCategoryName,
              //         _serviceController.text.trim(),
              //         _serviceCodeController.text.trim(),
              //         double.parse(_priceController.text.trim()),
              //         double.parse(_originalPriceController.text.trim()),
              //         double.parse(_discountInPer.text.trim()),
              //         discountAmount,
              //         int.parse(_hoursController.text.trim()) ?? 0,
              //         int.parse(_minController.text.trim()),
              //         _descriptionController.text.trim() ?? "",
              //         _serviceFor!,
              //       );

              //       // Update category status if required
              //       if (widget.categoryModel.haveData == false) {
              //         final updatedCategory =
              //             widget.categoryModel.copyWith(haveData: true);
              //         serviceProvider.updateSingleCategoryPro(updatedCategory);
              //         final updateSuperCate = serviceProvider
              //             .getSelectSuperCategoryModel!
              //             .copyWith(haveData: true);
              //         serviceProvider
              //             .updateSingleSuperCategoryPro(updateSuperCate);
              //       }

              //       // Show success message and close form
              //       showMessage("New Service added Successfully");
              //       Navigator.of(context).pop(); // Close the form screen
              //     } catch (e) {
              //       debugPrint("Error adding service: ${e.toString()}");
              //       showMessage("Error adding service: ${e.toString()}");
              //     } finally {
              //       // Ensure loader dialog is dismissed
              //       if (Navigator.of(context, rootNavigator: true).canPop()) {
              //         Navigator.of(context, rootNavigator: true).pop();
              //       }
              //     }
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // Custom heading text widget for consistency
  Text HeadingText(String heading) {
    return Text(
      heading,
      style: TextStyle(
        color: Colors.black,
        fontSize: Dimensions.dimenisonNo18,
        fontFamily: GoogleFonts.roboto().fontFamily,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
      ),
    );
  }

  // Custom TextFormField for time input
  TextFormField _TextFormTime(
      String hintText, TextEditingController controller) {
    return TextFormField(
      cursorHeight: Dimensions.dimenisonNo16,
      style: TextStyle(
        fontSize: Dimensions.dimenisonNo12,
        fontFamily: GoogleFonts.roboto().fontFamily,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: Dimensions.dimenisonNo12,
          fontFamily: GoogleFonts.roboto().fontFamily,
          fontWeight: FontWeight.bold,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: Dimensions.dimenisonNo10,
          vertical: Dimensions.dimenisonNo10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.dimenisonNo16),
        ),
      ),
    );
  }
}
