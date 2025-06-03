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
import 'package:samay_admin_plan/features/Calender/screen/calender.dart';
import 'package:samay_admin_plan/features/add_new_appointment/widget/single_service_appoint.dart';
import 'package:samay_admin_plan/features/add_new_appointment/widget/single_service_tap_icon.dart';
import 'package:samay_admin_plan/features/add_new_appointment/widget/time_tap.dart';
import 'package:samay_admin_plan/features/custom_appbar/screen/custom_appbar.dart';
import 'package:samay_admin_plan/features/drawer/drawer.dart';
import 'package:samay_admin_plan/features/home/screen/main_home/home_screen.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_firestore_helper/samay_fb.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_firestore_helper/user_order_fb.dart';
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
import 'package:samay_admin_plan/provider/service_provider.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimenison.dart';
import 'package:samay_admin_plan/widget/customauthbutton.dart';
import 'package:samay_admin_plan/widget/customtextfield.dart';

class EditAppointment extends StatefulWidget {
  final int index;
  final AppointModel appintModel;
  final UserModel userModel;
  final SalonModel salonModel;
  const EditAppointment({
    super.key,
    required this.index,
    required this.appintModel,
    required this.userModel,
    required this.salonModel,
  });

  @override
  State<EditAppointment> createState() => _EditAppointmentState();
}

class _EditAppointmentState extends State<EditAppointment> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  DateTime _time = DateTime.now();
  DateFormat _dateFormat = DateFormat("dd MMM yyyy");
  DateFormat _timeFormat12hr = DateFormat("hh:mm a"); // Format for 12-hour time
  DateFormat _timeFormat24hr = DateFormat("HH:mm"); // Format for 24-hour time

  TextEditingController _nameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _appointmentDateController = TextEditingController();
  TextEditingController _appointmentTimeController =
      TextEditingController(text: "Select Time");
  TextEditingController _serviceController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _userNote = TextEditingController();

  List<ServiceModel> serchServiceList = [];
  List<ServiceModel> allServiceList = [];
  List<ServiceModel> selectService = [];
  final List<TimeStampModel> _timeStampList = [];

  bool _showCalender = false;
  bool _showServiceList = false;
  bool _showTimeContaine = false;
  bool _isLoading = false;

  double extraDiscountInPer = 0.0;
  double extraDiscountInAmount = 0.0;
  SamaySalonSettingModel? _samaySalonSettingModel;
  SettingModel? _settingModel;
  int _timeDiffInTap = 30;

