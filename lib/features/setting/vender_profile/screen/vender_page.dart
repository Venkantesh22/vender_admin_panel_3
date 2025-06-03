// ignore_for_file: unrelated_type_equality_checks

import 'dart:typed_data';
import 'package:csc_picker_plus/csc_picker_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/constants/global_variable.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/constants/router.dart';
import 'package:samay_admin_plan/features/home/screen/main_home/home_screen.dart';
import 'package:samay_admin_plan/features/setting/vender_profile/widget/time_pick_f_venderpage.dart';
import 'package:samay_admin_plan/features/setting/widget/heading_text_of_page.dart';
import 'package:samay_admin_plan/models/salon_form_models/salon_infor_model.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';
import 'package:samay_admin_plan/provider/calender_provider.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimenison.dart';
import 'package:samay_admin_plan/utility/get_avatar_bg_color.dart';
import 'package:samay_admin_plan/widget/customauthbutton.dart';
import 'package:samay_admin_plan/widget/customtextfield.dart';

class SalonProfilePage extends StatefulWidget {
  const SalonProfilePage({super.key});

  @override
  State<SalonProfilePage> createState() => _SalonProfilePageState();
}

class _SalonProfilePageState extends State<SalonProfilePage> {
  final TextEditingController _salonName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _mobile = TextEditingController();
  final TextEditingController _whatApp = TextEditingController();
  final TextEditingController _descrition = TextEditingController();
  final TextEditingController _address = TextEditingController();

  final TextEditingController _pincode = TextEditingController();
  final TextEditingController _openTime = TextEditingController();
  final TextEditingController _closeTime = TextEditingController();

  String? adminUid = FirebaseAuth.instance.currentUser?.uid;
  late TimeOfDay openTimeAfterTime;
  late TimeOfDay closeTimeAfterTime;
  late TimeOfDay openTimeUpdate;
  late TimeOfDay closeTimeUpdate;

  String? countryValue = "";
  String? stateValue = "";
  String? cityValue = "";

  bool _isLoading = false;
  bool isupdate = false;
  bool isImageChange = false;
  bool islogChange = false;

  //! For DropDownList
  String? _selectedSalonType;
  final List<String> _salonTypeOptions = [
    'Unisex',
    'Only Male',
    'Only Female',
  ];

  Uint8List? selectedImage;
  Uint8List? selectedlog;

  chooseImages(Uint8List? imageValue) async {
    FilePickerResult? chosenImageFile =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (chosenImageFile != null) {
      setState(() {
        imageValue = chosenImageFile.files.single.bytes;
      });
    }
    isImageChange = true;
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    getData();
  }

  String convertTimeOfDayToString(TimeOfDay timeOfDay) {
    final hour = timeOfDay.hour;
    final minute = timeOfDay.minute;
    final period = hour < 12 ? 'AM' : 'PM';
    final hour12 = hour % 12 == 0 ? 12 : hour % 12;

    return '$hour12:$minute $period';
  }

