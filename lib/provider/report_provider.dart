import 'package:flutter/material.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_firestore_helper/report_fb.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_firestore_helper/user_order_fb.dart';
import 'package:samay_admin_plan/models/appoint_model/appoint_model.dart';

class ReportProvider with ChangeNotifier {
  final ReportFb _reportFb = ReportFb.instance;
  final UserBookingFB _userBookingFB = UserBookingFB.instance;

  List<AppointModel> _appointmentList = [];
  List<AppointModel> get getAppointmentList => _appointmentList;

  //! Get Appointment  of Single Date function
  // Get Appointment list for a specific date from Firebase\

  Future<void> getAppointSingleDateListPro(
    DateTime date,
    String salonId,
  ) async {
    // Normalize the date to the start of the day
    DateTime normalizedDate = DateTime(date.year, date.month, date.day);

    // Log the normalized date for debugging
    print("Normalized Date for Firestore Query: $normalizedDate");

    _appointmentList = await _reportFb.getAppointListDateAndStatusFB(
      date,
      salonId,
    );
    print("Fetched data for date: $date");
    print("Fetched Date length ${_appointmentList.length}");
    notifyListeners();
  }

  Future<void> getAppointListRangeDateAndStatusPro(
    DateTime startDate,
    DateTime endDate,
    String salonId,
  ) async {
    // String _startDateFormate =
    //     DateFormat('dd/MM/yyyy').format(startDate); // Format date correctly
    // String _endDateFormate =
    //     DateFormat('dd/MM/yyyy').format(endDate); // Format date correctly
    // Normalize the date to the start of the day
    DateTime startDateNormalized =
        DateTime(startDate.year, startDate.month, startDate.day);
    DateTime endDateNormalized =
        DateTime(endDate.year, endDate.month, endDate.day);

    // Log the normalized date for debugging
    print("Normalized Date for Firestore Query start: $startDateNormalized");
    print("Normalized Date for Firestore Query enf: $salonId");

    _appointmentList = await _reportFb.getAppointListRangeDateAndStatusFB(
      startDateNormalized,
      endDateNormalized,
      salonId,
    );
    // print("Fetched data for date: $_startDateFormate");
    // print("Fetched data for date: $_endDateFormate");
    // print("Fetched Date length ${_appointmentList.length}");
    notifyListeners();
  }
}
