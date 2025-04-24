// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/global_variable.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/features/setting/widget/heading_text_of_page.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_firestore_helper/setting_fb.dart';
import 'package:samay_admin_plan/models/salon_form_models/salon_infor_model.dart';
import 'package:samay_admin_plan/models/salon_setting_model/salon_setting_model.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';
import 'package:samay_admin_plan/provider/service_provider.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimenison.dart';
import 'package:samay_admin_plan/widget/customauthbutton.dart';
import 'package:samay_admin_plan/widget/customtextfield.dart';

class VerderSetting extends StatefulWidget {
  const VerderSetting({super.key});

  @override
  State<VerderSetting> createState() => _VerderSettingState();
}

class _VerderSettingState extends State<VerderSetting> {
  final TextEditingController timeController = TextEditingController();
  final TextEditingController dayController = TextEditingController();
  final TextEditingController gstController = TextEditingController();

  bool _isLoading = false;
  bool hasSettingSave = false;
  SettingModel? _settingModel;
  // Add a variable for GST price type selection.
  // It can be either "Inclusive" or "Exclusive". Default to "Inclusive".
  String _gstType = "";
  String _serviceAt = "";

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);

    if (appProvider.getSalonInformation.isSettingAdd) {
      setState(() {
        _isLoading = true;
      });

      try {
        hasSettingSave = true;
        final serviceProvider =
            Provider.of<ServiceProvider>(context, listen: false);

        await serviceProvider
            .fetchSettingPro(appProvider.getSalonInformation.id);
        _settingModel = serviceProvider.getSettingModel;

        timeController.text = _settingModel?.diffbtwTimetap ?? "";
        dayController.text = _settingModel?.dayForBooking.toString() ?? "";
        gstController.text = _settingModel?.gstNo ?? "";
        // If the setting model already has GST inclusion info, use it:
        if (_settingModel?.gSTIsIncludingOrExcluding != null) {
          _gstType = _settingModel!.gSTIsIncludingOrExcluding!;
        }
        if (_settingModel?.serviceAt != null) {
          _serviceAt = _settingModel!.serviceAt;
        }
      } catch (e) {
        print("Error fetching data: $e");
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    timeController.dispose();
    dayController.dispose();
    gstController.dispose();
    super.dispose();
  }

  bool validateFields() {
    if (timeController.text.trim().isEmpty) {
      showError("Time difference is required.");
      return false;
    }

    if (dayController.text.trim().isEmpty) {
      showError("Days for booking is required.");
      return false;
    }

    // If a GST type is selected, then a GST number must be provided.
    if (_gstType.isNotEmpty && gstController.text.trim().isEmpty) {
      showError("For selected GST type, please enter a GST number.");
      return false;
    }
    // is GST is enter then select gst type
    if (_gstType.isEmpty && gstController.text.trim().isNotEmpty) {
      showError("Please select GST type price is inclusive or exclusive");
      return false;
    }

    return true;
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final serviceProvider =
        Provider.of<ServiceProvider>(context, listen: false);

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                color: AppColor.bgForAdminCreateSec,
                child: Center(
                  child: Container(
                    margin: ResponsiveLayout.isMobile(context)
                        ? EdgeInsets.symmetric(
                            horizontal: Dimensions.dimenisonNo12,
                          )
                        : ResponsiveLayout.isTablet(context)
                            ? EdgeInsets.symmetric(
                                horizontal: Dimensions.dimenisonNo60,
                              )
                            : null,
                    padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveLayout.isMobile(context)
                            ? Dimensions.dimenisonNo10
                            : Dimensions.dimenisonNo30,
                        vertical: Dimensions.dimenisonNo20),
                    // color: Colors.green,
                    color: Colors.white,
                    width: ResponsiveLayout.isDesktop(context)
                        ? Dimensions.screenWidth / 1.5
                        : null,

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: headingTextOFPage(context, 'Settings'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: Dimensions.dimenisonNo10),
                          child: const Divider(),
                        ),
                        SizedBox(height: Dimensions.dimenisonNo14),
                        FormCustomTextField(
                          controller: timeController,
                          title:
                              "Enter the time difference in minutes between in-time taps?",
                          hintText: "Enter a Minute",
                          requiredField: false,
                        ),
                        SizedBox(height: Dimensions.dimenisonNo14),

                        FormCustomTextField(
                          controller: dayController,
                          title:
                              "Enter how many days before allowing for booking an appointment?",
                          hintText: "Enter a Day",
                          requiredField: false,
                        ),
                        SizedBox(height: Dimensions.dimenisonNo14),

                        TextForGSTNO(),
                        SizedBox(height: Dimensions.dimenisonNo20),
                        // GST price type selection:
                        // if (gstController.text.isNotEmpty)
                        GstInclusiveOrExclusive(),
                        SizedBox(height: Dimensions.dimenisonNo14),
                        ServiceAtSalonOrHome(),
                        const SizedBox(height: 50),
                        CustomAuthButton(
                          text:
                              serviceProvider.getSettingModel?.id.isNotEmpty ??
                                      false
                                  ? "Update"
                                  : "Save",
                          ontap: () async {
                            if (!validateFields()) return;

                            try {
                              final salonId =
                                  appProvider.getSalonInformation.id;

                              // Debugging: Log the value of isSettingAdd
                              debugPrint(
                                  "isSettingAdd: ${appProvider.getSalonInformation.isSettingAdd}");

                              String _saveGstType =
                                  gstController.text.isEmpty ? "" : _gstType;

                              final updatedSetting =
                                  serviceProvider.getSettingModel!.copyWith(
                                diffbtwTimetap: timeController.text.trim(),
                                dayForBooking:
                                    int.parse(dayController.text.trim()),
                                gstNo: gstController.text.trim(),
                                isUpdate: true,
                                gSTIsIncludingOrExcluding: _saveGstType,
                                serviceAt: _serviceAt,
                              );

                              // Update existing settings
                              debugPrint("Updating settings...");
                              await SettingFb.instance.updateSettingFB(
                                updatedSetting,
                                salonId,
                                serviceProvider.getSettingModel!.id,
                              );

                              // Refresh salon information
                              await appProvider.getSalonInfoFirebase();

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text("Settings updated successfully."),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } catch (e) {
                              showError("Failed to update settings: $e");
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Column TextForGSTNO() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Enter GST Number",
          style: TextStyle(
            color: Colors.black,
            fontSize: ResponsiveLayout.isMobile(context)
                ? Dimensions.dimenisonNo14
                : Dimensions.dimenisonNo18,
            fontFamily: GoogleFonts.roboto().fontFamily,
            fontWeight: FontWeight.w500,
            // letterSpacing: 0.90,
          ),
        ),
        SizedBox(
          height: Dimensions.dimenisonNo5,
        ),
        SizedBox(
          //salon description textbox has. max line.

          height: Dimensions.dimenisonNo30,
          child: TextFormField(
            cursorHeight: Dimensions.dimenisonNo16,
            style: TextStyle(
                fontSize: Dimensions.dimenisonNo12,
                fontFamily: GoogleFonts.roboto().fontFamily,
                fontWeight: FontWeight.bold,
                color: Colors.black),
            controller: gstController,
            decoration: InputDecoration(
              hintText: "Enter GST Number",
              hintStyle: TextStyle(
                  fontSize: Dimensions.dimenisonNo12,
                  fontFamily: GoogleFonts.roboto().fontFamily,
                  fontWeight: FontWeight.w200,
                  color: Colors.grey),
              contentPadding: EdgeInsets.symmetric(
                  horizontal: Dimensions.dimenisonNo10,
                  vertical: Dimensions.dimenisonNo10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.dimenisonNo16),
              ),
            ),
            onChanged: (val) => setState(() {
              if (gstController.text.isNotEmpty || gstController.text != null) {
                _gstType = "";
              }
            }),
            validator: (val) {
              if (val == null || val.isEmpty) {
                return 'Enter your GST Number';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Column GstInclusiveOrExclusive() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text:
                    "Is the service price inclusive or exclusive of the GST amount?",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: ResponsiveLayout.isMobile(context)
                      ? Dimensions.dimenisonNo14
                      : Dimensions.dimenisonNo18,
                  fontFamily: GoogleFonts.roboto().fontFamily,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextSpan(
                text: ' *',
                style: TextStyle(
                  color: const Color(0xFFFC0000),
                  fontSize: Dimensions.dimenisonNo18,
                  fontFamily: GoogleFonts.roboto().fontFamily,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: Dimensions.dimenisonNo5),
        Row(
          children: [
            Row(
              children: [
                Radio<String>(
                  value: "Inclusive",
                  groupValue: _gstType,
                  onChanged: (value) {
                    setState(() {
                      gstController.text.isNotEmpty ||
                              gstController.text != null
                          ? _gstType = value!
                          : _gstType = "";
                    });
                  },
                ),
                Text("Inclusive",
                    style: TextStyle(fontSize: Dimensions.dimenisonNo16)),
              ],
            ),
            SizedBox(
                width: ResponsiveLayout.isMobile(context)
                    ? Dimensions.dimenisonNo12
                    : Dimensions.dimenisonNo20),
            Row(
              children: [
                Radio<String>(
                  value: "Exclusive",
                  groupValue: _gstType,
                  onChanged: (value) {
                    setState(() {
                      gstController.text.isNotEmpty ||
                              gstController.text != null
                          ? _gstType = value!
                          : _gstType = "";
                    });
                  },
                ),
                Text("Exclusive",
                    style: TextStyle(fontSize: Dimensions.dimenisonNo16)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Column ServiceAtSalonOrHome() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text:
                    "Please select the type of services you offer at your salon or home.",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: Dimensions.dimenisonNo18,
                  fontFamily: GoogleFonts.roboto().fontFamily,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextSpan(
                text: ' *',
                style: TextStyle(
                  color: const Color(0xFFFC0000),
                  fontSize: Dimensions.dimenisonNo18,
                  fontFamily: GoogleFonts.roboto().fontFamily,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: Dimensions.dimenisonNo5),
        Row(
          children: [
            Row(
              children: [
                Radio<String>(
                  value: GlobalVariable.serviceAtSalon,
                  groupValue: _serviceAt,
                  onChanged: (value) {
                    setState(() {
                      _serviceAt = value!;
                    });
                  },
                ),
                Text(GlobalVariable.serviceAtSalon,
                    style: TextStyle(fontSize: Dimensions.dimenisonNo16)),
              ],
            ),
            SizedBox(
                width: ResponsiveLayout.isMobile(context)
                    ? Dimensions.dimenisonNo12
                    : Dimensions.dimenisonNo20),
            Row(
              children: [
                Radio<String>(
                  value: GlobalVariable.serviceAtHome,
                  groupValue: _serviceAt,
                  onChanged: (value) {
                    setState(() {
                      _serviceAt = value!;
                    });
                  },
                ),
                Text(GlobalVariable.serviceAtHome,
                    style: TextStyle(fontSize: Dimensions.dimenisonNo16)),
              ],
            ),
            SizedBox(
                width: ResponsiveLayout.isMobile(context)
                    ? Dimensions.dimenisonNo12
                    : Dimensions.dimenisonNo20),
            Row(
              children: [
                Radio<String>(
                  value: GlobalVariable.serviceAtBoth,
                  groupValue: _serviceAt,
                  onChanged: (value) {
                    setState(() {
                      _serviceAt = value!;
                    });
                  },
                ),
                Text(GlobalVariable.serviceAtBoth,
                    style: TextStyle(fontSize: Dimensions.dimenisonNo16)),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
