// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_local_variable, unused_element

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/models/category_model/category_model.dart';
import 'package:samay_admin_plan/models/service_model/service_model.dart';
import 'package:samay_admin_plan/provider/service_provider.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimension.dart';
import 'package:samay_admin_plan/widget/customauthbutton.dart';
import 'package:samay_admin_plan/widget/text_box/customtextfield.dart';

class EditServicePage extends StatefulWidget {
  final int index;
  final ServiceModel serviceModel;
  final CategoryModel categoryModel;
  const EditServicePage({
    super.key,
    required this.index,
    required this.serviceModel,
    required this.categoryModel,
  });

  @override
  State<EditServicePage> createState() => _EditServicePageState();
}

class _EditServicePageState extends State<EditServicePage> {
  String? _serviceFor;
  @override
  void initState() {
    super.initState();
    getData();
  }

  bool _isLoading = false;

  final TextEditingController _serviceController = TextEditingController();
  final TextEditingController _serviceCodeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _originalPriceController =
      TextEditingController();
  final TextEditingController _discountInPer = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _minController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // Dropdown options for "service for"
  final List<String> _serviceForList = ["Male", "Female", "Both"];

  double discountAmount = 0.0;

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

  Duration? serviceDuration;
  // Duration(minutes: widget.serviceModel.serviceDurationMin);
  int? _serviceDurationInHr;
  int? _serviceDurationInMin;

  void getData() {
    try {
      setStates() {
        _isLoading = true;
      }

      serviceDuration =
          Duration(minutes: widget.serviceModel.serviceDurationMin);
      _serviceDurationInHr = serviceDuration!.inHours;
      _serviceDurationInMin = serviceDuration!.inMinutes % 60;
      _serviceController.text = widget.serviceModel.servicesName;
      _serviceCodeController.text = widget.serviceModel.serviceCode;
      _priceController.text = widget.serviceModel.price.toString();
      _originalPriceController.text =
          widget.serviceModel.originalPrice.toString();
      _discountInPer.text = widget.serviceModel.discountInPer.toString();
      _hoursController.text = _serviceDurationInHr.toString();
      _minController.text = _serviceDurationInMin.toString();
      _descriptionController.text = widget.serviceModel.description!;
      _serviceFor = widget.serviceModel.serviceFor;
      _originalPriceController.addListener(_updateFinalPrice);
      _discountInPer.addListener(_updateFinalPrice);
    } finally {
      setStates() {
        _isLoading = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ServiceProvider serviceProvider = Provider.of<ServiceProvider>(context);

    return Scaffold(
      backgroundColor: ResponsiveLayout.isMoAndTab(context)
          ? AppColor.bgForAdminCreateSec
          : AppColor.bgForAdminCreateSec,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                // color: Colors.grey,
                color: AppColor.bgForAdminCreateSec,
                child: Container(
                  alignment: Alignment.topLeft,
                  width: ResponsiveLayout.isDesktop(context)
                      ? Dimensions.screenWidth / 1.5
                      : null,
                  // margin: EdgeInsets.only(top: Dimensions.dimensionNo30),
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.dimensionNo30,
                      vertical: Dimensions.dimensionNo30),
                  decoration: const BoxDecoration(
                    // color: Colors.green,
                    color: Colors.white,
                    // borderRadius: BorderRadius.circular(Dimensions.dimensionNo20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Update ${widget.serviceModel.servicesName} Service ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: Dimensions.dimensionNo24,
                              fontFamily: GoogleFonts.roboto().fontFamily,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.15,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.close)),
                        ],
                      ),
                      const Divider(),
                      SizedBox(
                        height: Dimensions.dimensionNo20,
                      ),
                      FormCustomTextField(
                          controller: _serviceController,
                          title: "Service name"),
                      SizedBox(
                        height: Dimensions.dimensionNo20,
                      ),
                      FormCustomTextField(
                          controller: _serviceCodeController,
                          title: "Service Code"),

                      SizedBox(
                        height: Dimensions.dimensionNo20,
                      ),
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
                      SizedBox(height: Dimensions.dimensionNo10),
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
                                    child:
                                        _TextFormTime(" HH ", _hoursController),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Dimensions.dimensionNo10),
                                    child: Text(
                                      ':',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: Dimensions.dimensionNo20,
                                        fontFamily:
                                            GoogleFonts.roboto().fontFamily,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.15,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: Dimensions.dimensionNo30,
                                    width: Dimensions.dimensionNo50,
                                    child:
                                        _TextFormTime(" MM ", _minController),
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
                                      fontFamily:
                                          GoogleFonts.roboto().fontFamily,
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

                      FormCustomTextField(
                          maxline: 6,
                          controller: _descriptionController,
                          title: "Service Description"),
                      SizedBox(
                        height: Dimensions.dimensionNo10,
                      ),
                      CustomAuthButton(
                        text: "Save",
                        ontap: () async {
                          try {
                            bool isVaildated = addNewServiceVaildation(
                              _serviceController.text.trim(),
                              _serviceCodeController.text.trim(),
                              _priceController.text.trim(),
                              context,

                              // _minController.text.trim(),
                            );
                            // Robust time validation

                            int hours = int.tryParse(_hoursController.text) ??
                                0; // Default to 0 if null or invalid
                            // Parse and validate numeric fields
                            double? originalPrice =
                                double.tryParse(_originalPriceController.text);
                            double? discountPercentage =
                                double.tryParse(_discountInPer.text);
                            double? finalPrice =
                                double.tryParse(_priceController.text);
                            int _hours = int.tryParse(_hoursController.text) ??
                                0; // Default to 0 if null or invalid
                            int? minutes = int.tryParse(_minController.text);

                            if (originalPrice == null ||
                                discountPercentage == null ||
                                finalPrice == null) {
                              showMessage(
                                  "Please enter valid numeric values for price and discount.");
                              return;
                            }

                            if (isVaildated) {
                              Duration? _serviceDurationMin = Duration(
                                  hours: hours,
                                  minutes:
                                      int.parse(_minController.text.trim()));
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
                              if (int.parse(_hoursController.text) < 0) {
                                showBottomMessageError(
                                  "Hours cannot be negative.",
                                  context,
                                );
                                return;
                              }

                              discountAmountFun();

                              ServiceModel serviceModel =
                                  widget.serviceModel.copyWith(
                                servicesName: _serviceController.text.trim(),
                                serviceCode: _serviceCodeController.text.trim(),
                                price: finalPrice,
                                originalPrice: originalPrice,
                                discountInPer: discountPercentage,
                                discountAmount: discountAmount,
                                serviceDurationMin:
                                    _serviceDurationMin.inMinutes,
                                description:
                                    _descriptionController.text.trim() ?? "",
                                serviceFor: _serviceFor ?? "Both",
                              );

                              serviceProvider
                                  .updateSingleServicePro(serviceModel);
                            }
                            Navigator.of(
                              context,
                            ).pop();

                            showMessage(
                                "Successfully updated ${widget.serviceModel.servicesName} service");
                          } catch (e) {
                            // showBottomMessageError(
                            //     "Something went wrong please add all fields",
                            //     context);
                          } finally {}
                        },
                      ),
                    ],
                  ),
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
