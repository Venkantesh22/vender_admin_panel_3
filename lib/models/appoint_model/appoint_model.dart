// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:samay_admin_plan/models/service_model/service_model.dart';
import 'package:samay_admin_plan/models/user_model/user_model.dart';
import 'package:samay_admin_plan/models/timestamp_model/timestamp_model.dart';

// class AppointModel {
//   final String orderId;
//   final String userId;
//   final String vendorId;
//   final String adminId;
//   final int appointmentNo;
//   final List<ServiceModel> services;
//   final String status;
//   final double grandTotalPrice;
//   final double serviceTotalPrice;
//   final double subTotal;
//   final double platformFees;
//   final String payment;
//   final String serviceAt;
//   final int serviceDuration;
//   final DateTime serviceDate;
//   final DateTime serviceStartTime;
//   final DateTime serviceEndTime;
//   final String userNote;
//   final UserModel userModel;
//   final List<TimeStampModel> timeStampList;
//   final bool isUpdate;
//   final bool isManual;
//   final double gstAmount;
//   final String gstNo;
//   final double netPrice;
//   final String gstIsIncludingOrExcluding;
//   final String? serviceAddress;
//   double? discountInPer;
//   double? discountAmount;
//   double? extraDiscountInPer;
//   double? extraDiscountInPerAMT;
//   double? extraDiscountInAmount;
//   String? transactionId;
//   String? billingId; // New variable
//   String? staffId; // New variable
//   ProductBillModel? productBillModel;
//   ServiceBillModel? serviceBillModel;
//   // ------update variables start here------

//   AppointModel(
//       {required this.orderId,
//       required this.userId,
//       required this.vendorId,
//       required this.adminId,
//       required this.appointmentNo,
//       required this.services,
//       required this.status,
//       required this.grandTotalPrice,
//       required this.serviceTotalPrice,
//       required this.subTotal,
//       required this.platformFees,
//       required this.payment,
//       required this.serviceDuration,
//       required this.serviceDate,
//       required this.serviceStartTime,
//       required this.serviceEndTime,
//       required this.userNote,
//       required this.userModel,
//       required this.timeStampList,
//       this.isUpdate = false,
//       this.isManual = false,
//       required this.gstAmount,
//       required this.gstNo,
//       required this.netPrice,
//       required this.gstIsIncludingOrExcluding,
//       required this.serviceAt,
//       this.serviceAddress = "No Address Defined",
//       this.discountInPer = 0.0,
//       this.discountAmount,
//       this.extraDiscountInPer = 0.0,
//       this.extraDiscountInPerAMT = 0.0,
//       this.extraDiscountInAmount = 0.0,
//       this.transactionId,
//       this.billingId,
//       this.staffId,
//       this.productBillModel,
//       this.serviceBillModel});

//   /// Convert Firestore JSON to `AppointModel`
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
//       serviceTotalPrice: (json['serviceTotalPrice'] ?? 0.0).toDouble(),
//       grandTotalPrice: (json['grandTotalPrice'] ?? 0.0).toDouble(),
//       subTotal: (json['subTotal'] ?? 0.0).toDouble(),
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
//       productBillModel: json['productBillModel'] != null
//           ? ProductBillModel.fromJson(json['productBillModel'])
//           : null,
//       serviceBillModel: json['serviceBillModel'] != null
//           ? ServiceBillModel.fromJson(json['serviceBillModel'])
//           : null,
//       timeStampList: (json['timeStampList'] as List?)
//               ?.map((item) => TimeStampModel.fromJson(item))
//               .toList() ??
//           [],
//       isUpdate: json['isUpdate'] ?? false,
//       isManual: json['isManual'] ?? false,
//       gstAmount: (json['gstAmount'] ?? 0.0).toDouble(),
//       gstNo: json['gstNo'] ?? '',
//       netPrice: (json['netPrice'] ?? 0.0).toDouble(),
//       gstIsIncludingOrExcluding:
//           json['gstIsIncludingOrExcluding'] ?? 'including',
//       serviceAt: json['serviceAt'] ?? 'Salon',
//       serviceAddress: json['serviceAddress'] ?? 'No Address fromJSAN',
//       discountInPer: (json['discountInPer'] ?? 0.0 as num?)?.toDouble(),
//       discountAmount: (json['discountAmount'] ?? 0.0 as num?)?.toDouble(),
//       extraDiscountInPer:
//           (json['extraDiscountInPer'] ?? 0.0 as num?)?.toDouble(),
//       extraDiscountInPerAMT:
//           (json['extraDiscountInPerAMT'] ?? 0.0 as num?)?.toDouble(),
//       extraDiscountInAmount:
//           (json['extraDiscountInAmount'] ?? 0.0 as num?)?.toDouble(),
//       transactionId: json['transactionId'],
//       billingId: json['billingId'] ?? '',
//       staffId: json['staffId'] ?? '',
//     );
//   }

