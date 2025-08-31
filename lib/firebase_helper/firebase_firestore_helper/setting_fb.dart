import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/models/message_model/message_model.dart';
import 'package:samay_admin_plan/models/salon_setting_model/salon_setting_model.dart';
import 'package:samay_admin_plan/models/vender_payent_details/vender_payment_detail.dart';

class SettingFb {
  static SettingFb instance = SettingFb();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //! Message Funtion
  //Save of message setting to Firebase
  Future<MessageModel> saveMessagestFB(
    String salonId,
    String wMessForBillPDF,
    BuildContext context,
  ) async {
    try {
      String? adminUid = FirebaseAuth.instance.currentUser?.uid;

      DocumentReference reference = _firebaseFirestore
          .collection("admins")
          .doc(adminUid)
          .collection("salon")
          .doc(salonId)
          .collection("MessageInfor")
          .doc();

      MessageModel messageModel = MessageModel(
        id: reference.id,
        adminId: adminUid!,
        salonId: salonId,
        wMasForbillPFD: wMessForBillPDF,
      );

      await reference.set(messageModel.toJson());
      print("Message Setting save Successfully ");
      // showMessage("messageModel save Successfully ");
      return messageModel;
    } catch (e) {
      print("error");
      print("Error Message save the messageModel ${e.toString()}");
      // showMessage("Error save the messageModel ${e.toString()}");
      rethrow; // Ensure the error is still thrown
    }
  }

