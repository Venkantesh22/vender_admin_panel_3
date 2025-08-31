/// ignore_for_file: unused_local_variable, unnecessary_null_comparison, prefer_final_fields
library;

// ignore_for_file: use_build_context_synchronously, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/constants/global_variable.dart';
import 'package:samay_admin_plan/constants/responsive_layout.dart';
import 'package:samay_admin_plan/constants/router.dart';
import 'package:samay_admin_plan/constants/validation.dart';
import 'package:samay_admin_plan/features/Calender/screen/calender.dart';
import 'package:samay_admin_plan/features/add_new_appointment/widget/from_widget/drop_down_service.dart';
import 'package:samay_admin_plan/features/add_new_appointment/widget/from_widget/product_searchbar.dart';
import 'package:samay_admin_plan/features/add_new_appointment/widget/from_widget/select_apppint_date.dart';
import 'package:samay_admin_plan/features/add_new_appointment/widget/from_widget/service_searchbar.dart';
import 'package:samay_admin_plan/features/add_new_appointment/widget/single_product_delete_icon_widget.dart';
import 'package:samay_admin_plan/features/add_new_appointment/widget/single_service_appoint.dart';
import 'package:samay_admin_plan/features/add_new_appointment/widget/single_service_tap_icon.dart';
import 'package:samay_admin_plan/features/add_new_appointment/widget/time_tap.dart';
import 'package:samay_admin_plan/features/custom_appbar/screen/custom_appbar.dart';
import 'package:samay_admin_plan/features/drawer/drawer.dart';
import 'package:samay_admin_plan/features/home/screen/main_home/home_screen.dart';
import 'package:samay_admin_plan/features/payment/user_payment_screen.dart';
import 'package:samay_admin_plan/features/payment/user_payment_screen_qb.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_firestore_helper/samay_fb.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_firestore_helper/setting_fb.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_firestore_helper/user_order_fb.dart';
import 'package:samay_admin_plan/models/Product/Product_Model/product_model.dart';
import 'package:samay_admin_plan/models/appoint_model/appoint_model.dart';
import 'package:samay_admin_plan/models/salon_form_models/salon_infor_model.dart';
import 'package:samay_admin_plan/models/salon_setting_model/salon_setting_model.dart';
import 'package:samay_admin_plan/models/samay_salon_settng_model/samay_salon_setting.dart';
import 'package:samay_admin_plan/models/service_model/service_model.dart';
import 'package:samay_admin_plan/models/timestamp_model/timestamp_model.dart';
import 'package:samay_admin_plan/models/user_model/user_model.dart';
import 'package:samay_admin_plan/models/vender_payent_details/vender_payment_detail.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';
import 'package:samay_admin_plan/provider/booking_provider.dart';
import 'package:samay_admin_plan/provider/calender_provider.dart';
import 'package:samay_admin_plan/provider/product_provider.dart';
import 'package:samay_admin_plan/provider/service_provider.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimension.dart';
import 'package:samay_admin_plan/widget/customauthbutton.dart';
import 'package:samay_admin_plan/widget/text_box/customtextfield.dart';
import 'package:samay_admin_plan/widget/text_box/validate_textbox_heading.dart';
import 'package:upi_payment_qrcode_generator/upi_payment_qrcode_generator.dart';

class DirectBillingScreen extends StatefulWidget {
  final SalonModel salonModel;
  const DirectBillingScreen({
    super.key,
    required this.salonModel,
  });

  @override
  State<DirectBillingScreen> createState() => _DirectBillingScreenState();
}

class _DirectBillingScreenState extends State<DirectBillingScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DateTime _time = DateTime.now();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _appointmentDateController = TextEditingController();
  TextEditingController _appointmentTimeController =
      TextEditingController(text: "Select Time");
  TextEditingController _serviceController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _userNote = TextEditingController();
  TextEditingController _staffName = TextEditingController();
  SearchController productSearchControl1 = SearchController();
  SearchController serviceSearchControl = SearchController();

// For Select Service at Salon or home-- Default value is Salon
  String serviceAt = GlobalVariable.serviceAtSalon;
  List<String> serviceAtList = [
    // GlobalVariable.serviceAtHome,
    GlobalVariable.serviceAtSalon
  ];

  // final List<String> _paymentOptions = ["Cash", "QR", "Custom"];
  // String _selectedPaymentMethod = "Cash";
  // late VenderPaymentDetailsModel? _venderPaymentDetailsModel;
  // UPIDetails? upiDetails;
  // double _netPriceLocal = 0.0;

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _appointmentDateController.dispose();
    _appointmentTimeController.dispose();
    _mobileController.dispose();
    _userNote.dispose();
    productSearchControl1.dispose();
    serviceSearchControl.dispose();
    // _serviceAtControl.dispose();

    super.dispose();
  }

  // List<ServiceModel> serchServiceList = [];
  List<ServiceModel> allServiceList = [];
  // List<ServiceModel> selectService = [];

// For Product List
  List<ProductModel> allProductList = [];

  bool _showCalender = false;
  // bool _showServiceList = false;
  bool _showTimeContaine = false;
  bool _isLoading = false;

  int _timediff = 30;
  int appointmentNO = 0;
  bool isGSTAvaible = false;

  SamaySalonSettingModel? _samaySalonSettingModel;
  SettingModel? _settingModel;

//Serching  Services base on service name and code
  // void serchService(String value) {
  //   // Filtering based on both service name and service code
  //   serchServiceList = allServiceList
  //       .where((element) =>
  //           element.servicesName.toLowerCase().contains(value.toLowerCase()) ||
  //           element.serviceCode.toLowerCase().contains(value.toLowerCase()))
  //       .toList();

  //   setState(() {});
  // }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
      _initializeTimes();
      updateDate();
    });
  }

  void updateDate() {
    Provider.of<BookingProvider>(context, listen: false)
        .updateSelectedDate(_time);
    print("Initial Date :- $_time");
  }

  getData() async {
    setState(() {
      _isLoading = true;
    });

    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    BookingProvider bookingProvider =
        Provider.of<BookingProvider>(context, listen: false);
    ServiceProvider serviceProvider =
        Provider.of<ServiceProvider>(context, listen: false);
    ProductProvider productProvider =
        Provider.of<ProductProvider>(context, listen: false);

    try {
      bookingProvider.setAllZero();

      _settingModel = await SettingFb.instance
          .fetchSettingFromFB(appProvider.getSalonInformation.id);
      await bookingProvider.fetchSettingPro(appProvider.getSalonInformation.id);
      await appProvider.getSalonInfoFirebase();
      await serviceProvider.fetchSettingPro(appProvider.getSalonInformation.id);
      // _venderPaymentDetailsModel = await SettingFb.instance
      //     .fetchVenderPaymentFB(appProvider.getSalonInformation.id);
      _timediff = int.parse(serviceProvider.getSettingModel!.diffbtwTimetap);
      setState(() {
        _appointmentDateController.text =
            DateFormat("dd MMM yyyy").format(_time);
      });

      List<ServiceModel> fetchedServices = await UserBookingFB.instance
          .getAllServicesFromCategories(appProvider.getSalonInformation.id);
      bookingProvider.getWatchList.clear();
      _samaySalonSettingModel = await SamayFB.instance.fetchSalonSettingData();

      // GlobalVariable.salonPlatformFee = _samaySalonSettingModel!.platformFee;

      print("Gst is == ${_settingModel!.gSTIsIncludingOrExcluding}");
      print("Plact fee ${_samaySalonSettingModel!.platformFee}");

      // Get all Product and assign to allProductList list
      await productProvider.getListProductPro();
      allProductList = productProvider.getProductList;
      print("Print all Product ${allProductList.length}");

      print("Gst is == ${_settingModel!.gSTIsIncludingOrExcluding}");
      print("Plact fee ${_samaySalonSettingModel!.platformFee}");

      setState(() {
        allServiceList = fetchedServices;
      });
    } catch (e) {
      print("Error fetching data: $e");
    }

    setState(() {
      _isLoading = false;
    });
  }

  String? _selectedTimeSlot = GlobalVariable.getCurrentTime();
  // String?
  //     _serviceEndTime; //! to get _serviceEndTime add _serviceStartTime + serviceDurtion

//for Salon open and closer time
  DateTime? _startTime;
  DateTime? _endTime;

//For time slot
  Map<String, List<String>> _categorizedTimeSlots = {
    'Morning': [],
    'Afternoon': [],
    'Evening': [],
    'Night': [],
  };

  String timeOfDayToString(TimeOfDay timeOfDay) {
    final hour = timeOfDay.hour
        .toString()
        .padLeft(2, '0'); // Ensures two digits for hour
    final minute = timeOfDay.minute
        .toString()
        .padLeft(2, '0'); // Ensures two digits for minute
    return "$hour:$minute";
  }

  void _initializeTimes() {
    try {
      // Ensure openTime and closeTime are not null and are TimeOfDay
      if (widget.salonModel.openTime == null ||
          widget.salonModel.closeTime == null) {
        throw 'Salon opening or closing time is missing.';
      }

      // Convert TimeOfDay to string for formatting
      String salonOpenTime = _timeOfDayToString(widget.salonModel.openTime!);
      String salonCloseTime = _timeOfDayToString(widget.salonModel.closeTime!);

      if (salonOpenTime.isEmpty || salonCloseTime.isEmpty) {
        throw 'Salon opening or closing time is empty.';
      }

      // Parse the 12-hour time format with AM/PM (e.g., '11:00 PM')
      try {
        _startTime = DateFormat('hh:mm a').parse(salonOpenTime);
        _endTime = DateFormat('hh:mm a').parse(salonCloseTime);

        print("Parsed startTime: $_startTime, endTime: $_endTime");
      } catch (e) {
        throw 'Error parsing the opening or closing time: $e';
      }
    } catch (e) {
      // Handle parsing errors and fallback times
      print('Error: $e');

      // Set default times if parsing fails
      _startTime = DateTime.now(); // Fallback to the current time
      _endTime = DateTime.now()
          .add(const Duration(hours: 8)); // Default to 8 hours later

      print("Using fallback times: startTime: $_startTime, endTime: $_endTime");
    }
  }

