// // ignore_for_file: prefer_const_constructors, unrelated_type_equality_checks, avoid_print, use_build_context_synchronously

// import 'dart:typed_data';
// import 'package:csc_picker_plus/csc_picker_plus.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:samay_admin_plan/constants/constants.dart';
// import 'package:samay_admin_plan/constants/global_variable.dart';
// import 'package:samay_admin_plan/constants/responsive_layout.dart';
// import 'package:samay_admin_plan/constants/router.dart';
// import 'package:samay_admin_plan/features/home/screen/main_home/home_screen.dart';
// import 'package:samay_admin_plan/features/setting/vender_profile/widget/time_pick_f_venderpage.dart';
// import 'package:samay_admin_plan/models/salon_form_models/salon_infor_model.dart';
// import 'package:samay_admin_plan/provider/app_provider.dart';
// import 'package:samay_admin_plan/provider/calender_provider.dart';
// import 'package:samay_admin_plan/utility/color.dart';
// import 'package:samay_admin_plan/utility/dimenison.dart';
// import 'package:samay_admin_plan/widget/customauthbutton.dart';
// import 'package:samay_admin_plan/widget/customtextfield.dart';

// class SalonProfilePage extends StatefulWidget {
//   const SalonProfilePage({super.key});

//   @override
//   State<SalonProfilePage> createState() => _SalonProfilePageState();
// }

// class _SalonProfilePageState extends State<SalonProfilePage> {
//   final TextEditingController _salonName = TextEditingController();
//   final TextEditingController _email = TextEditingController();
//   final TextEditingController _mobile = TextEditingController();
//   final TextEditingController _whatApp = TextEditingController();
//   final TextEditingController _descrition = TextEditingController();
//   final TextEditingController _address = TextEditingController();

//   final TextEditingController _pincode = TextEditingController();
//   final TextEditingController _openTime = TextEditingController();
//   final TextEditingController _closeTime = TextEditingController();

//   String? adminUid = FirebaseAuth.instance.currentUser?.uid;
//   late TimeOfDay openTimeAfterTime;
//   late TimeOfDay closeTimeAfterTime;
//   late TimeOfDay openTimeUpdate;
//   late TimeOfDay closeTimeUpdate;

//   String? countryValue = "";
//   String? stateValue = "";
//   String? cityValue = "";

//   bool _isLoading = false;
//   bool isupdate = false;
//   bool isImageChange = false;

//   //! For DropDownList
//   String? _selectedSalonType;
//   final List<String> _salonTypeOptions = [
//     'Unisex',
//     'Only Male',
//     'Only Female',
//   ];

//   Uint8List? selectedImage;

//   chooseImages() async {
//     FilePickerResult? chosenImageFile =
//         await FilePicker.platform.pickFiles(type: FileType.image);
//     if (chosenImageFile != null) {
//       setState(() {
//         selectedImage = chosenImageFile.files.single.bytes;
//       });
//     }
//     isImageChange = true;
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getData();
//   }

//   String convertTimeOfDayToString(TimeOfDay timeOfDay) {
//     final hour = timeOfDay.hour;
//     final minute = timeOfDay.minute;
//     final period = hour < 12 ? 'AM' : 'PM';
//     final hour12 = hour % 12 == 0 ? 12 : hour % 12;

//     return '$hour12:$minute $period';
//   }

//   // getData() async {
//   //   setState(() {
//   //     _isLoading = true;
//   //   });
//   //   AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

//   //   try {
//   //     _selectedSalonType = appProvider.getSalonInformation.salonType;
//   //     _salonName.text = appProvider.getSalonInformation.name;
//   //     _email.text = appProvider.getSalonInformation.email;
//   //     _mobile.text = appProvider.getSalonInformation.number.toString();
//   //     _whatApp.text = appProvider.getSalonInformation.whatApp.toString();
//   //     _descrition.text = appProvider.getSalonInformation.description;
//   //     _address.text = appProvider.getSalonInformation.address;

//   //     _pincode.text = appProvider.getSalonInformation.pinCode;
//   //     _openTime.text =
//   //         convertTimeOfDayToString(appProvider.getSalonInformation.openTime!);
//   //     _closeTime.text =
//   //         convertTimeOfDayToString(appProvider.getSalonInformation.closeTime!);

//   //     openTimeAfterTime = stringToTimeOfDay(_openTime.text);
//   //     closeTimeAfterTime = stringToTimeOfDay(_closeTime.text);

//   //     openTimeUpdate = appProvider.getSalonInformation.openTime!;
//   //     closeTimeUpdate = appProvider.getSalonInformation.closeTime!;

//   //     cityValue = appProvider.getSalonInformation.city;
//   //     stateValue = appProvider.getSalonInformation.state;
//   //   } catch (e) {
//   //     print("Error fetching data: $e");
//   //   }

//   //   setState(() {
//   //     _isLoading = false;
//   //   });
//   // }
//   getData() async {
//     setState(() {
//       _isLoading = true;
//     });
//     AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
//     appProvider.getSalonInfoFirebase();

//     try {
//       // Check if getSalonInformation is null
//       if (appProvider.getSalonInformation == null) {
//         throw Exception("Salon information is not available.");
//       }

