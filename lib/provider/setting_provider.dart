import 'package:flutter/material.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_firestore_helper/setting_fb.dart';
import 'package:samay_admin_plan/models/message_model/message_model.dart';
import 'package:samay_admin_plan/models/vender_payent_details/vender_payment_detail.dart';

class SettingProvider with ChangeNotifier {
  final SettingFb settingFb = SettingFb.instance;

  MessageModel? _messageModel;
  MessageModel? get getMessageModel => _messageModel;

  VenderPaymentDetailsModel? _venderPaymentDetailsModel;
  VenderPaymentDetailsModel? get getVenderPaymentDetailsModel =>
      _venderPaymentDetailsModel;

  // SettingModel? _settingModel;
  // SettingModel get getSettingModel => _settingModel!;

  // AppointModel? _appointModel;
  // AppointModel get getAppointModel => _appointModel!;

  // bool _isVenderPaymentDataHave = false;
  // bool get getIsVenderPaymentHave => _isVenderPaymentDataHave;

//! Messages fun of Provider
  //Fatch Messages for Firebase
  Future<void> fetchMessagesDetailsPro(String salonId) async {
    _messageModel = await settingFb.fetchMessagestFB(salonId);

    print("i have messages Details ");

    notifyListeners();
  }

  //Fatch Messages for Firebase
  Future<bool> updateMessagesDetailsPro(
      String salonId, messageModelId, MessageModel messageModel) async {
    bool isUpdate = await settingFb.updateMessagesPaymentFB(
        messageModel, salonId, messageModelId);
    print("i have messages Details ");
    if (isUpdate) {
      _messageModel = messageModel;
    }

    notifyListeners();
    return true;
  }

  //! Venderpayment fun of Provider

  //Fatch venderPaymentDetailsModel for Firebase
  Future<void> fetchVenderPaymentDetailsPro(String salonId) async {
    _venderPaymentDetailsModel = await settingFb.fetchVenderPaymentFB(salonId);

    print("i have Vender Payment Details  ");

    notifyListeners();
  }

  //Update venderPaymentDetailsModel for Firebase
  Future<bool> UpdateVenderPaymentDetailsPro(
      String salonId,
      String venderPaymentId,
      VenderPaymentDetailsModel venderPaymentModel) async {
    bool isUpdate = await settingFb.updateVenderPaymentFB(
        venderPaymentModel, salonId, venderPaymentId);

    print("i have Vender Payment Details  ");
    if (isUpdate) {
      _venderPaymentDetailsModel = venderPaymentModel;
    }

    notifyListeners();
    return true;
  }

  Future<void> callbackSettingProvider(String salonId) async {
    fetchMessagesDetailsPro(salonId);
    fetchVenderPaymentDetailsPro(salonId);
  }
}
