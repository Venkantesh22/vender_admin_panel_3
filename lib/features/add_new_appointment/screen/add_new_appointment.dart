/// ignore_for_file: unused_local_variable, unnecessary_null_comparison, prefer_final_fields
// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_local_variable

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
import 'package:samay_admin_plan/features/add_new_appointment/widget/budge.dart';
import 'package:samay_admin_plan/features/add_new_appointment/widget/from_widget/drop_down_service.dart';
import 'package:samay_admin_plan/features/add_new_appointment/widget/from_widget/product_searchbar.dart';
import 'package:samay_admin_plan/features/add_new_appointment/widget/from_widget/select_apppint_date.dart';
import 'package:samay_admin_plan/features/add_new_appointment/widget/from_widget/service_searchbar.dart';
import 'package:samay_admin_plan/features/add_new_appointment/widget/single_product_delete_icon_widget.dart';
import 'package:samay_admin_plan/features/add_new_appointment/widget/single_service_tap_icon.dart';
import 'package:samay_admin_plan/features/add_new_appointment/widget/time_tap.dart';
import 'package:samay_admin_plan/features/custom_appbar/screen/custom_appbar.dart';
import 'package:samay_admin_plan/features/drawer/drawer.dart';
import 'package:samay_admin_plan/features/home/screen/main_home/home_screen.dart';
import 'package:samay_admin_plan/features/payment/user_payment_screen.dart';
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

class AddNewAppointment extends StatefulWidget {
  final SalonModel salonModel;
  final bool isDirectBilling;
  const AddNewAppointment({
    this.isDirectBilling = false,
    super.key,
    required this.salonModel,
  });

  @override
  State<AddNewAppointment> createState() => _AddNewAppointmentState();
}

class _AddNewAppointmentState extends State<AddNewAppointment> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DateTime _time = DateTime.now();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _appointmentDateController = TextEditingController();
  TextEditingController _appointmentTimeController =
      TextEditingController(text: "Select Time");
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _userNote = TextEditingController();
  SearchController productSearchControl1 = SearchController();
  SearchController serviceSearchControl = SearchController();

// For Select Service at Salon or home-- Default value is Salon
  String serviceAt = GlobalVariable.serviceAtSalon;
  List<String> serviceAtList = [
    // GlobalVariable.serviceAtHome,
    GlobalVariable.serviceAtSalon
  ];

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

    super.dispose();
  }

// for Service List
  List<ServiceModel> allServiceList = [];