//       // Safely access properties with null checks
//       _selectedSalonType =
//           appProvider.getSalonInformation.salonType ?? 'Unisex';
//       _salonName.text = appProvider.getSalonInformation.name ?? '';
//       _email.text = appProvider.getSalonInformation.email ?? '';
//       _mobile.text = appProvider.getSalonInformation.number?.toString() ?? '';
//       _whatApp.text = appProvider.getSalonInformation.whatApp?.toString() ?? '';
//       _descrition.text = appProvider.getSalonInformation.description ?? '';
//       _address.text = appProvider.getSalonInformation.address ?? '';
//       _pincode.text = appProvider.getSalonInformation.pinCode ?? '';

//       _openTime.text = appProvider.getSalonInformation.openTime != null
//           ? convertTimeOfDayToString(appProvider.getSalonInformation.openTime!)
//           : '';
//       _closeTime.text = appProvider.getSalonInformation.closeTime != null
//           ? convertTimeOfDayToString(appProvider.getSalonInformation.closeTime!)
//           : '';

//       openTimeAfterTime = appProvider.getSalonInformation.openTime ??
//           TimeOfDay(hour: 9, minute: 0);
//       closeTimeAfterTime = appProvider.getSalonInformation.closeTime ??
//           TimeOfDay(hour: 18, minute: 0);

//       openTimeUpdate = appProvider.getSalonInformation.openTime ??
//           TimeOfDay(hour: 9, minute: 0);
//       closeTimeUpdate = appProvider.getSalonInformation.closeTime ??
//           TimeOfDay(hour: 18, minute: 0);

//       cityValue = appProvider.getSalonInformation.city ?? '';
//       stateValue = appProvider.getSalonInformation.state ?? '';
//     } catch (e) {
//       print("Error fetching data: $e");
//     }

//     setState(() {
//       _isLoading = false;
//     });
//   }

//   TimeOfDay stringToTimeOfDay(String timeString) {
//     final parts = timeString.split(' ');
//     final timeParts = parts[0].split(':');
//     final hour = int.parse(timeParts[0]);
//     final minute = int.parse(timeParts[1]);
//     final isPM = parts[1].toUpperCase() == 'PM';

//     if (isPM && hour != 12) {
//       return TimeOfDay(hour: hour + 12, minute: minute);
//     } else if (!isPM && hour == 12) {
//       return TimeOfDay(hour: 0, minute: minute);
//     } else {
//       return TimeOfDay(hour: hour, minute: minute);
//     }
//   }

//   @override
//   void dispose() {
//     _salonName.dispose();
//     _email.dispose();
//     _mobile.dispose();
//     _whatApp.dispose();
//     _descrition.dispose();
//     _address.dispose();
//     _pincode.dispose();
//     _openTime.dispose();
//     _closeTime.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     AppProvider appProvider = Provider.of<AppProvider>(context);

