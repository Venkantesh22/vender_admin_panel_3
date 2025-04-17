import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:samay_admin_plan/models/appoint_model/appoint_model.dart';

class ReportFb {
  static ReportFb instance = ReportFb();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //! User Appointment function
  //Get User Appointment by Date
  Future<List<AppointModel>> getAppointListDateAndStatusFB(
    DateTime selectDate,
    String salonId,
  ) async {
    try {
      DateTime startOfDay =
          DateTime(selectDate.year, selectDate.month, selectDate.day);
      DateTime endOfDay = startOfDay.add(const Duration(days: 1));

      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore
              .collectionGroup('order')
              .where('serviceDate', isGreaterThanOrEqualTo: startOfDay)
              .where('serviceDate', isLessThan: endOfDay)
              .where('vendorId', isEqualTo: salonId)
              .get();

      List<AppointModel> bookingList = querySnapshot.docs
          .map((e) => AppointModel.fromJson(e.data()))
          .toList();

      return bookingList;
    } catch (e) {
      print("Error fetching booking list: $e");
      return [];
    }
  }

  //! User Appointment function

  Future<List<AppointModel>> getAppointListRangeDateAndStatusFB(
    DateTime startDate,
    DateTime endDate,
    String salonId,
  ) async {
    try {
      DateTime _startOfDay =
          DateTime(startDate.year, startDate.month, startDate.day);
      DateTime _endOfDay = DateTime(endDate.year, endDate.month, endDate.day);

      DateTime _endOfDayFinla = _endOfDay.add(const Duration(days: 1));

      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore
              .collectionGroup('order')
              .where('serviceDate', isGreaterThanOrEqualTo: _startOfDay)
              .where('serviceDate', isLessThanOrEqualTo: _endOfDayFinla)
              .where('vendorId', isEqualTo: salonId)
              .get();
      print("for  data for date: $startDate");
      print("for data for date: $endDate");

      List<AppointModel> bookingList = querySnapshot.docs
          .map((e) => AppointModel.fromJson(e.data()))
          .toList();

      return bookingList;
    } catch (e) {
      print("Error fetching booking list: $e");
      return [];
    }
  }
}