// For Product List
  List<ProductModel> allProductList = [];

  bool _showCalender = false;

  bool _showTimeContain = false;
  bool _isLoading = false;

  int _timediff = 30;
  int appointmentNO = 0;

  SamaySalonSettingModel? _samaySalonSettingModel;
  SettingModel? _settingModel;

  @override
  void initState() {
    super.initState();

    _selectedTimeSlot = GlobalVariable.getCurrentTime() ;

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
    debugPrint(
        "---------------Appoint state ---------- ${widget.isDirectBilling}");

    try {
      bookingProvider.setAllZero();
      _settingModel = await SettingFb.instance
          .fetchSettingFromFB(appProvider.getSalonInformation.id);
      await bookingProvider.fetchSettingPro(appProvider.getSalonInformation.id);
      await appProvider.getSalonInfoFirebase();
      await serviceProvider.fetchSettingPro(appProvider.getSalonInformation.id);

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
// Get all Product and assign to allProductList list
      await productProvider.getListProductPro(appProvider.getSalonInformation.id);
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

  String? _selectedTimeSlot;
  String?
      _serviceEndTime; //! to get _serviceEndTime add _serviceStartTime + serviceDurtion

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
            Duration(minutes: _timediff)); // Adjust as needed just as needed
      }

      // Ensure the last slot includes the closing time
      String lastSlotFormattedTime = DateFormat('hh:mm a').format(_endTime!);
      if (_categorizedTimeSlots['Night']!.last != lastSlotFormattedTime) {
        _categorizedTimeSlots['Night']!.add(lastSlotFormattedTime);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    BookingProvider bookingProvider = Provider.of<BookingProvider>(context);
    // Avoid running generation/nullable-dependent logic while loader is shown.
    int serviceDurationInMinutes = 0;
    if (!_isLoading) {
      final serviceBookingDuration = bookingProvider.getServiceBookingDuration;
      serviceDurationInMinutes = parseDuration(serviceBookingDuration);
      _generateTimeSlots(serviceDurationInMinutes);
    }

    return Scaffold(
      backgroundColor: AppColor.whileColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: CustomAppBar(scaffoldKey: _scaffoldKey),
      ),
      drawer: const MobileDrawer(),
      key: _scaffoldKey,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: GestureDetector(
                  onTap: () {
                    if (_showCalender || _showTimeContain == true) {
                      setState(() {
                        _showCalender = false;

                        _showTimeContain = false;
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
                                padding:
                                    EdgeInsets.all(Dimensions.dimensionNo16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Spacer(),
                                    Text(
                                      "Add New Appointment",
                                      style: TextStyle(
                                        fontSize: Dimensions.dimensionNo20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const Spacer(),
                                    badgeFloatingActionButton(bookingProvider),
                                  ],
                                ),
                              ),
                              // Container to User TextBox
                              formOfAppoint(bookingProvider),
                              //! Genarate List of Service which in Watch list
                              GestureDetector(
                                onTap: () {
                                  if (_showCalender ||
                                      _showTimeContain == true) {
                                    setState(() {
                                      _showCalender = false;

                                      _showTimeContain = false;
                                    });
                                  }
                                },
                                child: Column(
                                  children: [
                                    //? Select Service List
                                    Padding(
                                      padding:
                                          ResponsiveLayout.isMobile(context)
                                              ? EdgeInsets.symmetric(
                                                  horizontal:
                                                      Dimensions.dimensionNo12,
                                                  vertical:
                                                      Dimensions.dimensionNo12)
                                              : EdgeInsets.symmetric(
                                                  horizontal:
                                                      Dimensions.dimensionNo18,
                                                  vertical:
                                                      Dimensions.dimensionNo12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          selectServiceList(
                                            context,
                                            bookingProvider,
                                          ),
                                          SizedBox(
                                              height: Dimensions.dimensionNo12),

                                          //? Select Product List

                                          bookingProvider
                                                  .budgetProductQuantityMap
                                                  .isNotEmpty
                                              ? selectProductLists(context)
                                              : const SizedBox(),
                                          SizedBox(
                                              height: Dimensions.dimensionNo12),

                                          //! TextBox for user note
                                          SizedBox(
                                            width: Dimensions.screenWidth,
                                            child: FormCustomTextField(
                                              requiredField: false,
                                              controller: _userNote,
                                              title: "User Note",
                                              maxline: 2,
                                              hintText:
                                                  "Instruction of for appointment",
                                            ),
                                          ),
                                          SizedBox(
                                              height: Dimensions.dimensionNo12),
                                          // Detail of appointment
                                          //! Appointment Details

                                          appointDetailsSummer(
                                              bookingProvider,
                                              serviceDurationInMinutes,
                                              context),
                                          SizedBox(
                                            height: Dimensions.dimensionNo8,
                                          ),

                                          //! Save Button
                                          saveAppointButton(
                                              context,
                                              serviceDurationInMinutes,
                                              bookingProvider),
                                          SizedBox(
                                              height: Dimensions.dimensionNo10),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if (_showTimeContain)
                            Positioned(
                              right: ResponsiveLayout.isMobile(context)
                                  ? Dimensions
                                      .dimensionNo20 // Adjust for mobile
                                  : Dimensions
                                      .dimensionNo360, // Default for larger screens
                              top: ResponsiveLayout.isMobile(context)
                                  ? Dimensions
                                      .dimensionNo150 // Adjust for mobile
                                  : Dimensions
                                      .dimensionNo150, // Default for larger screens
                              left: ResponsiveLayout.isMobile(context)
                                  ? Dimensions
                                      .dimensionNo20 // Adjust for mobile
                                  : null, // Default for larger screens
                              child: SingleChildScrollView(
                                child: Container(
                                  padding:
                                      EdgeInsets.all(Dimensions.dimensionNo12),

                                  width: ResponsiveLayout.isMobile(context)
                                      ? Dimensions
                                          .dimensionNo300 // Adjust width for mobile
                                      : Dimensions
                                          .dimensionNo500, // Default for larger screens
                                  constraints: BoxConstraints(
                                    maxHeight: ResponsiveLayout.isMobile(
                                            context)
                                        ? Dimensions
                                            .dimensionNo400 // Adjust height for mobile
                                        : Dimensions
                                            .dimensionNo500, // Default for larger screens
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.dimensionNo10),
                                    border: Border.all(
                                        color: Colors.grey, width: 1),
                                  ),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        TimeSlot(
                                          section: 'Morning',
                                          timeSlots: _categorizedTimeSlots[
                                                  'Morning'] ??
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
                                          section: 'Afternoon',
                                          timeSlots: _categorizedTimeSlots[
                                                  'Afternoon'] ??
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
                                          timeSlots: _categorizedTimeSlots[
                                                  'Evening'] ??
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
                                          section: 'Night',
                                          timeSlots:
                                              _categorizedTimeSlots['Night'] ??
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
                                  ? Dimensions
                                      .dimensionNo20 // Adjust for mobile
                                  : Dimensions
                                      .dimensionNo360, // Default for larger screens
                              top: ResponsiveLayout.isMobile(context)
                                  ? Dimensions
                                      .dimensionNo150 // Adjust for mobile
                                  : Dimensions
                                      .dimensionNo120, // Default for larger screens
                              left: ResponsiveLayout.isMobile(context)
                                  ? Dimensions
                                      .dimensionNo20 // Adjust for mobile
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
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

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
                        _timeSelectTextBox(),

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
                        serviceSearchBar(
                          serviceSearchControl,
                          context,
                          bookingProvider,
                          allServiceList,
                        ),
                        SizedBox(
                          width: Dimensions.dimensionNo30,
                        ),
                        //! mobile text box

                        textBoxOfForm("Mobile No", "Enter a Mobile NO",
                            _mobileController, addMobileValidator),

                        SizedBox(
                          width: Dimensions.dimensionNo30,
                        ),

                        //! select time textbox
                        _timeSelectTextBox(),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: Dimensions.dimensionNo60),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
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

  SizedBox _timeSelectTextBox() {
    final isDisabled = widget.isDirectBilling; // Shortcut for readability

    return SizedBox(
      width:
          ResponsiveLayout.isMobile(context) ? null : Dimensions.dimensionNo250,
      child: Opacity(
        opacity: isDisabled ? 0.5 : 1.0, // 🔹 Fade entire widget if disabled
        child: IgnorePointer(
          ignoring: isDisabled, // 🔹 Prevent all interaction
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
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
              SizedBox(height: Dimensions.dimensionNo5),
              Padding(
                padding:
                    EdgeInsets.symmetric(vertical: Dimensions.dimensionNo8),
                child: TextFormField(
                  readOnly:
                      true, // Always read-only because we handle tap manually
                  onTap: () {
                    setState(() {
                      _showTimeContain = !_showTimeContain;
                      print("Time : $_showTimeContain");
                    });
                  },
                  cursorHeight: Dimensions.dimensionNo16,
                  style: TextStyle(
                    fontSize: Dimensions.dimensionNo12,
                    fontFamily: GoogleFonts.roboto().fontFamily,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  controller: _appointmentTimeController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: Dimensions.dimensionNo10,
                      vertical: Dimensions.dimensionNo10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(Dimensions.dimensionNo16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
          // _selectedTimeSlot != null
          //     ?
          Column(
            children: [
              SizedBox(height: Dimensions.dimensionNo10),
              Row(
                children: [
                  Text(
                    'Appointment Start Time',
                    style: appointSummerTextStyle(),
                  ),
                  const Spacer(),
                  // _selectedTimeSlot != null &&
                  //         _selectedTimeSlot!.isNotEmpty
                  //     ?
                  Text(
                    '$_selectedTimeSlot',
                    style: appointSummerTextStyle(),
                  )
                  // : const SizedBox(),
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
                  // _selectedTimeSlot != null &&
                  //         _selectedTimeSlot!.isNotEmpty
                  // ?

                  Text(
                    DateFormat('hh:mm a').format(
                      DateFormat('hh:mm a').parse(_selectedTimeSlot!).add(
                            Duration(minutes: serviceDurationInMinutes),
                          ),
                    ),
                    style: appointSummerTextStyle(),
                  )
                  // : const SizedBox(),
                ],
              ),
            ],
          ),
          // : SizedBox(),
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
        text: "Save Appointment",
        ontap: () async {
          // Basic validation
         if (_selectedTimeSlot == null || _selectedTimeSlot!.isEmpty || _selectedTimeSlot == "No ")   {
            showBottomMessageError("Please select a time slot", context);
            return;
          }
          if (!_formKey.currentState!.validate()) return;

          // Start guarded async work
          showLoaderDialog(context);
          try {
            // Calculate end time — guarded parsing
            DateTime endTime;
            try {
              endTime = DateFormat('hh:mm a')
                  .parse(_selectedTimeSlot!)
                  .add(Duration(minutes: serviceDurationInMinutes));
            } catch (e) {
              endTime = DateTime.now()
                  .add(Duration(minutes: serviceDurationInMinutes));
              print("Time parse failed, fallback endTime: $e");
            }
            bookingProvider.updateAppointEndTime(endTime);

            // Timestamps / user
            TimeStampModel timeStampModel = TimeStampModel(
              id: "",
              dateAndTime: GlobalVariable.today,
              updateBy: "${widget.salonModel.name} (Create a Appointment)",
            );

            List<TimeStampModel> timeStampList = [timeStampModel];

            String fullName =
                "${_nameController.text.trim()} ${_lastNameController.text.trim()}"
                    .trim();

            UserModel userInfo = UserModel(
              id: _mobileController.text.trim(),
              name: fullName.isEmpty ? "Guest" : fullName,
              phone: _mobileController.text.trim(),
              image:
                  'https://static-00.iconduck.com/assets.00/profile-circle-icon-512x512-zxne30hp.png',
              email: "No email",
              password: " ",
              timeStampModel: timeStampModel,
            );

            // get appointmentNo
            appointmentNO =
                await SamayFB.instance.incrementSalonAppointmentNo();
            print("appointmentNo incremented -> $appointmentNO");

            // Products map -> ensure non-null Map<String,int>
            final Map<String, int> productListIdQty1 =
                (bookingProvider.getBudgetProductQuantityMap ?? {}).map(
                    (key, value) => MapEntry(key.id ?? key.toString(), value));

            // Service List IDs (guarantee non-null list)
            List<String> _serviceListId = [];
            final watchList = bookingProvider.getWatchList ?? [];
            if (watchList.isNotEmpty) {
              _serviceListId = watchList
                  .map((e) => e.id ?? "")
                  .where((s) => s.isNotEmpty)
                  .toList();
            }

            // Product Bill Model (use null-aware defaults)
            ProductBillModel productBillModel = ProductBillModel(
              productListIdQty: productListIdQty1,
              subTotalProduct: bookingProvider.getSubTotalProduct ?? 0.0,
              discountATMProduct: bookingProvider.getTotalProductDisco ?? 0.0,
              netPriceProduct: bookingProvider.getNetAmountProduct ?? 0.0,
              taxableAMTProduct: bookingProvider.getTaxableAmountProduct ?? 0.0,
              gSTAMTProduct: bookingProvider.getGstAmountProduct ?? 0.0,
              finalAMTProduct: bookingProvider.getFinalProductTotal ?? 0.0,
            );

            // Service Bill Model (only if there are services)
            ServiceBillModel? serviceBillModel;
            // if (_serviceListId.isNotEmpty) {
            // Use safe defaults instead of force unwrap
            final discountAmt = bookingProvider.getDiscountAmount ?? 0.0;
            final netPrice = bookingProvider.getNetPrice ?? 0.0;
            final taxableAmount = bookingProvider.getTaxAbleAmount ?? 0.0;
            final gstExcludingAmt = bookingProvider.getExcludingGSTAMT ?? 0.0;
            final gstIncludingAmt = bookingProvider.getIncludingGSTAMT ?? 0.0;
            final finalAmt = bookingProvider.getFinalPayableAMT ?? 0.0;

            // Determine gstAMT safely — check _settingModel exists
            double gstAMT = 0.0;
            if (_settingModel != null && (_settingModel!.gstNo.length == 15)) {
              final gstFlag = _settingModel!.gSTIsIncludingOrExcluding ??
                  GlobalVariable.noGST;
              gstAMT = (gstFlag == GlobalVariable.exclusiveGST)
                  ? gstExcludingAmt
                  : gstIncludingAmt;
            }

            serviceBillModel = ServiceBillModel(
              serviceListId: _serviceListId,
              subTotalService: bookingProvider.getSubTotal ?? 0.0,
              discountATMService: discountAmt,
              netPriceService: netPrice,
              taxableAMTService: taxableAmount,
              gSTAMTService: gstAMT,
              finalAMTService: finalAmt,
              gstIsIncludingOrExcluding:
                  _settingModel?.gSTIsIncludingOrExcluding ??
                      GlobalVariable.noGST,
            );
            // }

            // AppointmentInfo — guard nullable bookingProvider fields
            final duration =
                bookingProvider.getAppointDuration ?? Duration.zero;
            final selectedDate =
                bookingProvider.getAppointSelectedDate ?? GlobalVariable.today;
            final startTime =
                bookingProvider.getAppointStartTime ?? _selectedTimeSlot ?? "";
            final endTimeFinal = bookingProvider.getAppointEndTime ?? endTime;

            AppointmentInfo appointmentInfo = AppointmentInfo(
              serviceAt: serviceAt,
              serviceDuration: duration.inMinutes,
              serviceDate: selectedDate,
              serviceStartTime: startTime as DateTime,
              serviceEndTime: endTimeFinal,
              userNote: _userNote.text.isEmpty ? "" : _userNote.text.trim(),
              appointmentNo: appointmentNO,
              status: widget.isDirectBilling
                  ? GlobalVariable.billGenerateAppointState
                  : GlobalVariable.pendingAppointState,
            );

            // Final AppointModel
            AppointModel appointModel = AppointModel(
              orderId: "",
              userId: userInfo.id,
              vendorId: widget.salonModel.id,
              adminId: widget.salonModel.adminId,
              userModel: userInfo,
              timeStampList: timeStampList,
              gstNo: _settingModel?.gstNo ?? "",
              transactionId: '',
              billingId: '',
              subTotalBill: bookingProvider.getSubTotalBill ?? 0.0,
              discountBill: bookingProvider.getDiscountBill ?? 0.0,
              netPriceBill: bookingProvider.getNetPriceBill ?? 0.0,
              platformFeeBill: GlobalVariable.platformFee,
              taxableAmountBill: bookingProvider.getTaxableAmountBill ?? 0.0,
              gstAmountBill: bookingProvider.getGstAmountBill ?? 0.0,
              finalTotalBill: bookingProvider.getFinalTotalBill ?? 0.0,
              payment: GlobalVariable.pAPPayment,
              appointmentInfo: appointmentInfo,
              serviceBillModel: serviceBillModel,
              productBillModel: productBillModel,
              isManual: true,
            );

            // Save appointment
            AppointModel? updateAppointModel =
                await UserBookingFB.instance.saveAppointmentManual(
              context: context,
              appointModel: appointModel,
            );

            // Save date mapping
            UserBookingFB.instance.saveDateFB(
              bookingProvider.getAppointSelectedDate ?? GlobalVariable.today,
              GlobalVariable.today,
              widget.salonModel.adminId,
              widget.salonModel.id,
            );

            Navigator.of(context, rootNavigator: true).pop(); // pop loader

            showMessage("Successful add the appointment");
            if (widget.isDirectBilling) {
              AppProvider appProvider =
                  Provider.of<AppProvider>(context, listen: false);
              if (bookingProvider.getWatchList != null &&
                  bookingProvider.getWatchList.isNotEmpty) {
                appProvider.updateServiceTOserviceListFetchID(
                    serviceList: bookingProvider.getWatchList);
              }
              if (bookingProvider.budgetProductQuantityMap != null &&
                  bookingProvider.budgetProductQuantityMap.isNotEmpty) {
                appProvider.updateProductToProductListWithQty(
                    productMap: bookingProvider.budgetProductQuantityMap);
              }
            }

            // Post-save dialog / navigation (existing logic)
            if (updateAppointModel != null) {
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
                            onPressed: () {
                              widget.isDirectBilling
                                  ? Routes.instance.push(
                                      widget: UserSideBarPaymentScreen(
                                        appointModel: updateAppointModel,
                                      ),
                                      context: context)
                                  : Routes.instance.push(
                                      widget: HomeScreen(
                                        date: Provider.of<CalenderProvider>(
                                                context,
                                                listen: false)
                                            .getSelectDate,
                                      ),
                                      context: context);
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
              // Navigator.of(context, rootNavigator: true).pop();

              // show success dialog (existing code)...
              // (Keep your current dialog code here; omitted for brevity)
            }
          } catch (err, stack) {
            print("Save appointment failed: $err\n$stack");
            Navigator.of(context, rootNavigator: true)
                .pop(); // ensure loader removed
            showBottomMessageError(
                "Failed to save appointment: ${err.toString()}", context);
          }
        },
      ),
    );
  }
}
