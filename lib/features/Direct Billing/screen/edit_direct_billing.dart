// // ignore_for_file: use_build_context_synchronously, prefer_final_fields

// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:samay_admin_plan/constants/constants.dart';
// import 'package:samay_admin_plan/constants/global_variable.dart';
// import 'package:samay_admin_plan/constants/responsive_layout.dart';
// import 'package:samay_admin_plan/constants/router.dart';
// import 'package:samay_admin_plan/features/Calender/screen/calender.dart';
// import 'package:samay_admin_plan/features/add_new_appointment/widget/single_service_appoint.dart';
// import 'package:samay_admin_plan/features/add_new_appointment/widget/single_service_tap_icon.dart';
// import 'package:samay_admin_plan/features/add_new_appointment/widget/time_tap.dart';
// import 'package:samay_admin_plan/features/custom_appbar/screen/custom_appbar.dart';
// import 'package:samay_admin_plan/features/drawer/drawer.dart';
// import 'package:samay_admin_plan/features/payment/user_payment_screen_qb.dart';
// import 'package:samay_admin_plan/firebase_helper/firebase_firestore_helper/samay_fb.dart';
// import 'package:samay_admin_plan/firebase_helper/firebase_firestore_helper/setting_fb.dart';
// import 'package:samay_admin_plan/firebase_helper/firebase_firestore_helper/user_order_fb.dart';
// import 'package:samay_admin_plan/models/appoint_model/appoint_model.dart';
// import 'package:samay_admin_plan/models/salon_form_models/salon_infor_model.dart';
// import 'package:samay_admin_plan/models/salon_setting_model/salon_setting_model.dart';
// import 'package:samay_admin_plan/models/samay_salon_settng_model/samay_salon_setting.dart';
// import 'package:samay_admin_plan/models/service_model/service_model.dart';
// import 'package:samay_admin_plan/models/timestamp_model/timestamp_model.dart';
// import 'package:samay_admin_plan/models/user_model/user_model.dart';
// import 'package:samay_admin_plan/models/vender_payent_details/vender_payment_detail.dart';
// import 'package:samay_admin_plan/provider/app_provider.dart';
// import 'package:samay_admin_plan/provider/booking_provider.dart';
// import 'package:samay_admin_plan/provider/service_provider.dart';
// import 'package:samay_admin_plan/utility/color.dart';
// import 'package:samay_admin_plan/utility/dimension.dart';
// import 'package:samay_admin_plan/widget/customauthbutton.dart';
// import 'package:samay_admin_plan/widget/text_box/customtextfield.dart';
// import 'package:upi_payment_qrcode_generator/upi_payment_qrcode_generator.dart';

// class EditDirectBillingScreen extends StatefulWidget {
//   final SalonModel salonModel;
//   final AppointModel appointModel;
//   final UserModel userModel;

//   const EditDirectBillingScreen({
//     super.key,
//     required this.salonModel,
//     required this.appointModel,
//     required this.userModel,
//   });

//   @override
//   State<EditDirectBillingScreen> createState() =>
//       _EditDirectBillingScreenState();
// }

// class _EditDirectBillingScreenState extends State<EditDirectBillingScreen> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   DateTime _time = DateTime.now();
//   TextEditingController _nameController = TextEditingController();
//   TextEditingController _lastNameController = TextEditingController();
//   TextEditingController _appointmentDateController = TextEditingController();
//   TextEditingController _appointmentTimeController =
//       TextEditingController(text: "Select Time");
//   TextEditingController _serviceController = TextEditingController();
//   TextEditingController _mobileController = TextEditingController();
//   TextEditingController _userNote = TextEditingController();
//   TextEditingController _staffName = TextEditingController();
//   TextEditingController _extraDiscountInPer = TextEditingController();
//   TextEditingController _extraDiscountInDirectAmount = TextEditingController();
//   final TextEditingController _cashReceivedController =
//       TextEditingController(text: "0.0");

//   final TextEditingController _transactionIdController =
//       TextEditingController(text: "0");

//   final List<String> _paymentOptions = ["Cash", "QR", "Custom"];
//   String _selectedPaymentMethod = "Cash";
//   late VenderPaymentDetailsModel? _venderPaymentDetailsModel;
//   UPIDetails? upiDetails;
//   double _netPriceLocal = 0.0;
//   double _exteraDiscountInAmount = 0.0;

//   @override
//   void dispose() {
//     super.dispose();
//     _nameController.dispose();
//     _lastNameController.dispose();
//     _appointmentDateController.dispose();
//     _appointmentTimeController.dispose();
//     _serviceController.dispose();
//     _mobileController.dispose();
//     _userNote.dispose();
//     _staffName.dispose();
//     _extraDiscountInPer.dispose();
//     _extraDiscountInDirectAmount.dispose();
//     _cashReceivedController.dispose();
//     _transactionIdController.dispose();
//   }

//   List<ServiceModel> serchServiceList = [];
//   List<ServiceModel> allServiceList = [];
//   List<ServiceModel> selectService = [];

//   bool _showCalender = false;
//   bool _showServiceList = false;
//   bool _showTimeContaine = false;
//   bool _isLoading = false;
//   bool _showExtraDiscount = false;

//   final List<TimeStampModel> _timeStampList = [];

//   int _timediff = 30;
//   int appointmentNO = 0;
//   bool isGSTAvaible = false;

//   SamaySalonSettingModel? _samaySalonSettingModel;
//   SettingModel? _settingModel;

// //Serching  Services base on service name and code
//   void serchService(String value) {
//     // Filtering based on both service name and service code
//     serchServiceList = allServiceList
//         .where((element) =>
//             element.servicesName.toLowerCase().contains(value.toLowerCase()) ||
//             element.serviceCode.toLowerCase().contains(value.toLowerCase()))
//         .toList();

//     setState(() {});
//   }

//   void updateDate() {
//     Provider.of<BookingProvider>(context, listen: false)
//         .updateSelectedDate(widget.appointModel.appointmentInfo!.serviceDate);
//   }

//   getData() async {
//     setState(() {
//       _isLoading = true;
//     });

//     AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
//     BookingProvider bookingProvider =
//         Provider.of<BookingProvider>(context, listen: false);
//     ServiceProvider serviceProvider =
//         Provider.of<ServiceProvider>(context, listen: false);

//     try {
//       bookingProvider.setAllZero();

//       _settingModel = await SettingFb.instance
//           .fetchSettingFromFB(appProvider.getSalonInformation.id);
//       await bookingProvider.fetchSettingPro(appProvider.getSalonInformation.id);
//       await appProvider.getSalonInfoFirebase();
//       await serviceProvider.fetchSettingPro(appProvider.getSalonInformation.id);
//       _venderPaymentDetailsModel = await SettingFb.instance
//           .fetchVenderPaymentFB(appProvider.getSalonInformation.id);
//       _timediff = int.parse(serviceProvider.getSettingModel!.diffbtwTimetap);
//       setState(() {
//         _appointmentDateController.text =
//             DateFormat("dd MMM yyyy").format(_time);
//       });

