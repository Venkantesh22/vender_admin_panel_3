// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_local_variable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/models/category_model/category_model.dart';
import 'package:samay_admin_plan/models/service_model/service_model.dart';
import 'package:samay_admin_plan/provider/service_provider.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimenison.dart';
import 'package:samay_admin_plan/widget/customauthbutton.dart';
import 'package:samay_admin_plan/widget/customtextfield.dart';

class EditServicePage extends StatefulWidget {
  final int index;
  final ServiceModel serviceModel;
  final CategoryModel categoryModel;
  const EditServicePage({
    Key? key,
    required this.index,
    required this.serviceModel,
    required this.categoryModel,
  }) : super(key: key);

  @override
  State<EditServicePage> createState() => _EditServicePageState();
}

class _EditServicePageState extends State<EditServicePage> {
  String? _serviceFor;
  @override
  void initState() {
    super.initState();
    _serviceFor = widget.serviceModel.serviceFor;
  }

  @override
  Widget build(BuildContext context) {
    // AppProvider appProvider = Provider.of<AppProvider>(context);
    Duration? serviceDuration =
        Duration(minutes: widget.serviceModel.serviceDurationMin);
    int _serviceDurationInHr = serviceDuration.inHours;
    int _serviceDurationInMin = serviceDuration.inMinutes % 60;

    ServiceProvider serviceProvider = Provider.of<ServiceProvider>(context);
    final TextEditingController _serviceController =
        TextEditingController(text: widget.serviceModel.servicesName);
    final TextEditingController _serviceCodeController =
        TextEditingController(text: widget.serviceModel.serviceCode);
    final TextEditingController _priceController =
        TextEditingController(text: widget.serviceModel.price.toString());
    final TextEditingController _originalPriceController =
        TextEditingController(
            text: widget.serviceModel.originalPrice.toString());
    final TextEditingController _discountInPer = TextEditingController(
        text: widget.serviceModel.discountInPer.toString());
    final TextEditingController _hoursController =
        TextEditingController(text: _serviceDurationInHr.toString());
    final TextEditingController _minController =
        TextEditingController(text: _serviceDurationInMin.toString());
    final TextEditingController _descriptionController =
        TextEditingController(text: widget.serviceModel.description);

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

    return Scaffold(
      backgroundColor: ResponsiveLayout.isMoAndTab(context)
          ? AppColor.bgForAdminCreateSec
          : AppColor.bgForAdminCreateSec,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          // color: Colors.grey,
          color: AppColor.bgForAdminCreateSec,
          child: Container(
            alignment: Alignment.topLeft,
            width: ResponsiveLayout.isDesktop(context)
                ? Dimensions.screenWidth / 1.5
                : null,
            // margin: EdgeInsets.only(top: Dimensions.dimenisonNo30),
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.dimenisonNo30,
                vertical: Dimensions.dimenisonNo30),
            decoration: const BoxDecoration(
              // color: Colors.green,
              color: Colors.white,
              // borderRadius: BorderRadius.circular(Dimensions.dimenisonNo20),
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
                        fontSize: Dimensions.dimenisonNo24,
                        fontFamily: GoogleFonts.roboto().fontFamily,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.15,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close)),
                  ],
                ),
                const Divider(),
                SizedBox(
                  height: Dimensions.dimenisonNo20,
                ),
                FormCustomTextField(
                    controller: _serviceController, title: "Service name"),
                SizedBox(
                  height: Dimensions.dimenisonNo20,
                ),
                FormCustomTextField(
                    controller: _serviceCodeController, title: "Service Code"),

                SizedBox(
                  height: Dimensions.dimenisonNo20,
                ),
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
                SizedBox(height: Dimensions.dimenisonNo10),
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

                FormCustomTextField(
                    maxline: 6,
                    controller: _descriptionController,
                    title: "Service Description"),
                SizedBox(
                  height: Dimensions.dimenisonNo10,
                ),
                CustomAuthButton(
                  text: "Save",
                  ontap: () async {
                    try {
                      showLoaderDialog(context);
                      bool isVaildated = addNewServiceVaildation(
                        _serviceController.text.trim(),
                        _serviceCodeController.text.trim(),
                        _priceController.text.trim(),
                        // _hoursController.text.trim(),
                        _minController.text.trim(),
                      );
                      int hours = int.tryParse(_hoursController.text) ??
                          0; // Default to 0 if null or invalid

                      if (isVaildated) {
                        Duration? _serviceDurationMin = Duration(
                            hours: hours,
                            minutes: int.parse(_minController.text.trim()));
                        ServiceModel serviceModel =
                            widget.serviceModel.copyWith(
                          servicesName: _serviceController.text.trim(),
                          serviceCode: _serviceCodeController.text.trim(),
                          price: double.parse(_priceController.text.trim()),
                          serviceDurationMin: _serviceDurationMin.inMinutes,
                          description: _descriptionController.text.trim() ?? "",
                        );

                        serviceProvider.updateSingleServicePro(
                            widget.index, serviceModel);
                      }
                      Navigator.of(context, rootNavigator: true).pop();
                      Navigator.of(context).pop();

                      showMessage(
                          "Successfully updated ${widget.serviceModel.servicesName} service");
                    } catch (e) {
                      showMessage("Error not updated  service");
                    } finally {
                      Navigator.of(context, rootNavigator: true).pop();
                      Navigator.of(context).pop();
                    }
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
