// class VenderPaymentDetailsModel {
//   final String id;
//   String? upiID;
//   String? bankName;
//   String? bankIFSCCode;
//   int? bankNo;

//   VenderPaymentDetailsModel({
//     required this.id,
//     this.upiID = "",
//     this.bankName = "",
//     this.bankIFSCCode = "",
//     this.bankNo = 0000000,
//   });

//   factory VenderPaymentDetailsModel.fromJson(Map<String, dynamic> json) {
//     return VenderPaymentDetailsModel(
//       id: json['id' ?? "noData"] as String,
//       upiID: json['upiID' ?? "noData"] as String,
//       bankName: json['bankName' ?? "noData"] as String?,
//       bankIFSCCode: json['bankIFSCCode' ?? "noData"] as String?,
//       bankNo: json['bankNo' ?? 000000] as int?,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'upiID': upiID,
//       'bankName': bankName,
//       'bankIFSCCode': bankIFSCCode,
//       'bankNo': bankNo,
//     };
//   }

//   VenderPaymentDetailsModel copyWith({
//     String? id,
//     String? upiID,
//     String? bankName,
//     String? bankIFSCCode,
//     int? bankNo,
//   }) {
//     return VenderPaymentDetailsModel(
//       id: id ?? this.id,
//       upiID: upiID ?? this.upiID,
//       bankName: bankName ?? this.bankName,
//       bankIFSCCode: bankIFSCCode ?? this.bankIFSCCode,
//       bankNo: bankNo ?? this.bankNo,
//     );
//   }
// }

import 'dart:core';

class VenderPaymentDetailsModel {
  final String id;
  late final String upiID;
  final String adminId;
  final String salonID;
  final String? bankName;
  final String? bankIFSCCode;
  final int? bankNo;

  VenderPaymentDetailsModel({
    required this.id,
    required this.upiID,
    required this.adminId,
    required this.salonID,
    this.bankName,
    this.bankIFSCCode,
    this.bankNo,
  });

  factory VenderPaymentDetailsModel.fromJson(Map<String, dynamic> json) {
    return VenderPaymentDetailsModel(
      id: json['id'] as String,
      upiID: json['upiID'] as String,
      adminId: json['adminId'] as String,
      salonID: json['salonID'] as String,
      bankName: json['bankName'] as String?,
      bankIFSCCode: json['bankIFSCCode'] as String?,
      bankNo: json['bankNo'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'upiID': upiID,
      'adminId': adminId,
      'salonID': salonID,
      'bankName': bankName,
      'bankIFSCCode': bankIFSCCode,
      'bankNo': bankNo,
    };
  }

  VenderPaymentDetailsModel copyWith({
    String? id,
    String? upiID,
    String? bankName,
    String? bankIFSCCode,
    int? bankNo,
  }) {
    return VenderPaymentDetailsModel(
      id: id ?? this.id,
      upiID: upiID ?? this.upiID,
      adminId: adminId,
      salonID: salonID,
      bankName: bankName ?? this.bankName,
      bankIFSCCode: bankIFSCCode ?? this.bankIFSCCode,
      bankNo: bankNo ?? this.bankNo,
    );
  }
}