//       List<ServiceModel> fetchedServices = await UserBookingFB.instance
//           .getAllServicesFromCategories(appProvider.getSalonInformation.id);
//       _samaySalonSettingModel = await SamayFB.instance.fetchSalonSettingData();

//       // GlobalVariable.salonPlatformFee = _samaySalonSettingModel!.platformFee;

//       print("Gst is == ${_settingModel!.gSTIsIncludingOrExcluding}");
//       print("Plact fee ${_samaySalonSettingModel!.platformFee}");

//       setState(() {
//         allServiceList = fetchedServices;
//       });
//     } catch (e) {
//       print("Error fetching data: $e");
//     }

//     setState(() {
//       _isLoading = false;
//     });
//   }

//   String? _selectedTimeSlot = GlobalVariable.getCurrentTime();
//   // String?
//   //     _serviceEndTime; //! to get _serviceEndTime add _serviceStartTime + serviceDurtion

// //for Salon open and closer time
//   DateTime? _startTime;
//   DateTime? _endTime;

// //For time slot
//   Map<String, List<String>> _categorizedTimeSlots = {
//     'Morning': [],
//     'Afternoon': [],
//     'Evening': [],
//     'Night': [],
//   };

//   String timeOfDayToString(TimeOfDay timeOfDay) {
//     final hour = timeOfDay.hour
//         .toString()
//         .padLeft(2, '0'); // Ensures two digits for hour
//     final minute = timeOfDay.minute
//         .toString()
//         .padLeft(2, '0'); // Ensures two digits for minute
//     return "$hour:$minute";
//   }

//   void _initializeTimes() {
//     try {
//       // Ensure openTime and closeTime are not null and are TimeOfDay
//       if (widget.salonModel.openTime == null ||
//           widget.salonModel.closeTime == null) {
//         throw 'Salon opening or closing time is missing.';
//       }

//       // Convert TimeOfDay to string for formatting
//       String salonOpenTime = _timeOfDayToString(widget.salonModel.openTime!);
//       String salonCloseTime = _timeOfDayToString(widget.salonModel.closeTime!);

//       if (salonOpenTime.isEmpty || salonCloseTime.isEmpty) {
//         throw 'Salon opening or closing time is empty.';
//       }

//       // Parse the 12-hour time format with AM/PM (e.g., '11:00 PM')
//       try {
//         _startTime = DateFormat('hh:mm a').parse(salonOpenTime);
//         _endTime = DateFormat('hh:mm a').parse(salonCloseTime);

//         print("Parsed startTime: $_startTime, endTime: $_endTime");
//       } catch (e) {
//         throw 'Error parsing the opening or closing time: $e';
//       }
//     } catch (e) {
//       // Handle parsing errors and fallback times
//       print('Error: $e');

//       // Set default times if parsing fails
//       _startTime = DateTime.now(); // Fallback to the current time
//       _endTime =
//           DateTime.now().add(const Duration(hours: 8)); // Default to 8 hours later

//       print("Using fallback times: startTime: $_startTime, endTime: $_endTime");
//     }
//   }

// // Helper method to convert TimeOfDay to a 12-hour AM/PM string
//   String _timeOfDayToString(TimeOfDay timeOfDay) {
//     final hour = timeOfDay.hour % 12; // Convert hour to 12-hour format
//     final minute = timeOfDay.minute;
//     final period = timeOfDay.hour >= 12 ? 'PM' : 'AM';
//     return '$hour:${minute.toString().padLeft(2, '0')} $period';
//   }

//   String _normalizeTimeString(String timeString) {
//     return timeString.replaceAllMapped(
//       RegExp(r'(\d{1,2}):(\d{2})\s*(AM|PM)'),
//       (match) => '${match[1]?.padLeft(2, '0')}:${match[2]} ${match[3]}',
//     );
//   }

//   int parseDuration(String duration) {
//     final regex = RegExp(r'(\d+)h (\d+)m');
//     final match = regex.firstMatch(duration);

//     if (match != null) {
//       final hours = int.parse(match.group(1)!);
//       final minutes = int.parse(match.group(2)!);
//       return hours * 60 + minutes;
//     }

//     return 0; // Default to 0 if parsing fails
//   }

// //Generate Time slotes
//   void _generateTimeSlots(int serviceDurationInMinutes) {
//     if (_startTime != null && _endTime != null) {
//       DateTime currentTime = _startTime!;
//       _categorizedTimeSlots.forEach((key, value) => value.clear());

//       while (currentTime.isBefore(_endTime!)) {
//         final slotEndTime =
//             currentTime.add(Duration(minutes: serviceDurationInMinutes));

//         // Display only the time part, ignoring the date
//         String formattedTime = DateFormat('hh:mm a').format(currentTime);

//         if (currentTime.hour < 12) {
//           _categorizedTimeSlots['Morning']!.add(formattedTime);
//         } else if (currentTime.hour < 17) {
//           _categorizedTimeSlots['Afternoon']!.add(formattedTime);
//         } else if (currentTime.hour < 21) {
//           _categorizedTimeSlots['Evening']!.add(formattedTime);
//         } else {
//           _categorizedTimeSlots['Night']!.add(formattedTime);
//         }

//         // Move to the next time slot
//         currentTime = currentTime.add(
//             Duration(minutes: _timediff)); // Adjust as neededjust as needed
//         // currentTime = currentTime
//         //     .add(Duration(minutes: 30)); // Adjust as neededjust as needed
//       }

//       // Ensure the last slot includes the closing time
//       String lastSlotFormattedTime = DateFormat('hh:mm a').format(_endTime!);
//       if (_categorizedTimeSlots['Night']!.last != lastSlotFormattedTime) {
//         _categorizedTimeSlots['Night']!.add(lastSlotFormattedTime);
//       }
//     }
//   }

//   //!--------------------- calculate the Billing Amount---------------------------

//   // Cal Extra Discount Fun
//   double _extraDiscontAmountPer() {
//     BookingProvider bookingProvider =
//         Provider.of<BookingProvider>(context, listen: false);

//     final discountPercentage = double.tryParse(_extraDiscountInPer.text) ?? 0.0;
//     final validPercentage = discountPercentage.clamp(0.0, 100.0);

//     double discountAmount = (validPercentage / 100) * _netPriceLocal;

//     return discountAmount;
//   }

//   double get _cashToGiveBack {
//     BookingProvider bookingProvider =
//         Provider.of<BookingProvider>(context, listen: false);
//     final cashReceived = double.tryParse(_cashReceivedController.text) ?? 0.0;
//     //!---------------------------------------

//     return cashReceived;
//     // return cashReceived - _bookingProvider.getCalFinalAmountWithGST!;
//   }

//   //!----------------------Update all Date  to Provider -------------------------

//   void updateDataToProvider() {
//     try {
//       setState(() {
//         _isLoading = true;
//       });

//       BookingProvider bookingProvider =
//           Provider.of<BookingProvider>(context, listen: false);

//       bookingProvider.setAllZero();
//       //!---------------------------------------

//       // bookingProvider.setAppointEditAllData(widget.appointModel);
//       bookingProvider.getWatchList.clear();
//       // bookingProvider.getWatchList.addAll(widget.appointModel.services);
//       print(
//           "Watch List in Edit Direct Billing ${bookingProvider.getWatchList.length}");