//     return Scaffold(
//       body: _isLoading
//           ? CircularProgressIndicator()
//           : SingleChildScrollView(
//               scrollDirection: Axis.vertical,
//               child: Container(
//                 // color: Colors.grey,
//                 color: AppColor.bgForAdminCreateSec,
//                 child: Center(
//                   child: Container(
//                     margin: ResponsiveLayout.isMobile(context)
//                         ? EdgeInsets.symmetric(
//                             horizontal: Dimensions.dimenisonNo12,
//                           )
//                         : ResponsiveLayout.isTablet(context)
//                             ? EdgeInsets.symmetric(
//                                 horizontal: Dimensions.dimenisonNo60,
//                               )
//                             : null,
//                     padding: EdgeInsets.symmetric(
//                         horizontal: ResponsiveLayout.isMobile(context)
//                             ? Dimensions.dimenisonNo10
//                             : Dimensions.dimenisonNo30,
//                         vertical: Dimensions.dimenisonNo20),
//                     // color: Colors.green,
//                     color: Colors.white,
//                     width: ResponsiveLayout.isDesktop(context)
//                         ? Dimensions.screenWidth / 1.5
//                         : null,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Center(
//                           child: Text(
//                             'Saloon Profile Details',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontSize: Dimensions.dimenisonNo36,
//                               fontWeight: FontWeight.w500,
//                               height: 0,
//                               letterSpacing: 0.15,
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                               vertical: Dimensions.dimenisonNo10),
//                           child: Divider(),
//                         ),
//                         Text.rich(
//                           TextSpan(
//                             children: [
//                               TextSpan(
//                                 text: 'Upload ${GlobalVariable.salon} Images ',
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: Dimensions.dimenisonNo18,
//                                   fontFamily: GoogleFonts.roboto().fontFamily,
//                                   fontWeight: FontWeight.w500,
//                                   letterSpacing: 0.15,
//                                 ),
//                               ),
//                               TextSpan(
//                                 text: '*',
//                                 style: TextStyle(
//                                   color: const Color(0xFFFC0000),
//                                   fontSize: Dimensions.dimenisonNo18,
//                                   fontFamily: GoogleFonts.roboto().fontFamily,
//                                   fontWeight: FontWeight.w500,
//                                   height: 0,
//                                   letterSpacing: 0.15,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(height: Dimensions.dimenisonNo10),
//                         selectedImage == null
//                             ? InkWell(
//                                 onTap: chooseImages,
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(
//                                           Dimensions.dimenisonNo20)),
//                                   width: Dimensions.dimenisonNo300,
//                                   height: Dimensions.dimenisonNo200,
//                                   clipBehavior: Clip.antiAlias,
//                                   child:
//                                       appProvider.getSalonInformation.image !=
//                                               null
//                                           ? Image.network(
//                                               appProvider
//                                                   .getSalonInformation.image!,
//                                               fit: BoxFit.cover,
//                                             )
//                                           : Icon(
//                                               Icons.image,
//                                               size: Dimensions.dimenisonNo200,
//                                             ),
//                                 ),
//                               )
//                             : InkWell(
//                                 onTap: chooseImages,
//                                 child: Container(
//                                   margin: EdgeInsets.only(
//                                       left: Dimensions.dimenisonNo20),
//                                   decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(
//                                           Dimensions.dimenisonNo20)),
//                                   width: Dimensions.dimenisonNo300,
//                                   height: Dimensions.dimenisonNo200,
//                                   clipBehavior: Clip.antiAlias,
//                                   child: Image.memory(
//                                     selectedImage!,
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                               ),
//                         SizedBox(height: Dimensions.dimenisonNo10),
//                         FormCustomTextField(
//                           controller: _salonName,
//                           title: "${GlobalVariable.salon} Name",
//                         ),
//                         SizedBox(height: Dimensions.dimenisonNo10),
//                         FormCustomTextField(
//                           controller: _email,
//                           title: "Email ID",
//                         ),
//                         SizedBox(height: Dimensions.dimenisonNo10),
//                         FormCustomTextField(
//                           controller: _mobile,
//                           title: "Mobile No",
//                         ),
//                         SizedBox(height: Dimensions.dimenisonNo10),
//                         FormCustomTextField(
//                           controller: _whatApp,
//                           title: "WhatApp No",
//                         ),
//                         SizedBox(height: Dimensions.dimenisonNo10),
//                         Text.rich(
//                           TextSpan(
//                             children: [
//                               TextSpan(
//                                 text: '${GlobalVariable.salon} Type ',
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontSize: Dimensions.dimenisonNo18,
//                                   fontFamily: GoogleFonts.roboto().fontFamily,
//                                   fontWeight: FontWeight.w500,
//                                   letterSpacing: 0.15,
//                                 ),
//                               ),
//                               TextSpan(
//                                 text: '*',
//                                 style: TextStyle(
//                                   color: const Color(0xFFFC0000),
//                                   fontSize: Dimensions.dimenisonNo18,
//                                   fontFamily: GoogleFonts.roboto().fontFamily,
//                                   fontWeight: FontWeight.w500,
//                                   height: 0,
//                                   letterSpacing: 0.15,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(height: Dimensions.dimenisonNo5),
//                         DropdownButtonFormField<String>(
//                           hint: Text(
//                             'Select ${GlobalVariable.salon} Type',
//                             style: TextStyle(
//                               color: Colors.grey,
//                               fontSize: Dimensions.dimenisonNo16,
//                               fontFamily: GoogleFonts.roboto().fontFamily,
//                               fontWeight: FontWeight.w500,
//                               letterSpacing: 0.40,
//                             ),
//                           ),
//                           value: _selectedSalonType,
//                           items: _salonTypeOptions.map((String value) {
//                             return DropdownMenuItem<String>(
//                               value: value,
//                               child: Text(value),
//                             );
//                           }).toList(),
//                           onChanged: (newValue) {
//                             setState(() {
//                               _selectedSalonType = newValue;
//                             });
//                           },
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please select a ${GlobalVariable.salon} type';
//                             }
//                             return null;
//                           },
//                         ),
//                         SizedBox(height: Dimensions.dimenisonNo10),
//                         FormCustomTextField(
//                           controller: _descrition,
//                           title: "${GlobalVariable.salon} Description",
//                           maxline: 5,
//                         ),
//                         SizedBox(height: Dimensions.dimenisonNo10),
//                         TimingSection(appProvider, context),
//                         SizedBox(height: Dimensions.dimenisonNo10),
//                         FormCustomTextField(
//                           controller: _address,
//                           title: "Address",
//                           maxline: 2,
//                         ),
//                         SizedBox(height: Dimensions.dimenisonNo20),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             // Drop downloads to select state.and an city.
//                             Expanded(
//                               child: CSCPickerPlus(
//                                 layout: Layout.horizontal,
//                                 flagState: CountryFlag.DISABLE,
//                                 defaultCountry: CscCountry.India,

//                                 onCountryChanged: (country) {
//                                   countryValue = country;
//                                 },
//                                 onStateChanged: (state) {
//                                   stateValue = state;
//                                 },
//                                 onCityChanged: (city) {
//                                   cityValue = city;
//                                 },

//                                 ///placeholders for dropdown search field
//                                 countrySearchPlaceholder: "Country",
//                                 stateSearchPlaceholder: "State",
//                                 citySearchPlaceholder: "City",

//                                 ///labels for dropdown
//                                 countryDropdownLabel: "Select Country",
//                                 stateDropdownLabel: stateValue!,
//                                 cityDropdownLabel: cityValue!,

//                                 dropdownDialogRadius: Dimensions.dimenisonNo12,
//                                 searchBarRadius: Dimensions.dimenisonNo30,

