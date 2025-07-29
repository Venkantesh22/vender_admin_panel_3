import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GlobalVariable {
  static TimeOfDay OpenTime = TimeOfDay(hour: 6, minute: 0);
  static TimeOfDay CloseTime = TimeOfDay(hour: 21, minute: 0);
  static TimeOfDay openTimeGlo = TimeOfDay(hour: 6, minute: 0);
  static TimeOfDay closerTimeGlo = TimeOfDay(hour: 6, minute: 0);
  static String salonID = '';

  static const String salon = "Salon";
  static DateTime today = DateTime.now();

// variable for increment appointment no.
  static String samayCollectionId = '';
  // static String salonCollectionId = 'j5bzQoxDswYJdSLQI3Lw';
  static int appointmentNO = 0;
  static String salonSettingCollectionId = '';

//default valus
  static String customerNo = "7972391849";
  static String customerGmail = "helpquickjet@gmail.com";
  static String diffbtwTimetap = "30";
  static int dayForBooking = 10;
  static double salonGST0_18 = 0.18;
  static double salonGST18Per = 18;
  static double salonGST1_18 = 1.18;

  // Function to get current date and time in a formatted string
  static String getCurrentDate() {
    DateTime now = DateTime.now();
    return DateFormat('dd MMM yyyy').format(now);
  }

  static String getCurrentTime() {
    DateTime now = DateTime.now();
    return DateFormat('hh:mm a').format(now); // HH:mm a (e.g. 03:45 PM)
  }

// TimeOfDay 24 hr convert to TimeOfDay 12hr
  static TimeOfDay convertTo12HourFormat(TimeOfDay time) {
    int hour =
        time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
    return TimeOfDay(hour: hour, minute: time.minute);
  }

// TimeOfDay 24 hr convert to String 12:30 AM
  static String timeOfDayToDateTimeAM(TimeOfDay timeOfDay) {
    DateTime dateTime = DateTime(2024, 1, 1, timeOfDay.hour, timeOfDay.minute);
    return DateFormat('hh:mm a').format(dateTime);
  }

  // Formate DateTime (dd MMM yyy) to  DateTime
  static DateTime DateTimeFomate(DateTime _date) {
    String _formatted = DateFormat("dd MMM yyyy").format(_date);
    DateTime _FormateDate = DateFormat("dd MMM yyyy").parse(_formatted);
    return _FormateDate;
  }

  static String DateTimeDateToString(DateTime _date) {
    String _formatted = DateFormat("dd MMM yyyy").format(_date);
    return _formatted;
  }

  // Asstes,
  static String samayLogo = 'assets/images/log.jpg';
  static String samayLogoAndName = 'assets/images/logo_name.png';
  static String samayCartoon = 'assets/images/cartoon.png';

  // Counter code
  static String indiaCode = "+91";

  //
  static String GstExclusive = "Exclusive";
  static String GstInclusive = "Inclusive";

  // super Category
  static String supCatHair = "Hair Services";
  static String supCatSkin = "Skin Services";
  static String supCatManiPedi = "Mani Pedi Services";
  static String supCatNail = "Nail Services";
  static String supCatMakeUp = "Makeup Services";
  static String supCatMassage = "Massage Services";
  static String supCatOther = "Other Services";

  // Service at
  static String serviceAtSalon = "Salon";
  static String serviceAtHome = "Home";
  static String serviceAtBoth = "Both";

  // Appointment Status
  static String pendingAppointState = "Pending";
  static String confirmedAppointState = "Confirmed";
  static String completedAppointState = "Completed";
  static String cancelAppointState = "(Cancel)";
  static String inProccesAppointState = "InProcces";
  static String checkInAppointState = "Check-In";
  static String billGenerateAppointState = "Bill Generate";
  static String updateAppointState = "(Update)";

  // Product for
  static String forMale = "Male";
  static String forFemale = "Female";
  static String forUnisex = "Unisex";

  // Stock status
  static const String lowStock = "Low Stock";
  static const String outOfStock = "Out of Stock";
  static const String nullOfStock = "null";

  // Product visible  status
  static const String productVisible = "visible";
  static const String productHidden = "hidden";
}
