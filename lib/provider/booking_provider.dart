// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:samay_admin_plan/constants/global_variable.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_firestore_helper/samay_fb.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_firestore_helper/setting_fb.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_firestore_helper/user_order_fb.dart';
import 'package:samay_admin_plan/models/Product/Product_Model/product_model.dart';
import 'package:samay_admin_plan/models/salon_setting_model/salon_setting_model.dart';
import 'package:samay_admin_plan/models/samay_salon_settng_model/samay_salon_setting.dart';
import 'package:samay_admin_plan/models/service_model/service_model.dart';
import 'package:samay_admin_plan/models/appoint_model/appoint_model.dart';
import 'package:samay_admin_plan/models/user_model/user_model.dart';

class BookingProvider with ChangeNotifier {
  // Instance of Firebase helper for user bookings.
  final UserBookingFB _userBookingFB = UserBookingFB.instance;

  // Appointment Date & Time fields.
  DateTime _appointSelectedDate = DateTime.now();
  DateTime get getAppointSelectedDate => _appointSelectedDate;

  DateTime _appointStartTime = DateTime.now();
  DateTime get getAppointStartTime => _appointStartTime;

  DateTime _appointEndTime = DateTime.now();
  DateTime get getAppointEndTime => _appointEndTime;

  Duration? _appointDuration;
  Duration? get getAppointDuration => _appointDuration;

  DateTime _appointStartTimeCal = DateTime.now();
  DateTime get getAppointStartTimeCal => _appointStartTimeCal;

  DateTime _appointEndTimeCal = DateTime.now();
  DateTime get getAppointEndTimeCal => _appointEndTimeCal;

  Duration? _appointDurationCal;
  Duration? get getAppointDurationCal => _appointDurationCal;

  // User note.
  String? _userNote;
  String? get getUserNote => _userNote;

  // Booking details.

  List<AppointModel> _bookinglist = [];
  List<ServiceModel> _watchList = [];
  List<ServiceModel> get getWatchList => _watchList;
  List<AppointModel> get getBookingList => _bookinglist;

  String _serviceBookingDuration = "0h 0m";
  String get getServiceBookingDuration => _serviceBookingDuration;

  double _subTotal = 0.0;
  double get getSubTotal => _subTotal;

  // GST calculation.
  double _calGstAmount = 0.0;
  double get getCalGSTAmount => _calGstAmount;

  bool _isGSTApply = false;
  bool get getIsGSTApply => _isGSTApply;

  double? _calFinalAmountWithGST = 0.0;
  double? get getCalFinalAmountWithGST => _calFinalAmountWithGST;

  // Discount values.
  double? _discountInPer = 0.0;
  double? get getDiscountInPer => _discountInPer;

  double? _discountAmount = 0.0;
  double? get getDiscountAmount => _discountAmount;

  double? _extraDiscountAmount = 0.0;
  double? get getExtraDiscountAmount => _extraDiscountAmount;

  double? _extraDiscountInPerAmount = 0.0;
  double? get getExtraDiscountInPerAmount => _extraDiscountInPerAmount;

  double? _netPrice = 0.0;
  double? get getNetPrice => _netPrice;

  double? _taxAbleAmount = 0.0;
  double? get getTaxAbleAmount => _taxAbleAmount;

  double? _excludingGSTAMT = 0.0;
  double? get getExcludingGSTAMT => _excludingGSTAMT;

  double? _includingGSTAMT = 0.0;
  double? get getIncludingGSTAMT => _includingGSTAMT;

  double? _finalPayableAMT = 0.0;
  double? get getFinalPayableAMT => _finalPayableAMT;

  // Salon settings.
  SamaySalonSettingModel? _samaySalonSettingModel;
  SamaySalonSettingModel get getSamaySalonSettingModel =>
      _samaySalonSettingModel!;

  double? _salonGstPer = 0.0;
  double? get getSalonGSTPer => _salonGstPer;

  SettingModel? _settingModel;
  SettingModel get getSettingModel => _settingModel!;

  AppointModel? _appointModel;
  AppointModel get getAppointModel => _appointModel!;

  // Cal for Inclustive GST

  // ----------------- Update Methods -----------------