// Helper method to convert TimeOfDay to a 12-hour AM/PM string
  String _timeOfDayToString(TimeOfDay timeOfDay) {
    final hour = timeOfDay.hour % 12; // Convert hour to 12-hour format
    final minute = timeOfDay.minute;
    final period = timeOfDay.hour >= 12 ? 'PM' : 'AM';
    return '$hour:${minute.toString().padLeft(2, '0')} $period';
  }

  String _normalizeTimeString(String timeString) {
    return timeString.replaceAllMapped(
      RegExp(r'(\d{1,2}):(\d{2})\s*(AM|PM)'),
      (match) => '${match[1]?.padLeft(2, '0')}:${match[2]} ${match[3]}',
    );
  }

  int parseDuration(String duration) {
    final regex = RegExp(r'(\d+)h (\d+)m');
    final match = regex.firstMatch(duration);

    if (match != null) {
      final hours = int.parse(match.group(1)!);
      final minutes = int.parse(match.group(2)!);
      return hours * 60 + minutes;
    }

    return 0; // Default to 0 if parsing fails
  }

//Generate Time slotes
  void _generateTimeSlots(int serviceDurationInMinutes) {
    if (_startTime != null && _endTime != null) {
      DateTime currentTime = _startTime!;
      _categorizedTimeSlots.forEach((key, value) => value.clear());

      while (currentTime.isBefore(_endTime!)) {
        final slotEndTime =
            currentTime.add(Duration(minutes: serviceDurationInMinutes));

        // Display only the time part, ignoring the date
        String formattedTime = DateFormat('hh:mm a').format(currentTime);

        if (currentTime.hour < 12) {
          _categorizedTimeSlots['Morning']!.add(formattedTime);
        } else if (currentTime.hour < 17) {
          _categorizedTimeSlots['Afternoon']!.add(formattedTime);
        } else if (currentTime.hour < 21) {
          _categorizedTimeSlots['Evening']!.add(formattedTime);
        } else {
          _categorizedTimeSlots['Night']!.add(formattedTime);
        }

        // Move to the next time slot
        currentTime = currentTime.add(
            Duration(minutes: _timediff)); // Adjust as neededjust as needed
        // currentTime = currentTime
        //     .add(Duration(minutes: 30)); // Adjust as neededjust as needed
      }

      // Ensure the last slot includes the closing time
      String lastSlotFormattedTime = DateFormat('hh:mm a').format(_endTime!);
      if (_categorizedTimeSlots['Night']!.last != lastSlotFormattedTime) {
        _categorizedTimeSlots['Night']!.add(lastSlotFormattedTime);
      }
    }
  }

  //!--------------------- calculate the Billing Amount---------------------------

  // // Cal Extra Discount Fun
  // double _extraDiscontAmountPer() {
  //   BookingProvider bookingProvider =
  //       Provider.of<BookingProvider>(context, listen: false);

  //   final discountPercentage = double.tryParse(_extraDiscountInPer.text) ?? 0.0;
  //   final validPercentage = discountPercentage.clamp(0.0, 100.0);
  //   double discountAmount = (validPercentage / 100) * _netPriceLocal;

  //   return discountAmount;
  // }

  // double get _cashToGiveBack {
  //   BookingProvider bookingProvider =
  //       Provider.of<BookingProvider>(context, listen: false);
  //   final cashReceived = double.tryParse(_cashReceivedController.text) ?? 0.0;
  //   return cashReceived - bookingProvider.getCalFinalAmountWithGST!;
  // }

  @override
  Widget build(BuildContext context) {
    BookingProvider bookingProvider = Provider.of<BookingProvider>(context);
    AppProvider appProvider = Provider.of<AppProvider>(context);
    final serviceBookingDuration = bookingProvider.getServiceBookingDuration;
    final serviceDurationInMinutes = parseDuration(serviceBookingDuration);
    _generateTimeSlots(serviceDurationInMinutes);

    // Add this check before building the main UI
    if (_isLoading ||
        _settingModel == null ||
        _samaySalonSettingModel == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColor.whileColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: CustomAppBar(scaffoldKey: _scaffoldKey),
      ),
      drawer: const MobileDrawer(),
      key: _scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: GestureDetector(
            onTap: () {
              if (_showCalender ||
                  // _showServiceList ||
                  _showTimeContaine == true) {
                setState(() {
                  _showCalender = false;
                  // _showServiceList = false;
                  _showTimeContaine = false;
                });
              }
            },
            child: Column(
              children: [
                Stack(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(Dimensions.dimensionNo16),
                          child: Text(
                            " Quick Billing ",
                            style: TextStyle(
                              fontSize: Dimensions.dimensionNo20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        // Container to User TextBox
                        formOfAppoint(bookingProvider),
                        //! Genarate List of Service which in Watch list
                        GestureDetector(
                          onTap: () {
                            if (_showCalender ||
                                // _showServiceList ||
                                _showTimeContaine == true) {
                              setState(() {
                                _showCalender = false;
                                // _showServiceList = false;
                                _showTimeContaine = false;
                              });
                            }
                          },
                          child: Padding(
                            padding: ResponsiveLayout.isMobile(context)
                                ? EdgeInsets.symmetric(
                                    horizontal: Dimensions.dimensionNo12,
                                    vertical: Dimensions.dimensionNo12)
                                : EdgeInsets.symmetric(
                                    horizontal: Dimensions.dimensionNo18,
                                    vertical: Dimensions.dimensionNo12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                selectServiceList(
                                  context,
                                  bookingProvider,
                                ),
                                SizedBox(height: Dimensions.dimensionNo12),

                                //? Select Product List

                                bookingProvider
                                        .budgetProductQuantityMap.isNotEmpty
                                    ? selectProductLists(context)
                                    : const SizedBox(),
                                SizedBox(height: Dimensions.dimensionNo12),

                                //! TextBox for user note
                                SizedBox(
                                  width: Dimensions.screenWidth,
                                  child: FormCustomTextField(
                                    requiredField: false,
                                    controller: _userNote,
                                    title: "User Note",
                                    maxline: 2,
                                    hintText: "Instruction of for appointment",
                                  ),
                                ),
                                SizedBox(height: Dimensions.dimensionNo12),
                                // Detail of appointment
                                //! Appointment Details

                                appointDetailsSummer(bookingProvider,
                                    serviceDurationInMinutes, context),
                                SizedBox(
                                  height: Dimensions.dimensionNo8,
                                ),

                                //! Save Button
                                saveAppointButton(context,
                                    serviceDurationInMinutes, bookingProvider),
                                SizedBox(height: Dimensions.dimensionNo10),
                                // Row(
                                //   children: [
                                //     Text(
                                //       "Select Services",
                                //       style: TextStyle(
                                //         fontSize:
                                //             ResponsiveLayout.isMobile(context)
                                //                 ? Dimensions.dimensionNo14
                                //                 : Dimensions.dimensionNo18,
                                //         fontWeight:
                                //             ResponsiveLayout.isMobile(context)
                                //                 ? FontWeight.bold
                                //                 : FontWeight.w600,
                                //       ),
                                //     ),
                                //     const Spacer(),
                                //     Text(
                                //       "Service Duration ${bookingProvider.getServiceBookingDuration}",
                                //       style: TextStyle(
                                //         fontSize:
                                //             ResponsiveLayout.isMobile(context)
                                //                 ? Dimensions.dimensionNo14
                                //                 : Dimensions.dimensionNo18,
                                //         fontWeight:
                                //             ResponsiveLayout.isMobile(context)
                                //                 ? FontWeight.bold
                                //                 : FontWeight.w600,
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                // SizedBox(
                                //   height: Dimensions.dimensionNo10,
                                // ),
                                // Padding(
                                //   padding: ResponsiveLayout.isMobile(context)
                                //       ? EdgeInsets.zero
                                //       : EdgeInsets.symmetric(
                                //           horizontal: Dimensions.dimensionNo12),
                                //   child: ResponsiveLayout.isMobile(context)
                                //       ? selectServiceListMobile(
                                //           context, bookingProvider)
                                //       : selectServiceListWeb(
                                //           bookingProvider, context),
                                // ),
                                // SizedBox(height: Dimensions.dimensionNo12),
                                // //! TextBox for user note
                                // SizedBox(
                                //   width: Dimensions.screenWidth,
                                //   child: FormCustomTextField(
                                //     requiredField: false,
                                //     controller: _userNote,
                                //     title: "User Note",
                                //     maxline: 2,
                                //     hintText: "Instruction of for appointment",
                                //   ),
                                // ),
                                // SizedBox(height: Dimensions.dimensionNo12),
                                // // Detail of appointment
                                // //! Appointment Details
                                // AppointDetailsSummer(
                                //     bookingProvider,
                                //     serviceDurationInMinutes,
                                //     appProvider,
                                //     context),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_showTimeContaine)
                      Positioned(
                        right: ResponsiveLayout.isMobile(context)
                            ? Dimensions.dimensionNo20 // Adjust for mobile
                            : Dimensions
                                .dimensionNo360, // Default for larger screens
                        top: ResponsiveLayout.isMobile(context)
                            ? Dimensions.dimensionNo150 // Adjust for mobile
                            : Dimensions
                                .dimensionNo150, // Default for larger screens
                        left: ResponsiveLayout.isMobile(context)
                            ? Dimensions.dimensionNo20 // Adjust for mobile
                            : null, // Default for larger screens
                        child: SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.all(Dimensions.dimensionNo12),

                            width: ResponsiveLayout.isMobile(context)
                                ? Dimensions
                                    .dimensionNo300 // Adjust width for mobile
                                : Dimensions
                                    .dimensionNo500, // Default for larger screens
                            constraints: BoxConstraints(
                              maxHeight: ResponsiveLayout.isMobile(context)
                                  ? Dimensions
                                      .dimensionNo400 // Adjust height for mobile
                                  : Dimensions
                                      .dimensionNo500, // Default for larger screens
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                  Dimensions.dimensionNo10),
                              border: Border.all(color: Colors.grey, width: 1),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  TimeSlot(
                                    section: 'Morning',
                                    timeSlots:
                                        _categorizedTimeSlots['Morning'] ?? [],
                                    selectedTimeSlot: _selectedTimeSlot,
                                    serviceDurationInMinutes:
                                        serviceDurationInMinutes,
                                    endTime: _endTime,
                                    onTimeSlotSelected: (selectedSlot) {
                                      setState(() {
                                        _selectedTimeSlot = selectedSlot;
                                        _appointmentTimeController.text =
                                            selectedSlot;
                                      });
                                    },
                                  ),
                                  TimeSlot(
                                    section: 'Afternoon',
                                    timeSlots:
                                        _categorizedTimeSlots['Afternoon'] ??
                                            [],
                                    selectedTimeSlot: _selectedTimeSlot,
                                    serviceDurationInMinutes:
                                        serviceDurationInMinutes,
                                    endTime: _endTime,
                                    onTimeSlotSelected: (selectedSlot) {
                                      setState(() {
                                        _selectedTimeSlot = selectedSlot;
                                        _appointmentTimeController.text =
                                            selectedSlot;
                                      });
                                    },
                                  ),
                                  TimeSlot(
                                    section: 'Evening',
                                    timeSlots:
                                        _categorizedTimeSlots['Evening'] ?? [],
                                    selectedTimeSlot: _selectedTimeSlot,
                                    serviceDurationInMinutes:
                                        serviceDurationInMinutes,
                                    endTime: _endTime,
                                    onTimeSlotSelected: (selectedSlot) {
                                      setState(() {
                                        _selectedTimeSlot = selectedSlot;
                                        _appointmentTimeController.text =
                                            selectedSlot;
                                      });
                                    },
                                  ),
                                  TimeSlot(
                                    section: 'Night',
                                    timeSlots:
                                        _categorizedTimeSlots['Night'] ?? [],
                                    selectedTimeSlot: _selectedTimeSlot,
                                    serviceDurationInMinutes:
                                        serviceDurationInMinutes,
                                    endTime: _endTime,
                                    onTimeSlotSelected: (selectedSlot) {
                                      setState(() {
                                        _selectedTimeSlot = selectedSlot;
                                        _appointmentTimeController.text =
                                            selectedSlot;
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    height: Dimensions.dimensionNo12,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (_showCalender)
                      Positioned(
                        right: ResponsiveLayout.isMobile(context)
                            ? Dimensions.dimensionNo20 // Adjust for mobile
                            : Dimensions
                                .dimensionNo360, // Default for larger screens
                        top: ResponsiveLayout.isMobile(context)
                            ? Dimensions.dimensionNo150 // Adjust for mobile
                            : Dimensions
                                .dimensionNo120, // Default for larger screens
                        left: ResponsiveLayout.isMobile(context)
                            ? Dimensions.dimensionNo20 // Adjust for mobile
                            : null, // Default for larger screens
                        child: SizedBox(
                          height: ResponsiveLayout.isMobile(context)
                              ? Dimensions
                                  .dimensionNo400 // Adjust height for mobile
                              : ResponsiveLayout.isTablet(context)
                                  ? 400 // Adjust width for mobile
                                  : Dimensions
                                      .dimensionNo450, // Default for larger screens
                          width: ResponsiveLayout.isMobile(context)
                              ? Dimensions
                                  .dimensionNo300 // Adjust width for mobile
                              : ResponsiveLayout.isTablet(context)
                                  ? 600 // Adjust width for mobile
                                  : Dimensions
                                      .dimensionNo360, // Default for larger screens
                          child: CustomCalendar(
                            salonModel: widget.salonModel,
                            controller: _appointmentDateController,
                            initialDate: _time,
                            onDateChanged: (selectedDate) {},
                          ),
                        ),
                      ),
                    // if (_showServiceList)
                    //   Positioned(
                    //     right: ResponsiveLayout.isMobile(context)
                    //         ? Dimensions.dimensionNo20 // Adjust for mobile
                    //         : null,

                    //     //     .dimensionNo360, // Default for larger screens
                    //     top: ResponsiveLayout.isMobile(context)
                    //         ? Dimensions.dimensionNo200 // Adjust for mobile
                    //         : Dimensions
                    //             .dimensionNo210, // Default for larger screens
                    //     left: ResponsiveLayout.isMobile(context)
                    //         ? Dimensions.dimensionNo20 // Adjust for mobile
                    //         : Dimensions
                    //             .dimensionNo90, // Default for larger screens
                    //     child: Container(
                    //       width: Dimensions.dimensionNo500,
                    //       constraints: const BoxConstraints(
                    //         maxHeight:
                    //             320, // Set a max height to make it scrollable
                    //       ),
                    //       decoration: BoxDecoration(
                    //         color: const Color(0xFFFFFFFF),
                    //         borderRadius:
                    //             BorderRadius.circular(Dimensions.dimensionNo10),
                    //       ),
                    //       child: _serviceController.text.isNotEmpty &&
                    //               serchServiceList.isEmpty
                    //           ? Padding(
                    //               padding: EdgeInsets.only(
                    //                 top: Dimensions.dimensionNo12,
                    //                 left: Dimensions.dimensionNo16,
                    //                 bottom: Dimensions.dimensionNo12,
                    //               ),
                    //               child: Text(
                    //                 "No service found",
                    //                 style: TextStyle(
                    //                     fontSize: Dimensions.dimensionNo14,
                    //                     fontWeight: FontWeight.w600),
                    //               ),
                    //             )
                    //           : serchServiceList.contains(
                    //                       // ignore: iterable_contains_unrelated_type
                    //                       _serviceController.text) ||
                    //                   _serviceController.text.isEmpty
                    //               ? Padding(
                    //                   padding: EdgeInsets.only(
                    //                     top: Dimensions.dimensionNo12,
                    //                     left: Dimensions.dimensionNo16,
                    //                     bottom: Dimensions.dimensionNo12,
                    //                   ),
                    //                   child: Text(
                    //                     "Enter a Service name or Code",
                    //                     style: TextStyle(
                    //                         fontSize: Dimensions.dimensionNo14,
                    //                         fontWeight: FontWeight.w600),
                    //                   ),
                    //                 )
                    //               : ListView.builder(
                    //                   shrinkWrap: true,
                    //                   physics: const NeverScrollableScrollPhysics(),
                    //                   itemCount: serchServiceList.length,
                    //                   itemBuilder: (context, index) {
                    //                     ServiceModel serviceModel =
                    //                         serchServiceList[index];
                    //                     return
                    //                         // !isSearched()

                    //                                                                        serviceTapAddRemoveButton(serviceModel, context);;

                    //                   },
                    //                 ),
                    //     ),
                    //   ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

//? ----------- Appointment Booking information ----------------------

  Container appointDetailsSummer(
    BookingProvider bookingProvider,
    int serviceDurationInMinutes,
    BuildContext context,
  ) {
    return Container(
      margin: ResponsiveLayout.isMobile(context)
          ? EdgeInsets.zero
          : EdgeInsets.symmetric(horizontal: Dimensions.dimensionNo250),
      padding: EdgeInsets.symmetric(
          horizontal: ResponsiveLayout.isMobile(context)
              ? Dimensions.dimensionNo5
              : Dimensions.dimensionNo20),
      decoration: BoxDecoration(
        color: AppColor.grey,
        borderRadius: BorderRadius.circular(Dimensions.dimensionNo10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: Dimensions.dimensionNo16),
          // if (_selectedTimeSlot != null)
          Text(
            'Appointment Summary.',
            style: TextStyle(
              fontSize: Dimensions.dimensionNo16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(
            color: Colors.white,
          ),
          // if (_selectedTimeSlot != null) ...[
          SizedBox(height: Dimensions.dimensionNo10),
          Row(
            children: [
              Text(
                'Appointment Date',
                style: appointSummerTextStyle(),
              ),
              const Spacer(),
              Text(
                _appointmentDateController.text,
                style: appointSummerTextStyle(),
              ),
            ],
          ),
          SizedBox(height: Dimensions.dimensionNo10),
          Row(
            children: [
              Text(
                'Appointment Duration',
                style: appointSummerTextStyle(),
              ),
              const Spacer(),
              Text(
                bookingProvider.getServiceBookingDuration,
                style: appointSummerTextStyle(),
              ),
            ],
          ),
          _selectedTimeSlot != null
              ? Column(
                  children: [
                    SizedBox(height: Dimensions.dimensionNo10),
                    Row(
                      children: [
                        Text(
                          'Appointment Start Time',
                          style: appointSummerTextStyle(),
                        ),
                        const Spacer(),
                        _selectedTimeSlot != null &&
                                _selectedTimeSlot!.isNotEmpty
                            ? Text(
                                '$_selectedTimeSlot',
                                style: appointSummerTextStyle(),
                              )
                            : const SizedBox(),
                      ],
                    ),
                    SizedBox(height: Dimensions.dimensionNo10),
                    Row(
                      children: [
                        Text(
                          'Appointment End Time',
                          style: appointSummerTextStyle(),
                        ),
                        const Spacer(),
                        _selectedTimeSlot != null &&
                                _selectedTimeSlot!.isNotEmpty
                            ? Text(
                                DateFormat('hh:mm a').format(
                                  DateFormat('hh:mm a')
                                      .parse(_selectedTimeSlot!)
                                      .add(
                                        Duration(
                                            minutes: serviceDurationInMinutes),
                                      ),
                                ),
                                style: appointSummerTextStyle(),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ],
                )
              : SizedBox(),
          SizedBox(height: Dimensions.dimensionNo10),
          const Divider(
            color: Colors.white,
          ),
          Center(
            child: Text(
              'Price Details',
              style: TextStyle(
                fontSize: Dimensions.dimensionNo16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(
            color: Colors.white,
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SubTotal
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'SubTotal',
                      style: appointSummaryTextStyle(context),
                    ),
                  ),
                  Icon(Icons.currency_rupee, size: Dimensions.dimensionNo16),
                  Text(
                    bookingProvider.getSubTotalBill.toString(),
                    style: appointSummaryTextStyle(context, bold: true),
                  ),
                ],
              ),
              lineOfGrey(),

              //  Discount
              if (bookingProvider.getDiscountBill != 0.0) ...[
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Discount ${bookingProvider.discountBillPer.toStringAsFixed(2)}%',
                        style: appointSummaryTextStyle(context,
                            color: Colors.green),
                      ),
                    ),
                    Text(
                      "-₹ ${bookingProvider.getDiscountBill.toString()}",
                      style: appointSummaryTextStyle(context,
                          color: Colors.green, bold: true),
                    ),
                  ],
                ),
                lineOfGrey(),
              ],

              // Extra Discount
              if (bookingProvider.getExtraDiscountAmount != 0.0) ...[
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Extra Discount ',
                        // 'Extra Discount ${bookingProvider.getExtraDiscountInPer!.round()}%',
                        style: appointSummaryTextStyle(context,
                            color: Colors.blueGrey),
                      ),
                    ),
                    Text(
                      "-₹${bookingProvider.getExtraDiscountAmount.toString()}",
                      style: appointSummaryTextStyle(context,
                          color: Colors.blueGrey, bold: true),
                    ),
                  ],
                ),
                lineOfGrey(),
              ],

              // Net Price
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Net Price',
                      style: appointSummaryTextStyle(context),
                    ),
                  ),
                  Text(
                    "₹ ${bookingProvider.getNetPriceBill.toStringAsFixed(2)}",
                    style: appointSummaryTextStyle(context, bold: true),
                  ),
                ],
              ),
              lineOfGrey(),

              // Platform Fee
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _settingModel!.gSTIsIncludingOrExcluding ==
                              GlobalVariable.inclusiveGST
                          ? 'Platform fee (incl. GST)'
                          : 'Platform fee',
                      style: appointSummaryTextStyle(context),
                    ),
                  ),
                  Icon(Icons.currency_rupee, size: Dimensions.dimensionNo16),
                  Text(
                    _samaySalonSettingModel!.platformFee,
                    style: appointSummaryTextStyle(context, bold: true),
                  ),
                ],
              ),
              lineOfGrey(),

              // Taxable Amount
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Taxable Amount',
                      style: appointSummaryTextStyle(context),
                    ),
                  ),
                  Icon(Icons.currency_rupee, size: Dimensions.dimensionNo16),
                  Text(
                    bookingProvider.getTaxableAmountBill
                        .round()
                        .toStringAsFixed(2),
                    style: appointSummaryTextStyle(context, bold: true),
                  ),
                ],
              ),
              lineOfGrey(),

              // GST
              if (_settingModel!.gstNo.length == 15) ...[
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'GST 18% (SGST & CGST)',
                        style: appointSummaryTextStyle(context),
                      ),
                    ),
                    Icon(Icons.currency_rupee, size: Dimensions.dimensionNo16),
                    Text(
                      bookingProvider.getGstAmountBill.toStringAsFixed(2),
                      style: appointSummaryTextStyle(context, bold: true),
                    ),
                  ],
                ),
                lineOfGrey(),
              ],

              // Final Payable Amount
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Final Payable amount',
                      style: appointSummaryTextStyle(context, bold: true),
                    ),
                  ),
                  Icon(Icons.currency_rupee,
                      size: Dimensions.dimensionNo18,
                      color: Colors.green.shade700),
                  Text(
                    bookingProvider.getFinalTotalBill.round().toString(),
                    style: appointSummaryTextStyle(context,
                        color: Colors.green.shade700, bold: true),
                  ),
                ],
              ),
            ],
          ),
        ],
        // ],
      ),
    );
  }

  Widget lineOfGrey() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Divider(
        thickness: 0.5,
        color: Colors.grey,
      ),
    );
  }

  TextStyle appointSummerTextStyle() {
    return TextStyle(
      fontSize: Dimensions.dimensionNo14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.90,
    );
  }

  Wrap selectServiceListWeb(
      BookingProvider bookingProvider, BuildContext context) {
    return Wrap(
      spacing: Dimensions.dimensionNo12, // Horizontal space between items
      runSpacing: Dimensions.dimensionNo12, // Vertical space between rows
      alignment: WrapAlignment.center,
      runAlignment: WrapAlignment.start,
      children: List.generate(
        bookingProvider.getWatchList.length,
        (index) {
          ServiceModel servicelist = bookingProvider.getWatchList[index];
          return SizedBox(
            width: ResponsiveLayout.isMobile(context)
                ? Dimensions.dimensionNo210
                : Dimensions.dimensionNo300,
            child: SingleServiceTapDeleteIcon(
              serviceModel: servicelist,
              onTap: () {
                try {
                  showLoaderDialog(context);
                  setState(() {
                    bookingProvider.removeServiceToWatchList(servicelist);

                    bookingProvider.calculateTotalBookingDuration();
                    bookingProvider.calculateSubTotal();
                  });

                  Navigator.of(context, rootNavigator: true).pop();
                  showMessage('Service is removed from Watch List');
                } catch (e) {
                  showMessage(
                      'Error occurred while removing service from Watch List: ${e.toString()}');
                }
              },
            ),
          );
        },
      ),
    );
  }