//   /// Convert `AppointModel` to Firestore JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'orderId': orderId,
//       'userId': userId,
//       'vendorId': vendorId,
//       'adminId': adminId,
//       'appointmentNo': appointmentNo,
//       'services': services.map((e) => e.toJson()).toList(),
//       'status': status,
//       'grandTotalPrice': grandTotalPrice,
//       'serviceTotalPrice': serviceTotalPrice,
//       'subTotal': subTotal,
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
//       'isManual': isManual,
//       'gstAmount': gstAmount,
//       'gstNo': gstNo,
//       'netPrice': netPrice,
//       'gstIsIncludingOrExcluding': gstIsIncludingOrExcluding,
//       'serviceAt': serviceAt,
//       'serviceAddress': serviceAddress,
//       'discountInPer': discountInPer,
//       'discountAmount': discountAmount,
//       'extraDiscountInPer': extraDiscountInPer,
//       'extraDiscountInPerAMT': extraDiscountInPerAMT,
//       'extraDiscountInAmount': extraDiscountInAmount,
//       'transactionId': transactionId,
//       'billingId': billingId,
//       'staffId': staffId,
//       'productBillModel': productBillModel!.toJson(),
//       'serviceBillModel': serviceBillModel!.toJson(),
//     };
//   }

//   /// Copy Method for Updating Specific Fields
//   AppointModel copyWith({
//     List<ServiceModel>? services,
//     UserModel? userModel,
//     String? status,
//     double? serviceTotalPrice,
//     double? grandTotalPrice,
//     double? subTotal,
//     double? platformFees,
//     String? payment,
//     int? serviceDuration,
//     DateTime? serviceDate,
//     DateTime? serviceStartTime,
//     DateTime? serviceEndTime,
//     String? userNote,
//     List<TimeStampModel>? timeStampList,
//     bool? isUpdate,
//     bool? isManual,
//     double? gstAmount,
//     String? gstNo,
//     double? netPrice,
//     String? gstIsIncludingOrExcluding,
//     String? serviceAt,
//     String? serviceAddress,
//     double? discountInPer,
//     double? discountAmount,
//     double? extraDiscountInPer,
//     double? extraDiscountInPerAMT,
//     double? extraDiscountInAmount,
//     String? transactionId,
//     String? billingId,
//     String? staffId,
//     ProductBillModel? productBillModel,
//     ServiceBillModel? serviceBillModel,
//   }) {
//     return AppointModel(
//       orderId: orderId,
//       userId: userId,
//       vendorId: vendorId,
//       adminId: adminId,
//       appointmentNo: appointmentNo,
//       services: services ?? this.services,
//       status: status ?? this.status,
//       grandTotalPrice: grandTotalPrice ?? this.grandTotalPrice,
//       serviceTotalPrice: serviceTotalPrice ?? this.serviceTotalPrice,
//       subTotal: subTotal ?? this.subTotal,
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
//       isManual: isManual ?? this.isManual,
//       gstAmount: gstAmount ?? this.gstAmount,
//       gstNo: gstNo ?? this.gstNo,
//       netPrice: netPrice ?? this.netPrice,
//       gstIsIncludingOrExcluding:
//           gstIsIncludingOrExcluding ?? this.gstIsIncludingOrExcluding,
//       serviceAt: serviceAt ?? this.serviceAt,
//       serviceAddress: serviceAddress ?? this.serviceAddress,
//       discountInPer: discountInPer ?? this.discountInPer,
//       discountAmount: discountAmount ?? this.discountAmount,
//       extraDiscountInPer: extraDiscountInPer ?? this.extraDiscountInPer,
//       extraDiscountInPerAMT:
//           extraDiscountInPerAMT ?? this.extraDiscountInPerAMT,
//       extraDiscountInAmount:
//           extraDiscountInAmount ?? this.extraDiscountInAmount,
//       transactionId: transactionId ?? this.transactionId,
//       billingId: billingId ?? this.billingId,
//       staffId: staffId ?? this.staffId,
//       productBillModel: productBillModel ?? this.productBillModel,
//       serviceBillModel: serviceBillModel ?? this.serviceBillModel,
//     );
//   }
// }

// class AppointModel {
//   final String orderId;
//   final String userId;
//   final String vendorId;
//   final String adminId;
//   // final int appointmentNo;
//   // final List<ServiceModel> services;
//   // final String status;
//   // final double grandTotalPrice;
//   // final double serviceTotalPrice;
//   // final double subTotal;
//   // final double platformFees;
//   // final String serviceAt;
//   // final int serviceDuration;
//   // final DateTime serviceDate;
//   // final DateTime serviceStartTime;
//   // final DateTime serviceEndTime;
//   // final String userNote;
//   final UserModel userModel;
//   final List<TimeStampModel> timeStampList;
//   final bool isUpdate;
//   final bool isManual;
//   // final double gstAmount;
//   final String gstNo;
//   // final double netPrice;
//   // final String gstIsIncludingOrExcluding;
//   // final String? serviceAddress;
//   // final double? discountInPer;
//   // final double? discountAmount;
//   final double? extraDiscountInPer;
//   final double? extraDiscountInPerAMT;
//   final double? extraDiscountInAmount;
//   final String? transactionId;
//   final String? billingId;
//   // final String? staffId;
//   final ProductBillModel? productBillModel;
//   final ServiceBillModel? serviceBillModel;
//   final AppointmentInfo? appointmentInfo;