  /// Updates the user note.
  void updateUserNote(String note) {
    _userNote = note;
    notifyListeners();
  }

  /// Updates the selected date (normalized to year/month/day only).
  void updateSelectedDate(DateTime newDate) {
    _appointSelectedDate = DateTime(newDate.year, newDate.month, newDate.day);
    notifyListeners();
  }

  /// Updates the appointment start time using the current selected date.
  void updatAppointStartTime(DateTime startTime) {
    DateTime formattedStartTime = DateTime(
      _appointSelectedDate.year,
      _appointSelectedDate.month,
      _appointSelectedDate.day,
      startTime.hour,
      startTime.minute,
    );
    _appointStartTime = formattedStartTime;
    notifyListeners();
  }

  /// Updates the appointment end time using the current selected date.
  void updateAppointEndTime(DateTime endTime) {
    DateTime formattedEndTime = DateTime(
      _appointSelectedDate.year,
      _appointSelectedDate.month,
      _appointSelectedDate.day,
      endTime.hour,
      endTime.minute,
    );
    _appointEndTime = formattedEndTime;
    print("End time Pro $_appointEndTime");
    notifyListeners();
  }

  /// Updates the appointment duration.
  void updateAppointDuration(Duration duration) {
    _appointDuration = duration;
    notifyListeners();
  }

  // ----------------- Watch List Methods -----------------

  /// Adds a service to the watch list.
  void addServiceToWatchList(ServiceModel serviceModel) {
    _watchList.add(serviceModel);
    notifyListeners();
  }

  /// Adds a service to the watch list.
  void addServiceListToWatchList(List<ServiceModel> serviceModelList) {
    _watchList.addAll(serviceModelList);
    notifyListeners();
  }

  /// Removes a service from the watch list.
  void removeServiceToWatchList(ServiceModel serviceModel) {
    _watchList.remove(serviceModel);
    notifyListeners();
  }

  // ----------------- Data Fetch Methods -----------------

  /// Fetches booking list for a specific date.
  Future<void> getBookingListPro(DateTime date, String salonId) async {
    try {
      // Normalize the date.
      DateTime normalizedDate = DateTime(date.year, date.month, date.day);
      print("Normalized Date for Firestore Query: $normalizedDate");

      _bookinglist =
          await _userBookingFB.getUserBookingListFB(normalizedDate, salonId);
      print("Fetched bookings for date: $normalizedDate");
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching booking list: $e");
    }
  }

  /// Updates an appointment in the booking list.
  Future<bool> updateAppointment(
    String userId,
    appointmentId,
    AppointModel appointModel,
  ) async {
    try {
      await _userBookingFB.updateAppointmentFB(
        userId,
        appointmentId,
        appointModel,
      );
      return true;
    } catch (e) {
      debugPrint("Error updating appointment: $e");
      return false;
    }
  }

  // ----------------- Calculation Methods -----------------

  /// Calculates total booking duration from services in the watch list.
  void calculateTotalBookingDuration() {
    try {
      int totalMinutes =
          _watchList.fold(0, (sum, item) => sum + item.serviceDurationMin);
      Duration totalDuration = Duration(minutes: totalMinutes);
      _appointDuration = totalDuration;
      _serviceBookingDuration =
          "${totalDuration.inHours}h ${totalDuration.inMinutes % 60}min";

      notifyListeners();
    } catch (e) {
      debugPrint("Error calculating total booking duration: $e");
    }
  }

