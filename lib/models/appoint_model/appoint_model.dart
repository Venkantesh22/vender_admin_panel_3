// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:samay_admin_plan/models/user_model/user_model.dart';
import 'package:samay_admin_plan/models/timestamp_model/timestamp_model.dart';



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
