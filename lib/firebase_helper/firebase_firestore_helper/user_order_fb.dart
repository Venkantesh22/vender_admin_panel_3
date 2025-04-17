import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/constants/global_variable.dart';
import 'package:samay_admin_plan/models/salon_form_models/salon_infor_model.dart';
import 'package:samay_admin_plan/models/salon_setting_model/salon_setting_model.dart';
import 'package:samay_admin_plan/models/save_date/save_appointment_date.dart';
import 'package:samay_admin_plan/models/service_model/service_model.dart';
import 'package:samay_admin_plan/models/timestamp_model/timestamp_model.dart';
import 'package:samay_admin_plan/models/user_model/user_model.dart';
import 'package:samay_admin_plan/models/appoint_model/appoint_model.dart';
import 'package:samay_admin_plan/models/vender_payent_details/vender_payment_detail.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';

class UserBookingFB {
  static UserBookingFB instance = UserBookingFB();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

//! Add New Appointment function

  /// Fetch all services from multiple categories for a specific salon.
  Future<List<ServiceModel>> getAllServicesFromCategories(
      String salonId) async {
    List<ServiceModel> allServices = []; // List to store all services
    String? adminUid = FirebaseAuth.instance.currentUser?.uid;

    try {
      // Fetch all categories under the salon.
      QuerySnapshot categorySnapshot = await FirebaseFirestore.instance
          .collection("admins")
          .doc(adminUid)
          .collection("salon")
          .doc(salonId)
          .collection("category")
          .where("haveData", isEqualTo: true)
          .get();

      // Iterate through categories and fetch services from each one.
      for (var categoryDoc in categorySnapshot.docs) {
        String categoryId = categoryDoc.id;

        // Fetch services for this category.
        QuerySnapshot serviceSnapshot = await FirebaseFirestore.instance
            .collection("admins")
            .doc(adminUid)
            .collection("salon")
            .doc(salonId)
            .collection("category")
            .doc(categoryId)
            .collection("service")
            .get();

        // Iterate through services in the category.
        for (var serviceDoc in serviceSnapshot.docs) {
          try {
            // Parse and add each service to the list.
            ServiceModel service = ServiceModel.fromJson(
                serviceDoc.data() as Map<String, dynamic>);
            allServices.add(service);
          } catch (e) {
            print('Error parsing service data: $e');
          }
        }
      }
    } catch (e) {
      print('Error fetching services: $e');
    }

    return allServices;
  }

//! User Appointment function
  //Get User Appointment by Date
  Future<List<AppointModel>> getUserBookingListFB(
      DateTime selectDate, String salonId) async {
    try {
      // Normalize the `selectDate` to the start of the day (removing time).
      DateTime startOfDay =
          DateTime(selectDate.year, selectDate.month, selectDate.day);
      DateTime endOfDay = startOfDay.add(const Duration(days: 1));

      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore
              .collectionGroup('order')
              .where('vendorId', isEqualTo: salonId)
              .where('serviceDate', isGreaterThanOrEqualTo: startOfDay)
              .where('serviceDate', isLessThan: endOfDay)
              .get();

      List<AppointModel> bookingList = querySnapshot.docs
          .map((e) => AppointModel.fromJson(e.data()))
          .toList();

      print("Length of bookings fetched from Firestore: ${bookingList.length}");
      return bookingList;
    } catch (e) {
      print("Error fetching booking list from Firestore: $e");
      return [];
    }
  }