//   // NEW billing fields
//   final double subTotalBill;
//   final double discountBill;
//   final double netPriceBill;
//   final double platformFeeBill;
//   final double taxableAmountBill;
//   final double gstAmountBill;
//   final double finalTotalBill;
//   final String payment;

//   AppointModel({
//     required this.orderId,
//     required this.userId,
//     required this.vendorId,
//     required this.adminId,
//     required this.appointmentNo,
//     required this.services,
//     required this.status,
//     required this.grandTotalPrice,
//     required this.serviceTotalPrice,
//     required this.subTotal,
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
//     this.isManual = false,
//     required this.gstAmount,
//     required this.gstNo,
//     required this.netPrice,
//     required this.gstIsIncludingOrExcluding,
//     required this.serviceAt,
//     this.serviceAddress = "No Address Defined",
//     this.discountInPer = 0.0,
//     this.discountAmount,
//     this.extraDiscountInPer = 0.0,
//     this.extraDiscountInPerAMT = 0.0,
//     this.extraDiscountInAmount = 0.0,
//     this.transactionId,
//     this.billingId,
//     this.staffId,
//     this.productBillModel,
//     this.serviceBillModel,
//     this.appointmentInfo,

//     // Billing fields, all null-safe
//     this.subTotalBill = 0.0,
//     this.discountBill = 0.0,
//     this.netPriceBill = 0.0,
//     this.platformFeeBill = 0.0,
//     this.taxableAmountBill = 0.0,
//     this.gstAmountBill = 0.0,
//     this.finalTotalBill = 0.0,
//   });

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
//       serviceTotalPrice: (json['serviceTotalPrice'] ?? 0.0).toDouble(),
//       grandTotalPrice: (json['grandTotalPrice'] ?? 0.0).toDouble(),
//       subTotal: (json['subTotal'] ?? 0.0).toDouble(),
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
//       productBillModel: json['productBillModel'] != null
//           ? ProductBillModel.fromJson(json['productBillModel'])
//           : null,
//       serviceBillModel: json['serviceBillModel'] != null
//           ? ServiceBillModel.fromJson(json['serviceBillModel'])
//           : null,
//       appointmentInfo: json['appointmentInfo'] != null
//           ? AppointmentInfo.fromJson(json['appointmentInfo'])
//           : null,
//       timeStampList: (json['timeStampList'] as List?)
//               ?.map((item) => TimeStampModel.fromJson(item))
//               .toList() ??
//           [],
//       isUpdate: json['isUpdate'] ?? false,
//       isManual: json['isManual'] ?? false,
//       gstAmount: (json['gstAmount'] ?? 0.0).toDouble(),
//       gstNo: json['gstNo'] ?? '',
//       netPrice: (json['netPrice'] ?? 0.0).toDouble(),
//       gstIsIncludingOrExcluding:
//           json['gstIsIncludingOrExcluding'] ?? 'including',
//       serviceAt: json['serviceAt'] ?? 'Salon',
//       serviceAddress: json['serviceAddress'] ?? 'No Address Defined',
//       discountInPer: (json['discountInPer'] ?? 0.0 as num?)?.toDouble(),
//       discountAmount: (json['discountAmount'] ?? 0.0 as num?)?.toDouble(),
//       extraDiscountInPer:
//           (json['extraDiscountInPer'] ?? 0.0 as num?)?.toDouble(),
//       extraDiscountInPerAMT:
//           (json['extraDiscountInPerAMT'] ?? 0.0 as num?)?.toDouble(),
//       extraDiscountInAmount:
//           (json['extraDiscountInAmount'] ?? 0.0 as num?)?.toDouble(),
//       transactionId: json['transactionId'],
//       billingId: json['billingId'],
//       staffId: json['staffId'],
//       // New billing fields
//       subTotalBill: (json['subTotalBill'] ?? 0.0).toDouble(),
//       discountBill: (json['discountBill'] ?? 0.0).toDouble(),
//       netPriceBill: (json['netPriceBill'] ?? 0.0).toDouble(),
//       platformFeeBill: (json['platformFeeBill'] ?? 0.0).toDouble(),
//       taxableAmountBill: (json['taxableAmountBill'] ?? 0.0).toDouble(),
//       gstAmountBill: (json['gstAmountBill'] ?? 0.0).toDouble(),
//       finalTotalBill: (json['finalTotalBill'] ?? 0.0).toDouble(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'orderId': orderId,
//       'userId': userId,
//       'vendorId': vendorId,
//       'adminId': adminId,
//       'appointmentNo': appointmentNo,
//       'services': services.map((e) => e.toJson()).toList(),
//       'status': status,
//       'grandTotalPrice': grandTotalPrice,
//       'serviceTotalPrice': serviceTotalPrice,
//       'subTotal': subTotal,
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
//       'isManual': isManual,
//       'gstAmount': gstAmount,
//       'gstNo': gstNo,
//       'netPrice': netPrice,
//       'gstIsIncludingOrExcluding': gstIsIncludingOrExcluding,
//       'serviceAt': serviceAt,
//       'serviceAddress': serviceAddress,
//       'discountInPer': discountInPer,
//       'discountAmount': discountAmount,
//       'extraDiscountInPer': extraDiscountInPer,
//       'extraDiscountInPerAMT': extraDiscountInPerAMT,
//       'extraDiscountInAmount': extraDiscountInAmount,
//       'transactionId': transactionId,
//       'billingId': billingId,
//       'staffId': staffId,
//       'productBillModel': productBillModel?.toJson(),
//       'serviceBillModel': serviceBillModel?.toJson(),
//       'appointmentInfo': appointmentInfo?.toJson(),
//       // New billing fields
//       'subTotalBill': subTotalBill,
//       'discountBill': discountBill,
//       'netPriceBill': netPriceBill,
//       'platformFeeBill': platformFeeBill,
//       'taxableAmountBill': taxableAmountBill,
//       'gstAmountBill': gstAmountBill,
//       'finalTotalBill': finalTotalBill,
//     };
//   }