//                                 ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
//                                 dropdownDecoration: BoxDecoration(
//                                     borderRadius: BorderRadius.all(
//                                         Radius.circular(
//                                             Dimensions.dimenisonNo10)),
//                                     color: Colors.white,
//                                     border: Border.all(
//                                         color: Colors.black, width: 1)),

//                                 ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
//                                 disabledDropdownDecoration: BoxDecoration(
//                                     borderRadius: BorderRadius.all(
//                                         Radius.circular(
//                                             Dimensions.dimenisonNo10)),
//                                     color: Colors.grey.shade300,
//                                     border: Border.all(
//                                         color: Colors.black, width: 1)),
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: Dimensions.dimenisonNo12),
//                         FormCustomTextField(
//                             controller: _pincode, title: "Pincode"),
//                         SizedBox(height: Dimensions.dimenisonNo20),
//                         // CustomAuthButton(
//                         //     text: "Check",
//                         //     ontap: () {
//                         //       String timeOfDayToString(TimeOfDay timeOfDay) {
//                         //         return '${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}';
//                         //       }

//                         //       print(
//                         //           "Open time ${timeOfDayToString(openTimeUpdate)} ");
//                         //       print(
//                         //           "Closer time ${timeOfDayToString(closeTimeUpdate)} ");
//                         //       print(
//                         //           "${GlobalVariable.timeOfDayToDateTimeAM(openTimeUpdate)} To ${GlobalVariable.timeOfDayToDateTimeAM(closeTimeUpdate)}");
//                         //     }),
//                         CustomAuthButton(
//                           text: "Update",
//                           ontap: () async {
//                             try {
//                               String timeOfDayToString(TimeOfDay timeOfDay) {
//                                 return '${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}';
//                               }

//                               print(
//                                   "Open time ${timeOfDayToString(openTimeUpdate)} ");
//                               print(
//                                   "Closer time ${timeOfDayToString(closeTimeUpdate)} ");

//                               // if (_isVaildated) {
//                               SalonModel salonModelUpdate =
//                                   appProvider.getSalonInformation.copyWith(
//                                 name: _salonName.text.trim(),
//                                 email: _email.text.trim(),
//                                 number: int.parse(_mobile.text.trim()),
//                                 whatApp: int.parse(_whatApp.text.trim()),
//                                 salonType: _selectedSalonType!,
//                                 description: _descrition.text.trim(),
//                                 address: _address.text.trim(),
//                                 city: cityValue,
//                                 state: stateValue,
//                                 country: countryValue,
//                                 pinCode: _pincode.text.trim(),
//                                 openTime: openTimeUpdate,
//                                 closeTime: closeTimeUpdate,
//                                 monday: appProvider
//                                             .getSalonInformation.monday ==
//                                         'Close'
//                                     ? appProvider.getSalonInformation.monday
//                                     : _openTime ==
//                                                 appProvider.getSalonInformation
//                                                     .openTime &&
//                                             _closeTime ==
//                                                 appProvider.getSalonInformation
//                                                     .closeTime
//                                         ? appProvider.getSalonInformation.monday
//                                         : "${GlobalVariable.timeOfDayToDateTimeAM(openTimeUpdate)} To ${GlobalVariable.timeOfDayToDateTimeAM(closeTimeUpdate)}",
//                                 tuesday: appProvider
//                                             .getSalonInformation.tuesday ==
//                                         'Close'
//                                     ? appProvider.getSalonInformation.tuesday
//                                     : _openTime ==
//                                                 appProvider.getSalonInformation
//                                                     .openTime &&
//                                             _closeTime ==
//                                                 appProvider.getSalonInformation
//                                                     .closeTime
//                                         ? appProvider
//                                             .getSalonInformation.tuesday
//                                         : "${GlobalVariable.timeOfDayToDateTimeAM(openTimeUpdate)} To ${GlobalVariable.timeOfDayToDateTimeAM(closeTimeUpdate)}",
//                                 wednesday: appProvider
//                                             .getSalonInformation.wednesday ==
//                                         'Close'
//                                     ? appProvider.getSalonInformation.monday
//                                     : _openTime ==
//                                                 appProvider.getSalonInformation
//                                                     .openTime &&
//                                             _closeTime ==
//                                                 appProvider.getSalonInformation
//                                                     .closeTime
//                                         ? appProvider
//                                             .getSalonInformation.wednesday
//                                         : "${GlobalVariable.timeOfDayToDateTimeAM(openTimeUpdate)} To ${GlobalVariable.timeOfDayToDateTimeAM(closeTimeUpdate)}",
//                                 thursday: appProvider
//                                             .getSalonInformation.thursday ==
//                                         'Close'
//                                     ? appProvider.getSalonInformation.thursday
//                                     : _openTime ==
//                                                 appProvider.getSalonInformation
//                                                     .openTime &&
//                                             _closeTime ==
//                                                 appProvider.getSalonInformation
//                                                     .closeTime
//                                         ? appProvider
//                                             .getSalonInformation.thursday
//                                         : "${GlobalVariable.timeOfDayToDateTimeAM(openTimeUpdate)} To ${GlobalVariable.timeOfDayToDateTimeAM(closeTimeUpdate)}",
//                                 friday: appProvider
//                                             .getSalonInformation.friday ==
//                                         'Close'
//                                     ? appProvider.getSalonInformation.friday
//                                     : _openTime ==
//                                                 appProvider.getSalonInformation
//                                                     .openTime &&
//                                             _closeTime ==
//                                                 appProvider.getSalonInformation
//                                                     .closeTime
//                                         ? appProvider.getSalonInformation.friday
//                                         : "${GlobalVariable.timeOfDayToDateTimeAM(openTimeUpdate)} To ${GlobalVariable.timeOfDayToDateTimeAM(closeTimeUpdate)}",
//                                 saturday: appProvider
//                                             .getSalonInformation.saturday ==
//                                         'Close'
//                                     ? appProvider.getSalonInformation.saturday
//                                     : _openTime ==
//                                                 appProvider.getSalonInformation
//                                                     .openTime &&
//                                             _closeTime ==
//                                                 appProvider.getSalonInformation
//                                                     .closeTime
//                                         ? appProvider
//                                             .getSalonInformation.saturday
//                                         : "${GlobalVariable.timeOfDayToDateTimeAM(openTimeUpdate)} To ${GlobalVariable.timeOfDayToDateTimeAM(closeTimeUpdate)}",
//                                 sunday: appProvider
//                                             .getSalonInformation.sunday ==
//                                         'Close'
//                                     ? appProvider.getSalonInformation.sunday
//                                     : _openTime ==
//                                                 appProvider.getSalonInformation
//                                                     .openTime &&
//                                             _closeTime ==
//                                                 appProvider.getSalonInformation
//                                                     .closeTime
//                                         ? appProvider.getSalonInformation.sunday
//                                         : "${GlobalVariable.timeOfDayToDateTimeAM(openTimeUpdate)} To ${GlobalVariable.timeOfDayToDateTimeAM(closeTimeUpdate)}",
//                               );

