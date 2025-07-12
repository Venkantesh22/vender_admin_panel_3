import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/models/category_model/category_model.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';
import 'package:samay_admin_plan/provider/service_provider.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimension.dart';
import 'package:samay_admin_plan/widget/customauthbutton.dart';
import 'package:samay_admin_plan/widget/text_box/customtextfield.dart';

class AddServiceForm extends StatefulWidget {
  final CategoryModel categoryModel;
  const AddServiceForm({
    super.key,
    required this.categoryModel,
  });

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
  String? _serviceFor; // Default selection
  bool _loadingSave = false; // Loader state for save button

  double discountAmount = 0.0;

  @override
  @override
  void initState() {
    super.initState();
    // Set default value for _serviceFor
    _serviceFor = _serviceForList.last;
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
            horizontal: Dimensions.dimensionNo30,
            vertical: Dimensions.dimensionNo30,
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
                        fontSize: Dimensions.dimensionNo24,
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
              SizedBox(height: Dimensions.dimensionNo20),
              // Service Name field
              FormCustomTextField(
                controller: _serviceController,
                title: "Service name",
              ),
              SizedBox(height: Dimensions.dimensionNo20),
              // Service Code field
              FormCustomTextField(
                controller: _serviceCodeController,
                title: "Enter 4-Digit service code",
              ),
              SizedBox(height: Dimensions.dimensionNo10),

              // Price fields: Original Price, Discount Percentage, and Final Price.
              Wrap(
                spacing: Dimensions.dimensionNo20,
                runSpacing: Dimensions.dimensionNo20,
                children: [
                  // Original Price field
                  SizedBox(
                    width: Dimensions.dimensionNo200,
                    child: FormCustomTextField(
                      controller: _originalPriceController,
                      title: "Original Price",
                    ),
                  ),
                  // Discount Percentage field
                  SizedBox(
                    width: Dimensions.dimensionNo230,
                    child: FormCustomTextField(
                      requiredField: false,
                      controller: _discountInPer,
                      title: "Discount (%)",
                    ),
                  ),
                  // Final Price field (read-only, updated in real time)
                  SizedBox(
                    width: Dimensions.dimensionNo200,
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
                height: Dimensions.dimensionNo20,
              ),
              // Time duration and Service For fields
              Wrap(
                spacing: Dimensions.dimensionNo20,
                runSpacing: Dimensions.dimensionNo12,
                children: [
                  // Time Duration Column
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Time duration',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: Dimensions.dimensionNo18,
                          fontFamily: GoogleFonts.roboto().fontFamily,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.15,
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(width: Dimensions.dimensionNo10),
                          HeadingText('Timing'),
                          SizedBox(width: Dimensions.dimensionNo10),
                          SizedBox(
                            height: Dimensions.dimensionNo30,
                            width: Dimensions.dimensionNo50,
                            child: _TextFormTime(" HH ", _hoursController),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.dimensionNo10),
                            child: Text(
                              ':',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: Dimensions.dimensionNo20,
                                fontFamily: GoogleFonts.roboto().fontFamily,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.15,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: Dimensions.dimensionNo30,
                            width: Dimensions.dimensionNo50,
                            child: _TextFormTime(" MM ", _minController),
                          ),
                          SizedBox(width: Dimensions.dimensionNo10),
                        ],
                      ),
                    ],
                  ),
                  // SizedBox(width: Dimensions.dimensionNo30),
                  // Service For Dropdown Column
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeadingText('Select for'),
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
              SizedBox(height: Dimensions.dimensionNo10),

              // Service Description field
              FormCustomTextField(
                maxline: 4,
                controller: _descriptionController,
                title: "Service Description",
              ),
              SizedBox(height: Dimensions.dimensionNo10),

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
                      context,
                    );

                    // Parse and validate numeric fields
                    double? originalPrice =
                        double.tryParse(_originalPriceController.text);
                    double? discountPercentage =
                        double.tryParse(_discountInPer.text);
                    double? finalPrice = double.tryParse(_priceController.text);
                    int hours = int.tryParse(_hoursController.text) ??
                        0; // Default to 0 if null or invalid
                    int? minutes = int.tryParse(_minController.text) ??
                        0; // Default to 0 if null or invalid

                    if (originalPrice == null ||
                        discountPercentage == null ||
                        finalPrice == null) {
                      showBottomMessageError(
                          "Please enter valid numeric values for price and discount.",
                          context);

                      return;
                    }

                    if (minutes == null && hours == null) {
                      showBottomMessageError(
                          "Please enter valid numeric values for time duration.",
                          context);

                      return;
                    }

                    if (minutes != null && minutes < 0) {
                      showBottomMessageError(
                        "Minutes cannot be negative.",
                        context,
                      );
                      return;
                    }
                    if (minutes! >= 60) {
                      showBottomMessageError(
                        "Minutes cannot be greater than or equal to 60.",
                        context,
                      );
                      return;
                    }
                    if (_hoursController.text != null &&
                        int.parse(_hoursController.text) < 0) {
                      showBottomMessageError(
                        "Hours cannot be negative.",
                        context,
                      );
                      return;
                    }

                    if (!isValidated) {
                      showBottomMessageError(
                          "Please fill all required fields correctly.",
                          context);

                      return;
                    }

                    discountAmountFun();

                    // Retrieve provider data
                    final appProvider =
                        Provider.of<AppProvider>(context, listen: false);
                    final serviceProvider =
                        Provider.of<ServiceProvider>(context, listen: false);
                    hours != 0 && hours != null ? minutes = 0 : minutes;

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
                      minutes!,
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
                    showBottomMessage(
                        "New Service added Successfully", context);

                    Navigator.of(context).pop(); // Close the form screen
                  } catch (e) {
                    debugPrint("Error adding service: ${e.toString()}");
                    // showBottomMessageError(
                    //     "Something went wrong please add all fields", context);
                  } finally {
                    // Ensure loader dialog is dismissed
                    if (Navigator.of(context, rootNavigator: true).canPop()) {
                      Navigator.of(context, rootNavigator: true).pop();
                    }
                  }
                },
              ),
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
        fontSize: Dimensions.dimensionNo18,
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
      cursorHeight: Dimensions.dimensionNo16,
      style: TextStyle(
        fontSize: Dimensions.dimensionNo12,
        fontFamily: GoogleFonts.roboto().fontFamily,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: Dimensions.dimensionNo12,
          fontFamily: GoogleFonts.roboto().fontFamily,
          fontWeight: FontWeight.bold,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: Dimensions.dimensionNo10,
          vertical: Dimensions.dimensionNo10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.dimensionNo16),
        ),
      ),
    );
  }
}