//!  All Select service List for mobile
  Widget selectServiceListMobile(
      BuildContext context, BookingProvider bookingProvider) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: bookingProvider.getWatchList.length,
      itemBuilder: (context, index) {
        ServiceModel servicelist = bookingProvider.getWatchList[index];
        return Padding(
          padding: EdgeInsets.only(
            bottom: Dimensions.dimensionNo12,
            right: Dimensions.dimensionNo12,
          ),
          child: SizedBox(
            width: ResponsiveLayout.isMobile(context)
                ? Dimensions.dimensionNo210
                : Dimensions.dimensionNo300,
            child: SingleServiceTapDeleteIcon(
              serviceModel: servicelist,
              onTap: () {
                try {
                  showLoaderDialog(context);
                  setState(() {
                    bookingProvider.removeServiceToWatchList(servicelist);
                    bookingProvider.calculateTotalBookingDuration();
                    bookingProvider.calculateSubTotal();
                  });
                  Navigator.of(context, rootNavigator: true).pop();
                  showMessage('Service is removed from Watch List');
                } catch (e) {
                  showMessage(
                      'Error occurred while removing service from Watch List: ${e.toString()}');
                }
              },
            ),
          ),
        );
      },
    );
  }

// Form of Appointment textbox for Mobile and Desktop

  Widget formOfAppoint(BookingProvider bookingProvider) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Dimensions.dimensionNo16),
      padding: EdgeInsets.all(Dimensions.dimensionNo16),
      decoration: BoxDecoration(
        border: Border.all(width: 1.5),
        borderRadius: BorderRadius.circular(Dimensions.dimensionNo8),
      ),
      child: Form(
        key: _formKey,
        child: Center(
          child: ResponsiveLayout.isMobile(context)
              ? Column(
                  children: [
                    //! Textbox for Mobile screen size
                    Wrap(
                      spacing: Dimensions.dimensionNo8,
                      runSpacing: Dimensions.dimensionNo5,
                      alignment: WrapAlignment.start, // Align items to the left
                      children: [
                        textBoxOfForm("First Name", "Enter First name",
                            _nameController, addFirstNameValidator),

                        //! User last Name textbox

                        textBoxOfForm("Last Name", "Enter Last name",
                            _lastNameController, addFirstNameValidator),

                        //! select Date text box
                        // selectAppointDateTextBox(),
                        selectAppointDateTextBoxWidget(
                            appointmentDateController:
                                _appointmentDateController,
                            showCalender: _showCalender,
                            onTap: () {
                              setState(() {
                                _showCalender = !_showCalender;
                              });
                              print(_showCalender);
                            },
                            context: context),

                        textBoxOfForm("Mobile No", "Enter a Mobile NO",
                            _mobileController, addMobileValidator),

                        //! select time textbox
                        // _timeSelectTextBox(),

                        //! Search box for Services  text box

                        serviceSearchBar(
                          serviceSearchControl,
                          context,
                          bookingProvider,
                          allServiceList,
                        ),
                        //! search box for product

                        // productSearchTextBox(),
                        productSearchBar(
                          productSearchControl1,
                          context,
                          bookingProvider,
                          allProductList,
                        ),

                        dropDownListSelectServiceAt(
                          serviceAt,
                          serviceAtList,
                          context,
                          (value) {
                            setState(() {
                              serviceAt = value;
                            });
                            print("serviceAt  : ${serviceAt}");
                          },
                        ),
                      ],
                    ),
                  ],
                )
              //! Textbox for table and desktop screen size

              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // User Name textbox
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textBoxOfForm("First Name", "Enter First name",
                            _nameController, addFirstNameValidator),

                        SizedBox(
                          width: Dimensions.dimensionNo30,
                        ),
                        //! User last Name textbox

                        textBoxOfForm("Last Name", "Enter Last name",
                            _lastNameController, addFirstNameValidator),

                        SizedBox(
                          width: Dimensions.dimensionNo30,
                        ),
                        //! select Date text box
                        selectAppointDateTextBoxWidget(
                            appointmentDateController:
                                _appointmentDateController,
                            showCalender: _showCalender,
                            onTap: () {
                              setState(() {
                                _showCalender = !_showCalender;
                              });
                              print(_showCalender);
                            },
                            context: context),
                        //! Search box for Services  text box
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: Dimensions.dimensionNo30,
                        ),

                        serviceSearchBar(
                          serviceSearchControl,
                          context,
                          bookingProvider,
                          allServiceList,
                        ),
                        SizedBox(
                          width: Dimensions.dimensionNo30,
                        ),

                        //! search box for product
                        // productSearchTextBox(),
                        productSearchBar(
                          productSearchControl1,
                          context,
                          bookingProvider,
                          allProductList,
                        ),
                        SizedBox(
                          width: Dimensions.dimensionNo30,
                        ),

                        //! mobile text box

                        textBoxOfForm("Mobile No", "Enter a Mobile NO",
                            _mobileController, addMobileValidator),

                        //! select time textbox
                        // _timeSelectTextBox(),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: Dimensions.dimensionNo60),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: Dimensions.dimensionNo30,
                          ),
                          const Spacer(),
                          //! DropdownList select Service

                          // dropDownListSelectServiceAt(),

                          dropDownListSelectServiceAt(
                            serviceAt,
                            serviceAtList,
                            context,
                            (value) {
                              setState(() {
                                serviceAt = value;
                              });
                              print("serviceAt  : ${serviceAt}");
                            },
                          ),
                          SizedBox(
                            width: Dimensions.dimensionNo60,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

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
//             //! for Moblie screen
//             ? Column(
//                 children: [
//                   // User Name textbox
//                   Wrap(
//                     spacing: Dimensions.dimensionNo8,
//                     runSpacing: Dimensions.dimensionNo5,
//                     alignment: WrapAlignment.start, // Align items to the left
//                     children: [
//                       textBoxOfForm("First Name", _nameController),

//                       //! User last Name textbox

//                       textBoxOfForm("Last Name", _lastNameController),

//                       //! select Date text box
//                       selectAppointDateTextBox(),

//                       textBoxOfForm("Mobile No", _mobileController),

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

//                                                                                                serviceTapAddRemoveButton(serviceModel, context);;
// ;
//                                         },
//                                       ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               )
//             //! for Table, Web screen

//             : Column(
//                 children: [
//                   // User Name textbox
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       textBoxOfForm("First Name", _nameController),
//                       SizedBox(
//                         width: Dimensions.dimensionNo30,
//                       ),
//                       //! User last Name textbox

//                       textBoxOfForm("Last Name", _lastNameController),

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

//                       textBoxOfForm("Mobile No", _mobileController),

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

  SizedBox textBoxOfForm(String title, String hindText,
      TextEditingController controller, String? Function(String?)? validator) {
    return SizedBox(
      width:
          ResponsiveLayout.isMobile(context) ? null : Dimensions.dimensionNo250,
      child: validateTextBoxWithHeading(
        hintText: hindText,
        labelText: title,
        controller: controller,
        validator: validator,
      ),
    );
  }

  Widget selectAppointDateTextBox() {
    return SizedBox(
      height: Dimensions.dimensionNo70,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Appointment Date",
            style: TextStyle(
              color: Colors.black,
              fontSize: ResponsiveLayout.isMobile(context)
                  ? Dimensions.dimensionNo14
                  : Dimensions.dimensionNo18,
              fontFamily: GoogleFonts.roboto().fontFamily,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.90,
            ),
          ),
          SizedBox(
            height: Dimensions.dimensionNo5,
          ),
          SizedBox(
            height: ResponsiveLayout.isDesktop(context)
                ? Dimensions.dimensionNo30
                : Dimensions.dimensionNo40,
            width: ResponsiveLayout.isMobile(context)
                ? null
                : Dimensions.dimensionNo250,
            child: TextFormField(
              onTap: () {
                setState(() {
                  _showCalender = !_showCalender;
                });
                print(_showCalender);
              },
              readOnly: true,
              cursorHeight: Dimensions.dimensionNo16,
              style: TextStyle(
                  fontSize: Dimensions.dimensionNo12,
                  fontFamily: GoogleFonts.roboto().fontFamily,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              controller: _appointmentDateController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                    horizontal: Dimensions.dimensionNo10,
                    vertical: Dimensions.dimensionNo10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.dimensionNo16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  SizedBox timeSelectTextBox() {
    return SizedBox(
      height: Dimensions.dimensionNo70,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Time",
            style: TextStyle(
              color: Colors.black,
              fontSize: ResponsiveLayout.isMobile(context)
                  ? Dimensions.dimensionNo14
                  : Dimensions.dimensionNo18,
              fontFamily: GoogleFonts.roboto().fontFamily,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.90,
            ),
          ),
          SizedBox(
            height: Dimensions.dimensionNo5,
          ),
          SizedBox(
            height: ResponsiveLayout.isDesktop(context)
                ? Dimensions.dimensionNo30
                : Dimensions.dimensionNo40,
            width: ResponsiveLayout.isMobile(context)
                ? null
                : Dimensions.dimensionNo250,
            child: TextFormField(
              onTap: () {
                setState(() {
                  _showTimeContaine = !_showTimeContaine;
                  print("Time : $_showTimeContaine");
                });
              },
              cursorHeight: Dimensions.dimensionNo16,
              style: TextStyle(
                  fontSize: Dimensions.dimensionNo12,
                  fontFamily: GoogleFonts.roboto().fontFamily,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              controller: _appointmentTimeController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                    horizontal: Dimensions.dimensionNo10,
                    vertical: Dimensions.dimensionNo10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.dimensionNo16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  SizedBox staffIdSelectTextBox() {
    return SizedBox(
      height: Dimensions.dimensionNo70,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Staff Name",
            style: TextStyle(
              color: Colors.black,
              fontSize: ResponsiveLayout.isMobile(context)
                  ? Dimensions.dimensionNo14
                  : Dimensions.dimensionNo18,
              fontFamily: GoogleFonts.roboto().fontFamily,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.90,
            ),
          ),
          SizedBox(
            height: Dimensions.dimensionNo5,
          ),
          SizedBox(
            height: ResponsiveLayout.isDesktop(context)
                ? Dimensions.dimensionNo30
                : Dimensions.dimensionNo40,
            width: ResponsiveLayout.isMobile(context)
                ? null
                : Dimensions.dimensionNo250,
            child: TextFormField(
              cursorHeight: Dimensions.dimensionNo16,
              style: TextStyle(
                  fontSize: Dimensions.dimensionNo12,
                  fontFamily: GoogleFonts.roboto().fontFamily,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              controller: _staffName,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                    horizontal: Dimensions.dimensionNo10,
                    vertical: Dimensions.dimensionNo10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.dimensionNo16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container AppointDetailsSummer(
    BookingProvider bookingProvider,
    int serviceDurationInMinutes,
    AppProvider appProvider,
    BuildContext context,
  ) {
    return Container(
      margin: ResponsiveLayout.isMobile(context)
          ? EdgeInsets.zero
          : EdgeInsets.symmetric(horizontal: Dimensions.dimensionNo250),
      padding: EdgeInsets.symmetric(
          horizontal: ResponsiveLayout.isMobile(context)
              ? Dimensions.dimensionNo5
              : Dimensions.dimensionNo20),
      decoration: BoxDecoration(
        color: AppColor.grey,
        borderRadius: BorderRadius.circular(Dimensions.dimensionNo10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: Dimensions.dimensionNo16),
          Text(
            'Appointment Summary.',
            style: TextStyle(
              fontSize: Dimensions.dimensionNo16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(
            color: Colors.white,
          ),
          ...[
            SizedBox(height: Dimensions.dimensionNo10),
            Row(
              children: [
                Text(
                  'Appointment Date',
                  style: appointSummTextSyle(),
                ),
                const Spacer(),
                Text(
                  _appointmentDateController.text,
                  style: appointSummTextSyle(),
                ),
              ],
            ),
            SizedBox(height: Dimensions.dimensionNo10),
            Row(
              children: [
                Text(
                  'Appointment Duration',
                  style: appointSummTextSyle(),
                ),
                const Spacer(),
                Text(
                  bookingProvider.getServiceBookingDuration,
                  style: appointSummTextSyle(),
                ),
              ],
            ),
            SizedBox(height: Dimensions.dimensionNo10),
            Row(
              children: [
                Text(
                  'Appointment Start Time',
                  style: appointSummTextSyle(),
                ),
                const Spacer(),
                Text(
                  '$_selectedTimeSlot',
                  style: appointSummTextSyle(),
                ),
              ],
            ),
            SizedBox(height: Dimensions.dimensionNo10),
            Row(
              children: [
                Text(
                  'Appointment End Time',
                  style: appointSummTextSyle(),
                ),
                const Spacer(),
                Text(
                  DateFormat('hh:mm a').format(
                    DateFormat('hh:mm a').parse(_selectedTimeSlot!).add(
                          Duration(minutes: serviceDurationInMinutes),
                        ),
                  ),
                  style: appointSummTextSyle(),
                ),
              ],
            ),
            SizedBox(height: Dimensions.dimensionNo10),
            const Divider(
              color: Colors.white,
            ),
            Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      'Price Details',
                      style: TextStyle(
                        fontSize: Dimensions.dimensionNo16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // IconButton(
                //   onPressed: () {
                //     setState(() {
                //       _showExtraDiscount = !_showExtraDiscount;
                //       _netPriceLocal = bookingProvider.getNetPrice! ?? 0.0;
                //     });
                //   },
                //   icon: const Icon(Icons.discount_outlined),
                // ),
              ],
            ),
            const Divider(
              color: Colors.white,
            ),
            SizedBox(height: Dimensions.dimensionNo10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SubTotal
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _settingModel!.gSTIsIncludingOrExcluding ==
                                GlobalVariable.inclusiveGST
                            ? 'Subtotal (incl. GST ${_samaySalonSettingModel!.gstPer.toString()} %) '
                            : 'SubTotal',
                        style: appointSummaryTextStyle(context),
                      ),
                    ),
                    Icon(Icons.currency_rupee, size: Dimensions.dimensionNo16),
                    Text(
                      bookingProvider.getSubTotal.toString(),
                      style: appointSummaryTextStyle(context, bold: true),
                    ),
                  ],
                ),
                lineOfGrey(),

                // Item Discount
                if (bookingProvider.getDiscountInPer != 0.0) ...[
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Item Discount ${bookingProvider.getDiscountInPer!.round()}%',
                          style: appointSummaryTextStyle(context,
                              color: Colors.green),
                        ),
                      ),
                      Text(
                        "-₹${bookingProvider.getDiscountAmount.toString()}",
                        style: appointSummaryTextStyle(context,
                            color: Colors.green, bold: true),
                      ),
                    ],
                  ),
                  lineOfGrey(),
                ],

                // Extra Discount
                if (bookingProvider.getExtraDiscountAmount != 0.0) ...[
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Extra Discount ',
                          // 'Extra Discount ${bookingProvider.getExtraDiscountInPer!.round()}%',
                          style: appointSummaryTextStyle(context,
                              color: Colors.blueGrey),
                        ),
                      ),
                      Text(
                        "-₹${bookingProvider.getExtraDiscountAmount.toString()}",
                        style: appointSummaryTextStyle(context,
                            color: Colors.blueGrey, bold: true),
                      ),
                    ],
                  ),
                  lineOfGrey(),
                ],

                // Net Price
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _settingModel!.gSTIsIncludingOrExcluding ==
                                GlobalVariable.inclusiveGST
                            ? 'Net Price (incl. GST)'
                            : 'Net Price',
                        style: appointSummaryTextStyle(context),
                      ),
                    ),
                    Text(
                      "₹${bookingProvider.getNetPrice!.toStringAsFixed(2)}",
                      style: appointSummaryTextStyle(context, bold: true),
                    ),
                  ],
                ),
                lineOfGrey(),

                // Platform Fee
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _settingModel!.gSTIsIncludingOrExcluding ==
                                GlobalVariable.inclusiveGST
                            ? 'Platform fee (incl. GST)'
                            : 'Platform fee',
                        style: appointSummaryTextStyle(context),
                      ),
                    ),
                    Icon(Icons.currency_rupee, size: Dimensions.dimensionNo16),
                    Text(
                      _samaySalonSettingModel!.platformFee,
                      style: appointSummaryTextStyle(context, bold: true),
                    ),
                  ],
                ),
                lineOfGrey(),

                // Taxable Amount
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _settingModel!.gSTIsIncludingOrExcluding == null ||
                                _settingModel!
                                    .gSTIsIncludingOrExcluding!.isEmpty
                            ? "Total Amount"
                            : 'Taxable Amount',
                        style: appointSummaryTextStyle(context),
                      ),
                    ),
                    Icon(Icons.currency_rupee, size: Dimensions.dimensionNo16),
                    Text(
                      bookingProvider.getTaxAbleAmount!
                          .round()
                          .toStringAsFixed(2),
                      style: appointSummaryTextStyle(context, bold: true),
                    ),
                  ],
                ),
                lineOfGrey(),

                // GST
                if (_settingModel!.gstNo.length == 15) ...[
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'GST 18% (SGST & CGST)',
                          style: appointSummaryTextStyle(context),
                        ),
                      ),
                      Icon(Icons.currency_rupee,
                          size: Dimensions.dimensionNo16),
                      Text(
                        _settingModel!.gSTIsIncludingOrExcluding ==
                                GlobalVariable.exclusiveGST
                            ? bookingProvider.getExcludingGSTAMT!
                                .toStringAsFixed(2)
                            : bookingProvider.getIncludingGSTAMT!
                                .toStringAsFixed(2),
                        style: appointSummaryTextStyle(context, bold: true),
                      ),
                    ],
                  ),
                  lineOfGrey(),
                ],

                // Final Payable Amount
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Final Payable amount',
                        style: appointSummaryTextStyle(context, bold: true),
                      ),
                    ),
                    Icon(Icons.currency_rupee,
                        size: Dimensions.dimensionNo18,
                        color: Colors.green.shade700),
                    Text(
                      bookingProvider.getFinalPayableAMT!.round().toString(),
                      style: appointSummaryTextStyle(context,
                          color: Colors.green.shade700, bold: true),
                    ),
                  ],
                ),
                lineOfGrey(),
              ],
            ),
            SizedBox(height: Dimensions.dimensionNo20),
            // _buildPaymentOptionsSection(bookingProvider),

            //! Save Button
            //! Save Button
            saveAppointButton(
                context, serviceDurationInMinutes, bookingProvider),
            SizedBox(height: Dimensions.dimensionNo10),
          ],
        ],
      ),
    );
  }

  TextStyle appointSummaryTextStyle(BuildContext context,
      {Color? color, bool bold = false}) {
    double fontSize;
    if (ResponsiveLayout.isMobile(context)) {
      fontSize = Dimensions.dimensionNo13;
    } else if (ResponsiveLayout.isTablet(context)) {
      fontSize = Dimensions.dimensionNo15;
    } else {
      fontSize = Dimensions.dimensionNo17;
    }
    return TextStyle(
      fontSize: fontSize,
      fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
      color: color ?? Colors.black87,
      letterSpacing: 0.5,
      fontFamily: GoogleFonts.roboto().fontFamily,
    );
  }

  // Widget lineOfGrey() {
  //   return const Padding(
  //     padding: EdgeInsets.symmetric(vertical: 2),
  //     child: Divider(
  //       thickness: 0.5,
  //       color: Colors.grey,
  //     ),
  //   );
  // }

  TextStyle appointSummTextSyle() {
    return TextStyle(
      fontSize: Dimensions.dimensionNo14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.90,
    );
  }

  Widget saveAppointButton(
    BuildContext context,
    int serviceDurationInMinutes,
    BookingProvider bookingProvider,
  ) {
    return Container(
      margin: ResponsiveLayout.isMobile(context)
          ? EdgeInsets.zero
          : EdgeInsets.symmetric(horizontal: Dimensions.dimensionNo250),
      padding: EdgeInsets.symmetric(
          horizontal: ResponsiveLayout.isMobile(context)
              ? Dimensions.dimensionNo5
              : Dimensions.dimensionNo20),
      child: CustomAuthButton(
        text: "Generate Bill",
        ontap: () async {
          print("serviceAt home $serviceAt");
          // if (_selectedTimeSlot == null || _selectedTimeSlot!.isEmpty) {
          //   showBottomMessageError("Please select a time slot", context);
          //   return;
          // }
          if (_formKey.currentState!.validate()) {
            showLoaderDialog(context);

            // update appoint ent to BookingProvider

            DateTime endTime = DateFormat('hh:mm a')
                .parse(_selectedTimeSlot!)
                .add(Duration(minutes: serviceDurationInMinutes));
            bookingProvider.updateAppointEndTime(endTime);

            print("End time Pro--${bookingProvider.getAppointEndTime}");

            //! Format in Appointment Date

            TimeStampModel timeStampModel = TimeStampModel(
                id: "",
                dateAndTime: GlobalVariable.today,
                updateBy: "${widget.salonModel.name} (Create a Appointment)");

            List<TimeStampModel> timeStampList = [];
            timeStampList.add(timeStampModel);
            //! user full name
            String fullName =
                "${_nameController.text.trim()} ${_lastNameController.text.trim()}";

            //! user model
            UserModel userInfo = UserModel(
                id: _mobileController.text.trim(),
                name: fullName,
                phone: _mobileController.text.trim(),
                image:
                    'https://static-00.iconduck.com/assets.00/profile-circle-icon-512x512-zxne30hp.png',
                email: "No email",
                password: " ",
                timeStampModel: timeStampModel);

            //get appointmentNo by add 1
            appointmentNO =
                await SamayFB.instance.incrementSalonAppointmentNo();

            final Map<String, int> productListIdQty1;
            productListIdQty1 = bookingProvider.getBudgetProductQuantityMap.map(
              (key, value) => MapEntry(key.id, value),
            );

            List<String>? _serviceListId = [];
            _serviceListId =

                bookingProvider.getWatchList.map((e) => e.id).toList() ?? [];

            //** Product Bill Model
            ProductBillModel productBillModel = ProductBillModel(
              productListIdQty: productListIdQty1,
              subTotalProduct: bookingProvider.getSubTotalProduct,
              discountATMProduct: bookingProvider.getTotalProductDisco,
              netPriceProduct: bookingProvider.getNetAmountProduct,
              taxableAMTProduct: bookingProvider.getTaxableAmountProduct,
              gSTAMTProduct: bookingProvider.getGstAmountProduct,
              finalAMTProduct: bookingProvider.getFinalProductTotal,
            );

            //** Service Bill Model
            // ServiceBillModel serviceBillModel = ServiceBillModel(
            //   serviceListId: _serviceListId,
            //   subTotalService: bookingProvider.getSubTotal,
            //   discountATMService: bookingProvider.getDiscountAmount!,
            //   netPriceService: bookingProvider.getNetPrice!,
            //   taxableAMTService: bookingProvider.getTaxAbleAmount!,
            //   gSTAMTService: _settingModel!.gstNo.length == 15
            //       ? _settingModel!.gSTIsIncludingOrExcluding ==
            //               GlobalVariable.exclusiveGST
            //           ? bookingProvider.getExcludingGSTAMT!
            //           : bookingProvider.getIncludingGSTAMT!
            //       : 0.0,
            //   finalAMTService: bookingProvider.getFinalPayableAMT!,
            //   gstIsIncludingOrExcluding:
            //       _settingModel!.gSTIsIncludingOrExcluding!,
            // );
            ServiceBillModel? serviceBillModel;
            if (bookingProvider.getWatchList.isNotEmpty) {
              serviceBillModel = ServiceBillModel(
                serviceListId: _serviceListId,
                subTotalService: bookingProvider.getSubTotal,
                discountATMService: bookingProvider.getDiscountAmount!,
                netPriceService: bookingProvider.getNetPrice!,
                taxableAMTService: bookingProvider.getTaxAbleAmount!,
                gSTAMTService: _settingModel!.gstNo.length == 15
                    ? _settingModel!.gSTIsIncludingOrExcluding ==
                            GlobalVariable.exclusiveGST
                        ? bookingProvider.getExcludingGSTAMT!
                        : bookingProvider.getIncludingGSTAMT!
                    : 0.0,
                finalAMTService: bookingProvider.getFinalPayableAMT!,
                gstIsIncludingOrExcluding:
                    _settingModel!.gSTIsIncludingOrExcluding!,
              );
            } else {
              serviceBillModel = null;
            }

            //** AppointmentInfo Model */
            AppointmentInfo appointmentInfo = AppointmentInfo(
              serviceAt: serviceAt,
              serviceDuration: bookingProvider.getAppointDuration!.inMinutes,
              serviceDate: bookingProvider.getAppointSelectedDate,
              serviceStartTime: bookingProvider.getAppointStartTime,
              serviceEndTime: bookingProvider.getAppointEndTime,
              // userNote: _userNote.text.trim(),
              userNote: _userNote.text.isEmpty ? "" : _userNote.text.trim(),

              appointmentNo: appointmentNO,
              status: GlobalVariable.billGenerateAppointState,
            );

            AppointModel appointModel = AppointModel(
                orderId: "",
                userId: userInfo.id,
                vendorId: widget.salonModel.id,
                adminId: widget.salonModel.adminId,
                userModel: userInfo,
                timeStampList: timeStampList,
                gstNo: _settingModel!.gstNo.isEmpty ? "" : _settingModel!.gstNo,
                // gstNo: "gstNo",
                transactionId: '',
                billingId: '',
                subTotalBill: bookingProvider.getSubTotalBill,
                discountBill: bookingProvider.getDiscountBill,
                netPriceBill: bookingProvider.getNetPriceBill,
                platformFeeBill: GlobalVariable.platformFee,
                taxableAmountBill: bookingProvider.getTaxableAmountBill,
                gstAmountBill: bookingProvider.getGstAmountBill,
                finalTotalBill: bookingProvider.getFinalTotalBill,
                payment: GlobalVariable.pAPPayment,
                appointmentInfo: appointmentInfo,
                serviceBillModel: serviceBillModel,
                productBillModel: productBillModel,
                isManual: true);
            print(appointModel);

            showLoaderDialog(context);

            // await UserBookingFB.instance.saveAppointmentForQuicKBill(

            // bool value =
            //     await UserBookingFB.instance.saveAppointmentManual(
            //   context: context,
            //   appointModel: appointModel,
            // );
            print("before save appoint");
            String? appointID =
                await UserBookingFB.instance.saveAppointmentForQuicKBill(
              context: context,
              appointModel: appointModel,
            );

            print(" ${_samaySalonSettingModel!.platformFee} platformFee");

            UserBookingFB.instance.saveDateFB(
                bookingProvider.getAppointSelectedDate,
                GlobalVariable.today,
                widget.salonModel.adminId,
                widget.salonModel.id);
            Navigator.of(context, rootNavigator: true).pop();

            showMessage("Successful add the appointment");

            if (appointID!.isNotEmpty || appointID != null) {
              showLoaderDialog(context);
              Future.delayed(
                const Duration(seconds: 1),
                () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return AlertDialog(
                        content: SizedBox(
                          height: Dimensions.dimensionNo250,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: Dimensions.dimensionNo12,
                              ),
                              Icon(
                                FontAwesomeIcons.solidHourglassHalf,
                                size: Dimensions.dimensionNo40,
                                color: AppColor.buttonColor,
                              ),
                              SizedBox(
                                height: Dimensions.dimensionNo20,
                              ),
                              Text(
                                'Appointment Book Successful',
                                style: TextStyle(
                                  fontSize: Dimensions.dimensionNo16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(
                                height: Dimensions.dimensionNo16,
                              ),
                              Text(
                                '     Your booking has been processed!\nDetails of appointment are included below',
                                style: TextStyle(
                                  fontSize: Dimensions.dimensionNo12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(
                                height: Dimensions.dimensionNo20,
                              ),
                              Text(
                                'Appointment No : $appointmentNO',
                                style: TextStyle(
                                  fontSize: Dimensions.dimensionNo14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            // onPressed: () async {
                            //   showLoaderDialog(context);
                            //   AppProvider appProvider =
                            //       Provider.of<AppProvider>(context,
                            //           listen: false);
                            //   AppointModel fetchAppointId = await UserBookingFB
                            //       .instance
                            //       .getSingleAppointByIdFB(
                            //           userInfo.id, appointID);
                            //   appProvider
                            //       .updateSelectAppointModel(fetchAppointId);
                            //   await appProvider.fetchServiceListByListId(
                            //       serviceIds: fetchAppointId
                            //           .serviceBillModel!.serviceListId);
                            //   await appProvider.fetchProductListByListId(
                            //       productIds: fetchAppointId.productBillModel!
                            //           .productListIdQty.entries
                            //           .map((product) => product.key)
                            //           .toList(),
                            //       productIdQtyMap: fetchAppointId
                            //           .productBillModel!.productListIdQty);

                            //   Navigator.of(context, rootNavigator: true).pop();

                            //   // appProvider.fetchServiceListByListId(serviceIds: serviceIds)
                            //   Routes.instance.push(
                            //       widget: UserSideBarPaymentScreen(
                            //           appointModel: fetchAppointId),
                            //       context: context);
                            // },
                            onPressed: () async {
                              showLoaderDialog(context);
                              AppProvider appProvider =
                                  Provider.of<AppProvider>(context,
                                      listen: false);
                              AppointModel fetchAppointId = await UserBookingFB
                                  .instance
                                  .getSingleAppointByIdFB(
                                      userInfo.id, appointID);
                              appProvider
                                  .updateSelectAppointModel(fetchAppointId);

                              // Only fetch service list if serviceBillModel is not null
                              if (fetchAppointId.serviceBillModel != null) {
                                await appProvider.fetchServiceListByListId(
                                  serviceIds: fetchAppointId
                                      .serviceBillModel!.serviceListId,
                                );
                              }

                              // Only fetch product list if productBillModel is not null
                              if (fetchAppointId.productBillModel != null) {
                                await appProvider.fetchProductListByListId(
                                  productIds: fetchAppointId
                                      .productBillModel!.productListIdQty.keys
                                      .toList(),
                                  productIdQtyMap: fetchAppointId
                                      .productBillModel!.productListIdQty,
                                );
                              }

                              Navigator.of(context, rootNavigator: true).pop();

                              Routes.instance.push(
                                widget: UserSideBarPaymentScreen(
                                    appointModel: fetchAppointId),
                                context: context,
                              );
                            },
                            child: Text(
                              'OK',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: Dimensions.dimensionNo18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
              Navigator.of(context, rootNavigator: true).pop();
            }
          }
        },
      ),
    );
  }

  // CustomAuthButton saveAppointButton(
  //     BuildContext context,
  //     int serviceDurationInMinutes,
  //     BookingProvider bookingProvider,
  //     AppProvider appProvider) {
  //   return CustomAuthButton(
  //     text: "Generate Bill",
  //     ontap: () async {
  //       showLoaderDialog(context);

  //       //! Calculatiing service in time.
  //       DateTime serviceEndTime =
  //           DateFormat('hh:mm a').parse(_selectedTimeSlot!).add(
  //                 Duration(minutes: serviceDurationInMinutes),
  //               );

  //       bookingProvider.updatAppointStartTime(GlobalVariable.today);

  //       bookingProvider.updateAppointEndTime(serviceEndTime);
  //       print("Booking Date is : - ${bookingProvider.getAppointSelectedDate}");

  //       // bookingProvider.update

  //       //! Format in Appointment Date

  //       TimeStampModel timeStampModel = TimeStampModel(
  //           id: widget.salonModel.id,
  //           dateAndTime: GlobalVariable.today,
  //           updateBy: "${widget.salonModel.name} (Create a Appointment)");
  //       //! user full name
  //       String fullName =
  //           "${_nameController.text.trim()} ${_lastNameController.text.trim()}";
  //       //! user model
  //       UserModel userInfo = UserModel(
  //           id: _mobileController.text.trim(),
  //           name: fullName,
  //           phone: _mobileController.text.trim(),
  //           image:
  //               'https://static-00.iconduck.com/assets.00/profile-circle-icon-512x512-zxne30hp.png',
  //           email: "No email",
  //           password: " ",
  //           timeStampModel: timeStampModel);
  //       // get Book appointment time

  //       bool isVaildater = addNewAppointmentVaildation(_nameController.text,
  //           _lastNameController.text, _mobileController.text);
  //       Navigator.of(context, rootNavigator: true).pop();
  //       if (isVaildater) {
  //         showLoaderDialog(context);
  //         //get appointmentNo by add 1
  //         appointmentNO = await SamayFB.instance.incrementSalonAppointmentNo();

  //         // Save appointment or Billing
  //         String? appointID =
  //             // ignore: use_build_context_synchronously
  //             await UserBookingFB.instance.saveAppointmentForQuicKBill(
  //           listOfServices: bookingProvider.getWatchList,
  //           userModel: userInfo,
  //           appointmentNo: appointmentNO,
  //           serviceTotalPrice: bookingProvider.getFinalPayableAMT!,
  //           subTotal: bookingProvider.getSubTotal,
  //           platformFees: double.parse(_samaySalonSettingModel!.platformFee),
  //           payment: "PAP (Pay At Place)",
  //           serviceDuration: bookingProvider.getAppointDuration!.inMinutes,
  //           serviceDate: bookingProvider.getAppointSelectedDate,
  //           serviceStartTime: bookingProvider.getAppointStartTime,
  //           serviceEndTime: bookingProvider.getAppointEndTime,
  //           userNote: _userNote.text.isEmpty ? " " : _userNote.text.trim(),
  //           vendorId: widget.salonModel.id,
  //           gstNo: _settingModel!.gstNo,
  //           gstAmount: _settingModel!.gstNo.length == 15
  //               ? _settingModel!.gSTIsIncludingOrExcluding ==
  //                       GlobalVariable.exclusiveGST
  //                   ? bookingProvider.getExcludingGSTAMT!
  //                   : bookingProvider.getIncludingGSTAMT!
  //               : 0.0,
  //           discountInPer: bookingProvider.getDiscountInPer!,
  //           discountAmount: bookingProvider.getDiscountAmount!,
  //           extraDiscountInPer: 0.0, // not calculate extr Discount
  //           extraDiscountInAmount: 0.0,
  //           netPrice: bookingProvider.getNetPrice!,
  //           gstIsIncludingOrExcluding:
  //               _settingModel!.gSTIsIncludingOrExcluding!,
  //           status: GlobalVariable.billGenerateAppointState,
  //           context: context,
  //         );

  //         print(" ${_samaySalonSettingModel!.platformFee} platformFee");

  //         UserBookingFB.instance.saveDateFB(
  //             bookingProvider.getAppointSelectedDate,
  //             GlobalVariable.today,
  //             widget.salonModel.adminId,
  //             widget.salonModel.id);
  //         Navigator.of(context, rootNavigator: true).pop();

  //         showMessage("Successfull add the appointment");

  //         if (appointID!.isNotEmpty || appointID != null) {
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
  // Routes.instance.push(
  //     widget: UserSideBarPaymentScreenForQB(
  //       appointID: appointID,
  //       userId: _mobileController.text.trim(),
  //     ),
  //     context: context);
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
  //       }
  //     },
  //   );
  // }

//   Widget _buildPaymentMethodSelector(BookingProvider bookingProvider) {
//     return Container(
//       constraints: BoxConstraints(maxHeight: Dimensions.screenHeight * 0.4),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             flex: 1,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: DropdownButtonFormField<String>(
//                 value: _selectedPaymentMethod,
//                 items: _paymentOptions
//                     .map((method) => DropdownMenuItem(
//                           value: method,
//                           child: Text(method),
//                         ))
//                     .toList(),
//                 onChanged: (newValue) => setState(() {
//                   _selectedPaymentMethod = newValue!;
//                   if (_selectedPaymentMethod == "QR") {
//                     if (_venderPaymentDetailsModel != null &&
//                         _venderPaymentDetailsModel!.upiID.isNotEmpty) {
//                       upiDetails = UPIDetails(
//                         upiID: _venderPaymentDetailsModel!.upiID,
//                         payeeName: _nameController.text.trim(),
//                         amount: bookingProvider.getCalFinalAmountWithGST!,
//                         transactionNote:
//                             "Thank you for booking services on Samay.",
//                       );
//                     } else {
//                       // Fallback default UPI value if not available
//                       upiDetails = UPIDetails(
//                         upiID: " ",
//                         payeeName: '',
//                         amount: 0,
//                         transactionNote: "",
//                       );
//                     }
//                   } else if (_selectedPaymentMethod == "Custom") {
//                     // For custom, we may show a custom payment section
//                     upiDetails = null;
//                   } else {
//                     upiDetails = null;
//                   }
//                 }),
//                 decoration: const InputDecoration(
//                   labelText: "Payment Method",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 2,
//             child: Container(
//               decoration: BoxDecoration(
//                   color: AppColor.whileColor,
//                   borderRadius:
//                       BorderRadius.circular(Dimensions.dimensionNo12)),
//               padding: const EdgeInsets.all(8.0),
//               child: _selectedPaymentMethod == "Cash"
//                   ? _buildCashPaymentSection(bookingProvider)
//                   : _selectedPaymentMethod == "QR"
//                       ? _buildQRPaymentSection()
//                       : _buildCustomPaymentSection(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCashPaymentSection(BookingProvider bookingProvider) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         TextField(
//           controller: _cashReceivedController,
//           keyboardType: const TextInputType.numberWithOptions(decimal: true),
//           decoration: InputDecoration(
//             border: const OutlineInputBorder(),
//             labelText: "Cash Received",
//             errorText: _validateCashInput(),
//           ),
//           onChanged: (value) => setState(() {}),
//         ),
//         SizedBox(height: Dimensions.dimensionNo16),
//         Text(
//           "Change Due: ₹${_cashToGiveBack.round()}",
//           style: TextStyle(
//             fontSize: Dimensions.dimensionNo16,
//             color: _cashToGiveBack >= 0 ? Colors.green : Colors.red,
//           ),
//         ),
//         if (bookingProvider.getCalFinalAmountWithGST! < 0)
//           Text(
//             "Insufficient cash received",
//             style: TextStyle(
//               color: Colors.red,
//               fontSize: Dimensions.dimensionNo12,
//             ),
//           ),
//       ],
//     );
//   }

//   String? _validateCashInput() {
//     final value = double.tryParse(_cashReceivedController.text);
//     if (value == null && _cashReceivedController.text.isNotEmpty) {
//       return 'Invalid amount';
//     }
//     return null;
//   }

//   Widget _buildQRPaymentSection() {
//     return SingleChildScrollView(
//       child: Container(
//         constraints: BoxConstraints(
//           maxHeight: ResponsiveLayout.isMobile(context)
//               ? Dimensions.screenHeight * 0.8
//               : Dimensions.screenHeight * 0.5,
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             SizedBox(
//               height: Dimensions.dimensionNo150,
//               width: Dimensions.dimensionNo150,
//               child: UPIPaymentQRCode(upiDetails: upiDetails!),
//             ),
//             SizedBox(height: Dimensions.dimensionNo8),
//             Padding(
//               padding:
//                   EdgeInsets.symmetric(horizontal: Dimensions.dimensionNo20),
//               child: SizedBox(
//                 height: Dimensions.dimensionNo30,
//                 child: TextField(
//                   controller: _transactionIdController,
//                   style: TextStyle(fontSize: Dimensions.dimensionNo12),
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     labelText: "Transaction ID",
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Custom Payment Section for "Custom" payment option
//   Widget _buildCustomPaymentSection() {
//     return Center(
//       child: Text(
//         "Custom Payment method selected.",
//         style: TextStyle(fontSize: Dimensions.dimensionNo14),
//       ),
//     );
//   }
}