  // Fetch the Message setting details from Firebase
  Future<MessageModel?> fetchMessagestFB(String salonId) async {
    try {
      String? adminUid = FirebaseAuth.instance.currentUser?.uid;

      // Reference to the collection where the setting is stored
      CollectionReference settingCollection = _firebaseFirestore
          .collection("admins")
          .doc(adminUid)
          .collection("salon")
          .doc(salonId)
          .collection("MessageInfor");

      // Get the first document (since there's only one document)
      QuerySnapshot querySnapshot = await settingCollection.limit(1).get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document snapshot
        DocumentSnapshot docSnapshot = querySnapshot.docs.first;

        // Convert the document to a SettingModel
        MessageModel mesagesDetails =
            MessageModel.fromJson(docSnapshot.data() as Map<String, dynamic>);

        return mesagesDetails;
      } else {
        print("No _mesagesDetails found for the given salonId.");
        return null; // No setting found
      }
    } catch (e) {
      print("Error fetching the _mesagesDetails: ${e.toString()}");
      // showMessage("Error fetching the _mesagesDetails");
      rethrow; // Ensure the error is still thrown
    }
  }

  // Update the messageModel from Firebase

  Future<bool> updateMessagesPaymentFB(
    MessageModel messageModel,
    String salonId,
    String messageModelId,
  ) async {
    try {
      String? adminUid = FirebaseAuth.instance.currentUser?.uid;

      await _firebaseFirestore
          .collection("admins")
          .doc(adminUid)
          .collection("salon")
          .doc(salonId)
          .collection("MessageInfor")
          .doc(messageModelId)
          .update(messageModel.toJson());
      showMessage("Setting update Successfully ");
      return true;
    } catch (e) {
      print("Error update the messageModel: ${e.toString()}");
      // showMessage("Error update the messageModel");
      rethrow;
    }
  }

  //! Vender Banking Details
  //Save of setting to Firebase
  Future<VenderPaymentDetailsModel> saveVenderPaymentFB(
    String salonId,
    String upiID,
    // String bankName,
    // String bankIFSCCode,
    // int bankNo,
    BuildContext context,
  ) async {
    try {
      String? adminUid = FirebaseAuth.instance.currentUser?.uid;

      DocumentReference reference = _firebaseFirestore
          .collection("admins")
          .doc(adminUid)
          .collection("salon")
          .doc(salonId)
          .collection("VenderPaymentDetails")
          .doc();

      VenderPaymentDetailsModel venderPaymentDetailsModel =
          VenderPaymentDetailsModel(
              id: reference.id,
              upiID: upiID,
              // bankName: bankName,
              // bankIFSCCode: bankIFSCCode,
              // bankNo: bankNo,
              salonID: salonId,
              adminId: adminUid!);

      await reference.set(venderPaymentDetailsModel.toJson());
      print("Setting save Successfully ");
      // showMessage("venderPaymentDetailsModel save Successfully ");
      return venderPaymentDetailsModel;
    } catch (e) {
      print("error");
      print("Error save the venderPaymentDetailsModel ${e.toString()}");
      // showMessage("Error save the venderPaymentDetailsModel ${e.toString()}");
      rethrow; // Ensure the error is still thrown
    }
  }

  // Fetch the Vender Banking Details from Firebase
  Future<VenderPaymentDetailsModel?> fetchVenderPaymentFB(
      String salonId) async {
    try {
      String? adminUid = FirebaseAuth.instance.currentUser?.uid;

      // Reference to the collection where the setting is stored
      CollectionReference settingCollection = _firebaseFirestore
          .collection("admins")
          .doc(adminUid)
          .collection("salon")
          .doc(salonId)
          .collection("VenderPaymentDetails");

      // Get the first document (since there's only one document)
      QuerySnapshot querySnapshot = await settingCollection.limit(1).get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document snapshot
        DocumentSnapshot docSnapshot = querySnapshot.docs.first;

        // Convert the document to a SettingModel
        VenderPaymentDetailsModel venderPaymentDetails =
            VenderPaymentDetailsModel.fromJson(
                docSnapshot.data() as Map<String, dynamic>);

        return venderPaymentDetails;
      } else {
        print("No _venderPaymentDetails found for the given salonId.");
        return null; // No setting found
      }
    } catch (e) {
      print("Error fetching the _venderPaymentDetails: ${e.toString()}");
      // showMessage("Error fetching the _venderPaymentDetails");
      rethrow; // Ensure the error is still thrown
    }
  }

  // update Venderpayment details

  Future<bool> updateVenderPaymentFB(
    VenderPaymentDetailsModel venderPaymentDetailsModel,
    String salonId,
    String venderPaymentModelId,
  ) async {
    try {
      String? adminUid = FirebaseAuth.instance.currentUser?.uid;

      await _firebaseFirestore
          .collection("admins")
          .doc(adminUid)
          .collection("salon")
          .doc(salonId)
          .collection("VenderPaymentDetails")
          .doc(venderPaymentModelId)
          .update(venderPaymentDetailsModel.toJson());
      // showMessage("Vender pay update Successfully ");
      print("Vender update Successfully  ");
      return true;
    } catch (e) {
      print("Error Vender the messageModel: ${e.toString()}");
      // showMessage("Error Vender the messageModel");
      rethrow;
    }
  }

  //Save of setting to Firebase
  Future<SettingModel> saveSettingToFB(
    String salonId,
    String diffbtwTimetap,
    int dayForBooking,
    String gstNo,
    BuildContext context,
  ) async {
    try {
      String? adminUid = FirebaseAuth.instance.currentUser?.uid;

      DocumentReference reference = _firebaseFirestore
          .collection("admins")
          .doc(adminUid)
          .collection("salon")
          .doc(salonId)
          .collection("setting")
          .doc();

      SettingModel settingModel = SettingModel(
        id: reference.id,
        adminId: adminUid!,
        salonId: salonId,
        diffbtwTimetap: diffbtwTimetap,
        dayForBooking: dayForBooking,
        gstNo: gstNo,
      );

      await reference.set(settingModel.toJson());
      print("Setting save Successfully ");
      // showMessage("Setting save Successfully ");
      return settingModel;
    } catch (e) {
      print("error");
      print("Error save the Setting ${e.toString()}");
      showMessage("Error save the Setting ${e.toString()}");
      rethrow; // Ensure the error is still thrown
    }
  }

  // Fetch the setting from Firebase
  Future<SettingModel?> fetchSettingFromFB(String salonId) async {
    try {
      String? adminUid = FirebaseAuth.instance.currentUser?.uid;

      // Reference to the collection where the setting is stored
      CollectionReference settingCollection = _firebaseFirestore
          .collection("admins")
          .doc(adminUid)
          .collection("salon")
          .doc(salonId)
          .collection("setting");

      // Get the first document (since there's only one document)
      QuerySnapshot querySnapshot = await settingCollection.limit(1).get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document snapshot
        DocumentSnapshot docSnapshot = querySnapshot.docs.first;

        // Convert the document to a SettingModel
        SettingModel settingModel =
            SettingModel.fromJson(docSnapshot.data() as Map<String, dynamic>);

        return settingModel;
      } else {
        print("No setting found for the given salonId.");
        return null; // No setting found
      }
    } catch (e) {
      print("Error fetching the setting: ${e.toString()}");
      showMessage("Error fetching the setting");
      rethrow; // Ensure the error is still thrown
    }
  }

  // Update the setting from Firebase

  Future<bool> updateSettingFB(
    SettingModel settingModel,
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
          .collection("setting")
          .doc(settingId)
          .update(settingModel.toJson());
      // showMessage("Setting update Successfully ");
      return true;
    } catch (e) {
      print("Error update the setting: ${e.toString()}");
      // showMessage("Error update the setting");
      rethrow;
    }
  }
}