  /// Calculates the subtotal, discount, GST, and final total.
  void calculateSubTotal() {
    try {
      if (_settingModel!.gSTIsIncludingOrExcluding ==
          GlobalVariable.GstExclusive) {
        //! Calculate GST for "Exclusive"
        print("Calculate GST for Exclusive pro---------");
        // Calculate subtotal: sum of prices of all services.
        _subTotal =
            _watchList.fold(0.0, (sum, item) => sum + item.originalPrice!);
        print("Subtotal Exclusive: $_subTotal");

        // Calculate total discount amount safely.
        _discountAmount = _watchList.fold(0.0, (sum, item) {
          return sum! + (item.discountAmount ?? 0.0);
        });
        print("Discount Amount Exclusive : $_discountAmount");

        // Calculate discount percentage based on subtotal.
        _discountInPer =
            calculateDiscountPercentage(_subTotal, _discountAmount!);
        // print("Discount Percentage: $_discountInPer");

        calNetPirce();
        // calTotalExtraDicPer();

        // Calculate final total without GST.
        double platformFee =
            double.tryParse(getSamaySalonSettingModel.platformFee) ?? 0.0;

        _taxAbleAmount = _netPrice! + platformFee;
        print("Taxable Amount: $_taxAbleAmount");

        // Calculate GST if applicable.
        _excludingGSTAMT = GlobalVariable.salonGST0_18 * _taxAbleAmount!;
        print(
            "Excluding GST Amount (${GlobalVariable.salonGST0_18 * _taxAbleAmount!}):  $_excludingGSTAMT");

        _finalPayableAMT = _taxAbleAmount! + _excludingGSTAMT!;
        print("Final Payable Amount: $_finalPayableAMT");
      } else if (_settingModel!.gSTIsIncludingOrExcluding ==
          GlobalVariable.GstInclusive) {
        print("Calculate GST for incl pro----------");
        // _isGSTApply = true;

        _subTotal =
            _watchList.fold(0.0, (sum, item) => sum + item.originalPrice!);
        print("Subtotal Inclusive: $_subTotal");

        _discountAmount = _watchList.fold(0.0, (sum, item) {
          return sum! + (item.discountAmount ?? 0.0);
        });
        print("Discount Amount Inclusive : $_discountAmount");

        // Calculate discount percentage based on subtotal.
        _discountInPer =
            calculateDiscountPercentage(_subTotal, _discountAmount!);
        print("Discount Percentage Inclusive: $_discountInPer");

        // Calculate final total without GST.
        double platformFee =
            double.tryParse(getSamaySalonSettingModel.platformFee) ?? 0.0;
        calNetPirce();

        print("incl NetPRice $_netPrice");

        // Calculate GST if applicable.
        _taxAbleAmount =
            (_netPrice! + platformFee) / GlobalVariable.salonGST1_18;

        _includingGSTAMT = (_netPrice! + platformFee) - _taxAbleAmount!;
        _finalPayableAMT = _taxAbleAmount! + _includingGSTAMT!;

        print("Final Total (with GST) Inclusive: $_finalPayableAMT");

        // calTotalExtraDicPer();
      } else {
        print("Calculate without GST pro----------");
        // _isGSTApply = true;

        _subTotal =
            _watchList.fold(0.0, (sum, item) => sum + item.originalPrice!);
        print("Subtotal withoutGST: $_subTotal");

        _discountAmount = _watchList.fold(0.0, (sum, item) {
          return sum! + (item.discountAmount ?? 0.0);
        });
        print("Discount Amount  withoutGST : $_discountAmount");

        // Calculate discount percentage based on subtotal.
        _discountInPer =
            calculateDiscountPercentage(_subTotal, _discountAmount!);
        print("Discount Percentage withoutGST: $_discountInPer");

        double platformFee =
            double.tryParse(getSamaySalonSettingModel.platformFee) ?? 0.0;
        calNetPirce();
        print("incl NetPRice withoutGST $_netPrice");

        _taxAbleAmount = _netPrice! + platformFee;

        _finalPayableAMT = _taxAbleAmount!;
      }

      notifyListeners();
    } catch (e) {
      debugPrint("Error in calculateSubTotal: $e");
    }
  }

  /// Calculates discount percentage given subtotal and discount amount.
  double calculateDiscountPercentage(
      double subtotalValue, double discountAmountValue) {
    if (subtotalValue == 0) return 0.0;
    return (discountAmountValue / subtotalValue) * 100;
  }

  void calNetPirce() {
    if (_settingModel!.gSTIsIncludingOrExcluding ==
        GlobalVariable.GstExclusive) {
      _netPrice = _subTotal -
          _discountAmount! -
          _extraDiscountAmount! -
          _extraDiscountInPerAmount!;
    } else if (_settingModel!.gSTIsIncludingOrExcluding ==
        GlobalVariable.GstInclusive) {
      _netPrice = _subTotal -
          _discountAmount! -
          _extraDiscountAmount! -
          _extraDiscountInPerAmount!;
    } else {
      _netPrice = (_subTotal -
          _discountAmount! -
          _extraDiscountAmount! -
          _extraDiscountInPerAmount!);
    }
    notifyListeners();
  }

