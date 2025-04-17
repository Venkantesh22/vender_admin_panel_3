import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:samay_admin_plan/models/service_model/service_model.dart';
import 'package:samay_admin_plan/models/user_model/user_model.dart';
import 'package:samay_admin_plan/models/timestamp_model/timestamp_model.dart';

class AppointModel {
  final String orderId;
  final String userId;
  final String vendorId;
  final String adminId;
  final int appointmentNo;
  final List<ServiceModel> services;
  final String status;
  final double totalPrice;
  final double subtatal;
  final double platformFees;
  final String payment;
  final int serviceDuration;
  final DateTime serviceDate;
  final DateTime serviceStartTime;
  final DateTime serviceEndTime;
  final String userNote;
  final UserModel userModel;
  final List<TimeStampModel> timeStampList;
  final bool isUpdate;
  final bool isMadual;
  final double gstAmount;
  final String gstNo;
  final double netPrice; // New field
  final String gstIsIncludingOrExcluding; // New field
  final String serviceAt; // New field
  double? discountInPer;
  double? discountAmount;
  double? extraDiscountInPer;
  double? extraDiscountInAmount;
  String? transactionId; // New field

  AppointModel({
    required this.orderId,
    required this.userId,
    required this.vendorId,
    required this.adminId,
    required this.appointmentNo,
    required this.services,
    required this.status,
    required this.totalPrice,
    required this.subtatal,
    required this.platformFees,
    required this.payment,
    required this.serviceDuration,
    required this.serviceDate,
    required this.serviceStartTime,
    required this.serviceEndTime,
    required this.userNote,
    required this.userModel,
    required this.timeStampList,
    this.isUpdate = false,
    this.isMadual = false,
    required this.gstAmount,
    required this.gstNo,
    required this.netPrice, // New field
    required this.gstIsIncludingOrExcluding, // New field
    required this.serviceAt, // New field
    this.discountInPer = 0.0,
    this.discountAmount,
    this.extraDiscountInPer = 0.0,
    this.extraDiscountInAmount = 0.0,
    this.transactionId, // New field
  });

