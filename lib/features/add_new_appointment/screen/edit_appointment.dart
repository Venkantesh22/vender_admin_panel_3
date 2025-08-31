// // ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers, prefer_final_fields
// ignore_for_file: prefer_final_fields, no_leading_underscores_for_local_identifiers, unused_local_variable, use_build_context_synchronously

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
import 'package:samay_admin_plan/features/add_new_appointment/widget/single_service_tap_icon.dart';
import 'package:samay_admin_plan/features/add_new_appointment/widget/time_tap.dart';
import 'package:samay_admin_plan/features/custom_appbar/screen/custom_appbar.dart';
import 'package:samay_admin_plan/features/drawer/drawer.dart';
import 'package:samay_admin_plan/features/home/screen/main_home/home_screen.dart';
import 'package:samay_admin_plan/features/payment/user_payment_screen.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_firestore_helper/samay_fb.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_firestore_helper/user_order_fb.dart';
import 'package:samay_admin_plan/models/Product/Product_Model/product_model.dart';
import 'package:samay_admin_plan/models/salon_form_models/salon_infor_model.dart';
import 'package:samay_admin_plan/models/salon_setting_model/salon_setting_model.dart';
import 'package:samay_admin_plan/models/samay_salon_settng_model/samay_salon_setting.dart';
import 'package:samay_admin_plan/models/service_model/service_model.dart';
import 'package:samay_admin_plan/models/timestamp_model/timestamp_model.dart';
import 'package:samay_admin_plan/models/user_model/user_model.dart';
import 'package:samay_admin_plan/models/appoint_model/appoint_model.dart';
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

class EditAppointment extends StatefulWidget {
  final int index;
  final AppointModel appointModel;
  final UserModel userModel;
  final SalonModel salonModel;
  const EditAppointment({
    super.key,
    required this.index,
    required this.appointModel,
    required this.userModel,
    required this.salonModel,
  });

  @override
  State<EditAppointment> createState() => _EditAppointmentState();
}