  Future<void> getData() async {
    setState(() => _isLoading = true);
    final appProvider = Provider.of<AppProvider>(context, listen: false);

    try {
      final info = appProvider.getSalonInformation;
      if (info == null) throw Exception("Salon information is not available.");

      // Safely assign with fallbacks
      _selectedSalonType = info.salonType ?? _salonTypeOptions.first;
      _salonName.text = info.name ?? '';
      _email.text = info.email ?? '';
      _mobile.text = info.number?.toString() ?? '';
      _whatApp.text = info.whatApp?.toString() ?? '';
      _descrition.text = info.description ?? '';
      _address.text = info.address ?? '';
      _pincode.text = info.pinCode ?? '';

      if (info.openTime != null) {
        openTimeUpdate = info.openTime!;
        _openTime.text = convertTimeOfDayToString(openTimeUpdate);
      }
      if (info.closeTime != null) {
        closeTimeUpdate = info.closeTime!;
        _closeTime.text = convertTimeOfDayToString(closeTimeUpdate);
      }
      openTimeAfterTime = info.openTime ?? openTimeAfterTime;
      closeTimeAfterTime = info.closeTime ?? closeTimeAfterTime;

      countryValue = info.country ?? '';
      stateValue = info.state ?? '';
      cityValue = info.city ?? '';
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  TimeOfDay stringToTimeOfDay(String timeString) {
    final parts = timeString.split(' ');
    final timeParts = parts[0].split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    final isPM = parts[1].toUpperCase() == 'PM';

    if (isPM && hour != 12) {
      return TimeOfDay(hour: hour + 12, minute: minute);
    } else if (!isPM && hour == 12) {
      return TimeOfDay(hour: 0, minute: minute);
    } else {
      return TimeOfDay(hour: hour, minute: minute);
    }
  }

  @override
  void dispose() {
    _salonName.dispose();
    _email.dispose();
    _mobile.dispose();
    _whatApp.dispose();
    _descrition.dispose();
    _address.dispose();
    _pincode.dispose();
    _openTime.dispose();
    _closeTime.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                // color: Colors.grey,
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
                          child: headingTextOFPage(
                            context,
                            'Saloon Profile Details',
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: Dimensions.dimenisonNo10),
                          child: Divider(),
                        ),
                        imageAndLogPart(appProvider),
                        SizedBox(height: Dimensions.dimenisonNo10),
                        FormCustomTextField(
                          controller: _salonName,
                          title: "${GlobalVariable.salon} Name",
                        ),
                        SizedBox(height: Dimensions.dimenisonNo10),
                        FormCustomTextField(
                          controller: _email,
                          title: "Email ID",
                        ),
                        SizedBox(height: Dimensions.dimenisonNo10),
                        FormCustomTextField(
                          controller: _mobile,
                          title: "Mobile No",
                        ),
                        SizedBox(height: Dimensions.dimenisonNo10),
                        FormCustomTextField(
                          controller: _whatApp,
                          title: "WhatApp No",
                        ),
                        SizedBox(height: Dimensions.dimenisonNo10),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '${GlobalVariable.salon} Type ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: Dimensions.dimenisonNo18,
                                  fontFamily: GoogleFonts.roboto().fontFamily,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.15,
                                ),
                              ),
                              TextSpan(
                                text: '*',
                                style: TextStyle(
                                  color: const Color(0xFFFC0000),
                                  fontSize: Dimensions.dimenisonNo18,
                                  fontFamily: GoogleFonts.roboto().fontFamily,
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                  letterSpacing: 0.15,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: Dimensions.dimenisonNo5),
                        DropdownButtonFormField<String>(
                          hint: Text(
                            'Select ${GlobalVariable.salon} Type',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: Dimensions.dimenisonNo16,
                              fontFamily: GoogleFonts.roboto().fontFamily,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.40,
                            ),
                          ),
                          value: _selectedSalonType,
                          items: _salonTypeOptions.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedSalonType = newValue;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a ${GlobalVariable.salon} type';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: Dimensions.dimenisonNo10),
                        FormCustomTextField(
                          controller: _descrition,
                          title: "${GlobalVariable.salon} Description",
                          maxline: 5,
                        ),
                        SizedBox(height: Dimensions.dimenisonNo10),
                        TimingSection(appProvider, context),
                        SizedBox(height: Dimensions.dimenisonNo10),
                        FormCustomTextField(
                          controller: _address,
                          title: "Address",
                          maxline: 2,
                        ),
                        SizedBox(height: Dimensions.dimenisonNo20),
                        Text(
                          "The address is updated; it does not show here. You can see it in the app. If you want to change it, do it here.",
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: Dimensions.dimenisonNo12,
                            fontFamily: GoogleFonts.roboto().fontFamily,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.40,
                          ),
                        ),
                        SizedBox(height: Dimensions.dimenisonNo5),
                        Row(
                          children: [
                            Expanded(
                              child: CSCPickerPlus(
                                layout: Layout.horizontal,
                                flagState: CountryFlag.DISABLE,
                                defaultCountry: CscCountry.India,
                                onCountryChanged: (c) =>
                                    setState(() => countryValue = c),
                                onStateChanged: (s) =>
                                    setState(() => stateValue = s ?? ''),
                                onCityChanged: (c) =>
                                    setState(() => cityValue = c ?? ''),
                                countrySearchPlaceholder: "Country",
                                stateSearchPlaceholder: "State",
                                citySearchPlaceholder: "City",
                                countryDropdownLabel: countryValue != null &&
                                        countryValue!.isNotEmpty
                                    ? countryValue!
                                    : "India",
                                stateDropdownLabel:
                                    stateValue != null && stateValue!.isNotEmpty
                                        ? stateValue!
                                        : "Select State",
                                cityDropdownLabel:
                                    cityValue != null && cityValue!.isNotEmpty
                                        ? cityValue!
                                        : "Select City",
                                dropdownDialogRadius: Dimensions.dimenisonNo12,
                                searchBarRadius: Dimensions.dimenisonNo30,
                                dropdownDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.dimenisonNo10),
                                  color: Colors.white,
                                  border:
                                      Border.all(color: Colors.black, width: 1),
                                ),
                                disabledDropdownDecoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.dimenisonNo10),
                                  color: Colors.grey.shade300,
                                  border:
                                      Border.all(color: Colors.black, width: 1),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Dimensions.dimenisonNo12),
                        FormCustomTextField(
                            controller: _pincode, title: "Pincode"),
                        SizedBox(height: Dimensions.dimenisonNo20),
                        CustomAuthButton(
                          text: "Update",
                          ontap: () async {
                            try {
                              String timeOfDayToString(TimeOfDay timeOfDay) {
                                return '${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}';
                              }

                              print(
                                  "Open time ${timeOfDayToString(openTimeUpdate)} ");
                              print(
                                  "Closer time ${timeOfDayToString(closeTimeUpdate)} ");

                              // if (_isVaildated) {
                              SalonModel salonModelUpdate =
                                  appProvider.getSalonInformation.copyWith(
                                name: _salonName.text.trim(),
                                email: _email.text.trim(),
                                number: int.parse(_mobile.text.trim()),
                                whatApp: int.parse(_whatApp.text.trim()),
                                salonType: _selectedSalonType!,
                                description: _descrition.text.trim(),
                                address: _address.text.trim(),
                                city: cityValue,
                                state: stateValue,
                                country: countryValue,
                                pinCode: _pincode.text.trim(),
                                openTime: openTimeUpdate,
                                closeTime: closeTimeUpdate,
                                monday: appProvider
                                            .getSalonInformation.monday ==
                                        'Close'
                                    ? appProvider.getSalonInformation.monday
                                    : _openTime ==
                                                appProvider.getSalonInformation
                                                    .openTime &&
                                            _closeTime ==
                                                appProvider.getSalonInformation
                                                    .closeTime
                                        ? appProvider.getSalonInformation.monday
                                        : "${GlobalVariable.timeOfDayToDateTimeAM(openTimeUpdate)} To ${GlobalVariable.timeOfDayToDateTimeAM(closeTimeUpdate)}",
                                tuesday: appProvider
                                            .getSalonInformation.tuesday ==
                                        'Close'
                                    ? appProvider.getSalonInformation.tuesday
                                    : _openTime ==
                                                appProvider.getSalonInformation
                                                    .openTime &&
                                            _closeTime ==
                                                appProvider.getSalonInformation
                                                    .closeTime
                                        ? appProvider
                                            .getSalonInformation.tuesday
                                        : "${GlobalVariable.timeOfDayToDateTimeAM(openTimeUpdate)} To ${GlobalVariable.timeOfDayToDateTimeAM(closeTimeUpdate)}",
                                wednesday: appProvider
                                            .getSalonInformation.wednesday ==
                                        'Close'
                                    ? appProvider.getSalonInformation.monday
                                    : _openTime ==
                                                appProvider.getSalonInformation
                                                    .openTime &&
                                            _closeTime ==
                                                appProvider.getSalonInformation
                                                    .closeTime
                                        ? appProvider
                                            .getSalonInformation.wednesday
                                        : "${GlobalVariable.timeOfDayToDateTimeAM(openTimeUpdate)} To ${GlobalVariable.timeOfDayToDateTimeAM(closeTimeUpdate)}",
                                thursday: appProvider
                                            .getSalonInformation.thursday ==
                                        'Close'
                                    ? appProvider.getSalonInformation.thursday
                                    : _openTime ==
                                                appProvider.getSalonInformation
                                                    .openTime &&
                                            _closeTime ==
                                                appProvider.getSalonInformation
                                                    .closeTime
                                        ? appProvider
                                            .getSalonInformation.thursday
                                        : "${GlobalVariable.timeOfDayToDateTimeAM(openTimeUpdate)} To ${GlobalVariable.timeOfDayToDateTimeAM(closeTimeUpdate)}",
                                friday: appProvider
                                            .getSalonInformation.friday ==
                                        'Close'
                                    ? appProvider.getSalonInformation.friday
                                    : _openTime ==
                                                appProvider.getSalonInformation
                                                    .openTime &&
                                            _closeTime ==
                                                appProvider.getSalonInformation
                                                    .closeTime
                                        ? appProvider.getSalonInformation.friday
                                        : "${GlobalVariable.timeOfDayToDateTimeAM(openTimeUpdate)} To ${GlobalVariable.timeOfDayToDateTimeAM(closeTimeUpdate)}",
                                saturday: appProvider
                                            .getSalonInformation.saturday ==
                                        'Close'
                                    ? appProvider.getSalonInformation.saturday
                                    : _openTime ==
                                                appProvider.getSalonInformation
                                                    .openTime &&
                                            _closeTime ==
                                                appProvider.getSalonInformation
                                                    .closeTime
                                        ? appProvider
                                            .getSalonInformation.saturday
                                        : "${GlobalVariable.timeOfDayToDateTimeAM(openTimeUpdate)} To ${GlobalVariable.timeOfDayToDateTimeAM(closeTimeUpdate)}",
                                sunday: appProvider
                                            .getSalonInformation.sunday ==
                                        'Close'
                                    ? appProvider.getSalonInformation.sunday
                                    : _openTime ==
                                                appProvider.getSalonInformation
                                                    .openTime &&
                                            _closeTime ==
                                                appProvider.getSalonInformation
                                                    .closeTime
                                        ? appProvider.getSalonInformation.sunday
                                        : "${GlobalVariable.timeOfDayToDateTimeAM(openTimeUpdate)} To ${GlobalVariable.timeOfDayToDateTimeAM(closeTimeUpdate)}",
                              );

                              if (isImageChange && islogChange) {
                                // Both image and logo changed
                                isupdate =
                                    await appProvider.updateSalonInfoFirebase(
                                  context,
                                  salonModelUpdate,
                                  image: selectedImage,
                                  imageLogo: selectedlog,
                                );
                              } else if (isImageChange) {
                                // Only image changed
                                isupdate =
                                    await appProvider.updateSalonInfoFirebase(
                                  context,
                                  salonModelUpdate,
                                  image: selectedImage,
                                );
                              } else if (islogChange) {
                                // Only logo changed
                                isupdate =
                                    await appProvider.updateSalonInfoFirebase(
                                  context,
                                  salonModelUpdate,
                                  imageLogo: selectedlog,
                                );
                              } else {
                                // No image or logo changed, just update other info
                                isupdate =
                                    await appProvider.updateSalonInfoFirebase(
                                  context,
                                  salonModelUpdate,
                                );
                              }

                              showMessage("Salon Update Successfully add");
                              print("Salon ID ${GlobalVariable.salonID}");

                              if (isupdate) {
                                Routes.instance.push(
                                    widget: HomeScreen(
                                      date: Provider.of<CalenderProvider>(
                                              context,
                                              listen: false)
                                          .getSelectDate,
                                    ),
                                    // ignore: use_build_context_synchronously
                                    context: context);
                              }
                              // }
                            } catch (e) {
                              print(e.toString());
                              showMessage(
                                  'Salon is not Update or an error occurred');
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

//! Image and log part
  Column imageAndLogPart(AppProvider appProvider) {
    return Column(
      children: [
        textboxHeading('Upload ${GlobalVariable.salon} Images ', true),
        SizedBox(height: Dimensions.dimenisonNo10),
        Stack(
          children: [
            // Main Salon Image
            InkWell(
              onTap: () async {
                FilePickerResult? chosenImageFile =
                    await FilePicker.platform.pickFiles(type: FileType.image);
                if (chosenImageFile != null) {
                  setState(() {
                    selectedImage = chosenImageFile.files.single.bytes;
                    isImageChange = true;
                  });
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.dimenisonNo20),
                ),
                width: Dimensions.dimenisonNo300,
                height: Dimensions.dimenisonNo200,
                clipBehavior: Clip.antiAlias,
                child: selectedImage != null
                    ? Image.memory(selectedImage!, fit: BoxFit.cover)
                    : (appProvider.getSalonInformation.image != null &&
                            appProvider.getSalonInformation.image!.isNotEmpty)
                        ? Image.network(
                            appProvider.getSalonInformation.image!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Center(
                              child: Icon(
                                Icons.image,
                                size: Dimensions.dimenisonNo200,
                              ),
                            ),
                          )
                        : Center(
                            child: Icon(
                              Icons.image,
                              size: Dimensions.dimenisonNo200,
                            ),
                          ),
              ),
            ),
            // Salon Logo (bottom left)
            Positioned(
              bottom: 8,
              left: 8,
              child: InkWell(
                onTap: () async {
                  FilePickerResult? chosenLogoFile =
                      await FilePicker.platform.pickFiles(type: FileType.image);
                  if (chosenLogoFile != null) {
                    setState(() {
                      selectedlog = chosenLogoFile.files.single.bytes;
                      islogChange = true;
                    });
                  }
                },
                child: CircleAvatar(
                  radius: Dimensions.dimenisonNo40,
                  backgroundColor: Colors.white,
                  child: selectedlog != null
                      ? CircleAvatar(
                          radius: Dimensions.dimenisonNo38,
                          backgroundImage: MemoryImage(selectedlog!),
                        )
                      : (appProvider.getSalonInformation.logImage != null &&
                              appProvider
                                  .getSalonInformation.logImage!.isNotEmpty)
                          ? CircleAvatar(
                              radius: Dimensions.dimenisonNo38,
                              backgroundColor: getAvatarBgColor(
                                  appProvider.getSalonInformation.name),
                              backgroundImage: NetworkImage(
                                  appProvider.getSalonInformation.logImage!),
                              onBackgroundImageError: (_, __) {},
                            )
                          : CircleAvatar(
                              radius: Dimensions.dimenisonNo38,
                              backgroundColor: getAvatarBgColor(
                                  appProvider.getSalonInformation.name),
                              child: Text(
                                (appProvider
                                        .getSalonInformation.name.isNotEmpty)
                                    ? appProvider.getSalonInformation.name[0]
                                        .toUpperCase()
                                    : '',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: Dimensions.dimenisonNo28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Text textboxHeading(String heading, bool isRequired) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: heading,
            style: TextStyle(
              color: Colors.black,
              fontSize: Dimensions.dimenisonNo18,
              fontFamily: GoogleFonts.roboto().fontFamily,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.15,
            ),
          ),
          TextSpan(
            text: isRequired ? '*' : '',
            style: TextStyle(
              color: const Color(0xFFFC0000),
              fontSize: Dimensions.dimenisonNo18,
              fontFamily: GoogleFonts.roboto().fontFamily,
              fontWeight: FontWeight.w500,
              height: 0,
              letterSpacing: 0.15,
            ),
          ),
        ],
      ),
    );
  }

  Row TimingSection(AppProvider appProvider, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //! select a time

        PickTimeSectionForVenderPage(
          openController: _openTime,
          closeController: _closeTime,
          openTime: openTimeUpdate,
          closeTime: closeTimeUpdate,
          heading: "Select the timing of ${GlobalVariable.salon}",
          onOpenTimeSelected: (TimeOfDay selectedTime) {
            setState(() {
              openTimeUpdate = selectedTime;
            });
          },
          onCloseTimeSelected: (TimeOfDay selectedTime) {
            setState(() {
              closeTimeUpdate = selectedTime;
              // GlobalVariable.convertTo12HourFormat(selectedTime);
            });
          },
        )
      ],
    );
  }
}