//                               isImageChange
//                                   ? isupdate =
//                                       await appProvider.updateSalonInfoFirebase(
//                                           context, salonModelUpdate,
//                                           image: selectedImage)
//                                   : isupdate =
//                                       await appProvider.updateSalonInfoFirebase(
//                                       context,
//                                       salonModelUpdate,
//                                     );

//                               showMessage("Salon Update Successfully add");
//                               print("Salon ID ${GlobalVariable.salonID}");

//                               if (isupdate) {
//                                 Routes.instance.push(
//                                     widget: HomeScreen(
//                                       date: Provider.of<CalenderProvider>(
//                                               context,
//                                               listen: false)
//                                           .getSelectDate,
//                                     ),
//                                     // ignore: use_build_context_synchronously
//                                     context: context);
//                               }
//                               // }
//                             } catch (e) {
//                               print(e.toString());
//                               showMessage(
//                                   'Salon is not Update or an error occurred');
//                             }
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//     );
//   }

//   Row TimingSection(AppProvider appProvider, BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         //! select a time

//         PickTimeSectionForVenderPage(
//           openController: _openTime,
//           closeController: _closeTime,
//           openTime: openTimeUpdate,
//           closeTime: closeTimeUpdate,
//           heading: "Select the timing of ${GlobalVariable.salon}",
//           onOpenTimeSelected: (TimeOfDay selectedTime) {
//             setState(() {
//               openTimeUpdate = selectedTime;
//             });
//           },
//           onCloseTimeSelected: (TimeOfDay selectedTime) {
//             setState(() {
//               closeTimeUpdate = selectedTime;
//             });
//           },
//         )
//       ],
//     );
//   }
// }

// ignore_for_file: avoid_print, use_build_context_synchronously

// import 'dart:typed_data';
// import 'package:csc_picker_plus/csc_picker_plus.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:samay_admin_plan/constants/responsive_layout.dart';
// import 'package:samay_admin_plan/features/home/screen/main_home/home_screen.dart';
// import 'package:samay_admin_plan/features/setting/vender_profile/widget/time_pick_f_venderpage.dart';
// import 'package:samay_admin_plan/provider/app_provider.dart';
// import 'package:samay_admin_plan/provider/calender_provider.dart';

// import 'package:samay_admin_plan/widget/customauthbutton.dart';
// import 'package:samay_admin_plan/widget/customtextfield.dart';

// class SalonProfilePage extends StatefulWidget {
//   const SalonProfilePage({Key? key}) : super(key: key);

//   @override
//   _SalonProfilePageState createState() => _SalonProfilePageState();
// }

// class _SalonProfilePageState extends State<SalonProfilePage> {
//   // --- Controllers ---
//   final _formKey = GlobalKey<FormState>();
//   final _nameCtrl = TextEditingController();
//   final _emailCtrl = TextEditingController();
//   final _mobileCtrl = TextEditingController();
//   final _whatsappCtrl = TextEditingController();
//   final _descCtrl = TextEditingController();
//   final _addressCtrl = TextEditingController();
//   final _pinCtrl = TextEditingController();
//   final _openTimeCtrl = TextEditingController();
//   final _closeTimeCtrl = TextEditingController();

//   // --- State Variables & Defaults ---
//   String? _selectedSalonType;
//   String? _country, _state, _city;
//   Uint8List? _pickedImage;
//   bool _isLoading = false, _imageChanged = false;

//   // Provide a default so `late` never triggers
//   TimeOfDay _openTime = const TimeOfDay(hour: 9, minute: 0);
//   TimeOfDay _closeTime = const TimeOfDay(hour: 18, minute: 0);