//   AppointModel copyWith({
//     List<ServiceModel>? services,
//     UserModel? userModel,
//     String? status,
//     double? serviceTotalPrice,
//     double? grandTotalPrice,
//     double? subTotal,
//     double? platformFees,
//     String? payment,
//     int? serviceDuration,
//     DateTime? serviceDate,
//     DateTime? serviceStartTime,
//     DateTime? serviceEndTime,
//     String? userNote,
//     List<TimeStampModel>? timeStampList,
//     bool? isUpdate,
//     bool? isManual,
//     double? gstAmount,
//     String? gstNo,
//     double? netPrice,
//     String? gstIsIncludingOrExcluding,
//     String? serviceAt,
//     String? serviceAddress,
//     double? discountInPer,
//     double? discountAmount,
//     double? extraDiscountInPer,
//     double? extraDiscountInPerAMT,
//     double? extraDiscountInAmount,
//     String? transactionId,
//     String? billingId,
//     String? staffId,
//     ProductBillModel? productBillModel,
//     ServiceBillModel? serviceBillModel,
//     AppointmentInfo? appointmentInfo,
//     // New billing fields
//     double? subTotalBill,
//     double? discountBill,
//     double? netPriceBill,
//     double? platformFeeBill,
//     double? taxableAmountBill,
//     double? gstAmountBill,
//     double? finalTotalBill,
//   }) {
//     return AppointModel(
//       orderId: orderId,
//       userId: userId,
//       vendorId: vendorId,
//       adminId: adminId,
//       appointmentNo: appointmentNo,
//       services: services ?? this.services,
//       status: status ?? this.status,
//       grandTotalPrice: grandTotalPrice ?? this.grandTotalPrice,
//       serviceTotalPrice: serviceTotalPrice ?? this.serviceTotalPrice,
//       subTotal: subTotal ?? this.subTotal,
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
//       isManual: isManual ?? this.isManual,
//       gstAmount: gstAmount ?? this.gstAmount,
//       gstNo: gstNo ?? this.gstNo,
//       netPrice: netPrice ?? this.netPrice,
//       gstIsIncludingOrExcluding:
//           gstIsIncludingOrExcluding ?? this.gstIsIncludingOrExcluding,
//       serviceAt: serviceAt ?? this.serviceAt,
//       serviceAddress: serviceAddress ?? this.serviceAddress,
//       discountInPer: discountInPer ?? this.discountInPer,
//       discountAmount: discountAmount ?? this.discountAmount,
//       extraDiscountInPer: extraDiscountInPer ?? this.extraDiscountInPer,
//       extraDiscountInPerAMT:
//           extraDiscountInPerAMT ?? this.extraDiscountInPerAMT,
//       extraDiscountInAmount:
//           extraDiscountInAmount ?? this.extraDiscountInAmount,
//       transactionId: transactionId ?? this.transactionId,
//       billingId: billingId ?? this.billingId,
//       staffId: staffId ?? this.staffId,
//       productBillModel: productBillModel ?? this.productBillModel,
//       serviceBillModel: serviceBillModel ?? this.serviceBillModel,
//       appointmentInfo: appointmentInfo ?? this.appointmentInfo,
//       // New billing fields
//       subTotalBill: subTotalBill ?? this.subTotalBill,
//       discountBill: discountBill ?? this.discountBill,
//       netPriceBill: netPriceBill ?? this.netPriceBill,
//       platformFeeBill: platformFeeBill ?? this.platformFeeBill,
//       taxableAmountBill: taxableAmountBill ?? this.taxableAmountBill,
//       gstAmountBill: gstAmountBill ?? this.gstAmountBill,
//       finalTotalBill: finalTotalBill ?? this.finalTotalBill,
//     );
//   }
// }