class _EditAppointmentState extends State<EditAppointment> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DateTime _time = DateTime.now();
  DateFormat _dateFormat = DateFormat("dd MMM yyyy");
  DateFormat _timeFormat12hr = DateFormat("hh:mm a"); // Format for 12-hour time
  DateFormat _timeFormat24hr = DateFormat("HH:mm"); // Format for 24-hour time

  TextEditingController _nameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _appointmentDateController = TextEditingController();
  TextEditingController _appointmentTimeController =
      TextEditingController(text: "Select Time");
  // TextEditingController serviceSearchControl = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _userNote = TextEditingController();
  SearchController productSearchControl1 = SearchController();
  SearchController serviceSearchControl = SearchController();

  List<ServiceModel> allServiceList = [];
  final List<TimeStampModel> _timeStampList = [];
  List<ProductModel> allProductList = [];

  bool _showCalender = false;
  bool _showServiceList = false;
  bool _showTimeContaine = false;
  bool _isLoading = true;

  double extraDiscountInPer = 0.0;
  double extraDiscountInAmount = 0.0;
  SamaySalonSettingModel? _samaySalonSettingModel;
  SettingModel? _settingModel;
  int _timeDiffInTap = 30;

  // For Select Service at Salon or home-- Default value is Salon
  String serviceAt = GlobalVariable.serviceAtSalon;
  List<String> serviceAtList = [
    GlobalVariable.serviceAtHome,
    GlobalVariable.serviceAtSalon
  ];

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    getData();
    _initializeTimes();

    getSalonSetting();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      addBookingServiceToWatchList();
      updateDate();
    });
  }

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
    ProductProvider productProvider =
        Provider.of<ProductProvider>(context, listen: false);

    try {
      // bookingProvider.getWatchList.addAll(widget.appointModel.services);
      await appProvider.getSalonInfoFirebase();

      List<ServiceModel> fetchedServices = await UserBookingFB.instance
          .getAllServicesFromCategories(appProvider.getSalonInformation.id);
      _nameController.text = widget.userModel.name;
      // _appointmentDateController.text = widget.appointModel.appointmentInfo!.serviceDate;
      _appointmentDateController.text = DateFormat('dd MMM yyyy')
          .format(widget.appointModel.appointmentInfo!.serviceDate);
      _mobileController.text = widget.userModel.phone.toString();

      if (widget.appointModel.appointmentInfo!.userNote.length >= 3) {
        _userNote.text = widget.appointModel.appointmentInfo!.userNote;
      }
      _samaySalonSettingModel = await SamayFB.instance.fetchSalonSettingData();
      // Get all Product and assign to allProductList list
      await productProvider.getListProductPro();
      allProductList = productProvider.getProductList;
      print("Print all Product ${allProductList.length}");

      setState(() {
        allServiceList = fetchedServices;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching data: $e");
    }

    setState(() {});
  }

  void getSalonSetting() async {
    try {
      ServiceProvider serviceProvider =
          Provider.of<ServiceProvider>(context, listen: false);
      await serviceProvider.fetchSettingPro(widget.salonModel.id);
      _settingModel = serviceProvider.getSettingModel;
      String salonTimeTapDiff = _settingModel!.diffbtwTimetap ?? "30";
      _timeDiffInTap = int.parse(salonTimeTapDiff) ?? 30;

      if (widget.appointModel.gstNo.isEmpty ==
          _settingModel!.gstNo.isNotEmpty) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return waringAlertDialogBox(
                "Appointment do not have GST No but ${GlobalVariable.salon} save have GST No. if appointment is update then GST is apply",
                context);
          },
        );
      } else if (_settingModel!.gSTIsIncludingOrExcluding !=
          widget.appointModel.serviceBillModel!.gstIsIncludingOrExcluding) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return waringAlertDialogBox(
                "When an appointment is booked, the price ${widget.appointModel.serviceBillModel!.gstIsIncludingOrExcluding} GST, while the ${GlobalVariable.salon} saves the price ${_settingModel!.gSTIsIncludingOrExcluding} GST.If the appointment is updated, then it applies the price ${_settingModel!.gSTIsIncludingOrExcluding} GST.",
                context);
          },
        );
      } else if (widget.appointModel.gstNo != _settingModel!.gstNo) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return waringAlertDialogBox(
                "Appointment GST No. is not same to ${GlobalVariable.salon} have GST No.",
                context);
          },
        );
      } else if (widget.appointModel.gstNo.isNotEmpty ==
          _settingModel!.gstNo.isEmpty) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return waringAlertDialogBox(
                "Appointment do have GST No but ${GlobalVariable.salon} do not save GST No. if appointment is update then GST is not apply",
                context);
          },
        );
      }
    } catch (e) {
      print(
          "Error  time different between tap == null,set first salon setting time different between tap : $e");
    }
  }

  //function to add Booking Service to Watch List
  Future<void> addBookingServiceToWatchList() async {
    BookingProvider bookingProvider =
        Provider.of<BookingProvider>(context, listen: false);
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    bookingProvider.getWatchList.clear();
    bookingProvider.setAllZero();

    bookingProvider
        .addServiceListTOServiceList(appProvider.getServiceListFetchID);
    bookingProvider.addProductMapPro(appProvider.getProductListWithQty);

    bookingProvider.calculateTotalBookingDuration();
    bookingProvider.calculateSubTotal();
    bookingProvider.callCalSubTotalAndDicFun();
    _timeStampList.addAll(widget.appointModel.timeStampList);
    print("Length of watch list ${bookingProvider.getWatchList.length}");

    // Add this to force UI update
    setState(() {});
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
      String salonOpenTime = timeOfDayToString(widget.salonModel.openTime!);
      String salonCloseTime = timeOfDayToString(widget.salonModel.closeTime!);

      // Since the times are in 24-hour format, use 'HH:mm' instead of 'hh:mm a'
      _startTime = DateFormat('HH:mm').parse(salonOpenTime);
      _endTime = DateFormat('HH:mm').parse(salonCloseTime);

      print("Parsed startTime: $_startTime, endTime: $_endTime");
    } catch (e) {
      print('Error parsing time: $e');
    }
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
        currentTime = currentTime
            .add(Duration(minutes: _timeDiffInTap)); // Adjust as needed
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
    final serviceBookingDuration = bookingProvider.getServiceBookingDuration;
    final serviceDurationInMinutes = parseDuration(serviceBookingDuration);
    _generateTimeSlots(serviceDurationInMinutes);

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
                padding: EdgeInsets.zero,
                child: GestureDetector(
                  onTap: () {
                    if (_showCalender ||
                        _showServiceList ||
                        _showTimeContaine == true) {
                      setState(() {
                        _showCalender = false;
                        _showServiceList = false;
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
                                padding:
                                    EdgeInsets.all(Dimensions.dimensionNo16),
                                child: Text(
                                  "Update Appointment",
                                  style: TextStyle(
                                    fontSize: Dimensions.dimensionNo20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              // Container to User TextBox
                              _formOfAppoint(bookingProvider),
                              //! Genarate List of Service which in Watch list
                              GestureDetector(
                                onTap: () {
                                  if (_showCalender ||
                                      _showServiceList ||
                                      _showTimeContaine == true) {
                                    setState(() {
                                      _showCalender = false;
                                      _showServiceList = false;
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      selectServiceList(
                                        context,
                                        bookingProvider,
                                      ),
                                      SizedBox(
                                          height: Dimensions.dimensionNo12),

                                      //? Select Product List

                                      bookingProvider.budgetProductQuantityMap
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
                                      appointDetailsSummer(bookingProvider,
                                          serviceDurationInMinutes, context),
                                      SizedBox(
                                        height: Dimensions.dimensionNo8,
                                      ),
                                      saveButton(
                                          context,
                                          serviceDurationInMinutes,
                                          bookingProvider),
                                      SizedBox(
                                          height: Dimensions.dimensionNo12),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (_showTimeContaine)
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

  Container _formOfAppoint(BookingProvider bookingProvider) {
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
              // Textbox for screen screen size

              ? Column(
                  children: [
                    //! User Name textbox
                    Wrap(
                      spacing: Dimensions.dimensionNo8,
                      runSpacing: Dimensions.dimensionNo5,
                      alignment: WrapAlignment.start, // Align items to the left
                      children: [
                        textBoxOfForm("First Name", "Enter First name",
                            _nameController, addFirstNameValidator),

                        //! User last Name textbox

                        textBoxOfForm("Last Name", "Enter Last name",
                            _lastNameController, noValidator,
                            readOnly: true),
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
                            serviceAt, serviceAtList, context, (value) {
                          setState(() {
                            serviceAt = value;
                          });
                        }),
                      ],
                    ),
                  ],
                )
              //! Textbox for table and decktap screen size
              : Column(
                  children: [
                    // User Name textbox
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        textBoxOfForm("First Name", "Enter First name",
                            _nameController, addFirstNameValidator),

                        SizedBox(
                          width: Dimensions.dimensionNo30,
                        ),
                        //! User last Name textbox

                        textBoxOfForm("Last Name", "Enter Last name",
                            _lastNameController, noValidator,
                            readOnly: true),
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
                      ],
                    ),
                    //! Search box for Services  text box

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // _serviceServiceTextBox(),
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
                            _mobileController, addMobileValidator,
                            readOnly: true),
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

                          dropDownListSelectServiceAt(
                              serviceAt, serviceAtList, context, (value) {
                            setState(() {
                              serviceAt = value;
                            });
                          }),
                          SizedBox(
                            width: Dimensions.dimensionNo60,
                          ),
                        ],
                      ),
                    ),

                    // SizedBox(height: Dimensions.dimensionNo16),
                  ],
                ),
        ),
      ),
    );
  }

  SizedBox _timeSelectTextBox() {
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

  SizedBox textBoxOfForm(
    String title,
    String hindText,
    TextEditingController controller,
    String? Function(String?)? validator, {
    final bool readOnly = false,
  }) {
    return SizedBox(
      width:
          ResponsiveLayout.isMobile(context) ? null : Dimensions.dimensionNo250,
      child: validateTextBoxWithHeading(
          hintText: hindText,
          labelText: title,
          controller: controller,
          validator: validator,
          readOnly: readOnly),
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
          SizedBox(height: Dimensions.dimensionNo10),
          Row(
            children: [
              Text(
                'Appointment Start Time',
                style: appointSummerTextStyle(),
              ),
              const Spacer(),
              _selectedTimeSlot != null && _selectedTimeSlot!.isNotEmpty
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
              _selectedTimeSlot != null && _selectedTimeSlot!.isNotEmpty
                  ? Text(
                      DateFormat('hh:mm a').format(
                        DateFormat('hh:mm a').parse(_selectedTimeSlot!).add(
                              Duration(minutes: serviceDurationInMinutes),
                            ),
                      ),
                      style: appointSummerTextStyle(),
                    )
                  : const SizedBox(),
            ],
          ),

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
              SizedBox(
                height: Dimensions.dimensionNo12,
              )
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

  TextStyle appointSummerTextStyle() {
    return TextStyle(
      fontSize: Dimensions.dimensionNo14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.90,
    );
  }

  Widget saveButton(BuildContext context, int serviceDurationInMinutes,
      BookingProvider bookingProvider) {
    return Container(
      margin: ResponsiveLayout.isMobile(context)
          ? EdgeInsets.zero
          : EdgeInsets.symmetric(horizontal: Dimensions.dimensionNo250),
      padding: EdgeInsets.symmetric(
          horizontal: ResponsiveLayout.isMobile(context)
              ? Dimensions.dimensionNo5
              : Dimensions.dimensionNo20),
      child: CustomAuthButton(
        text: "Update Appointment",
        ontap: () async {
          if (_selectedTimeSlot == null || _selectedTimeSlot!.isEmpty) {
            showBottomMessageError("Please select a time slot", context);
            return;
          }

          if (_formKey.currentState!.validate()) {
            showLoaderDialog(context);
            // update appoint ent-time to BookingProvider
            DateTime _endTime = DateFormat('hh:mm a')
                .parse(_selectedTimeSlot!)
                .add(Duration(minutes: serviceDurationInMinutes));

            bookingProvider.updateAppointEndTime(_endTime);

            // Create the time and date model
            TimeStampModel _timeStampModel = TimeStampModel(
              id: widget.appointModel.orderId,
              dateAndTime: GlobalVariable.today,
              updateBy: "${widget.salonModel.name} (Appointment update)",
            );

            _timeStampList.add(_timeStampModel);

            //! Convert Date to save fb
            String _inputDate = _appointmentDateController.text.trim();
            // Parse the input date string into a DateTime object

            DateTime appointmentDate = _dateFormat.parse(_inputDate);
            // Ensure the time is set to midnight (00:00:00)
            DateTime _selectAppointDate = DateTime(
              appointmentDate.year,
              appointmentDate.month,
              appointmentDate.day,
            );
            List<String>? _serviceListId = [];
            _serviceListId =
                bookingProvider.getWatchList.map((e) => e.id).toList();

            final Map<String, int> productListIdQty1;
            productListIdQty1 = bookingProvider.getBudgetProductQuantityMap.map(
              (key, value) => MapEntry(key.id, value),
            );

            //** Product Bill Model
            ProductBillModel productBillModelUpdate =
                widget.appointModel.productBillModel!.copyWith(
              productListIdQty: productListIdQty1,
              subTotalProduct: bookingProvider.getSubTotalProduct,
              discountATMProduct: bookingProvider.getTotalProductDisco,
              netPriceProduct: bookingProvider.getNetAmountProduct,
              taxableAMTProduct: bookingProvider.getTaxableAmountProduct,
              gSTAMTProduct: bookingProvider.getGstAmountProduct,
              finalAMTProduct: bookingProvider.getFinalProductTotal,
            );

            ServiceBillModel serviceBillModelUpdate =
                widget.appointModel.serviceBillModel!.copyWith(
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

            //** AppointmentInfo Model */
            AppointmentInfo appointmentInfoUpdate =
                widget.appointModel.appointmentInfo!.copyWith(
              serviceAt: serviceAt,
              serviceDuration: bookingProvider.getAppointDuration!.inMinutes,
              serviceDate: bookingProvider.getAppointSelectedDate,
              serviceStartTime: bookingProvider.getAppointStartTime,
              serviceEndTime: bookingProvider.getAppointEndTime,
              userNote: _userNote.text.isEmpty ? " " : _userNote.text.trim(),
            );

            AppointModel updateAppointModel = widget.appointModel.copyWith(
              subTotalBill: bookingProvider.getSubTotalBill,
              discountBill: bookingProvider.getDiscountBill,
              netPriceBill: bookingProvider.getNetPriceBill,
              platformFeeBill: GlobalVariable.platformFee,
              taxableAmountBill: bookingProvider.getTaxableAmountBill,
              gstAmountBill: bookingProvider.getGstAmountBill,
              finalTotalBill: bookingProvider.getFinalTotalBill,
              appointmentInfo: appointmentInfoUpdate,
              serviceBillModel: serviceBillModelUpdate,
              productBillModel: productBillModelUpdate,
              timeStampList: _timeStampList,
              isUpdate: true,
            );

            // Now use appointModel in the updateAppointment function
            Future<bool> isUpdate = bookingProvider.updateAppointment(
              widget.userModel.id,
              widget.appointModel.orderId,
              updateAppointModel,
            );

            await UserBookingFB.instance.updateDateFB(
              widget.appointModel.appointmentInfo!.serviceDate,
              widget.appointModel.appointmentInfo!.serviceDate,
              widget.appointModel.adminId,
              widget.appointModel.vendorId,
            );

            Navigator.of(context, rootNavigator: true).pop();
            showMessage("Successfully updated the appointment");

            if (await isUpdate) {
              showLoaderDialog(context);
              Future.delayed(
                const Duration(microseconds: 50),
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
                              SizedBox(height: Dimensions.dimensionNo12),
                              Icon(
                                FontAwesomeIcons.solidHourglassHalf,
                                size: Dimensions.dimensionNo40,
                                color: AppColor.buttonColor,
                              ),
                              SizedBox(height: Dimensions.dimensionNo20),
                              Text(
                                'Appointment update Successfully',
                                style: TextStyle(
                                  fontSize: Dimensions.dimensionNo16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: Dimensions.dimensionNo16),
                              Text(
                                'Appointment update has been processed!\nDetails of the appointment are included below',
                                style: TextStyle(
                                  fontSize: Dimensions.dimensionNo12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: Dimensions.dimensionNo20),
                              Text(
                                'Appointment No : ${widget.appointModel.appointmentInfo!.appointmentNo}',
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
                              updateAppointModel.appointmentInfo!.status ==
                                      GlobalVariable.billGenerateAppointState
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
                                              .getSelectDate),
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

  AlertDialog waringAlertDialogBox(String messages, BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: Dimensions.dimensionNo360,
        height: Dimensions.dimensionNo200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: Dimensions.dimensionNo12),
            Text(
              'Warning',
              style: TextStyle(
                fontSize: Dimensions.dimensionNo16,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: Dimensions.dimensionNo16),
            Wrap(
              children: [
                Text(
                  messages,
                  style: TextStyle(
                    fontSize: Dimensions.dimensionNo14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Routes.instance.push(
                widget: HomeScreen(
                  date: Provider.of<CalenderProvider>(context, listen: false)
                      .getSelectDate,
                ),
                context: context);
          },
          child: Text(
            'GO Back',
            style: TextStyle(
              color: Colors.black,
              fontSize: Dimensions.dimensionNo18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
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
  }
}