  Future<AppointModel> getSingleApointByIdFB(
      String userId, String appointID) async {
    try {
      print("FB $userId, $appointID");

      DocumentSnapshot<Map<String, dynamic>> doc = await _firebaseFirestore
          .collection('UserOrder')
          .doc(userId)
          .collection('order')
          .doc(appointID)
          .get();

      if (!doc.exists) {
        throw Exception(
            "Appointment document does not exist for userId: $userId and appointID: $appointID");
      }

      final data = doc.data();
      if (data == null) {
        throw Exception(
            "Document data is null for userId: $userId and appointID: $appointID");
      }

      AppointModel _appointModel = AppointModel.fromJson(data);
      print("Single Appointment is ${_appointModel.appointmentNo}");
      return _appointModel;
    } catch (e) {
      print("Error fetching booking list from Firestore: $e");
      rethrow;
    }
  }

// Update Appointment by Id
  Future<bool> updateAppointmentFB(
      String userId, appointmentId, AppointModel appointModel) async {
    try {
      await _firebaseFirestore
          .collection('UserOrder')
          .doc(userId)
          .collection('order')
          .doc(appointmentId)
          .update(appointModel.toJson());
      return true;
    } on Exception catch (e) {
      print("Error At Firebase :$e");
      rethrow;
      // TODO
    }
  }

// Save new Appointment
  Future<bool> saveAppointmentManual(
      List<ServiceModel> listOfServices,
      UserModel userModel,
      int appointmentNo,
      double totalPrice,
      double subtatal,
      double platformFees,
      String payment,
      int serviceDuration,
      DateTime serviceDate,
      DateTime serviceStartTime,
      DateTime serviceEndTime,
      String userNote,
      String vendorId,
      String gstNo,
      double gstAmount,
      double discountInPer,
      double discountAmount,
      double extraDiscountInPer,
      double extraDiscountInAmount,
      double netPrice,
      String gstIsIncludingOrExcluding,
      BuildContext context) async {
    try {
      AppProvider appProvider =
          Provider.of<AppProvider>(context, listen: false);
      String? adminUid = _auth.currentUser?.uid;
      // final List<TimeDateModel> timeDateList = [];
      final List<TimeStampModel> _timeStampList = [];

      if (listOfServices == null) {
        Navigator.of(context, rootNavigator: true)
            .pop(); // Dismiss any loading dialog
        showMessage("Error: User Service is not available.");
        return false;
      }
      if (userModel == null) {
        Navigator.of(context, rootNavigator: true)
            .pop(); // Dismiss any loading dialog
        showMessage("Error: User Model is not available.");
        return false;
      }

      if (vendorId == null) {
        Navigator.of(context, rootNavigator: true)
            .pop(); // Dismiss any loading dialog
        showMessage("Error: Salon information is not available.");
        return false;
      }

      DocumentReference documentReference = _firebaseFirestore
          .collection("UserOrder")
          .doc(userModel.id)
          .collection('order')
          .doc();
      DocumentReference documentReferenceTime = _firebaseFirestore
          .collection("UserOrder")
          .doc(userModel.id)
          .collection('order')
          .doc();

      //Add TimeDate list
      TimeStampModel _timeStampModel = TimeStampModel(
          id: documentReferenceTime.id,
          dateAndTime: GlobalVariable.today,
          updateBy:
              "${appProvider.getSalonInformation.name} (Create a Appointment)");

      _timeStampList.add(_timeStampModel);

      documentReference.set({
        "orderId": documentReference.id,
        "userId": userModel.id,
        "vendorId": vendorId,
        "adminId": adminUid,
        "appointmentNo": appointmentNo,
        "userModel": userModel.toJson(), // Convert SalonModel to JSON
        "services": listOfServices.map((e) => e.toJson()).toList(),
        "status": "Pending",
        "totalPrice": totalPrice,
        "platformFees": platformFees,
        "subtatal": subtatal,
        "payment": payment,
        "gstNo": gstNo,
        "gstAmount": gstAmount,
        "discountInPer": discountInPer,
        "discountAmount": discountAmount,
        "extraDiscountInPer": extraDiscountInPer,
        "extraDiscountInAmount": extraDiscountInAmount,
        "serviceDuration": serviceDuration,
        "serviceDate": serviceDate,
        "serviceStartTime": serviceStartTime,
        "serviceEndTime": serviceEndTime,
        "userNote": userNote,
        "timeStampList": _timeStampList.map((e) => e.toJson()).toList(),
        "isUpdate": false,
        "isMadual": true,
        "netPrice": netPrice,
        "gstIsIncludingOrExcluding": gstIsIncludingOrExcluding,
      });

      return true;
    } catch (e) {
      return false;
    }
  }

// Get salon information
  Future<SalonModel?> getSalonInformationOrderFB(
    String adminId,
    String vendorId,
  ) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore
              .collection("admins")
              .doc(adminId)
              .collection('salon')
              .doc(vendorId)
              .get();
      return SalonModel.fromJson(querySnapshot.data()!, querySnapshot.id);
    } catch (e) {
      showMessage('Error fetching vender: $e');
    }
    return null;
  }