class AppointModel {
  final String orderId;
  final String userId;
  final String vendorId;
  final String adminId;
  final UserModel userModel;
  final List<TimeStampModel> timeStampList;
  final bool isUpdate;
  final bool isManual;
  final String gstNo;
  final double? extraDiscountInPer;
  final double? extraDiscountInPerAMT;
  final double? extraDiscountInAmount;
  final String? transactionId;
  final String? billingId;
  final double subTotalBill;
  final double discountBill;
  final double netPriceBill;
  final double platformFeeBill;
  final double taxableAmountBill;
  final double gstAmountBill;
  final double finalTotalBill;
  final String payment;
  final AppointmentInfo? appointmentInfo;
  final ProductBillModel? productBillModel;
  final ServiceBillModel? serviceBillModel;

  const AppointModel({
    required this.orderId,
    required this.userId,
    required this.vendorId,
    required this.adminId,
    required this.userModel,
    this.timeStampList = const <TimeStampModel>[],
    this.isUpdate = false,
    this.isManual = true,  //** True for Admin-panel, False for User APP  */
    this.gstNo = '',
    this.extraDiscountInPer = 0.0,
    this.extraDiscountInPerAMT = 0.0,
    this.extraDiscountInAmount = 0.0,
    this.transactionId = '',
    this.billingId,
    this.subTotalBill = 0.0,
    this.discountBill = 0.0,
    this.netPriceBill = 0.0,
    this.platformFeeBill = 0.0,
    this.taxableAmountBill = 0.0,
    this.gstAmountBill = 0.0,
    this.finalTotalBill = 0.0,
    this.payment = '',
    this.appointmentInfo,
    this.productBillModel,
    this.serviceBillModel,
  });

  AppointModel copyWith({
    String? orderId,
    String? userId,
    String? vendorId,
    String? adminId,
    UserModel? userModel,
    List<TimeStampModel>? timeStampList,
    bool? isUpdate,
    bool? isManual,
    String? gstNo,
    double? extraDiscountInPer,
    double? extraDiscountInPerAMT,
    double? extraDiscountInAmount,
    String? transactionId,
    String? billingId,
    ProductBillModel? productBillModel,
    ServiceBillModel? serviceBillModel,
    double? subTotalBill,
    double? discountBill,
    double? netPriceBill,
    double? platformFeeBill,
    double? taxableAmountBill,
    double? gstAmountBill,
    double? finalTotalBill,
    String? payment,
    AppointmentInfo? appointmentInfo,
  }) {
    return AppointModel(
      orderId: orderId ?? this.orderId,
      userId: userId ?? this.userId,
      vendorId: vendorId ?? this.vendorId,
      adminId: adminId ?? this.adminId,
      userModel: userModel ?? this.userModel,
      timeStampList: timeStampList ?? this.timeStampList,
      isUpdate: isUpdate ?? this.isUpdate,
      isManual: isManual ?? this.isManual,
      gstNo: gstNo ?? this.gstNo,
      extraDiscountInPer: extraDiscountInPer ?? this.extraDiscountInPer,
      extraDiscountInPerAMT:
          extraDiscountInPerAMT ?? this.extraDiscountInPerAMT,
      extraDiscountInAmount:
          extraDiscountInAmount ?? this.extraDiscountInAmount,
      transactionId: transactionId ?? this.transactionId,
      billingId: billingId ?? this.billingId,
      productBillModel: productBillModel ?? this.productBillModel,
      serviceBillModel: serviceBillModel ?? this.serviceBillModel,
      subTotalBill: subTotalBill ?? this.subTotalBill,
      discountBill: discountBill ?? this.discountBill,
      netPriceBill: netPriceBill ?? this.netPriceBill,
      platformFeeBill: platformFeeBill ?? this.platformFeeBill,
      taxableAmountBill: taxableAmountBill ?? this.taxableAmountBill,
      gstAmountBill: gstAmountBill ?? this.gstAmountBill,
      finalTotalBill: finalTotalBill ?? this.finalTotalBill,
      payment: payment ?? this.payment,
      appointmentInfo: appointmentInfo ?? this.appointmentInfo,
    );
  }

