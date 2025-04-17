// ignore_for_file: no_leading_underscores_for_local_identifiers, unnecessary_string_interpolations, use_build_context_synchronously

import 'dart:typed_data';
// import 'package:csc_picker/csc_picker.dart';
import 'package:csc_picker_plus/csc_picker_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/constants/global_variable.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/features/Account_Create_Form/widget/account_time_section.dart';
import 'package:samay_admin_plan/features/Account_Create_Form/widget/salon_social_media_add.dart';
import 'package:samay_admin_plan/features/auth/login.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimenison.dart';
import 'package:samay_admin_plan/widget/customauthbutton.dart';
import 'package:samay_admin_plan/widget/customtextfield.dart';

class AccountCreateForm extends StatefulWidget {
  const AccountCreateForm({super.key});

  @override
  State<AccountCreateForm> createState() => _AccountCreateFormState();
}

class _AccountCreateFormState extends State<AccountCreateForm> {
  final TextEditingController _salonName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _mobile = TextEditingController();
  final TextEditingController _whatApp = TextEditingController();
  final TextEditingController _descrition = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _pincode = TextEditingController();
  final TextEditingController _openTime = TextEditingController();
  final TextEditingController _closeTime = TextEditingController();
  final TextEditingController _instagram = TextEditingController();
  final TextEditingController _facebook = TextEditingController();
  final TextEditingController _googleMap = TextEditingController();
  final TextEditingController _linked = TextEditingController();
  String? adminUid = FirebaseAuth.instance.currentUser?.uid;
  DateTime? openTimeFormat;
  DateTime? closeTimeFormat;

  String? countryValue = "";
  String? stateValue = "";
  String? cityValue = "";

  //! For DropDownList
  String? _selectedSalonType;
  final List<String> _salonTypeOptions = [
    'Unisex',
    'Only Male',
    'Only Female',
  ];

  Uint8List? selectedImage;