  // //!------------ calculate Time Of Appointment Start and End time --------------

  // ----------------- Utility Methods -----------------

  /// Converts a TimeOfDay to a formatted string.
  String formatTimeOfDay(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final dateTime = DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    return DateFormat('HH:mm').format(dateTime);
  }

  /// Parses a formatted time string back to TimeOfDay safely.
  TimeOfDay parseTimeOfDay(String timeString) {
    final parts = timeString.split(":");
    if (parts.length != 2) {
      throw FormatException("Invalid time format");
    }
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
      throw FormatException("Invalid time values");
    }
    return TimeOfDay(hour: hour, minute: minute);
  }

  // ----------------- Setting Fetch Methods -----------------

  /// Fetches salon settings from Firestore.
  Future<void> setSamaySalonSetting() async {
    try {
      _samaySalonSettingModel = await SamayFB.instance.fetchSalonSettingData();
      _salonGstPer = _samaySalonSettingModel!.gstPer;
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching salon setting: $e");
    }
  }

  /// Fetches vendor settings from Firestore.
  Future<void> fetchSettingPro(
    String salonId,
  ) async {
    try {
      _settingModel = await SettingFb.instance.fetchSettingFromFB(salonId);
      _isGSTApply = _settingModel!.gstNo.length == 15;
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching salon settings: $e");
    }
  }

  // Select Appointment and user
  UserModel? selectAppointUser;
  UserModel get getSelectAppointUser => selectAppointUser!;

  void selectAppointUserPro(UserModel userModel) {
    selectAppointUser = userModel;
    print("select Appoint User ${selectAppointUser!.name}");
    notifyListeners();
  }

  // select Appoint
  void selectAppoint(AppointModel appointValue) {
    _appointModel = appointValue;
    print("select Appoint ${_appointModel!.appointmentNo.toString()}");
    notifyListeners();
  }

  void setExtraDiscountInPerAmount(double discount) {
    _extraDiscountInPerAmount = discount;
    print(
        " --------------------Extra Discount per: Amount $_extraDiscountInPerAmount");
    notifyListeners();
  }

  // Set Extra discount amount
  void setExtraDiscountAmount(double discount) {
    _extraDiscountAmount = discount;
    print(" -------------Extra Discount Amount: $_extraDiscountAmount");
    notifyListeners();
  }

//!-------------- PRODUCT FUNCTION ----------------------------------

  List<ProductModel> selectBuyProductList = [];
  List<ProductModel> get getSelectBuyProductList => selectBuyProductList;

  // add Product to List
  void addProductToListPro(ProductModel value) {
    selectBuyProductList.add(value);
    print(
        " add selectBuyProductList = ${selectBuyProductList.length} , ${value.name}");
    notifyListeners();
  }

  // remove Product to List
  void removeProductToListPro(ProductModel value) {
    selectBuyProductList.removeWhere((product) => product.id == value.id);
    print(
        "remove selectBuyProductList = ${selectBuyProductList.length} , ${value.name}");
    notifyListeners();
  }

//!-------------- RESET PRODUCT  ----------------------------------

  void setAllZero() {
    _discountInPer = 0.0;
    _subTotal = 0.0;
    _taxAbleAmount = 0.0;
    _netPrice = 0.0;
    _calGstAmount = 0.0;
    _discountInPer = 0.0;
    _discountAmount = 0.0;
    _extraDiscountAmount = 0.0;
    _extraDiscountInPerAmount = 0.0;
    _salonGstPer = 0.0;
    _watchList.clear();
    _bookinglist.clear();

    _serviceBookingDuration = "0h 0m";
    notifyListeners();
  }

  void setAppointEditAllData(
    AppointModel appointModel,
  ) {
    _netPrice = appointModel.netPrice;
    _calFinalAmountWithGST = appointModel.totalPrice;

    notifyListeners();
  }
}