//       bookingProvider.calculateTotalBookingDuration();
//       bookingProvider.calculateSubTotal();

//       _nameController.text = widget.appointModel.userModel.name;
//       _appointmentDateController.text =
//           GlobalVariable.DateTimeDateToString(widget.appointModel.appointmentInfo!.serviceDate);
//       appointmentNO = widget.appointModel.appointmentInfo.appointmentNo;
//       _mobileController.text = widget.appointModel.userModel.phone;
//       _userNote.text = widget.appointModel.userNote;
//       _timeStampList.addAll(widget.appointModel.timeStampList);
// //!---------------------------------------
//       // bookingProvider.setAppointEditAllData(widget.appointModel);

//       _extraDiscountInDirectAmount.text =
//           widget.appointModel.extraDiscountInAmount.toString();

//       widget.appointModel.extraDiscountInAmount == 0.0
//           ? setState(() {
//               _showExtraDiscount = false;
//               _netPriceLocal = widget.appointModel.netPriceBill +
//                   widget.appointModel.extraDiscountInAmount!;
//             })
//           : setState(() {
//               _showExtraDiscount = true;
//               _netPriceLocal = widget.appointModel.netPriceBill +
//                   widget.appointModel.extraDiscountInAmount!;
//             });
//     } catch (e) {
//       print("Error in Setting data to provider $e");
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       getData();
//       _initializeTimes();
//       updateDate();
//       updateDataToProvider();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     BookingProvider bookingProvider = Provider.of<BookingProvider>(context);
//     AppProvider appProvider = Provider.of<AppProvider>(context);
//     final serviceBookingDuration = bookingProvider.getServiceBookingDuration;
//     final serviceDurationInMinutes = parseDuration(serviceBookingDuration);
//     _generateTimeSlots(serviceDurationInMinutes);

//     // Add this check before building the main UI
//     if (_isLoading ||
//         _settingModel == null ||
//         _samaySalonSettingModel == null) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     return Scaffold(
//       backgroundColor: AppColor.whileColor,
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(60.0),
//         child: CustomAppBar(scaffoldKey: _scaffoldKey),
//       ),
//       drawer: const MobileDrawer(),
//       key: _scaffoldKey,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.zero,
//           child: GestureDetector(
//             onTap: () {
//               if (_showCalender ||
//                  
//                   _showTimeContaine == true) {
//                 setState(() {
//                   _showCalender = false;
//                   _showServiceList = false;
//                   _showTimeContaine = false;
//                 });
//               }
//             },
//             child: Column(
//               children: [
//                 Stack(
//                   children: [
//                     Column(
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.all(Dimensions.dimensionNo16),
//                           child: Text(
//                             "Edit Quick Billing ",
//                             style: TextStyle(
//                               fontSize: Dimensions.dimensionNo20,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                         // Container to User TextBox
//                         formOfAppoint(),
//                         //! Genarate List of Service which in Watch list
//                         GestureDetector(
//                           onTap: () {
//                             if (_showCalender ||
//                                
//                                 _showTimeContaine == true) {
//                               setState(() {
//                                 _showCalender = false;
//                                 _showServiceList = false;
//                                 _showTimeContaine = false;
//                               });
//                             }
//                           },
//                           child: Padding(
//                             padding: ResponsiveLayout.isMobile(context)
//                                 ? EdgeInsets.symmetric(
//                                     horizontal: Dimensions.dimensionNo12,
//                                     vertical: Dimensions.dimensionNo12)
//                                 : EdgeInsets.symmetric(
//                                     horizontal: Dimensions.dimensionNo18,
//                                     vertical: Dimensions.dimensionNo12),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Text(
//                                       "Select Serivce",
//                                       style: TextStyle(
//                                         fontSize:
//                                             ResponsiveLayout.isMobile(context)
//                                                 ? Dimensions.dimensionNo14
//                                                 : Dimensions.dimensionNo18,
//                                         fontWeight:
//                                             ResponsiveLayout.isMobile(context)
//                                                 ? FontWeight.bold
//                                                 : FontWeight.w600,
//                                       ),
//                                     ),
//                                     const Spacer(),
//                                     Text(
//                                       "Service Duration ${bookingProvider.getServiceBookingDuration}",
//                                       style: TextStyle(
//                                         fontSize:
//                                             ResponsiveLayout.isMobile(context)
//                                                 ? Dimensions.dimensionNo14
//                                                 : Dimensions.dimensionNo18,
//                                         fontWeight:
//                                             ResponsiveLayout.isMobile(context)
//                                                 ? FontWeight.bold
//                                                 : FontWeight.w600,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(
//                                   height: Dimensions.dimensionNo10,
//                                 ),
//                                 Padding(
//                                   padding: ResponsiveLayout.isMobile(context)
//                                       ? EdgeInsets.zero
//                                       : EdgeInsets.symmetric(
//                                           horizontal: Dimensions.dimensionNo12),
//                                   child: Wrap(
//                                     spacing: Dimensions
//                                         .dimensionNo12, // Horizontal space between items
//                                     runSpacing: Dimensions
//                                         .dimensionNo12, // Vertical space between rows
//                                     alignment: WrapAlignment.center,
//                                     runAlignment: WrapAlignment.start,
//                                     children: List.generate(
//                                       bookingProvider.getWatchList.length,
//                                       (index) {
//                                         ServiceModel servicelist =
//                                             bookingProvider.getWatchList[index];

//                                         return SizedBox(
//                                           width:
//                                               ResponsiveLayout.isMobile(context)
//                                                   ? Dimensions.dimensionNo210
//                                                   : Dimensions.dimensionNo300,
//                                           child: SingleServiceTapDeleteIcon(
//                                             serviceModel: servicelist,
//                                             onTap: () {
//                                               try {
//                                                 showLoaderDialog(context);
//                                                 setState(() {
//                                                   bookingProvider
//                                                       .removeServiceToWatchList(
//                                                           servicelist);

//                                                   bookingProvider
//                                                       .calculateTotalBookingDuration();
//                                                   bookingProvider
//                                                       .calculateSubTotal();
//                                                 });

//                                                 Navigator.of(context,
//                                                         rootNavigator: true)
//                                                     .pop();
//                                                 showMessage(
//                                                     'Service is removed from Watch List');
//                                               } catch (e) {
//                                                 showMessage(
//                                                     'Error occurred while removing service from Watch List: ${e.toString()}');
//                                               }
//                                             },
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(height: Dimensions.dimensionNo12),
//                                 //! TextBox for user note
//                                 SizedBox(
//                                   width: Dimensions.screenWidth,
//                                   child: FormCustomTextField(
//                                     requiredField: false,
//                                     controller: _userNote,
//                                     title: "User Note",
//                                     maxline: 2,
//                                     hintText: "Instruction of for appointment",
//                                   ),
//                                 ),
//                                 SizedBox(height: Dimensions.dimensionNo12),
//                                 // Detail of appointment
//                                 //! Appointment Details
//                                 AppointDetailsSummer(
//                                     bookingProvider,
//                                     serviceDurationInMinutes,
//                                     appProvider,
//                                     context),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     if (_showTimeContaine)
//                       Positioned(
//                         right: ResponsiveLayout.isMobile(context)
//                             ? Dimensions.dimensionNo20 // Adjust for mobile
//                             : Dimensions
//                                 .dimensionNo360, // Default for larger screens
//                         top: ResponsiveLayout.isMobile(context)
//                             ? Dimensions.dimensionNo150 // Adjust for mobile
//                             : Dimensions
//                                 .dimensionNo150, // Default for larger screens
//                         left: ResponsiveLayout.isMobile(context)
//                             ? Dimensions.dimensionNo20 // Adjust for mobile
//                             : null, // Default for larger screens
//                         child: SingleChildScrollView(
//                           child: Container(
//                             padding: EdgeInsets.all(Dimensions.dimensionNo12),