  factory AppointModel.fromJson(Map<String, dynamic> json) {
    return AppointModel(
      orderId: json['orderId']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      vendorId: json['vendorId']?.toString() ?? '',
      adminId: json['adminId']?.toString() ?? '',
      userModel: json['userModel'] != null
          ? UserModel.fromJson(
              Map<String, dynamic>.from(json['userModel'] as Map))
          : (throw ArgumentError(
              'userModel is required in AppointModel.fromJson')),
      timeStampList: (json['timeStampList'] as List?)
              ?.map((e) =>
                  TimeStampModel.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList() ??
          <TimeStampModel>[],
      isUpdate: json['isUpdate'] is bool
          ? json['isUpdate'] as bool
          : (json['isUpdate'] == 1),
      isManual: json['isManual'] is bool
          ? json['isManual'] as bool
          : (json['isManual'] == 1),
      gstNo: json['gstNo']?.toString() ?? '',
      extraDiscountInPer: (json['extraDiscountInPer'] as num?)?.toDouble(),
      extraDiscountInPerAMT:
          (json['extraDiscountInPerAMT'] as num?)?.toDouble(),
      extraDiscountInAmount:
          (json['extraDiscountInAmount'] as num?)?.toDouble(),
      transactionId: json['transactionId']?.toString(),
      billingId: json['billingId']?.toString(),
      productBillModel: json['productBillModel'] != null
          ? ProductBillModel.fromJson(
              Map<String, dynamic>.from(json['productBillModel'] as Map))
          : null,
      serviceBillModel: json['serviceBillModel'] != null
          ? ServiceBillModel.fromJson(
              Map<String, dynamic>.from(json['serviceBillModel'] as Map))
          : null,
      subTotalBill: (json['subTotalBill'] as num?)?.toDouble() ?? 0.0,
      discountBill: (json['discountBill'] as num?)?.toDouble() ?? 0.0,
      netPriceBill: (json['netPriceBill'] as num?)?.toDouble() ?? 0.0,
      platformFeeBill: (json['platformFeeBill'] as num?)?.toDouble() ?? 0.0,
      taxableAmountBill: (json['taxableAmountBill'] as num?)?.toDouble() ?? 0.0,
      gstAmountBill: (json['gstAmountBill'] as num?)?.toDouble() ?? 0.0,
      finalTotalBill: (json['finalTotalBill'] as num?)?.toDouble() ?? 0.0,
      payment: json['payment']?.toString() ?? '',
      appointmentInfo: json['appointmentInfo'] != null
          ? AppointmentInfo.fromJson(
              Map<String, dynamic>.from(json['appointmentInfo'] as Map))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'userId': userId,
      'vendorId': vendorId,
      'adminId': adminId,
      'userModel': userModel.toJson(),
      'timeStampList': timeStampList.map((e) => e.toJson()).toList(),
      'isUpdate': isUpdate,
      'isManual': isManual,
      'gstNo': gstNo,
      'extraDiscountInPer': extraDiscountInPer,
      'extraDiscountInPerAMT': extraDiscountInPerAMT,
      'extraDiscountInAmount': extraDiscountInAmount,
      'transactionId': transactionId,
      'billingId': billingId,
      'productBillModel': productBillModel?.toJson(),
      'serviceBillModel': serviceBillModel?.toJson(),
      'subTotalBill': subTotalBill,
      'discountBill': discountBill,
      'netPriceBill': netPriceBill,
      'platformFeeBill': platformFeeBill,
      'taxableAmountBill': taxableAmountBill,
      'gstAmountBill': gstAmountBill,
      'finalTotalBill': finalTotalBill,
      'payment': payment,
      'appointmentInfo': appointmentInfo?.toJson(),
    };
  }

  @override
  String toString() {
    return 'AppointModel(orderId: $orderId, userId: $userId, vendorId: $vendorId, adminId: $adminId, '
        'userModel: $userModel, timeStampList: $timeStampList, isUpdate: $isUpdate, isManual: $isManual, '
        'gstNo: $gstNo, extraDiscountInPer: $extraDiscountInPer, extraDiscountInPerAMT: $extraDiscountInPerAMT, '
        'extraDiscountInAmount: $extraDiscountInAmount, transactionId: $transactionId, billingId: $billingId, '
        'productBillModel: $productBillModel, serviceBillModel: $serviceBillModel, subTotalBill: $subTotalBill, '
        'discountBill: $discountBill, netPriceBill: $netPriceBill, platformFeeBill: $platformFeeBill, '
        'taxableAmountBill: $taxableAmountBill, gstAmountBill: $gstAmountBill, finalTotalBill: $finalTotalBill, '
        'payment: $payment, appointmentInfo: $appointmentInfo)';
  }
}

class ServiceBillModel {
  final List<String> serviceListId;
  final double subTotalService;
  final double discountATMService;
  final double netPriceService;
  final double platformFee;
  final double taxableAMTService;
  final double gSTAMTService;
  final double finalAMTService;
  final String gstIsIncludingOrExcluding;

  const ServiceBillModel({
    this.serviceListId = const <String>[],
    this.subTotalService = 0.0,
    this.discountATMService = 0.0,
    this.netPriceService = 0.0,
    this.platformFee = 0.0,
    this.taxableAMTService = 0.0,
    this.gSTAMTService = 0.0,
    this.finalAMTService = 0.0,
    this.gstIsIncludingOrExcluding = "",
  });

