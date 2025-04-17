import 'package:flutter/material.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_firestore_helper/setting_fb.dart';
import 'package:samay_admin_plan/models/appoint_model/appoint_model.dart';
import 'package:samay_admin_plan/models/salon_setting_model/salon_setting_model.dart';

class EditProvider with ChangeNotifier {
  AppointModel? _appointModel;
  AppointModel? get getappointModel => _appointModel;

  SettingModel? _settingModel;
  SettingModel? get getSettingModel => _settingModel;

  double _netPrice = 0.0;
  double get getNetPrice => _netPrice;

  double _gstAmount = 0.0;
  double get getGstAmount => _gstAmount;

  double _finalAmount = 0.0;
  double get getFinalAmount => _finalAmount;

  double _extraDiscontAmount = 0.0;
  double get getExtraDiscontAmount => _extraDiscontAmount;

  double _extraDiscontPer = 0.0;
  double get getExtraDiscontPer => _extraDiscontPer;

  double _cashToGiveBack = 0.0;
  double get getCashToGiveBack => _cashToGiveBack;

  double _cashReceived = 0.0;

  void calNetPrice() {
    _netPrice = (_appointModel!.subtatal -
            _appointModel!.discountAmount! -
            _extraDiscontAmount) /
        1.18;
    // _netPrice = _netPricelocal;
    print("cal net $_netPrice");
    notifyListeners();
  }

  void calExtraDisountAmount() {
    final discountPercentage = _extraDiscontPer ?? 0.0;
    final validPercentage = discountPercentage.clamp(0.0, 100.0);
    _extraDiscontAmount = (validPercentage / 100) * (_appointModel!.subtatal);
    _extraDiscontPer = _extraDiscontAmount;
    print("cal extra $_extraDiscontAmount");
    notifyListeners();
  }

  void calGSTAmount() {
    _gstAmount = _netPrice * 0.18;
  }

  void calFinalAmount() {
    _finalAmount = _netPrice + _gstAmount + _appointModel!.platformFees;
  }

  void calCashToGiveBack() {
    _cashToGiveBack = _cashReceived - _finalAmount;
  }

  void setExtraDiscontPer(String value) {
    _extraDiscontPer = double.parse(value);
  }

  void selectAppointFun(AppointModel value) {
    _appointModel = value;
    notifyListeners();
  }

  void setSettingModelFun(String salonId) async {
    _settingModel = await SettingFb.instance.fetchSettingFromFB(salonId);
    notifyListeners();
  }

  void setReceivedCash(String value) async {
    _cashReceived = double.parse(value);
    notifyListeners();
  }
}