//                             width: ResponsiveLayout.isMobile(context)
//                                 ? Dimensions
//                                     .dimensionNo300 // Adjust width for mobile
//                                 : Dimensions
//                                     .dimensionNo500, // Default for larger screens
//                             constraints: BoxConstraints(
//                               maxHeight: ResponsiveLayout.isMobile(context)
//                                   ? Dimensions
//                                       .dimensionNo400 // Adjust height for mobile
//                                   : Dimensions
//                                       .dimensionNo500, // Default for larger screens
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(
//                                   Dimensions.dimensionNo10),
//                               border: Border.all(color: Colors.grey, width: 1),
//                             ),
//                             child: SingleChildScrollView(
//                               child: Column(
//                                 children: [
//                                   TimeSlot(
//                                     section: 'Morning',
//                                     timeSlots:
//                                         _categorizedTimeSlots['Morning'] ?? [],
//                                     selectedTimeSlot: _selectedTimeSlot,
//                                     serviceDurationInMinutes:
//                                         serviceDurationInMinutes,
//                                     endTime: _endTime,
//                                     onTimeSlotSelected: (selectedSlot) {
//                                       setState(() {
//                                         _selectedTimeSlot = selectedSlot;
//                                         _appointmentTimeController.text =
//                                             selectedSlot;
//                                       });
//                                     },
//                                   ),
//                                   TimeSlot(
//                                     section: 'Afternoon',
//                                     timeSlots:
//                                         _categorizedTimeSlots['Afternoon'] ??
//                                             [],
//                                     selectedTimeSlot: _selectedTimeSlot,
//                                     serviceDurationInMinutes:
//                                         serviceDurationInMinutes,
//                                     endTime: _endTime,
//                                     onTimeSlotSelected: (selectedSlot) {
//                                       setState(() {
//                                         _selectedTimeSlot = selectedSlot;
//                                         _appointmentTimeController.text =
//                                             selectedSlot;
//                                       });
//                                     },
//                                   ),
//                                   TimeSlot(
//                                     section: 'Evening',
//                                     timeSlots:
//                                         _categorizedTimeSlots['Evening'] ?? [],
//                                     selectedTimeSlot: _selectedTimeSlot,
//                                     serviceDurationInMinutes:
//                                         serviceDurationInMinutes,
//                                     endTime: _endTime,
//                                     onTimeSlotSelected: (selectedSlot) {
//                                       setState(() {
//                                         _selectedTimeSlot = selectedSlot;
//                                         _appointmentTimeController.text =
//                                             selectedSlot;
//                                       });
//                                     },
//                                   ),
//                                   TimeSlot(
//                                     section: 'Night',
//                                     timeSlots:
//                                         _categorizedTimeSlots['Night'] ?? [],
//                                     selectedTimeSlot: _selectedTimeSlot,
//                                     serviceDurationInMinutes:
//                                         serviceDurationInMinutes,
//                                     endTime: _endTime,
//                                     onTimeSlotSelected: (selectedSlot) {
//                                       setState(() {
//                                         _selectedTimeSlot = selectedSlot;
//                                         _appointmentTimeController.text =
//                                             selectedSlot;
//                                       });
//                                     },
//                                   ),
//                                   SizedBox(
//                                     height: Dimensions.dimensionNo12,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     if (_showCalender)
//                       Positioned(
//                         right: ResponsiveLayout.isMobile(context)
//                             ? Dimensions.dimensionNo20 // Adjust for mobile
//                             : Dimensions
//                                 .dimensionNo360, // Default for larger screens
//                         top: ResponsiveLayout.isMobile(context)
//                             ? Dimensions.dimensionNo150 // Adjust for mobile
//                             : Dimensions
//                                 .dimensionNo120, // Default for larger screens
//                         left: ResponsiveLayout.isMobile(context)
//                             ? Dimensions.dimensionNo20 // Adjust for mobile
//                             : null, // Default for larger screens
//                         child: SizedBox(
//                           height: ResponsiveLayout.isMobile(context)
//                               ? Dimensions
//                                   .dimensionNo400 // Adjust height for mobile
//                               : ResponsiveLayout.isTablet(context)
//                                   ? 400 // Adjust width for mobile
//                                   : Dimensions
//                                       .dimensionNo450, // Default for larger screens
//                           width: ResponsiveLayout.isMobile(context)
//                               ? Dimensions
//                                   .dimensionNo300 // Adjust width for mobile
//                               : ResponsiveLayout.isTablet(context)
//                                   ? 600 // Adjust width for mobile
//                                   : Dimensions
//                                       .dimensionNo360, // Default for larger screens
//                           child: CustomCalendar(
//                             salonModel: widget.salonModel,
//                             controller: _appointmentDateController,
//                             initialDate: _time,
//                             onDateChanged: (selectedDate) {},
//                           ),
//                         ),
//                       ),
//                     if (_showServiceList)
//                       Positioned(
//                         right: ResponsiveLayout.isMobile(context)
//                             ? Dimensions.dimensionNo20 // Adjust for mobile
//                             : null,

//                         //     .dimensionNo360, // Default for larger screens
//                         top: ResponsiveLayout.isMobile(context)
//                             ? Dimensions.dimensionNo200 // Adjust for mobile
//                             : Dimensions
//                                 .dimensionNo210, // Default for larger screens
//                         left: ResponsiveLayout.isMobile(context)
//                             ? Dimensions.dimensionNo20 // Adjust for mobile
//                             : Dimensions
//                                 .dimensionNo90, // Default for larger screens
//                         child: Container(
//                           width: Dimensions.dimensionNo500,
//                           constraints: const BoxConstraints(
//                             maxHeight:
//                                 320, // Set a max height to make it scrollable
//                           ),
//                           decoration: BoxDecoration(
//                             color: const Color(0xFFFFFFFF),
//                             borderRadius:
//                                 BorderRadius.circular(Dimensions.dimensionNo10),
//                           ),
//                           child: _serviceController.text.isNotEmpty &&
//                                   serchServiceList.isEmpty
//                               ? Padding(
//                                   padding: EdgeInsets.only(
//                                     top: Dimensions.dimensionNo12,
//                                     left: Dimensions.dimensionNo16,
//                                     bottom: Dimensions.dimensionNo12,
//                                   ),
//                                   child: Text(
//                                     "No service found",
//                                     style: TextStyle(
//                                         fontSize: Dimensions.dimensionNo14,
//                                         fontWeight: FontWeight.w600),
//                                   ),
//                                 )
//                               : serchServiceList.contains(
//                                           // ignore: iterable_contains_unrelated_type
//                                           _serviceController.text) ||
//                                       _serviceController.text.isEmpty
//                                   ? Padding(
//                                       padding: EdgeInsets.only(
//                                         top: Dimensions.dimensionNo12,
//                                         left: Dimensions.dimensionNo16,
//                                         bottom: Dimensions.dimensionNo12,
//                                       ),
//                                       child: Text(
//                                         "Enter a Service name or Code",
//                                         style: TextStyle(
//                                             fontSize: Dimensions.dimensionNo14,
//                                             fontWeight: FontWeight.w600),
//                                       ),
//                                     )
//                                   : ListView.builder(
//                                       shrinkWrap: true,
//                                       itemCount: serchServiceList.length,
//                                       itemBuilder: (context, index) {
//                                         ServiceModel serviceModel =
//                                             serchServiceList[index];
//                                         _netPriceLocal =
//                                             bookingProvider.getNetPrice! ?? 0.0;

//                                         return
//                                             // !isSearched()

//                                                                                            serviceTapAddRemoveButton(serviceModel, context);;

//                                       },
//                                     ),
//                         ),
//                       ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

// // Form of Appointment textbox for Mobile and Decktop
//   Container formOfAppoint() {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: Dimensions.dimensionNo16),
//       padding: EdgeInsets.all(Dimensions.dimensionNo16),
//       decoration: BoxDecoration(
//         border: Border.all(width: 1.5),
//         borderRadius: BorderRadius.circular(Dimensions.dimensionNo8),
//       ),
//       child: Center(
//         child: ResponsiveLayout.isMobile(context)

//             //! Textbox for mobile screen
//             ? Column(
//                 children: [
//                   // User Name textbox
//                   Wrap(
//                     spacing: Dimensions.dimensionNo8,
//                     runSpacing: Dimensions.dimensionNo5,
//                     alignment: WrapAlignment.start, // Align items to the left
//                     children: [
//                       textBoxOfForm(
//                         "First Name",
//                         _nameController,
//                         readOnly: true,
//                       ),

//                       //! User last Name textbox

//                       textBoxOfForm(
//                         "Last Name",
//                         _lastNameController,
//                         readOnly: true,
//                       ),

//                       //! select Date text box
//                       selectAppointDateTextBox(),
//                       textBoxOfForm(
//                         "Mobile No",
//                         _mobileController,
//                         readOnly: true,
//                       ),

//                       //! select Staff Name textbox
//                       staffIdSelectTextBox(),

//                       // timeSelectTextBox(),

//                       //! Search box for Services  text box
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           serviceServiceTextBox(),
//                           SizedBox(
//                             height: Dimensions.dimensionNo8,
//                           ),
//                           Container(
//                             width: Dimensions.dimensionNo500,
//                             constraints: const BoxConstraints(
//                               maxHeight:
//                                   320, // Set a max height to make it scrollable
//                             ),
//                             decoration: BoxDecoration(
//                               color: const Color(0xFFFFFFFF),
//                               borderRadius: BorderRadius.circular(
//                                   Dimensions.dimensionNo10),
//                             ),
//                             child: _serviceController.text.isNotEmpty &&
//                                     serchServiceList.isEmpty
//                                 ? Padding(
//                                     padding: EdgeInsets.only(
//                                       top: Dimensions.dimensionNo12,
//                                       left: Dimensions.dimensionNo16,
//                                       bottom: Dimensions.dimensionNo12,
//                                     ),
//                                     child: Text(
//                                       "No service found",
//                                       style: TextStyle(
//                                           fontSize: Dimensions.dimensionNo14,
//                                           fontWeight: FontWeight.w600),
//                                     ),
//                                   )
//                                 : serchServiceList.contains(
//                                             // ignore: iterable_contains_unrelated_type
//                                             _serviceController.text) ||
//                                         _serviceController.text.isEmpty
//                                     ? const SizedBox()
//                                     : ListView.builder(
//                                         shrinkWrap: true,
//                                         itemCount: serchServiceList.length,
//                                         itemBuilder: (context, index) {
//                                           ServiceModel serviceModel =
//                                               serchServiceList[index];
//                                           return
//                                               // !isSearched()

//                                                                                               serviceTapAddRemoveButton(serviceModel, context);;

//                                         },
//                                       ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               )
//             : Column(
//                 children: [
//                   // User Name textbox
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       textBoxOfForm(
//                         "First Name",
//                         _nameController,
//                         readOnly: true,
//                       ),
//                       SizedBox(
//                         width: Dimensions.dimensionNo30,
//                       ),
//                       //! User last Name textbox

//                       textBoxOfForm(
//                         "Last Name",
//                         _lastNameController,
//                         readOnly: true,
//                       ),

//                       SizedBox(
//                         width: Dimensions.dimensionNo30,
//                       ),
//                       //! select Date text box
//                       selectAppointDateTextBox(),
//                       //! Search box for Services  text box
//                     ],
//                   ),

//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       serviceServiceTextBox(),

//                       SizedBox(
//                         width: Dimensions.dimensionNo30,
//                       ),
//                       //! mobile text box

//                       textBoxOfForm(
//                         "Mobile No",
//                         _mobileController,
//                         readOnly: true,
//                       ),

//                       SizedBox(
//                         width: Dimensions.dimensionNo30,
//                       ),

//                       //! select Staff Name textbox
//                       staffIdSelectTextBox(),
//                       // timeSelectTextBox(),
//                     ],
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }

//   SizedBox textBoxOfForm(
//     String title,
//     TextEditingController controller, {
//     bool readOnly = false,
//   }) {
//     return SizedBox(
//       height: Dimensions.dimensionNo70,
//       width:
//           ResponsiveLayout.isMobile(context) ? null : Dimensions.dimensionNo250,
//       child: FormCustomTextField(
//         requiredField: false,
//         controller: controller,
//         title: title,
//         readOnly: readOnly,
//       ),
//     );
//   }

//   SizedBox selectAppointDateTextBox() {
//     return SizedBox(
//       height: Dimensions.dimensionNo70,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Appointment Date",
//             style: TextStyle(
//               color: Colors.black,
//               fontSize: ResponsiveLayout.isMobile(context)
//                   ? Dimensions.dimensionNo14
//                   : Dimensions.dimensionNo18,
//               fontFamily: GoogleFonts.roboto().fontFamily,
//               fontWeight: FontWeight.w500,
//               letterSpacing: 0.90,
//             ),
//           ),
//           SizedBox(
//             height: Dimensions.dimensionNo5,
//           ),
//           SizedBox(
//             height: ResponsiveLayout.isDesktop(context)
//                 ? Dimensions.dimensionNo30
//                 : Dimensions.dimensionNo40,
//             width: ResponsiveLayout.isMobile(context)
//                 ? null
//                 : Dimensions.dimensionNo250,
//             child: TextFormField(
//               onTap: () {
//                 setState(() {
//                   _showCalender = !_showCalender;
//                 });
//                 print(_showCalender);
//               },
//               readOnly: true,
//               cursorHeight: Dimensions.dimensionNo16,
//               style: TextStyle(
//                   fontSize: Dimensions.dimensionNo12,
//                   fontFamily: GoogleFonts.roboto().fontFamily,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black),
//               controller: _appointmentDateController,
//               decoration: InputDecoration(
//                 contentPadding: EdgeInsets.symmetric(
//                     horizontal: Dimensions.dimensionNo10,
//                     vertical: Dimensions.dimensionNo10),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(Dimensions.dimensionNo16),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   SizedBox timeSelectTextBox() {
//     return SizedBox(
//       height: Dimensions.dimensionNo70,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Time",
//             style: TextStyle(
//               color: Colors.black,
//               fontSize: ResponsiveLayout.isMobile(context)
//                   ? Dimensions.dimensionNo14
//                   : Dimensions.dimensionNo18,
//               fontFamily: GoogleFonts.roboto().fontFamily,
//               fontWeight: FontWeight.w500,
//               letterSpacing: 0.90,
//             ),
//           ),
//           SizedBox(
//             height: Dimensions.dimensionNo5,
//           ),
//           SizedBox(
//             height: ResponsiveLayout.isDesktop(context)
//                 ? Dimensions.dimensionNo30
//                 : Dimensions.dimensionNo40,
//             width: ResponsiveLayout.isMobile(context)
//                 ? null
//                 : Dimensions.dimensionNo250,
//             child: TextFormField(
//               onTap: () {
//                 setState(() {
//                   _showTimeContaine = !_showTimeContaine;
//                   print("Time : $_showTimeContaine");
//                 });
//               },
//               cursorHeight: Dimensions.dimensionNo16,
//               style: TextStyle(
//                   fontSize: Dimensions.dimensionNo12,
//                   fontFamily: GoogleFonts.roboto().fontFamily,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black),
//               controller: _appointmentTimeController,
//               decoration: InputDecoration(
//                 contentPadding: EdgeInsets.symmetric(
//                     horizontal: Dimensions.dimensionNo10,
//                     vertical: Dimensions.dimensionNo10),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(Dimensions.dimensionNo16),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   SizedBox staffIdSelectTextBox() {
//     return SizedBox(
//       height: Dimensions.dimensionNo70,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Staff Name",
//             style: TextStyle(
//               color: Colors.black,
//               fontSize: ResponsiveLayout.isMobile(context)
//                   ? Dimensions.dimensionNo14
//                   : Dimensions.dimensionNo18,
//               fontFamily: GoogleFonts.roboto().fontFamily,
//               fontWeight: FontWeight.w500,
//               letterSpacing: 0.90,
//             ),
//           ),
//           SizedBox(
//             height: Dimensions.dimensionNo5,
//           ),
//           SizedBox(
//             height: ResponsiveLayout.isDesktop(context)
//                 ? Dimensions.dimensionNo30
//                 : Dimensions.dimensionNo40,
//             width: ResponsiveLayout.isMobile(context)
//                 ? null
//                 : Dimensions.dimensionNo250,
//             child: TextFormField(
//               cursorHeight: Dimensions.dimensionNo16,
//               style: TextStyle(
//                   fontSize: Dimensions.dimensionNo12,
//                   fontFamily: GoogleFonts.roboto().fontFamily,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black),
//               controller: _staffName,
//               decoration: InputDecoration(
//                 contentPadding: EdgeInsets.symmetric(
//                     horizontal: Dimensions.dimensionNo10,
//                     vertical: Dimensions.dimensionNo10),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(Dimensions.dimensionNo16),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   SizedBox serviceServiceTextBox() {
//     BookingProvider bookingProvider =
//         Provider.of<BookingProvider>(context, listen: false);
//     return SizedBox(
//       height: Dimensions.dimensionNo70,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Service",
//             style: TextStyle(
//               color: Colors.black,
//               fontSize: ResponsiveLayout.isMobile(context)
//                   ? Dimensions.dimensionNo14
//                   : Dimensions.dimensionNo18,
//               fontFamily: GoogleFonts.roboto().fontFamily,
//               fontWeight: FontWeight.w500,
//               letterSpacing: 0.90,
//             ),
//           ),
//           SizedBox(
//             height: Dimensions.dimensionNo5,
//           ),
//           SizedBox(
//             height: ResponsiveLayout.isDesktop(context)
//                 ? Dimensions.dimensionNo30
//                 : Dimensions.dimensionNo40,
//             width: ResponsiveLayout.isMobile(context)
//                 ? null
//                 : Dimensions.dimensionNo250,
//             child: TextFormField(
//               onChanged: (String value) {
//                 serchService(value);

//                 if (ResponsiveLayout.isDesktop(context) ||
//                     ResponsiveLayout.isTablet(context)) {
//                   _showServiceList = true;
//                   _netPriceLocal = bookingProvider.getNetPrice! ?? 0.0;
//                 }
//               },
//               onTap: () {
//                 if (ResponsiveLayout.isDesktop(context) ||
//                     ResponsiveLayout.isTablet(context)) {
//                   setState(() {
//                     _showServiceList = !_showServiceList;
//                   });
//                 }
//               },
//               cursorHeight: Dimensions.dimensionNo16,
//               style: TextStyle(
//                   fontSize: Dimensions.dimensionNo12,
//                   fontFamily: GoogleFonts.roboto().fontFamily,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black),
//               controller: _serviceController,
//               decoration: InputDecoration(
//                 hintText: "Search Service...",
//                 contentPadding: EdgeInsets.symmetric(
//                     horizontal: Dimensions.dimensionNo10,
//                     vertical: Dimensions.dimensionNo10),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(Dimensions.dimensionNo16),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Container AppointDetailsSummer(
//     BookingProvider bookingProvider,
//     int serviceDurationInMinutes,
//     AppProvider appProvider,
//     BuildContext context,
//   ) {
//     return Container(
//       margin: ResponsiveLayout.isMobile(context)
//           ? EdgeInsets.zero
//           : EdgeInsets.symmetric(horizontal: Dimensions.dimensionNo250),
//       padding: EdgeInsets.symmetric(
//           horizontal: ResponsiveLayout.isMobile(context)
//               ? Dimensions.dimensionNo5
//               : Dimensions.dimensionNo20),
//       decoration: BoxDecoration(
//         color: AppColor.grey,
//         borderRadius: BorderRadius.circular(Dimensions.dimensionNo10),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(height: Dimensions.dimensionNo16),
//           Text(
//             'Appointment Summary.',
//             style: TextStyle(
//               fontSize: Dimensions.dimensionNo16,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const Divider(
//             color: Colors.white,
//           ),
//           ...[
//             SizedBox(height: Dimensions.dimensionNo10),
//             Row(
//               children: [
//                 Text(
//                   'Appointment Date',
//                   style: appointSummTextSyle(),
//                 ),
//                 const Spacer(),
//                 Text(
//                   _appointmentDateController.text,
//                   style: appointSummTextSyle(),
//                 ),
//               ],
//             ),
//             SizedBox(height: Dimensions.dimensionNo10),
//             Row(
//               children: [
//                 Text(
//                   'Appointment Duration',
//                   style: appointSummTextSyle(),
//                 ),
//                 const Spacer(),
//                 Text(
//                   bookingProvider.getServiceBookingDuration,
//                   style: appointSummTextSyle(),
//                 ),
//               ],
//             ),
//             SizedBox(height: Dimensions.dimensionNo10),
//             Row(
//               children: [
//                 Text(
//                   'Appointment Start Time',
//                   style: appointSummTextSyle(),
//                 ),
//                 const Spacer(),
//                 Text(
//                   '$_selectedTimeSlot',
//                   style: appointSummTextSyle(),
//                 ),
//               ],
//             ),
//             SizedBox(height: Dimensions.dimensionNo10),
//             Row(
//               children: [
//                 Text(
//                   'Appointment End Time',
//                   style: appointSummTextSyle(),
//                 ),
//                 const Spacer(),
//                 Text(
//                   DateFormat('hh:mm a').format(
//                     DateFormat('hh:mm a').parse(_selectedTimeSlot!).add(
//                           Duration(minutes: serviceDurationInMinutes),
//                         ),
//                   ),
//                   style: appointSummTextSyle(),
//                 ),
//               ],
//             ),
//             SizedBox(height: Dimensions.dimensionNo10),
//             const Divider(
//               color: Colors.white,
//             ),
//             Row(
//               children: [
//                 Expanded(
//                   child: Center(
//                     child: Text(
//                       'Price Details',
//                       style: TextStyle(
//                         fontSize: Dimensions.dimensionNo16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: () {
//                     setState(() {
//                       _showExtraDiscount = !_showExtraDiscount;
//                       _netPriceLocal = bookingProvider.getNetPrice! ?? 0.0;
//                     });
//                   },
//                   icon: const Icon(Icons.discount_outlined),
//                 ),
//               ],
//             ),
//             const Divider(
//               color: Colors.white,
//             ),
//             SizedBox(height: Dimensions.dimensionNo10),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // SubTotal
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Text(
//                         _settingModel!.gSTIsIncludingOrExcluding ==
//                                 GlobalVariable.inclusiveGST
//                             ? 'Subtotal (incl. GST ${_samaySalonSettingModel!.gstPer.toString()} %) '
//                             : 'SubTotal',
//                         style: appointSummaryTextStyle(context),
//                       ),
//                     ),
//                     Icon(Icons.currency_rupee, size: Dimensions.dimensionNo16),
//                     Text(
//                       bookingProvider.getSubTotal.toString(),
//                       style: appointSummaryTextStyle(context, bold: true),
//                     ),
//                   ],
//                 ),
//                 lineOfGrey(),

//                 // Item Discount
//                 if (bookingProvider.getDiscountInPer != 0.0) ...[
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Text(
//                           'Item Discount ${bookingProvider.getDiscountInPer!.round()}%',
//                           style: appointSummaryTextStyle(context,
//                               color: Colors.green),
//                         ),
//                       ),
//                       Text(
//                         "-₹${bookingProvider.getDiscountAmount.toString()}",
//                         style: appointSummaryTextStyle(context,
//                             color: Colors.green, bold: true),
//                       ),
//                     ],
//                   ),
//                   lineOfGrey(),
//                 ],

//                 // Extra Discount
//                 if (bookingProvider.getExtraDiscountAmount != 0.0) ...[
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Text(
//                           'Extra Discount ',
//                           // 'Extra Discount ${bookingProvider.getExtraDiscountInPer!.round()}%',
//                           style: appointSummaryTextStyle(context,
//                               color: Colors.blueGrey),
//                         ),
//                       ),
//                       Text(
//                         "-₹${bookingProvider.getExtraDiscountAmount.toString()}",
//                         style: appointSummaryTextStyle(context,
//                             color: Colors.blueGrey, bold: true),
//                       ),
//                     ],
//                   ),
//                   lineOfGrey(),
//                 ],

//                 // Net Price
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Text(
//                         _settingModel!.gSTIsIncludingOrExcluding ==
//                                 GlobalVariable.inclusiveGST
//                             ? 'Net Price (incl. GST)'
//                             : 'Net Price',
//                         style: appointSummaryTextStyle(context),
//                       ),
//                     ),
//                     Text(
//                       "₹${bookingProvider.getNetPrice!.toStringAsFixed(2)}",
//                       style: appointSummaryTextStyle(context, bold: true),
//                     ),
//                   ],
//                 ),
//                 lineOfGrey(),

//                 // Platform Fee
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Text(
//                         _settingModel!.gSTIsIncludingOrExcluding ==
//                                 GlobalVariable.inclusiveGST
//                             ? 'Platform fee (incl. GST)'
//                             : 'Platform fee',
//                         style: appointSummaryTextStyle(context),
//                       ),
//                     ),
//                     Icon(Icons.currency_rupee, size: Dimensions.dimensionNo16),
//                     Text(
//                       _samaySalonSettingModel!.platformFee,
//                       style: appointSummaryTextStyle(context, bold: true),
//                     ),
//                   ],
//                 ),
//                 lineOfGrey(),

//                 // Taxable Amount
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Text(
//                         _settingModel!.gSTIsIncludingOrExcluding == null ||
//                                 _settingModel!
//                                     .gSTIsIncludingOrExcluding!.isEmpty
//                             ? "Total Amount"
//                             : 'Taxable Amount',
//                         style: appointSummaryTextStyle(context),
//                       ),
//                     ),
//                     Icon(Icons.currency_rupee, size: Dimensions.dimensionNo16),
//                     Text(
//                       bookingProvider.getTaxAbleAmount!
//                           .round()
//                           .toStringAsFixed(2),
//                       style: appointSummaryTextStyle(context, bold: true),
//                     ),
//                   ],
//                 ),
//                 lineOfGrey(),

//                 // GST
//                 if (_settingModel!.gstNo.length == 15) ...[
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Text(
//                           'GST 18% (SGST & CGST)',
//                           style: appointSummaryTextStyle(context),
//                         ),
//                       ),
//                       Icon(Icons.currency_rupee,
//                           size: Dimensions.dimensionNo16),
//                       Text(
//                         _settingModel!.gSTIsIncludingOrExcluding ==
//                                 GlobalVariable.exclusiveGST
//                             ? bookingProvider.getExcludingGSTAMT!
//                                 .toStringAsFixed(2)
//                             : bookingProvider.getIncludingGSTAMT!
//                                 .toStringAsFixed(2),
//                         style: appointSummaryTextStyle(context, bold: true),
//                       ),
//                     ],
//                   ),
//                   lineOfGrey(),
//                 ],

//                 // Final Payable Amount
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Text(
//                         'Final Payable amount',
//                         style: appointSummaryTextStyle(context, bold: true),
//                       ),
//                     ),
//                     Icon(Icons.currency_rupee,
//                         size: Dimensions.dimensionNo18,
//                         color: Colors.green.shade700),
//                     Text(
//                       bookingProvider.getFinalPayableAMT!.round().toString(),
//                       style: appointSummaryTextStyle(context,
//                           color: Colors.green.shade700, bold: true),
//                     ),
//                   ],
//                 ),
//                 lineOfGrey(),
//               ],
//             ),
//             SizedBox(height: Dimensions.dimensionNo20),

//             //! Save Button
//             //! Save Button
//             saveAppointButton(context, serviceDurationInMinutes,
//                 bookingProvider, appProvider),
//             SizedBox(height: Dimensions.dimensionNo10),
//           ],
//         ],
//       ),
//     );
//   }

//   TextStyle appointSummaryTextStyle(BuildContext context,
//       {Color? color, bool bold = false}) {
//     double fontSize;
//     if (ResponsiveLayout.isMobile(context)) {
//       fontSize = Dimensions.dimensionNo13;
//     } else if (ResponsiveLayout.isTablet(context)) {
//       fontSize = Dimensions.dimensionNo15;
//     } else {
//       fontSize = Dimensions.dimensionNo17;
//     }
//     return TextStyle(
//       fontSize: fontSize,
//       fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
//       color: color ?? Colors.black87,
//       letterSpacing: 0.5,
//       fontFamily: GoogleFonts.roboto().fontFamily,
//     );
//   }

//   Widget lineOfGrey() {
//     return const Padding(
//       padding: EdgeInsets.symmetric(vertical: 2),
//       child: Divider(
//         thickness: 0.5,
//         color: Colors.grey,
//       ),
//     );
//   }

//   TextStyle appointSummTextSyle() {
//     return TextStyle(
//       fontSize: Dimensions.dimensionNo14,
//       fontWeight: FontWeight.w500,
//       letterSpacing: 0.90,
//     );
//   }

//   CustomAuthButton saveAppointButton(
//       BuildContext context,
//       int serviceDurationInMinutes,
//       BookingProvider bookingProvider,
//       AppProvider appProvider) {
//     return CustomAuthButton(
//       text: "Generate Bill",
//       ontap: () async {
//         showLoaderDialog(context);

//         //! Calculatiing service in time.
//         DateTime serviceEndTime =
//             DateFormat('hh:mm a').parse(_selectedTimeSlot!).add(
//                   Duration(minutes: serviceDurationInMinutes),
//                 );

//         bookingProvider.updatAppointStartTime(GlobalVariable.today);

//         bookingProvider.updateAppointEndTime(serviceEndTime);
//         print("Booking Date is : - ${bookingProvider.getAppointSelectedDate}");

//         // bookingProvider.update

//         //! Format in Appointment Date

//         TimeStampModel timeStampModel = TimeStampModel(
//             id: widget.salonModel.id,
//             dateAndTime: GlobalVariable.today,
//             updateBy: "${widget.salonModel.name} (update Bill)");
//         //! user full name
//         String fullName =
//             "${_nameController.text.trim()} ${_lastNameController.text.trim()}";
//         //! user model
//         UserModel userInfo = UserModel(
//             id: _mobileController.text.trim(),
//             name: fullName,
//             phone: _mobileController.text.trim(),
//             image:
//                 'https://static-00.iconduck.com/assets.00/profile-circle-icon-512x512-zxne30hp.png',
//             email: "No email",
//             password: " ",
//             timeStampModel: timeStampModel);
//         // get Book appointment time

//         Navigator.of(context, rootNavigator: true).pop();

//         showLoaderDialog(context);

//         _timeStampList.add(timeStampModel);
//         AppointModel updateAppointModel = widget.appointModel.copyWith(
//           services: bookingProvider.getWatchList,
//           subTotal: bookingProvider.getSubTotal,
//           serviceTotalPrice: bookingProvider.getFinalPayableAMT!,
//           netPrice: bookingProvider.getNetPrice!,
//           gstAmount: _settingModel!.gstNo.length == 15
//               ? _settingModel!.gSTIsIncludingOrExcluding ==
//                       GlobalVariable.exclusiveGST
//                   ? bookingProvider.getExcludingGSTAMT!
//                   : bookingProvider.getIncludingGSTAMT!
//               : 0.0,
//           payment: "PAP (Pay At Place)",
//           discountInPer: bookingProvider.getDiscountInPer!,
//           discountAmount: bookingProvider.getDiscountAmount,
//           serviceDuration: bookingProvider.getAppointDuration!.inMinutes,
//           serviceDate: bookingProvider.getAppointSelectedDate,
//           serviceStartTime: bookingProvider.getAppointStartTime,
//           serviceEndTime: bookingProvider.getAppointEndTime,
//           userNote: _userNote.text.trim(),
//           timeStampList: _timeStampList,
//           isUpdate: true,
//         );
//         bool value = await UserBookingFB.instance.updateAppointmentFB(
//           widget.userModel.id,
//           widget.appointModel.orderId,
//           updateAppointModel,
//         );

//         print(" ${_samaySalonSettingModel!.platformFee} platformFee");

//         await UserBookingFB.instance.updateDateFB(
//           widget.appointModel.appointmentInfo!.serviceDate,
//           widget.appointModel.appointmentInfo!.serviceDate,
//           widget.appointModel.adminId,
//           widget.appointModel.vendorId,
//         );
//         Navigator.of(context, rootNavigator: true).pop();

//         showMessage("Successfull add the appointment");

//         if (value) {
//           showLoaderDialog(context);
//           Future.delayed(
//             const Duration(seconds: 1),
//             () {
//               showDialog(
//                 context: context,
//                 barrierDismissible: false,
//                 builder: (context) {
//                   return AlertDialog(
//                     content: SizedBox(
//                       height: Dimensions.dimensionNo250,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           SizedBox(
//                             height: Dimensions.dimensionNo12,
//                           ),
//                           Icon(
//                             FontAwesomeIcons.solidHourglassHalf,
//                             size: Dimensions.dimensionNo40,
//                             color: AppColor.buttonColor,
//                           ),
//                           SizedBox(
//                             height: Dimensions.dimensionNo20,
//                           ),
//                           Text(
//                             'Appointment Book Successfull',
//                             style: TextStyle(
//                               fontSize: Dimensions.dimensionNo16,
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                           SizedBox(
//                             height: Dimensions.dimensionNo16,
//                           ),
//                           Text(
//                             '     Your booking has been processed!\nDetails of appointment are included below',
//                             style: TextStyle(
//                               fontSize: Dimensions.dimensionNo12,
//                               fontWeight: FontWeight.w400,
//                             ),
//                           ),
//                           SizedBox(
//                             height: Dimensions.dimensionNo20,
//                           ),
//                           Text(
//                             'Appointment No : $appointmentNO',
//                             style: TextStyle(
//                               fontSize: Dimensions.dimensionNo14,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     actions: [
//                       TextButton(
//                         onPressed: () {
//                           Routes.instance.push(
//                               widget: UserSideBarPaymentScreenForQB(
//                                 appointID: widget.appointModel.orderId,
//                                 userId: _mobileController.text.trim(),
//                               ),
//                               context: context);
//                         },
//                         child: Text(
//                           'OK',
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: Dimensions.dimensionNo18,
//                             fontWeight: FontWeight.w700,
//                           ),
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               );
//             },
//           );
//           Navigator.of(context, rootNavigator: true).pop();
//         }
//       },
//     );
//   }



// }