  /// Convert Firestore JSON to `AppointModel`
  factory AppointModel.fromJson(Map<String, dynamic> json) {
    return AppointModel(
      orderId: json['orderId'] ?? '',
      userId: json['userId'] ?? '',
      vendorId: json['vendorId'] ?? '',
      adminId: json['adminId'] ?? '',
      appointmentNo: (json['appointmentNo'] ?? 0) as int,
      services: (json['services'] as List?)
              ?.map((item) => ServiceModel.fromJson(item))
              .toList() ??
          [],
      status: json['status'] ?? 'error',
      totalPrice: (json['totalPrice'] ?? 0.0).toDouble(),
      subtatal: (json['subtatal'] ?? 0.0).toDouble(),
      platformFees: (json['platformFees'] ?? 0.0).toDouble(),
      payment: json['payment'] ?? 'Unknown',
      serviceDuration: (json['serviceDuration'] ?? 0).toInt(),
      serviceDate:
          (json['serviceDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      serviceStartTime:
          (json['serviceStartTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      serviceEndTime:
          (json['serviceEndTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      userNote: json['userNote'] ?? '',
      userModel: UserModel.fromJson(json['userModel'] ?? {}),
      timeStampList: (json['timeStampList'] as List?)
              ?.map((item) => TimeStampModel.fromJson(item))
              .toList() ??
          [],
      isUpdate: json['isUpdate'] ?? false,
      isMadual: json['isMadual'] ?? false,
      gstAmount: (json['gstAmount'] ?? 0.0).toDouble(),
      gstNo: json['gstNo'] ?? '',
      netPrice: (json['netPrice'] ?? 0.0).toDouble(), // New field
      gstIsIncludingOrExcluding:
          json['gstIsIncludingOrExcluding'] ?? 'including', // New field
      serviceAt: json['serviceAt'] ?? 'Salon', // New field with default value
      discountInPer: (json['discountInPer'] ?? 0.0 as num?)?.toDouble(),
      discountAmount: (json['discountAmount'] ?? 0.0 as num?)?.toDouble(),
      extraDiscountInPer:
          (json['extraDiscountInPer'] ?? 0.0 as num?)?.toDouble(),
      extraDiscountInAmount:
          (json['extraDiscountInAmount'] ?? 0.0 as num?)?.toDouble(),
      transactionId: json['transactionId'], // New field
    );
  }

  /// Convert `AppointModel` to Firestore JSON
  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'userId': userId,
      'vendorId': vendorId,
      'adminId': adminId,
      'appointmentNo': appointmentNo,
      'services': services.map((e) => e.toJson()).toList(),
      'status': status,
      'totalPrice': totalPrice,
      'subtatal': subtatal,
      'platformFees': platformFees,
      'payment': payment,
      'serviceDuration': serviceDuration,
      'serviceDate': Timestamp.fromDate(serviceDate),
      'serviceStartTime': Timestamp.fromDate(serviceStartTime),
      'serviceEndTime': Timestamp.fromDate(serviceEndTime),
      'userNote': userNote,
      'userModel': userModel.toJson(),
      'timeStampList': timeStampList.map((e) => e.toJson()).toList(),
      'isUpdate': isUpdate,
      'isMadual': isMadual,
      'gstAmount': gstAmount,
      'gstNo': gstNo,
      'netPrice': netPrice, // New field
      'gstIsIncludingOrExcluding': gstIsIncludingOrExcluding, // New field
      'serviceAt': serviceAt, // New field
      'discountInPer': discountInPer,
      'discountAmount': discountAmount,
      'extraDiscountInPer': extraDiscountInPer,
      'extraDiscountInAmount': extraDiscountInAmount,
      'transactionId': transactionId, // New field
    };
  }

  /// Copy Method for Updating Specific Fields
  AppointModel copyWith({
    List<ServiceModel>? services,
    UserModel? userModel,
    String? status,
    double? totalPrice,
    double? subtatal,
    double? platformFees,
    String? payment,
    int? serviceDuration,
    DateTime? serviceDate,
    DateTime? serviceStartTime,
    DateTime? serviceEndTime,
    String? userNote,
    List<TimeStampModel>? timeStampList,
    bool? isUpdate,
    bool? isMadual,
    double? gstAmount,
    String? gstNo,
    double? netPrice, // New field
    String? gstIsIncludingOrExcluding, // New field
    String? serviceAt, // New field
    double? discountInPer,
    double? discountAmount,
    double? extraDiscountInPer,
    double? extraDiscountInAmount,
    String? transactionId, // New field
  }) {
    return AppointModel(
      orderId: orderId,
      userId: userId,
      vendorId: vendorId,
      adminId: adminId,
      appointmentNo: appointmentNo,
      services: services ?? this.services,
      status: status ?? this.status,
      totalPrice: totalPrice ?? this.totalPrice,
      subtatal: subtatal ?? this.subtatal,
      platformFees: platformFees ?? this.platformFees,
      payment: payment ?? this.payment,
      serviceDuration: serviceDuration ?? this.serviceDuration,
      serviceDate: serviceDate ?? this.serviceDate,
      serviceStartTime: serviceStartTime ?? this.serviceStartTime,
      serviceEndTime: serviceEndTime ?? this.serviceEndTime,
      userNote: userNote ?? this.userNote,
      userModel: userModel ?? this.userModel,
      timeStampList: timeStampList ?? this.timeStampList,
      isUpdate: isUpdate ?? this.isUpdate,
      isMadual: isMadual ?? this.isMadual,
      gstAmount: gstAmount ?? this.gstAmount,
      gstNo: gstNo ?? this.gstNo,
      netPrice: netPrice ?? this.netPrice, // New field
      gstIsIncludingOrExcluding: gstIsIncludingOrExcluding ??
          this.gstIsIncludingOrExcluding, // New field
      serviceAt: serviceAt ?? this.serviceAt, // New field
      discountInPer: discountInPer ?? this.discountInPer,
      discountAmount: discountAmount ?? this.discountAmount,
      extraDiscountInPer: extraDiscountInPer ?? this.extraDiscountInPer,
      extraDiscountInAmount:
          extraDiscountInAmount ?? this.extraDiscountInAmount,
      transactionId: transactionId ?? this.transactionId, // New field
    );
  }
}


// class AppointModel {
//   final String orderId;
//   final String userId;
//   final String vendorId;
//   final String adminId;
//   final int appointmentNo;
//   final List<ServiceModel> services;
//   final String status;
//   final double totalPrice;
//   final double subtatal;
//   final double platformFees;
//   final String payment;
//   final int serviceDuration;
//   final DateTime serviceDate;
//   final DateTime serviceStartTime;
//   final DateTime serviceEndTime;
//   final String userNote;
//   final UserModel userModel;
//   final List<TimeStampModel> timeStampList;
//   final bool isUpdate;
//   final bool isMadual;
//   final double gstAmount;
//   final String gstNo;
//   double? discountInPer;
//   double? discountAmount;
//   double? extraDiscountInPer;
//   double? extraDiscountInAmount;
//   String? transactionId; // New variable
//   final double netPrice; // New final double field
//   final String gstIsIncludingOrExcluding; // New final String field

//   AppointModel({
//     required this.orderId,
//     required this.userId,
//     required this.vendorId,
//     required this.adminId,
//     required this.appointmentNo,
//     required this.services,
//     required this.status,
//     required this.totalPrice,
//     required this.subtatal,
//     required this.platformFees,
//     required this.payment,
//     required this.serviceDuration,
//     required this.serviceDate,
//     required this.serviceStartTime,
//     required this.serviceEndTime,
//     required this.userNote,
//     required this.userModel,
//     required this.timeStampList,
//     this.isUpdate = false,
//     this.isMadual = false,
//     required this.gstAmount,
//     required this.gstNo,
//     this.discountInPer = 0.0,
//     this.discountAmount,
//     this.extraDiscountInPer = 0.0,
//     this.extraDiscountInAmount = 0.0,
//     this.transactionId = "00000",
//     required this.netPrice,
//     required this.gstIsIncludingOrExcluding,
//   });

//   /// Factory constructor to create an instance from JSON
//   factory AppointModel.fromJson(Map<String, dynamic> json) {
//     return AppointModel(
//       orderId: json['orderId'] ?? '',
//       userId: json['userId'] ?? '',
//       vendorId: json['vendorId'] ?? '',
//       adminId: json['adminId'] ?? '',
//       appointmentNo: (json['appointmentNo'] ?? 0) as int,
//       services: (json['services'] as List?)
//               ?.map((item) => ServiceModel.fromJson(item))
//               .toList() ??
//           [],
//       status: json['status'] ?? 'error',
//       totalPrice: (json['totalPrice'] ?? 0.0).toDouble(),
//       subtatal: (json['subtatal'] ?? 0.0).toDouble(),
//       platformFees: (json['platformFees'] ?? 0.0).toDouble(),
//       payment: json['payment'] ?? 'Unknown',
//       serviceDuration: (json['serviceDuration'] ?? 0).toInt(),
//       serviceDate:
//           (json['serviceDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
//       serviceStartTime:
//           (json['serviceStartTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
//       serviceEndTime:
//           (json['serviceEndTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
//       userNote: json['userNote'] ?? '',
//       userModel: UserModel.fromJson(json['userModel'] ?? {}),
//       timeStampList: (json['timeStampList'] as List?)
//               ?.map((item) => TimeStampModel.fromJson(item))
//               .toList() ??
//           [],
//       isUpdate: json['isUpdate'] ?? false,
//       isMadual: json['isMadual'] ?? false,
//       gstAmount: (json['gstAmount'] ?? 0.0).toDouble(),
//       gstNo: json['gstNo'] ?? '',
//       discountInPer: (json['discountInPer'] ?? 0.0 as num?)?.toDouble(),
//       discountAmount: (json['discountAmount'] ?? 0.0 as num?)?.toDouble(),
//       extraDiscountInPer:
//           (json['extraDiscountInPer'] ?? 0.0 as num?)?.toDouble(),
//       extraDiscountInAmount:
//           (json['extraDiscountInAmount'] ?? 0.0 as num?)?.toDouble(),
//       transactionId: json['transactionId'] ?? "00000",
//       netPrice: (json['netPrice'] ?? 0.0).toDouble(),
//       gstIsIncludingOrExcluding: json['gstIsIncludingOrExcluding'] ?? '',
//     );
//   }

//   /// Convert this instance to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'orderId': orderId,
//       'userId': userId,
//       'vendorId': vendorId,
//       'adminId': adminId,
//       'appointmentNo': appointmentNo,
//       'services': services.map((e) => e.toJson()).toList(),
//       'status': status,
//       'totalPrice': totalPrice,
//       'subtatal': subtatal,
//       'platformFees': platformFees,
//       'payment': payment,
//       'serviceDuration': serviceDuration,
//       'serviceDate': Timestamp.fromDate(serviceDate),
//       'serviceStartTime': Timestamp.fromDate(serviceStartTime),
//       'serviceEndTime': Timestamp.fromDate(serviceEndTime),
//       'userNote': userNote,
//       'userModel': userModel.toJson(),
//       'timeStampList': timeStampList.map((e) => e.toJson()).toList(),
//       'isUpdate': isUpdate,
//       'isMadual': isMadual,
//       'gstAmount': gstAmount,
//       'gstNo': gstNo,
//       'discountInPer': discountInPer,
//       'discountAmount': discountAmount,
//       'extraDiscountInPer': extraDiscountInPer,
//       'extraDiscountInAmount': extraDiscountInAmount,
//       'transactionId': transactionId,
//       'netPrice': netPrice,
//       'gstIsIncludingOrExcluding': gstIsIncludingOrExcluding,
//     };
//   }

//   /// CopyWith method for creating a modified copy of this instance.
//   AppointModel copyWith({
//     String? orderId,
//     String? userId,
//     String? vendorId,
//     String? adminId,
//     int? appointmentNo,
//     List<ServiceModel>? services,
//     String? status,
//     double? totalPrice,
//     double? subtatal,
//     double? platformFees,
//     String? payment,
//     int? serviceDuration,
//     DateTime? serviceDate,
//     DateTime? serviceStartTime,
//     DateTime? serviceEndTime,
//     String? userNote,
//     UserModel? userModel,
//     List<TimeStampModel>? timeStampList,
//     bool? isUpdate,
//     bool? isMadual,
//     double? gstAmount,
//     String? gstNo,
//     double? discountInPer,
//     double? discountAmount,
//     double? extraDiscountInPer,
//     double? extraDiscountInAmount,
//     String? transactionId,
//     double? netPrice,
//     String? gstIsIncludingOrExcluding,
//   }) {
//     return AppointModel(
//       orderId: orderId ?? this.orderId,
//       userId: userId ?? this.userId,
//       vendorId: vendorId ?? this.vendorId,
//       adminId: adminId ?? this.adminId,
//       appointmentNo: appointmentNo ?? this.appointmentNo,
//       services: services ?? this.services,
//       status: status ?? this.status,
//       totalPrice: totalPrice ?? this.totalPrice,
//       subtatal: subtatal ?? this.subtatal,
//       platformFees: platformFees ?? this.platformFees,
//       payment: payment ?? this.payment,
//       serviceDuration: serviceDuration ?? this.serviceDuration,
//       serviceDate: serviceDate ?? this.serviceDate,
//       serviceStartTime: serviceStartTime ?? this.serviceStartTime,
//       serviceEndTime: serviceEndTime ?? this.serviceEndTime,
//       userNote: userNote ?? this.userNote,
//       userModel: userModel ?? this.userModel,
//       timeStampList: timeStampList ?? this.timeStampList,
//       isUpdate: isUpdate ?? this.isUpdate,
//       isMadual: isMadual ?? this.isMadual,
//       gstAmount: gstAmount ?? this.gstAmount,
//       gstNo: gstNo ?? this.gstNo,
//       discountInPer: discountInPer ?? this.discountInPer,
//       discountAmount: discountAmount ?? this.discountAmount,
//       extraDiscountInPer: extraDiscountInPer ?? this.extraDiscountInPer,
//       extraDiscountInAmount:
//           extraDiscountInAmount ?? this.extraDiscountInAmount,
//       transactionId: transactionId ?? this.transactionId,
//       netPrice: netPrice ?? this.netPrice,
//       gstIsIncludingOrExcluding:
//           gstIsIncludingOrExcluding ?? this.gstIsIncludingOrExcluding,
//     );
//   }
// }