//! Vender Setting details
  //Get User by Order userId infor
  Future<UserModel> getUserInforOrderFB(String userId) async {
    DocumentSnapshot<Map<String, dynamic>> querySnapshot =
        await _firebaseFirestore.collection('users').doc(userId).get();
    return UserModel.fromJson(querySnapshot.data()!);
  }

  //! Update the venderPaymentDetailsModel from Firebase

  Future<bool> updateVenderPaymentFB(
    VenderPaymentDetailsModel venderPaymentDetailsModel,
    String salonId,
    String settingId,
  ) async {
    try {
      String? adminUid = FirebaseAuth.instance.currentUser?.uid;

      await _firebaseFirestore
          .collection("admins")
          .doc(adminUid)
          .collection("salon")
          .doc(salonId)
          .collection("VenderPaymentDetails")
          .doc(settingId)
          .update(venderPaymentDetailsModel.toJson());
      showMessage("Setting update Successfully ");
      return true;
    } catch (e) {
      print("Error update the venderPaymentDetailsModel: ${e.toString()}");
      showMessage("Error update the venderPaymentDetailsModel");
      rethrow;
    }
  }

//! Fatch only appointment date
  Future<List<SaveDateModel>> getAppointmentDate(
    String adminId,
    String salonId,
  ) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore
              .collection("admins")
              .doc(adminId)
              .collection("salon")
              .doc(salonId)
              .collection("appointment_Date")
              .get();
      List<SaveDateModel> listDate = querySnapshot.docs
          .map((e) => SaveDateModel.fromJson(e.data()))
          .toList();
      print("Get all Date of appoint");
      return listDate;
    } on Exception catch (e) {
      print("Error : when get date of appoint fatch $e");
      rethrow;
    }
  }

  Future<void> saveDateFB(
      DateTime date, DateTime time, String adminId, String salonId) async {
    try {
      // Format the date to a string containing only the date part.
      DateTime _formattedDate = GlobalVariable.DateTimeFomate(date);

      CollectionReference<Map<String, dynamic>> collectionReference =
          _firebaseFirestore
              .collection("admins")
              .doc(adminId)
              .collection("salon")
              .doc(salonId)
              .collection("appointment_Date");

      // Query using the formatted date
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await collectionReference
              .where("date", isEqualTo: _formattedDate)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        // If the document exists, increment the totalAppointNo.
        DocumentReference<Map<String, dynamic>> documentReference =
            querySnapshot.docs.first.reference;
        int currentTotal =
            querySnapshot.docs.first.data()["totalAppointNo"] as int;
        await documentReference.update({"totalAppointNo": currentTotal + 1});
      } else {
        // If no document exists for the given date, create a new one.
        DocumentReference<Map<String, dynamic>> newDocumentReference =
            collectionReference.doc();

        SaveDateModel saveDate = SaveDateModel(
          date: _formattedDate, // You can store the original date if needed.
          time: time,
          id: newDocumentReference.id,
          totalAppointNo: 1,
        );

        await newDocumentReference.set(saveDate.toJson());
      }
    } catch (e) {
      print("Error: date not saved. $e");
    }
  }

  // update by Decrement 1 or totalAppointNo == 0 then delete it date
  Future<void> updateDateFB(
      DateTime date, DateTime time, String adminId, String salonId) async {
    try {
      DateTime _formattedDate = GlobalVariable.DateTimeFomate(date);

      CollectionReference<Map<String, dynamic>> collectionReference =
          _firebaseFirestore
              .collection("admins")
              .doc(adminId)
              .collection("salon")
              .doc(salonId)
              .collection("appointment_Date");

      // Check if a document with the specified date exists
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await collectionReference
              .where("date",
                  isEqualTo:
                      _formattedDate) // Date is stored as a String in "dd/MM/yyyy" format
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        // If the date is found, get the document reference
        DocumentReference<Map<String, dynamic>> documentReference =
            querySnapshot.docs.first.reference;

        int currentTotal =
            querySnapshot.docs.first.data()["totalAppointNo"] as int;

        if (currentTotal > 1) {
          // Decrement totalAppointNo by 1 if it's greater than 1
          await documentReference.update({"totalAppointNo": currentTotal - 1});
        } else {
          // If totalAppointNo is 1, delete the document
          await documentReference.delete();
        }
      } else {
        // Document with the specified date does not exist, no action taken
        print("No document found with the specified date: $date");
      }
    } on Exception catch (e) {
      print("Error: Unable to update date. $e");
    }
  }
}