  ServiceBillModel copyWith({
    List<String>? serviceListId,
    double? subTotalService,
    double? discountATMService,
    double? netPriceService,
    // double? platformFee,
    double? taxableAMTService,
    double? gSTAMTService,
    double? finalAMTService,
    String? gstIsIncludingOrExcluding,
  }) {
    return ServiceBillModel(
      serviceListId: serviceListId ?? this.serviceListId,
      subTotalService: subTotalService ?? this.subTotalService,
      discountATMService: discountATMService ?? this.discountATMService,
      netPriceService: netPriceService ?? this.netPriceService,
      // platformFee: platformFee ?? this.platformFee,
      taxableAMTService: taxableAMTService ?? this.taxableAMTService,
      gSTAMTService: gSTAMTService ?? this.gSTAMTService,
      finalAMTService: finalAMTService ?? this.finalAMTService,
      gstIsIncludingOrExcluding:
          gstIsIncludingOrExcluding ?? this.gstIsIncludingOrExcluding,
    );
  }

  factory ServiceBillModel.fromJson(Map<String, dynamic> json) {
    return ServiceBillModel(
      serviceListId: (json['serviceListId'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          <String>[],
      subTotalService: (json['subTotalService'] as num?)?.toDouble() ?? 0.0,
      discountATMService:
          (json['discountATMService'] as num?)?.toDouble() ?? 0.0,
      netPriceService: (json['netPriceService'] as num?)?.toDouble() ?? 0.0,
      // platformFee: (json['platformFee'] as num?)?.toDouble() ?? 0.0,
      taxableAMTService: (json['taxableAMTService'] as num?)?.toDouble() ?? 0.0,
      gSTAMTService: (json['gSTAMTService'] as num?)?.toDouble() ?? 0.0,
      finalAMTService: (json['finalAMTService'] as num?)?.toDouble() ?? 0.0,
      gstIsIncludingOrExcluding:
          (json['gstIsIncludingOrExcluding'] as String?) ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        'serviceListId': serviceListId,
        'subTotalService': subTotalService,
        'discountATMService': discountATMService,
        'netPriceService': netPriceService,
        // 'platformFee': platformFee,
        'taxableAMTService': taxableAMTService,
        'gSTAMTService': gSTAMTService,
        'finalAMTService': finalAMTService,
        'gstIsIncludingOrExcluding': gstIsIncludingOrExcluding,
      };

  // @override
  // String toString() => 'ServiceBillModel(serviceListId: $serviceListId, '
  //     'subTotalService: $subTotalService, discountATMService: $discountATMService, '
  //     'netPriceService: $netPriceService, platformFee: $platformFee, '
  //     'taxableAMTService: $taxableAMTService, gSTAMTService: $gSTAMTService, '
  //     'finalAMTService: $finalAMTService, gstIsIncludingOrExcluding: $gstIsIncludingOrExcluding)';
}

class ProductBillModel {
  final Map<String, int> productListIdQty;

  final double subTotalProduct;
  final double discountATMProduct;
  final double netPriceProduct;
  // final double platformFee;
  final double taxableAMTProduct;
  final double gSTAMTProduct;
  final double finalAMTProduct;

  const ProductBillModel({
    this.productListIdQty = const <String, int>{},
    this.subTotalProduct = 0.0,
    this.discountATMProduct = 0.0,
    this.netPriceProduct = 0.0,
    // this.platformFee = 0.0,
    this.taxableAMTProduct = 0.0,
    this.gSTAMTProduct = 0.0,
    this.finalAMTProduct = 0.0,
  });

  ProductBillModel copyWith({
    Map<String, int>? productListIdQty,
    double? subTotalProduct,
    double? discountATMProduct,
    double? netPriceProduct,
    // double? platformFee,
    double? taxableAMTProduct,
    double? gSTAMTProduct,
    double? finalAMTProduct,
  }) {
    return ProductBillModel(
      productListIdQty: productListIdQty ?? this.productListIdQty,
      subTotalProduct: subTotalProduct ?? this.subTotalProduct,
      discountATMProduct: discountATMProduct ?? this.discountATMProduct,
      netPriceProduct: netPriceProduct ?? this.netPriceProduct,
      // platformFee: platformFee ?? this.platformFee,
      taxableAMTProduct: taxableAMTProduct ?? this.taxableAMTProduct,
      gSTAMTProduct: gSTAMTProduct ?? this.gSTAMTProduct,
      finalAMTProduct: finalAMTProduct ?? this.finalAMTProduct,
    );
  }

  factory ProductBillModel.fromJson(Map<String, dynamic> json) {
    return ProductBillModel(
      productListIdQty: (json['productListIdQty'] as Map<String, dynamic>?)
              ?.map((key, value) => MapEntry(key, (value as num).toInt())) ??
          {},
      subTotalProduct: (json['subTotalProduct'] as num?)?.toDouble() ?? 0.0,
      discountATMProduct:
          (json['discountATMProduct'] as num?)?.toDouble() ?? 0.0,
      netPriceProduct: (json['netPriceProduct'] as num?)?.toDouble() ?? 0.0,
      // platformFee: (json['platformFee'] as num?)?.toDouble() ?? 0.0,
      taxableAMTProduct: (json['taxableAMTProduct'] as num?)?.toDouble() ?? 0.0,
      gSTAMTProduct: (json['gSTAMTProduct'] as num?)?.toDouble() ?? 0.0,
      finalAMTProduct: (json['finalAMTProduct'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'productListIdQty': productListIdQty,
        'subTotalProduct': subTotalProduct,
        'discountATMProduct': discountATMProduct,
        'netPriceProduct': netPriceProduct,
        // 'platformFee': platformFee,
        'taxableAMTProduct': taxableAMTProduct,
        'gSTAMTProduct': gSTAMTProduct,
        'finalAMTProduct': finalAMTProduct,
      };

  // @override
  // String toString() => 'ProductBillModel(productListIdQty: $productListIdQty, '
  //     'subTotalProduct: $subTotalProduct, discountATMProduct: $discountATMProduct, '
  //     'netPriceProduct: $netPriceProduct, platformFee: $platformFee, '
  //     'taxableAMTProduct: $taxableAMTProduct, gSTAMTProduct: $gSTAMTProduct, '
  //     'finalAMTProduct: $finalAMTProduct)';
}

class AppointmentInfo {
  final String serviceAt; // Place: Salon / Home etc.
  final int serviceDuration; // Duration in minutes
  final DateTime serviceDate; // Date of appointment
  final DateTime serviceStartTime; // Start time
  final DateTime serviceEndTime; // End time
  final String userNote; // Notes from user
  final int appointmentNo; // Appointment number
  final String? serviceAddress; // Optional address if at home
  final String? staffId; // Optional staff assigned
  final String status;

  const AppointmentInfo({
    required this.serviceAt,
    required this.serviceDuration,
    required this.serviceDate,
    required this.serviceStartTime,
    required this.serviceEndTime,
    required this.userNote,
    required this.appointmentNo,
    this.serviceAddress,
    this.staffId,
    required this.status,
  });

  /// Copy with
  AppointmentInfo copyWith({
    String? serviceAt,
    int? serviceDuration,
    DateTime? serviceDate,
    DateTime? serviceStartTime,
    DateTime? serviceEndTime,
    String? userNote,
    int? appointmentNo,
    String? serviceAddress,
    String? staffId,
    String? status,
  }) {
    return AppointmentInfo(
      serviceAt: serviceAt ?? this.serviceAt,
      serviceDuration: serviceDuration ?? this.serviceDuration,
      serviceDate: serviceDate ?? this.serviceDate,
      serviceStartTime: serviceStartTime ?? this.serviceStartTime,
      serviceEndTime: serviceEndTime ?? this.serviceEndTime,
      userNote: userNote ?? this.userNote,
      appointmentNo: appointmentNo ?? this.appointmentNo,
      serviceAddress: serviceAddress ?? this.serviceAddress,
      staffId: staffId ?? this.staffId,
      status: status ?? this.status,
    );
  }

  /// JSON Factory
  factory AppointmentInfo.fromJson(Map<String, dynamic> json) {
    return AppointmentInfo(
      serviceAt: json['serviceAt'] as String? ?? "",
      serviceDuration: (json['serviceDuration'] as num?)?.toInt() ?? 0,
      serviceDate: (json['serviceDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      serviceStartTime: (json['serviceStartTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      serviceEndTime: (json['serviceEndTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      userNote: json['userNote'] as String? ?? "",
      appointmentNo: (json['appointmentNo'] as num?)?.toInt() ?? 0,
      serviceAddress: json['serviceAddress'] as String?,
      staffId: json['staffId'] as String?,
      status: json['status'] as String? ?? 'error',
    );
  }

  /// JSON Serializer
  Map<String, dynamic> toJson() => {
        'serviceAt': serviceAt,
         'serviceDuration': serviceDuration,
      'serviceDate': Timestamp.fromDate(serviceDate),
      'serviceStartTime': Timestamp.fromDate(serviceStartTime),
      'serviceEndTime': Timestamp.fromDate(serviceEndTime),
        'userNote': userNote,
        'appointmentNo': appointmentNo,
        'serviceAddress': serviceAddress,
        'staffId': staffId,
        'status': status,
      };

  @override
  String toString() {
    return 'AppointmentInfo(serviceAt: $serviceAt, serviceDuration: $serviceDuration, '
        'serviceDate: $serviceDate, serviceStartTime: $serviceStartTime, '
        'serviceEndTime: $serviceEndTime, userNote: $userNote, '
        'appointmentNo: $appointmentNo, serviceAddress: $serviceAddress, '
        'staffId: $staffId)';
  }
}
