import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GlobalVariable {
  static TimeOfDay OpenTime = const TimeOfDay(hour: 6, minute: 0);
  static TimeOfDay CloseTime = const TimeOfDay(hour: 21, minute: 0);
  static TimeOfDay openTimeGlo = const TimeOfDay(hour: 6, minute: 0);
  static TimeOfDay closerTimeGlo = const TimeOfDay(hour: 6, minute: 0);
  static String salonID = '';

  static const String salon = "Salon";
  static DateTime today = DateTime.now();

  //! Version
  static String webVersion = "1.0.0.4";

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

  // GST 18% for salon services
  static double salonGST0_18 = 0.18;
  static double salonGST18Per = 18;
  static double salonGST1_18 = 1.18;

  // GST 18% for salon products
  static double productGST18 = 18;
  static double productGST1_18 = 1.18;

  static double gST18 = 18;

  // Platform fee
  static double platformFee = 0.00; // 5% of the total bill

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
  static DateTime DateTimeFomate(DateTime date) {
    String formatted = DateFormat("dd MMM yyyy").format(date);
    DateTime FormateDate = DateFormat("dd MMM yyyy").parse(formatted);
    return FormateDate;
  }

  static String DateTimeDateToString(DateTime date) {
    String formatted = DateFormat("dd MMM yyyy").format(date);
    return formatted;
  }

  // Asstes,
  static String samayLogo = 'assets/images/log.jpg';
  static String samayLogoAndName = 'assets/images/logo_name.png';
  static String samayCartoon = 'assets/images/cartoon.png';

  // Counter code
  static String indiaCode = "+91";

  //
  static String exclusiveGST = "Exclusive";
  static String inclusiveGST = "Inclusive";
  static String noGST = "noGST";

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

  // Product type

  static const String cashPayment = "Cash";
  static const String qRPayment = "QR";
  static const String customPayment = "Custom";
  static const String pAPPayment = "PAP (Pay At Place)";

//! Function of List
//? check two list are same or not
  static bool twoListsEqual(
      {required List<String>? a, required List<String>? b}) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;
    final aSorted = List<String>.from(a)..sort();
    final bSorted = List<String>.from(b)..sort();
    for (int i = 0; i < aSorted.length; i++) {
      if (aSorted[i] != bSorted[i]) return false;
    }
    return true;
  }

//! Function of Maps
//? check two Map are same or not

static  bool areMapsEqual<K, V>(Map<K, V>? map1, Map<K, V>? map2) {
    // 1. Check for nulls
    if (map1 == null && map2 == null) return true;
    if (map1 == null || map2 == null) return false;

    // 2. Check length
    if (map1.length != map2.length) return false;

    // 3. Iterate keys and compare values
    for (final key in map1.keys) {
      if (!map2.containsKey(key)) return false;
      if (map1[key] != map2[key]) return false;
    }

    // 4. All checks passed
    return true;
  }
}