//   final _salonTypes = ['Unisex', 'Only Male', 'Only Female'];

//   @override
//   void initState() {
//     super.initState();
//     _loadExistingData();
//   }

//   Future<void> _loadExistingData() async {
//     setState(() => _isLoading = true);
//     final appProv = context.read<AppProvider>();

//     try {
//       await appProv.getSalonInfoFirebase();
//       final info = appProv.getSalonInformation!;

//       // Populate controllers & state
//       _selectedSalonType = info.salonType ?? _salonTypes.first;
//       _nameCtrl.text = info.name ?? '';
//       _emailCtrl.text = info.email ?? '';
//       _mobileCtrl.text = info.number?.toString() ?? '';
//       _whatsappCtrl.text = info.whatApp?.toString() ?? '';
//       _descCtrl.text = info.description ?? '';
//       _addressCtrl.text = info.address ?? '';
//       _pinCtrl.text = info.pinCode ?? '';
//       _country = info.country;
//       _state = info.state;
//       _city = info.city;

//       // Times
//       if (info.openTime != null) {
//         _openTime = info.openTime!;
//         _openTimeCtrl.text = _formatTime(_openTime);
//       }
//       if (info.closeTime != null) {
//         _closeTime = info.closeTime!;
//         _closeTimeCtrl.text = _formatTime(_closeTime);
//       }
//     } catch (e) {
//       debugPrint("Error loading salon info: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Failed to load existing salon data.")),
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   String _formatTime(TimeOfDay t) {
//     final h12 = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
//     final meridiem = t.period == DayPeriod.am ? 'AM' : 'PM';
//     return '$h12:${t.minute.toString().padLeft(2, '0')} $meridiem';
//   }

//   Future<void> _pickImage() async {
//     final result = await FilePicker.platform.pickFiles(type: FileType.image);
//     if (result != null) {
//       setState(() {
//         _pickedImage = result.files.single.bytes;
//         _imageChanged = true;
//       });
//     }
//   }

//   Future<void> _submit() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => _isLoading = true);
//     final appProv = context.read<AppProvider>();

//     try {
//       // Build updated model
//       final updated = appProv.getSalonInformation!.copyWith(
//         name: _nameCtrl.text.trim(),
//         email: _emailCtrl.text.trim(),
//         number: int.tryParse(_mobileCtrl.text.trim()),
//         whatApp: int.tryParse(_whatsappCtrl.text.trim()),
//         salonType: _selectedSalonType!,
//         description: _descCtrl.text.trim(),
//         address: _addressCtrl.text.trim(),
//         country: _country,
//         state: _state,
//         city: _city,
//         pinCode: _pinCtrl.text.trim(),
//         openTime: _openTime,
//         closeTime: _closeTime,
//       );

//       final success = await appProv.updateSalonInfoFirebase(
//         context,
//         updated,
//         image: _imageChanged ? _pickedImage : null,
//       );

//       if (!success) throw Exception("Update failed on server.");

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Salon updated successfully!")),
//       );

//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (_) => HomeScreen(
//             date: context.read<CalenderProvider>().getSelectDate,
//           ),
//         ),
//       );
//     } catch (e) {
//       debugPrint("Update error: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Failed to update salon profile.")),
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   /// If the original value was "Close", keep it. Otherwise build new range.
//   String _dayString(String original) {
//     if (original.toLowerCase() == 'close') return original;
//     return "${_formatTime(_openTime)} To ${_formatTime(_closeTime)}";
//   }

//   @override
//   void dispose() {
//     for (final c in [
//       _nameCtrl,
//       _emailCtrl,
//       _mobileCtrl,
//       _whatsappCtrl,
//       _descCtrl,
//       _addressCtrl,
//       _pinCtrl,
//       _openTimeCtrl,
//       _closeTimeCtrl
//     ]) {
//       c.dispose();
//     }
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(24),
//               child: Center(
//                 child: ConstrainedBox(
//                   constraints: BoxConstraints(
//                     maxWidth: ResponsiveLayout.isDesktop(context)
//                         ? MediaQuery.of(context).size.width * 0.6
//                         : 600,
//                   ),
//                   child: Card(
//                     elevation: 4,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12)),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16),
//                       child: Form(
//                         key: _formKey,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Salon Profile Details',
//                               style: GoogleFonts.roboto(
//                                   fontSize: 32, fontWeight: FontWeight.w600),
//                             ),
//                             const Divider(height: 32),
//                             _buildImagePicker(),
//                             const SizedBox(height: 16),
//                             _buildContactFields(),
//                             const SizedBox(height: 16),
//                             _buildTypeDropdown(),
//                             const SizedBox(height: 16),
//                             _buildTimingSection(),
//                             const SizedBox(height: 16),
//                             _buildAddressSection(),
//                             const SizedBox(height: 24),
//                             CustomAuthButton(
//                               text: "Update",
//                               ontap: _submit,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//     );
//   }

//   Widget _buildImagePicker() {
//     final img = _pickedImage != null
//         ? Image.memory(_pickedImage!, fit: BoxFit.cover)
//         : (context.read<AppProvider>().getSalonInformation?.image != null
//             ? Image.network(
//                 context.read<AppProvider>().getSalonInformation!.image!)
//             : const Icon(Icons.image, size: 100));

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("Upload Salon Image *", style: TextStyle(fontSize: 18)),
//         const SizedBox(height: 8),
//         InkWell(
//           onTap: _pickImage,
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(12),
//             child: Container(
//               width: 300,
//               height: 200,
//               color: Colors.grey.shade200,
//               child: img,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildContactFields() {
//     return Column(
//       children: [
//         FormCustomTextField(
//           controller: _nameCtrl,
//           title: "Salon Name",
//           // validator: (v) => v!.isEmpty ? "Enter name" : null
//         ),
//         const SizedBox(height: 8),
//         FormCustomTextField(
//           controller: _emailCtrl,
//           title: "Email ID",
//           // validator: (v) => v!.contains("@") ? null : "Enter valid email"
//         ),
//         const SizedBox(height: 8),
//         FormCustomTextField(
//           controller: _mobileCtrl,
//           title: "Mobile No",
//           // validator: (v) =>
//           //     v!.length >= 10 ? null : "Enter at least 10 digits"
//         ),
//         const SizedBox(height: 8),
//         FormCustomTextField(
//           controller: _whatsappCtrl,
//           title: "WhatsApp No",
//           // validator: (v) =>
//           //     v!.length >= 10 ? null : "Enter at least 10 digits"
//         ),
//       ],
//     );
//   }

//   Widget _buildTypeDropdown() {
//     return DropdownButtonFormField<String>(
//       decoration: InputDecoration(labelText: "Salon Type *"),
//       value: _selectedSalonType,
//       items: _salonTypes
//           .map((t) => DropdownMenuItem(value: t, child: Text(t)))
//           .toList(),
//       onChanged: (v) => setState(() => _selectedSalonType = v),
//       validator: (v) => v == null ? "Please select a type" : null,
//     );
//   }

//   Widget _buildTimingSection() {
//     return PickTimeSectionForVenderPage(
//       openController: _openTimeCtrl,
//       closeController: _closeTimeCtrl,
//       openTime: _openTime,
//       closeTime: _closeTime,
//       heading: "Select salon timings",
//       onOpenTimeSelected: (t) {
//         setState(() {
//           _openTime = t;
//           _openTimeCtrl.text = _formatTime(t);
//         });
//       },
//       onCloseTimeSelected: (t) {
//         setState(() {
//           _closeTime = t;
//           _closeTimeCtrl.text = _formatTime(t);
//         });
//       },
//     );
//   }

//   Widget _buildAddressSection() {
//     return Column(
//       children: [
//         FormCustomTextField(
//             controller: _addressCtrl, title: "Address", maxline: 2),
//         const SizedBox(height: 8),
//         Row(children: [
//           Expanded(
//             child: CSCPickerPlus(
//               layout: Layout.horizontal,
//               flagState: CountryFlag.DISABLE,
//               defaultCountry: CscCountry.India,
//               countrySearchPlaceholder: "Country",
//               stateSearchPlaceholder: "State",
//               citySearchPlaceholder: "City",
//               countryDropdownLabel: _country ?? "Select Country",
//               stateDropdownLabel: _state ?? "Select State",
//               cityDropdownLabel: _city ?? "Select City",
//               onCountryChanged: (c) => _country = c,
//               onStateChanged: (s) => _state = s,
//               onCityChanged: (c) => _city = c,
//               dropdownDecoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 border: Border.all(color: Colors.black),
//               ),
//             ),
//           ),
//         ]),
//         const SizedBox(height: 8),
//         FormCustomTextField(
//           controller: _pinCtrl,
//           title: "Pincode",
//           // validator: (v) => v!.isEmpty ? "Enter pin code" : null
//         ),
//       ],
//     );
//   }
// }

// ignore_for_file: prefer_const_constructors, unrelated_type_equality_checks, avoid_print, use_build_context_synchronously

// ignore_for_file: prefer_const_constructors, unrelated_type_equality_checks, avoid_print, use_build_context_synchronously

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
import 'package:samay_admin_plan/models/salon_form_models/salon_infor_model.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';
import 'package:samay_admin_plan/provider/calender_provider.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimenison.dart';
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

  // Provide defaults so they’re never null
  TimeOfDay openTimeAfterTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay closeTimeAfterTime = const TimeOfDay(hour: 18, minute: 0);
  TimeOfDay openTimeUpdate = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay closeTimeUpdate = const TimeOfDay(hour: 18, minute: 0);

  // Non-nullable with empty defaults
  String countryValue = "";
  String? stateValue = "";
  String? cityValue = "";

  bool _isLoading = false;
  bool isupdate = false;
  bool isImageChange = false;

  // For dropdown
  String _selectedSalonType = 'Unisex';
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
    isImageChange = true;
  }

  @override
  void initState() {
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

  getData() async {
    setState(() => _isLoading = true);
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    // ← await here so data is loaded before we read it
    await appProvider.getSalonInfoFirebase();

    try {
      final info = appProvider.getSalonInformation;
      if (info == null) throw Exception("Salon information is not available.");

      // Safely assign with fallbacks
      _selectedSalonType = info.salonType ?? _selectedSalonType;
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
    final appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                color: AppColor.bgForAdminCreateSec,
                child: Center(
                  child: Container(
                    margin: ResponsiveLayout.isMobile(context)
                        ? EdgeInsets.symmetric(
                            horizontal: Dimensions.dimenisonNo12)
                        : ResponsiveLayout.isTablet(context)
                            ? EdgeInsets.symmetric(
                                horizontal: Dimensions.dimenisonNo60)
                            : null,
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveLayout.isMobile(context)
                          ? Dimensions.dimenisonNo10
                          : Dimensions.dimenisonNo30,
                      vertical: Dimensions.dimenisonNo20,
                    ),
                    color: Colors.white,
                    width: ResponsiveLayout.isDesktop(context)
                        ? Dimensions.screenWidth / 1.5
                        : null,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'Saloon Profile Details',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: Dimensions.dimenisonNo36,
                              fontWeight: FontWeight.w500,
                              height: 0,
                              letterSpacing: 0.15,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: Dimensions.dimenisonNo10),
                          child: Divider(),
                        ),
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
                        const SizedBox(height: 10),
                        selectedImage == null
                            ? InkWell(
                                onTap: chooseImages,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.dimenisonNo20),
                                  ),
                                  width: Dimensions.dimenisonNo300,
                                  height: Dimensions.dimenisonNo200,
                                  clipBehavior: Clip.antiAlias,
                                  child:
                                      appProvider.getSalonInformation.image !=
                                              null
                                          ? Image.network(
                                              appProvider
                                                  .getSalonInformation.image!,
                                              fit: BoxFit.cover,
                                            )
                                          : Icon(
                                              Icons.image,
                                              size: Dimensions.dimenisonNo200,
                                            ),
                                ),
                              )
                            : InkWell(
                                onTap: chooseImages,
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: Dimensions.dimenisonNo20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.dimenisonNo20),
                                  ),
                                  width: Dimensions.dimenisonNo300,
                                  height: Dimensions.dimenisonNo200,
                                  clipBehavior: Clip.antiAlias,
                                  child: Image.memory(
                                    selectedImage!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                        const SizedBox(height: 10),
                        FormCustomTextField(
                          controller: _salonName,
                          title: "${GlobalVariable.salon} Name",
                        ),
                        const SizedBox(height: 10),
                        FormCustomTextField(
                          controller: _email,
                          title: "Email ID",
                        ),
                        const SizedBox(height: 10),
                        FormCustomTextField(
                          controller: _mobile,
                          title: "Mobile No",
                        ),
                        const SizedBox(height: 10),
                        FormCustomTextField(
                          controller: _whatApp,
                          title: "WhatApp No",
                        ),
                        const SizedBox(height: 10),
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
                        const SizedBox(height: 5),
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
                              _selectedSalonType = newValue!;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a ${GlobalVariable.salon} type';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        FormCustomTextField(
                          controller: _descrition,
                          title: "${GlobalVariable.salon} Description",
                          maxline: 5,
                        ),
                        const SizedBox(height: 10),
                        TimingSection(appProvider, context),
                        const SizedBox(height: 10),
                        FormCustomTextField(
                          controller: _address,
                          title: "Address",
                          maxline: 2,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
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
                                stateDropdownLabel: stateValue!,
                                cityDropdownLabel: cityValue!,

                                dropdownDialogRadius: Dimensions.dimenisonNo12,
                                searchBarRadius: Dimensions.dimenisonNo30,

                                ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
                                dropdownDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            Dimensions.dimenisonNo10)),
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.black, width: 1)),

                                ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                                disabledDropdownDecoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            Dimensions.dimenisonNo10)),
                                    color: Colors.grey.shade300,
                                    border: Border.all(
                                        color: Colors.black, width: 1)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        FormCustomTextField(
                          controller: _pincode,
                          title: "Pincode",
                        ),
                        const SizedBox(height: 20),
                        CustomAuthButton(
                          text: "Update",
                          ontap: () async {
                            try {
                              String timeOfDayToString(TimeOfDay timeOfDay) {
                                return '${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}';
                              }

                              SalonModel salonModelUpdate =
                                  appProvider.getSalonInformation.copyWith(
                                name: _salonName.text.trim(),
                                email: _email.text.trim(),
                                number: int.parse(_mobile.text.trim()),
                                whatApp: int.parse(_whatApp.text.trim()),
                                salonType: _selectedSalonType,
                                description: _descrition.text.trim(),
                                address: _address.text.trim(),
                                city: cityValue,
                                state: stateValue,
                                country: countryValue,
                                pinCode: _pincode.text.trim(),
                                openTime: openTimeUpdate,
                                closeTime: closeTimeUpdate,
                              );

                              isImageChange
                                  ? isupdate =
                                      await appProvider.updateSalonInfoFirebase(
                                          context, salonModelUpdate,
                                          image: selectedImage)
                                  : isupdate =
                                      await appProvider.updateSalonInfoFirebase(
                                          context, salonModelUpdate);

                              showMessage("Salon Update Successfully add");

                              if (isupdate) {
                                Routes.instance.push(
                                  widget: HomeScreen(
                                    date: Provider.of<CalenderProvider>(context,
                                            listen: false)
                                        .getSelectDate,
                                  ),
                                  context: context,
                                );
                              }
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

  Row TimingSection(AppProvider appProvider, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
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
            });
          },
        )
      ],
    );
  }
}