//Serching  Services base on service name and code
  void serchService(String value) {
    // Filtering based on both service name and service code
    serchServiceList = allServiceList
        .where((element) =>
            element.servicesName.toLowerCase().contains(value.toLowerCase()) ||
            element.serviceCode.toLowerCase().contains(value.toLowerCase()))
        .toList();

    setState(() {});
  }

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

  void updateDate() {
    Provider.of<BookingProvider>(context, listen: false)
        .updateSelectedDate(_time);
    print("Initial Date :- ${_time}");
  }

  getData() async {
    setState(() {
      _isLoading = true;
    });

    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    try {
      // bookingProvider.getWatchList.addAll(widget.appintModel.services);
      await appProvider.getSalonInfoFirebase();
      List<ServiceModel> fetchedServices = await UserBookingFB.instance
          .getAllServicesFromCategories(appProvider.getSalonInformation.id);
      _nameController.text = widget.userModel.name;
      // _appointmentDateController.text = widget.appintModel.serviceDate;
      _appointmentDateController.text =
          DateFormat('dd MMM yyyy').format(widget.appintModel.serviceDate);
      _mobileController.text = widget.userModel.phone.toString();

      if (widget.appintModel.userNote.length >= 3) {
        _userNote.text = widget.appintModel.userNote;
      }

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

  void getSalonSetting() async {
    try {
      ServiceProvider serviceProvider =
          Provider.of<ServiceProvider>(context, listen: false);
      serviceProvider.fetchSettingPro(widget.salonModel.id);
      _settingModel = serviceProvider.getSettingModel;
      String salonTimetapDiff = _settingModel!.diffbtwTimetap ?? "30";
      _samaySalonSettingModel = await SamayFB.instance.fetchSalonSettingData();
      _timeDiffInTap = int.parse(salonTimetapDiff) ?? 30;

      if (widget.appintModel.gstNo.isEmpty == _settingModel!.gstNo.isNotEmpty) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return warnigAlertDialogBox(
                "Appointment do not have GST No but ${GlobalVariable.salon} save have GST No. if appointment is update then GST is apply",
                context);
          },
        );
      } else if (_settingModel!.gSTIsIncludingOrExcluding !=
          widget.appintModel.gstIsIncludingOrExcluding) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return warnigAlertDialogBox(
                "When an appointment is booked, the price ${widget.appintModel.gstIsIncludingOrExcluding} GST, while the ${GlobalVariable.salon} saves the price ${_settingModel!.gSTIsIncludingOrExcluding} GST.If the appointment is updated, then it applies the price ${_settingModel!.gSTIsIncludingOrExcluding} GST.",
                context);
          },
        );
      } else if (widget.appintModel.gstNo != _settingModel!.gstNo) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return warnigAlertDialogBox(
                "Appointment GST No. is not same to ${GlobalVariable.salon} have GST No.",
                context);
          },
        );
      } else if (widget.appintModel.gstNo.isNotEmpty ==
          _settingModel!.gstNo.isEmpty) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return warnigAlertDialogBox(
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
  void addBookingServiceToWatchList() {
    BookingProvider bookingProvider =
        Provider.of<BookingProvider>(context, listen: false);
    bookingProvider.getWatchList.clear();
    bookingProvider.setAllZero();
    bookingProvider.getWatchList.addAll(widget.appintModel.services);
    bookingProvider.calculateTotalBookingDuration();
    bookingProvider.calculateSubTotal();
    // timeDateList.addAll(widget.appintModel.timeDateList);
    _timeStampList.addAll(widget.appintModel.timeStampList);
    print("Length of watch list ${bookingProvider.getWatchList.length}");
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
      drawer: MobileDrawer(),
      key: _scaffoldKey,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
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
                    SizedBox(
                      height: Dimensions.screenHeight * 2,
                      child: Stack(
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.all(Dimensions.dimenisonNo16),
                                  child: Text(
                                    "Update Appointment",
                                    style: TextStyle(
                                      fontSize: Dimensions.dimenisonNo20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                // Container to User TextBox
                                _formOfAppoint(),
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
                                            horizontal:
                                                Dimensions.dimenisonNo12,
                                            vertical: Dimensions.dimenisonNo12)
                                        : EdgeInsets.symmetric(
                                            horizontal:
                                                Dimensions.dimenisonNo18,
                                            vertical: Dimensions.dimenisonNo12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Select Serivce",
                                              style: TextStyle(
                                                fontSize: ResponsiveLayout
                                                        .isMobile(context)
                                                    ? Dimensions.dimenisonNo14
                                                    : Dimensions.dimenisonNo18,
                                                fontWeight:
                                                    ResponsiveLayout.isMobile(
                                                            context)
                                                        ? FontWeight.bold
                                                        : FontWeight.w600,
                                              ),
                                            ),
                                            const Spacer(),
                                            Text(
                                              "Service Duration ${bookingProvider.getServiceBookingDuration}",
                                              style: TextStyle(
                                                fontSize: ResponsiveLayout
                                                        .isMobile(context)
                                                    ? Dimensions.dimenisonNo14
                                                    : Dimensions.dimenisonNo18,
                                                fontWeight:
                                                    ResponsiveLayout.isMobile(
                                                            context)
                                                        ? FontWeight.bold
                                                        : FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: Dimensions.dimenisonNo10,
                                        ),
                                        Padding(
                                          padding:
                                              ResponsiveLayout.isMobile(context)
                                                  ? EdgeInsets.zero
                                                  : EdgeInsets.symmetric(
                                                      horizontal: Dimensions
                                                          .dimenisonNo12),
                                          child: Wrap(
                                            spacing: Dimensions
                                                .dimenisonNo12, // Horizontal space between items
                                            runSpacing: Dimensions
                                                .dimenisonNo12, // Vertical space between rows
                                            alignment: WrapAlignment.center,
                                            runAlignment: WrapAlignment.start,
                                            children: List.generate(
                                              bookingProvider
                                                  .getWatchList.length,
                                              (index) {
                                                ServiceModel servicelist =
                                                    bookingProvider
                                                        .getWatchList[index];
                                                return SizedBox(
                                                  width:
                                                      ResponsiveLayout.isMobile(
                                                              context)
                                                          ? Dimensions
                                                              .dimenisonNo210
                                                          : Dimensions
                                                              .dimenisonNo300,
                                                  child:
                                                      SingleServiceTapDeleteIcon(
                                                    serviceModel: servicelist,
                                                    onTap: () {
                                                      try {
                                                        showLoaderDialog(
                                                            context);
                                                        setState(() {
                                                          bookingProvider
                                                              .removeServiceToWatchList(
                                                                  servicelist);

                                                          bookingProvider
                                                              .calculateTotalBookingDuration();
                                                          bookingProvider
                                                              .calculateSubTotal();
                                                        });

                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .pop();
                                                        showMessage(
                                                            'Service is removed from Watch List');
                                                      } catch (e) {
                                                        showMessage(
                                                            'Error occurred while removing service from Watch List: ${e.toString()}');
                                                      }
                                                    },
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                            height: Dimensions.dimenisonNo12),
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
                                            height: Dimensions.dimenisonNo12),
                                        // Detail of appointment
                                        //! Appointment Details
                                        if (_appointmentDateController != null)
                                          AppointDetailsSummer(
                                              bookingProvider,
                                              serviceDurationInMinutes,
                                              context),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (_showTimeContaine)
                            Positioned(
                              right: ResponsiveLayout.isMobile(context)
                                  ? Dimensions
                                      .dimenisonNo20 // Adjust for mobile
                                  : Dimensions
                                      .dimenisonNo360, // Default for larger screens
                              top: ResponsiveLayout.isMobile(context)
                                  ? Dimensions
                                      .dimenisonNo150 // Adjust for mobile
                                  : Dimensions
                                      .dimenisonNo150, // Default for larger screens
                              left: ResponsiveLayout.isMobile(context)
                                  ? Dimensions
                                      .dimenisonNo20 // Adjust for mobile
                                  : null, // Default for larger screens
                              child: SingleChildScrollView(
                                child: Container(
                                  padding:
                                      EdgeInsets.all(Dimensions.dimenisonNo12),

                                  width: ResponsiveLayout.isMobile(context)
                                      ? Dimensions
                                          .dimenisonNo300 // Adjust width for mobile
                                      : Dimensions
                                          .dimenisonNo500, // Default for larger screens
                                  constraints: BoxConstraints(
                                    maxHeight: ResponsiveLayout.isMobile(
                                            context)
                                        ? Dimensions
                                            .dimenisonNo400 // Adjust height for mobile
                                        : Dimensions
                                            .dimenisonNo500, // Default for larger screens
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.dimenisonNo10),
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
                                          height: Dimensions.dimenisonNo12,
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
                                      .dimenisonNo20 // Adjust for mobile
                                  : Dimensions
                                      .dimenisonNo360, // Default for larger screens
                              top: ResponsiveLayout.isMobile(context)
                                  ? Dimensions
                                      .dimenisonNo150 // Adjust for mobile
                                  : Dimensions
                                      .dimenisonNo120, // Default for larger screens
                              left: ResponsiveLayout.isMobile(context)
                                  ? Dimensions
                                      .dimenisonNo20 // Adjust for mobile
                                  : null, // Default for larger screens
                              child: SizedBox(
                                height: ResponsiveLayout.isMobile(context)
                                    ? Dimensions
                                        .dimenisonNo400 // Adjust height for mobile
                                    : ResponsiveLayout.isTablet(context)
                                        ? 400 // Adjust width for mobile
                                        : Dimensions
                                            .dimenisonNo450, // Default for larger screens
                                width: ResponsiveLayout.isMobile(context)
                                    ? Dimensions
                                        .dimenisonNo300 // Adjust width for mobile
                                    : ResponsiveLayout.isTablet(context)
                                        ? 600 // Adjust width for mobile
                                        : Dimensions
                                            .dimenisonNo360, // Default for larger screens
                                child: CustomCalendar(
                                  salonModel: widget.salonModel,
                                  controller: _appointmentDateController,
                                  initialDate: _time,
                                  onDateChanged: (selectedDate) {},
                                ),
                              ),
                            ),
                          if (_showServiceList)
                            Positioned(
                              right: ResponsiveLayout.isMobile(context)
                                  ? Dimensions
                                      .dimenisonNo20 // Adjust for mobile
                                  : null,

                              //     .dimenisonNo360, // Default for larger screens
                              top: ResponsiveLayout.isMobile(context)
                                  ? Dimensions
                                      .dimenisonNo200 // Adjust for mobile
                                  : Dimensions
                                      .dimenisonNo210, // Default for larger screens
                              left: ResponsiveLayout.isMobile(context)
                                  ? Dimensions
                                      .dimenisonNo20 // Adjust for mobile
                                  : Dimensions
                                      .dimenisonNo90, // Default for larger screens
                              child: Container(
                                width: Dimensions.dimenisonNo500,
                                constraints: const BoxConstraints(
                                  maxHeight:
                                      320, // Set a max height to make it scrollable
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFFFFF),
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.dimenisonNo10),
                                ),
                                child: _serviceController.text.isNotEmpty &&
                                        serchServiceList.isEmpty
                                    ? Padding(
                                        padding: EdgeInsets.only(
                                          top: Dimensions.dimenisonNo12,
                                          left: Dimensions.dimenisonNo16,
                                          bottom: Dimensions.dimenisonNo12,
                                        ),
                                        child: Text(
                                          "No service found",
                                          style: TextStyle(
                                              fontSize:
                                                  Dimensions.dimenisonNo14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      )
                                    : serchServiceList.contains(
                                                // ignore: iterable_contains_unrelated_type
                                                _serviceController.text) ||
                                            _serviceController.text.isEmpty
                                        ? Padding(
                                            padding: EdgeInsets.only(
                                              top: Dimensions.dimenisonNo12,
                                              left: Dimensions.dimenisonNo16,
                                              bottom: Dimensions.dimenisonNo12,
                                            ),
                                            child: Text(
                                              "Enter a Service name or Code",
                                              style: TextStyle(
                                                  fontSize:
                                                      Dimensions.dimenisonNo14,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          )
                                        : ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: serchServiceList.length,
                                            itemBuilder: (context, index) {
                                              ServiceModel serviceModel =
                                                  serchServiceList[index];
                                              return
                                                  // !isSearched()

                                                  SingleServiceTapAppoint(
                                                      serviceModel:
                                                          serviceModel);
                                            },
                                          ),
                              ),
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

  Container _formOfAppoint() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Dimensions.dimenisonNo16),
      padding: EdgeInsets.all(Dimensions.dimenisonNo16),
      decoration: BoxDecoration(
        border: Border.all(width: 1.5),
        borderRadius: BorderRadius.circular(Dimensions.dimenisonNo8),
      ),
      child: Center(
        child: ResponsiveLayout.isMobile(context)
            ? Column(
                children: [
                  // User Name textbox
                  Wrap(
                    spacing: Dimensions.dimenisonNo8,
                    runSpacing: Dimensions.dimenisonNo5,
                    alignment: WrapAlignment.start, // Align items to the left
                    children: [
                      textBoxOfForm("First Name", _nameController),

                      //! User last Name textbox

                      textBoxOfForm("Last Name", _lastNameController),

                      //! select Date text box
                      _selectAppointDateTextBox(),
                      textBoxOfForm("Mobile No", _mobileController),

                      //! select time textbox
                      _timeSelectTextBox(),

                      //! Search box for Services  text box
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _serviceServiceTextBox(),
                          SizedBox(
                            height: Dimensions.dimenisonNo8,
                          ),
                          Container(
                            width: Dimensions.dimenisonNo500,
                            constraints: const BoxConstraints(
                              maxHeight:
                                  320, // Set a max height to make it scrollable
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFFFFF),
                              borderRadius: BorderRadius.circular(
                                  Dimensions.dimenisonNo10),
                            ),
                            child: _serviceController.text.isNotEmpty &&
                                    serchServiceList.isEmpty
                                ? Padding(
                                    padding: EdgeInsets.only(
                                      top: Dimensions.dimenisonNo12,
                                      left: Dimensions.dimenisonNo16,
                                      bottom: Dimensions.dimenisonNo12,
                                    ),
                                    child: Text(
                                      "No service found",
                                      style: TextStyle(
                                          fontSize: Dimensions.dimenisonNo14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  )
                                : serchServiceList.contains(
                                            // ignore: iterable_contains_unrelated_type
                                            _serviceController.text) ||
                                        _serviceController.text.isEmpty
                                    ? SizedBox()
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: serchServiceList.length,
                                        itemBuilder: (context, index) {
                                          ServiceModel serviceModel =
                                              serchServiceList[index];
                                          return
                                              // !isSearched()

                                              SingleServiceTapAppoint(
                                                  serviceModel: serviceModel);
                                        },
                                      ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              )
            : Column(
                children: [
                  // User Name textbox
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      textBoxOfForm("First Name", _nameController),
                      SizedBox(
                        width: Dimensions.dimenisonNo30,
                      ),
                      //! User last Name textbox

                      textBoxOfForm("Last Name", _lastNameController),
                      SizedBox(
                        width: Dimensions.dimenisonNo30,
                      ),
                      //! select Date text box
                      _selectAppointDateTextBox(),
                    ],
                  ),
                  //! Search box for Services  text box

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _serviceServiceTextBox(),
                      SizedBox(
                        width: Dimensions.dimenisonNo30,
                      ),
                      //! mobile text box
                      textBoxOfForm("Mobile No", _mobileController),

                      SizedBox(
                        width: Dimensions.dimenisonNo30,
                      ),

                      //! select time textbox
                      _timeSelectTextBox(),
                    ],
                  ),

                  // SizedBox(height: Dimensions.dimenisonNo16),
                ],
              ),
      ),
    );
  }

  SizedBox _timeSelectTextBox() {
    return SizedBox(
      height: Dimensions.dimenisonNo70,
      width: Dimensions.dimenisonNo250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Time",
            style: TextStyle(
              color: Colors.black,
              fontSize: Dimensions.dimenisonNo18,
              fontFamily: GoogleFonts.roboto().fontFamily,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.90,
            ),
          ),
          SizedBox(
            height: Dimensions.dimenisonNo5,
          ),
          SizedBox(
            height: Dimensions.dimenisonNo30,
            width: Dimensions.dimenisonNo250,
            child: TextFormField(
              onTap: () {
                setState(() {
                  _showTimeContaine = !_showTimeContaine;
                  print("Time : $_showTimeContaine");
                });
              },
              cursorHeight: Dimensions.dimenisonNo16,
              style: TextStyle(
                  fontSize: Dimensions.dimenisonNo12,
                  fontFamily: GoogleFonts.roboto().fontFamily,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              controller: _appointmentTimeController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                    horizontal: Dimensions.dimenisonNo10,
                    vertical: Dimensions.dimenisonNo10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.dimenisonNo16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  SizedBox _serviceServiceTextBox() {
    return SizedBox(
      height: Dimensions.dimenisonNo70,
      width: Dimensions.dimenisonNo250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Service",
            style: TextStyle(
              color: Colors.black,
              fontSize: Dimensions.dimenisonNo18,
              fontFamily: GoogleFonts.roboto().fontFamily,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.90,
            ),
          ),
          SizedBox(
            height: Dimensions.dimenisonNo5,
          ),
          SizedBox(
            height: Dimensions.dimenisonNo30,
            width: Dimensions.dimenisonNo250,
            child: TextFormField(
              onChanged: (String value) {
                serchService(value);
                if (ResponsiveLayout.isDesktop(context) ||
                    ResponsiveLayout.isTablet(context)) {
                  _showServiceList = true;
                }
              },
              onTap: () {
                if (ResponsiveLayout.isDesktop(context) ||
                    ResponsiveLayout.isTablet(context)) {
                  setState(() {
                    _showServiceList = !_showServiceList;
                  });
                }
              },
              cursorHeight: Dimensions.dimenisonNo16,
              style: TextStyle(
                  fontSize: Dimensions.dimenisonNo12,
                  fontFamily: GoogleFonts.roboto().fontFamily,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              controller: _serviceController,
              decoration: InputDecoration(
                hintText: "Search Service...",
                contentPadding: EdgeInsets.symmetric(
                    horizontal: Dimensions.dimenisonNo10,
                    vertical: Dimensions.dimenisonNo10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.dimenisonNo16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  SizedBox _selectAppointDateTextBox() {
    return SizedBox(
      height: Dimensions.dimenisonNo70,
      width: Dimensions.dimenisonNo250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Appointment Date",
            style: TextStyle(
              color: Colors.black,
              fontSize: Dimensions.dimenisonNo18,
              fontFamily: GoogleFonts.roboto().fontFamily,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.90,
            ),
          ),
          SizedBox(
            height: Dimensions.dimenisonNo5,
          ),
          SizedBox(
            height: Dimensions.dimenisonNo30,
            width: Dimensions.dimenisonNo250,
            child: TextFormField(
              onTap: () {
                setState(() {
                  _showCalender = !_showCalender;
                });
                print(_showCalender);
              },
              readOnly: true,
              cursorHeight: Dimensions.dimenisonNo16,
              style: TextStyle(
                  fontSize: Dimensions.dimenisonNo12,
                  fontFamily: GoogleFonts.roboto().fontFamily,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              controller: _appointmentDateController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                    horizontal: Dimensions.dimenisonNo10,
                    vertical: Dimensions.dimenisonNo10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Dimensions.dimenisonNo16),
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
    TextEditingController controller,
  ) {
    return SizedBox(
      height: Dimensions.dimenisonNo70,
      width: Dimensions.dimenisonNo250,
      child: FormCustomTextField(
        requiredField: false,
        controller: controller,
        title: title,
      ),
    );
  }

  Container AppointDetailsSummer(
    BookingProvider bookingProvider,
    int serviceDurationInMinutes,
    BuildContext context,
  ) {
    return Container(
      margin: ResponsiveLayout.isMobile(context)
          ? EdgeInsets.zero
          : EdgeInsets.symmetric(horizontal: Dimensions.dimenisonNo250),
      padding: EdgeInsets.symmetric(
          horizontal: ResponsiveLayout.isMobile(context)
              ? Dimensions.dimenisonNo5
              : Dimensions.dimenisonNo20),
      decoration: BoxDecoration(
        color: AppColor.grey,
        borderRadius: BorderRadius.circular(Dimensions.dimenisonNo10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: Dimensions.dimenisonNo16),
          if (_selectedTimeSlot != null)
            Text(
              'Appointment Duration',
              style: TextStyle(
                fontSize: Dimensions.dimenisonNo16,
                fontWeight: FontWeight.bold,
              ),
            ),
          const Divider(
            color: Colors.white,
          ),
          if (_selectedTimeSlot != null) ...[
            SizedBox(height: Dimensions.dimenisonNo10),
            Row(
              children: [
                Text(
                  'Appointment Date',
                  style: _appointSummTextSyle(),
                ),
                Spacer(),
                Text(
                  _appointmentDateController.text,
                  style: _appointSummTextSyle(),
                ),
              ],
            ),
            SizedBox(height: Dimensions.dimenisonNo10),
            Row(
              children: [
                Text(
                  'Appointment Duration',
                  style: _appointSummTextSyle(),
                ),
                const Spacer(),
                Text(
                  bookingProvider.getServiceBookingDuration,
                  style: _appointSummTextSyle(),
                ),
              ],
            ),
            SizedBox(height: Dimensions.dimenisonNo10),
            Row(
              children: [
                Text(
                  'Appointment Start Time',
                  style: _appointSummTextSyle(),
                ),
                const Spacer(),
                Text(
                  '$_selectedTimeSlot',
                  style: _appointSummTextSyle(),
                ),
              ],
            ),
            SizedBox(height: Dimensions.dimenisonNo10),
            Row(
              children: [
                Text(
                  'Appointment End Time',
                  style: _appointSummTextSyle(),
                ),
                const Spacer(),
                Text(
                  DateFormat('hh:mm a').format(
                    DateFormat('hh:mm a').parse(_selectedTimeSlot!).add(
                          Duration(minutes: serviceDurationInMinutes),
                        ),
                  ),
                  style: _appointSummTextSyle(),
                ),
              ],
            ),
            SizedBox(height: Dimensions.dimenisonNo10),
            const Divider(
              color: Colors.white,
            ),
            Center(
              child: Text(
                'Price Details',
                style: TextStyle(
                  fontSize: Dimensions.dimenisonNo16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(
              color: Colors.white,
            ),
            SizedBox(height: Dimensions.dimenisonNo10),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SubTotal
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _settingModel!.gSTIsIncludingOrExcluding ==
                                GlobalVariable.GstInclusive
                            ? 'Subtotal (incl. GST ${_samaySalonSettingModel!.gstPer.toString()} %) '
                            : 'SubTotal',
                        style: appointSummaryTextStyle(context),
                      ),
                    ),
                    Icon(Icons.currency_rupee, size: Dimensions.dimenisonNo16),
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
                                GlobalVariable.GstInclusive
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
                                GlobalVariable.GstInclusive
                            ? 'Platform fee (incl. GST)'
                            : 'Platform fee',
                        style: appointSummaryTextStyle(context),
                      ),
                    ),
                    Icon(Icons.currency_rupee, size: Dimensions.dimenisonNo16),
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
                    Icon(Icons.currency_rupee, size: Dimensions.dimenisonNo16),
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
                          size: Dimensions.dimenisonNo16),
                      Text(
                        _settingModel!.gSTIsIncludingOrExcluding ==
                                GlobalVariable.GstExclusive
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
                        size: Dimensions.dimenisonNo18,
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

            // //! Save Button
            // CustomAuthButton(
            //     text: "Check value",
            //     ontap: () {
            // //! Convert time and Date to save fb
            // String _inputDate = _appointmentDateController.text.trim();
            // // Parse the input date string into a DateTime object
            // DateTime appointmentDate = _dateFormat.parse(_inputDate);
            // // Ensure the time is set to midnight (00:00:00)
            // DateTime _selectAppointDate = DateTime(
            //   appointmentDate.year,
            //   appointmentDate.month,
            //   appointmentDate.day,
            // );
            //! Convert Date to save fb
            // Get the trimmed input time
            // String _inputStartime =
            //     _appointmentTimeController.text.trim();
            // // Parse the input time string into a DateTime object
            // DateTime _parsedStartime =
            //     _timeFormat12hr.parse(_inputStartime);
            // // Combine today's date with the parsed time
            // DateTime _appointStartTime = DateTime(
            //   appointmentDate.year,
            //   appointmentDate.month,
            //   appointmentDate.day,
            //   _parsedStartime.hour,
            //   _parsedStartime.minute,
            // );
            // print("Appointment Date $_selectAppointDate");
            // print("Appointment Time $_appointStartTime");
            // }),

            saveButton(context, serviceDurationInMinutes, bookingProvider),
            SizedBox(height: Dimensions.dimenisonNo12),
          ],
        ],
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
      fontSize = Dimensions.dimenisonNo13;
    } else if (ResponsiveLayout.isTablet(context)) {
      fontSize = Dimensions.dimenisonNo15;
    } else {
      fontSize = Dimensions.dimenisonNo17;
    }
    return TextStyle(
      fontSize: fontSize,
      fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
      color: color ?? Colors.black87,
      letterSpacing: 0.5,
      fontFamily: GoogleFonts.roboto().fontFamily,
    );
  }

  TextStyle _appointSummTextSyle() {
    return TextStyle(
      fontSize: Dimensions.dimenisonNo14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.90,
    );
  }

  CustomAuthButton saveButton(BuildContext context,
      int serviceDurationInMinutes, BookingProvider bookingProvider) {
    return CustomAuthButton(
      text: "Update Appointment",
      ontap: () async {
        showLoaderDialog(context);

        // Calculating service end time.
        _serviceEndTime = DateFormat('hh:mm a').format(
          DateFormat('hh:mm a')
              .parse(_selectedTimeSlot!)
              .add(Duration(minutes: serviceDurationInMinutes)),
        );

        // Create the time and date model
        TimeStampModel _timeStampModel = TimeStampModel(
          id: widget.appintModel.orderId,
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
        //! Convert Date to save fb
        // Get the trimmed input time
        String _inputStartime = _appointmentTimeController.text.trim();
        String _inputEndtime = _serviceEndTime!;
        // Parse the input time string into a DateTime object
        DateTime _parsedStartime = _timeFormat12hr.parse(_inputStartime);
        DateTime _parsedEndtime = _timeFormat12hr.parse(_inputEndtime);
        // Combine today's date with the parsed time
        DateTime _appointStartTime = DateTime(
          appointmentDate.year,
          appointmentDate.month,
          appointmentDate.day,
          _parsedStartime.hour,
          _parsedStartime.minute,
        );
        DateTime _appointEndTime = DateTime(
          appointmentDate.year,
          appointmentDate.month,
          appointmentDate.day,
          _parsedEndtime.hour,
          _parsedEndtime.minute,
        );

        // Declare the appointModel variable before using it
        AppointModel appointModel = widget.appintModel.copyWith(
          services: bookingProvider.getWatchList,
          subtatal: bookingProvider.getSubTotal,
          totalPrice: bookingProvider.getFinalPayableAMT!,
          netPrice: bookingProvider.getNetPrice!,
          gstAmount: _settingModel!.gstNo.length == 15
              ? _settingModel!.gSTIsIncludingOrExcluding ==
                      GlobalVariable.GstExclusive
                  ? bookingProvider.getExcludingGSTAMT!
                  : bookingProvider.getIncludingGSTAMT!
              : 0.0,
          payment: "PAP (Pay At Place)",
          discountInPer: bookingProvider.getDiscountInPer!,
          discountAmount: bookingProvider.getDiscountAmount,
          extraDiscountInAmount: 0.0,
          extraDiscountInPer: 0.0,
          serviceDuration: bookingProvider.getAppointDuration!.inMinutes,
          serviceDate: _selectAppointDate,
          serviceStartTime: bookingProvider.getAppointStartTime,
          serviceEndTime: bookingProvider.getAppointEndTime,
          userNote: _userNote.text.trim(),
          timeStampList: _timeStampList,
          isUpdate: true,
        );

        // Now use appointModel in the updateAppointment function
        Future<bool> isUpdate = bookingProvider.updateAppointment(
          widget.userModel.id,
          widget.appintModel.orderId,
          appointModel,
        );

        await UserBookingFB.instance.updateDateFB(
          widget.appintModel.serviceDate,
          widget.appintModel.serviceDate,
          widget.appintModel.adminId,
          widget.appintModel.vendorId,
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
                      height: Dimensions.dimenisonNo250,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: Dimensions.dimenisonNo12),
                          Icon(
                            FontAwesomeIcons.solidHourglassHalf,
                            size: Dimensions.dimenisonNo40,
                            color: AppColor.buttonColor,
                          ),
                          SizedBox(height: Dimensions.dimenisonNo20),
                          Text(
                            'Appointment update Successfully',
                            style: TextStyle(
                              fontSize: Dimensions.dimenisonNo16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: Dimensions.dimenisonNo16),
                          Text(
                            'Appointment update has been processed!\nDetails of the appointment are included below',
                            style: TextStyle(
                              fontSize: Dimensions.dimenisonNo12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: Dimensions.dimenisonNo20),
                          Text(
                            'Appointment No : ${widget.appintModel.appointmentNo}',
                            style: TextStyle(
                              fontSize: Dimensions.dimenisonNo14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Routes.instance.push(
                            widget: HomeScreen(
                                date: Provider.of<CalenderProvider>(context,
                                        listen: false)
                                    .getSelectDate),
                            context: context,
                          );
                        },
                        child: Text(
                          'OK',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: Dimensions.dimenisonNo18,
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
      },
    );
  }

  AlertDialog warnigAlertDialogBox(String messages, BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: Dimensions.dimenisonNo360,
        height: Dimensions.dimenisonNo200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: Dimensions.dimenisonNo12),
            Text(
              'Warning',
              style: TextStyle(
                fontSize: Dimensions.dimenisonNo16,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: Dimensions.dimenisonNo16),
            Wrap(
              children: [
                Text(
                  messages,
                  style: TextStyle(
                    fontSize: Dimensions.dimenisonNo14,
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
              fontSize: Dimensions.dimenisonNo18,
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
              fontSize: Dimensions.dimenisonNo18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