  chooseImages() async {
    FilePickerResult? chosenImageFile =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (chosenImageFile != null) {
      setState(() {
        selectedImage = chosenImageFile.files.single.bytes;
      });
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
    _instagram.dispose();
    _facebook.dispose();
    _googleMap.dispose();
    _linked.dispose();
    super.dispose();
  }

  void save(
    AppProvider appProvider,
  ) async {
    try {
      await appProvider.getAdminInfoFirebase();
      bool _isVaildated = formCreateAccountVaildation(
        _salonName.text,
        _email.text,
        _mobile.text,
        _whatApp.text,
        _selectedSalonType!,
        _descrition.text,
        _address.text,
        cityValue!,
        stateValue!,
        countryValue!,
        _pincode.text,
        GlobalVariable.openTimeGlo,
        GlobalVariable.closerTimeGlo,
        _instagram.text,
        _facebook.text,
        _googleMap.text,
        _linked.text,
        selectedImage!,
      );

      if (_isVaildated) {
        appProvider.addsalonInfoForm(
            selectedImage!,
            _salonName.text.trim(),
            _email.text.trim(),
            _mobile.text.trim(),
            _whatApp.text.trim(),
            _selectedSalonType!,
            _descrition.text.trim(),
            _address.text.trim(),
            cityValue!,
            stateValue!,
            countryValue!,
            _pincode.text.trim(),
            GlobalVariable.openTimeGlo,
            GlobalVariable.closerTimeGlo,
            _instagram.text.trim(),
            _facebook.text.trim(),
            _googleMap.text.trim(),
            _linked.text.trim(),
            context);
        showMessage("Salon profile is created...");
        print("Salon profile is created...");
        showMessage("Salon is successfully created");
        showMessage("Please login to your salon account");

//! ##########   function saveSettingToFB move to account_create_form.dart file at last check it work porter

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } catch (e) {
      print('Salon is not create or an error occurred : $e');
      showMessage('Salon is not create or an error occurred $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.mainColor,
          title: Center(
            child: Text(
              '${GlobalVariable.salon} Profile Details',
              style: TextStyle(
                color: Colors.white,
                fontSize: Dimensions.dimenisonNo30,
                fontFamily: GoogleFonts.roboto().fontFamily,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.15,
              ),
            ),
          ),
        ),
        body: ResponsiveLayout(
          mobile: accountMobileWidget(appProvider, context),
          desktop: accountWebWidget(appProvider, context),
        ));
  }

  SingleChildScrollView accountWebWidget(
      AppProvider appProvider, BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        // color: Colors.grey,
        color: AppColor.bgForAdminCreateSec,
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.dimenisonNo30,
                vertical: Dimensions.dimenisonNo20),
            // color: Colors.green,
            color: Colors.white,
            width: Dimensions.screenWidth / 1.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Upload ${GlobalVariable.salon} Images ',
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
                SizedBox(height: Dimensions.dimenisonNo10),
                selectedImage == null
                    ? InkWell(
                        onTap: chooseImages,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  Dimensions.dimenisonNo20)),
                          width: Dimensions.dimenisonNo300,
                          height: Dimensions.dimenisonNo200,
                          child: Icon(
                            Icons.image,
                            size: Dimensions.dimenisonNo200,
                          ),
                        ),
                      )
                    : InkWell(
                        onTap: chooseImages,
                        child: Container(
                          margin:
                              EdgeInsets.only(left: Dimensions.dimenisonNo20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  Dimensions.dimenisonNo20)),
                          width: Dimensions.dimenisonNo300,
                          height: Dimensions.dimenisonNo200,
                          clipBehavior: Clip.antiAlias,
                          child: Image.memory(
                            selectedImage!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
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
                //! select a time

                PickTimeSection(
                  openController: _openTime,
                  closeController: _closeTime,
                  onOpenTimeSelected: (DateTime selectedTime) {
                    setState(() {
                      openTimeFormat = selectedTime;
                    });
                  },
                  onCloseTimeSelected: (DateTime selectedTime) {
                    setState(() {
                      closeTimeFormat = selectedTime;
                    });
                  },
                ),

                SizedBox(height: Dimensions.dimenisonNo20),
                FormCustomTextField(
                  controller: _address,
                  title: "Address",
                  maxline: 2,
                ),
                SizedBox(height: Dimensions.dimenisonNo10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Drop downloads to select state.and an city.
                    Expanded(
                      child: CSCPickerPlus(
                        layout: Layout.horizontal,
                        flagState: CountryFlag.DISABLE,
                        defaultCountry: CscCountry.India,
                        onCountryChanged: (country) {
                          countryValue = country;
                        },
                        onStateChanged: (state) {
                          stateValue = state;
                        },
                        onCityChanged: (city) {
                          cityValue = city;
                        },

                        ///placeholders for dropdown search field
                        countrySearchPlaceholder: "Country",
                        stateSearchPlaceholder: "State",
                        citySearchPlaceholder: "City",

                        ///labels for dropdown
                        countryDropdownLabel: "Select Country",
                        stateDropdownLabel: "Select State",
                        cityDropdownLabel: "Select City",

                        dropdownDialogRadius: Dimensions.dimenisonNo12,
                        searchBarRadius: Dimensions.dimenisonNo30,

                        ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
                        dropdownDecoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(Dimensions.dimenisonNo10)),
                            color: Colors.white,
                            border: Border.all(color: Colors.black, width: 1)),

                        ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                        disabledDropdownDecoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(Dimensions.dimenisonNo10)),
                            color: Colors.grey.shade300,
                            border: Border.all(color: Colors.black, width: 1)),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: Dimensions.dimenisonNo10),
                SizedBox(
                  width: Dimensions.dimenisonNo150,
                  child: FormCustomTextField(
                      controller: _pincode, title: "Pincode"),
                ),
                SizedBox(height: Dimensions.dimenisonNo20),
                Text(
                  'Social media Information',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: Dimensions.dimenisonNo16,
                    fontWeight: FontWeight.w500,
                    fontFamily: GoogleFonts.roboto().fontFamily,
                    letterSpacing: 0.15,
                  ),
                ),
                SizedBox(height: Dimensions.dimenisonNo10),
                Column(
                  children: [
                    SalonSocialMediaAdd(
                      text: "Instagram",
                      icon: FontAwesomeIcons.instagram,
                      controller: _instagram,
                    ),
                    SalonSocialMediaAdd(
                      text: "Facebook",
                      icon: FontAwesomeIcons.facebook,
                      controller: _facebook,
                    ),
                    SalonSocialMediaAdd(
                      text: "Google Map",
                      icon: FontAwesomeIcons.mapLocationDot,
                      controller: _googleMap,
                    ),
                    SalonSocialMediaAdd(
                      text: "Linkedin",
                      icon: FontAwesomeIcons.linkedin,
                      controller: _linked,
                    ),
                  ],
                ),
                SizedBox(height: Dimensions.dimenisonNo20),
                // CustomAuthButton(
                //     text: "check",
                //     ontap: () {
                //       print(
                //           " open Time ${DateFormat('hh:mm a').format(openTimeFormat!)}");
                //       print(
                //           " Clost Time ${DateFormat('hh:mm a').format(closeTimeFormat!)}");
                //       print("state $stateValue");
                //       print("city $cityValue");
                //     }),
                CustomAuthButton(
                  text: "Save",
                  ontap: () => save(
                    appProvider,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SingleChildScrollView accountMobileWidget(
      AppProvider appProvider, BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(
            horizontal: Dimensions.dimenisonNo20,
            vertical: Dimensions.dimenisonNo10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Upload ${GlobalVariable.salon} Images ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: Dimensions.dimenisonNo16,
                      fontFamily: GoogleFonts.roboto().fontFamily,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.15,
                    ),
                  ),
                  TextSpan(
                    text: '*',
                    style: TextStyle(
                      color: const Color(0xFFFC0000),
                      fontSize: Dimensions.dimenisonNo16,
                      fontFamily: GoogleFonts.roboto().fontFamily,
                      fontWeight: FontWeight.w500,
                      height: 0,
                      letterSpacing: 0.15,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: Dimensions.dimenisonNo10),
            selectedImage == null
                ? InkWell(
                    onTap: chooseImages,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Dimensions.dimenisonNo10)),
                      width: double.infinity,
                      height: Dimensions.dimenisonNo150,
                      child: Icon(
                        Icons.image,
                        size: Dimensions.dimenisonNo100,
                      ),
                    ),
                  )
                : InkWell(
                    onTap: chooseImages,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Dimensions.dimenisonNo10)),
                      width: double.infinity,
                      height: Dimensions.dimenisonNo150,
                      clipBehavior: Clip.antiAlias,
                      child: Image.memory(
                        selectedImage!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
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
                      fontSize: Dimensions.dimenisonNo16,
                      fontFamily: GoogleFonts.roboto().fontFamily,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.15,
                    ),
                  ),
                  TextSpan(
                    text: '*',
                    style: TextStyle(
                      color: const Color(0xFFFC0000),
                      fontSize: Dimensions.dimenisonNo16,
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
                  fontSize: Dimensions.dimenisonNo14,
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
              maxline: 3,
            ),
            SizedBox(height: Dimensions.dimenisonNo10),
            PickTimeSection(
              openController: _openTime,
              closeController: _closeTime,
              onOpenTimeSelected: (DateTime selectedTime) {
                setState(() {
                  openTimeFormat = selectedTime;
                });
              },
              onCloseTimeSelected: (DateTime selectedTime) {
                setState(() {
                  closeTimeFormat = selectedTime;
                });
              },
            ),
            SizedBox(height: Dimensions.dimenisonNo10),
            FormCustomTextField(
              controller: _address,
              title: "Address",
              maxline: 2,
            ),
            SizedBox(height: Dimensions.dimenisonNo10),
            CSCPickerPlus(
              layout: Layout.vertical,
              flagState: CountryFlag.DISABLE,
              defaultCountry: CscCountry.India,
              onCountryChanged: (country) {
                countryValue = country;
              },
              onStateChanged: (state) {
                stateValue = state;
              },
              onCityChanged: (city) {
                cityValue = city;
              },
              countryDropdownLabel: "Select Country",
              stateDropdownLabel: "Select State",
              cityDropdownLabel: "Select City",
              dropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                      Radius.circular(Dimensions.dimenisonNo10)),
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 1)),
            ),
            SizedBox(height: Dimensions.dimenisonNo10),
            FormCustomTextField(
              controller: _pincode,
              title: "Pincode",
            ),
            SizedBox(height: Dimensions.dimenisonNo10),
            Text(
              'Social Media Information',
              style: TextStyle(
                color: Colors.black,
                fontSize: Dimensions.dimenisonNo14,
                fontWeight: FontWeight.w500,
                fontFamily: GoogleFonts.roboto().fontFamily,
                letterSpacing: 0.15,
              ),
            ),
            SizedBox(height: Dimensions.dimenisonNo10),
            Column(
              children: [
                SalonSocialMediaAdd(
                  text: "Instagram",
                  icon: FontAwesomeIcons.instagram,
                  controller: _instagram,
                ),
                SalonSocialMediaAdd(
                  text: "Facebook",
                  icon: FontAwesomeIcons.facebook,
                  controller: _facebook,
                ),
                SalonSocialMediaAdd(
                  text: "Google Map",
                  icon: FontAwesomeIcons.mapLocationDot,
                  controller: _googleMap,
                ),
                SalonSocialMediaAdd(
                  text: "Linkedin",
                  icon: FontAwesomeIcons.linkedin,
                  controller: _linked,
                ),
              ],
            ),
            SizedBox(height: Dimensions.dimenisonNo20),
            CustomAuthButton(
              text: "Save",
              ontap: () => save(
                appProvider,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
