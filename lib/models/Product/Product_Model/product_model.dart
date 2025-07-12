import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:samay_admin_plan/models/timestamp_model/timestamp_model.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final String imgUrl;
  final String productFor;
  final String salonId;
  final String adminId;
  final String brandName;
  final String brandID;
  final String cateName; // renamed
  final String cateId; // renamed
  final String subCateName; // added
  final String subCateId; // added
  final String branchName; // added
  final String branchId; // added
  final int stockQuantity;
  final bool visibility;
  DateTime? expiryDate;
  final double originalPrice;
  final double discountPer;
  final double discountPrice;
  final String? productCode;
  final TimeStampModel? timeStampModel;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imgUrl,
    required this.productFor,
    required this.salonId,
    required this.adminId,
    required this.brandName,
    required this.brandID,
    required this.cateName, // renamed
    required this.cateId, // renamed
    required this.subCateName, // added
    required this.subCateId, // added
    required this.branchName, // added
    required this.branchId, // added
    required this.stockQuantity,
    required this.visibility,
    DateTime? expiryDate,
    required this.originalPrice,
    required this.discountPer,
    required this.discountPrice,
    this.productCode,
    this.timeStampModel,
  }) : expiryDate = expiryDate ?? DateTime.now();

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imgUrl: json['imgUrl'],
      productFor: json['productFor'],
      salonId: json['salonId'] ?? '',
      adminId: json['adminId'] ?? '',
      brandName: json['brandName'],
      brandID: json['brandID'],
      cateName: json['cateName'], // renamed
      cateId: json['cateId'], // renamed
      subCateName: json['subCateName'], // added
      subCateId: json['subCateId'], // added
      branchName: json['branchName'], // added
      branchId: json['branchId'], // added
      stockQuantity: json['stockQuantity'],
      visibility: json['visibility'],
      expiryDate:
          (json['expiryDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      originalPrice: (json['originalPrice'] as num).toDouble(),
      discountPer: (json['discountPer'] as num).toDouble(),
      discountPrice: (json['discountPrice'] as num).toDouble(),
      productCode: json['productCode'],
      timeStampModel: json['timeStampModel'] != null
          ? TimeStampModel.fromJson(json['timeStampModel'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imgUrl': imgUrl,
      'productFor': productFor,
      'salonId': salonId,
      'adminId': adminId,
      'brandName': brandName,
      'brandID': brandID,
      'cateName': cateName, // renamed
      'cateId': cateId, // renamed
      'subCateName': subCateName, // added
      'subCateId': subCateId, // added
      'branchName': branchName, // added
      'branchId': branchId, // added
      'stockQuantity': stockQuantity,
      'visibility': visibility,
      'expiryDate': Timestamp.fromDate(expiryDate!),
      'originalPrice': originalPrice,
      'discountPer': discountPer,
      'discountPrice': discountPrice,
      'productCode': productCode,
      'timeStampModel': timeStampModel?.toJson(),
    };
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    String? imgUrl,
    String? productFor,
    String? salonId,
    String? adminId,
    String? brandName,
    String? brandID,
    String? cateName, // renamed
    String? cateId, // renamed
    String? subCateName, // added
    String? subCateId, // added
    String? branchName, // added
    String? branchId, // added
    int? stockQuantity,
    bool? visibility,
    DateTime? expiryDate,
    double? originalPrice,
    double? discountPer,
    double? discountPrice,
    String? productCode,
    TimeStampModel? timeStampModel,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imgUrl: imgUrl ?? this.imgUrl,
      productFor: productFor ?? this.productFor,
      salonId: salonId ?? this.salonId,
      adminId: adminId ?? this.adminId,
      brandName: brandName ?? this.brandName,
      brandID: brandID ?? this.brandID,
      cateName: cateName ?? this.cateName, // renamed
      cateId: cateId ?? this.cateId, // renamed
      subCateName: subCateName ?? this.subCateName, // added
      subCateId: subCateId ?? this.subCateId, // added
      branchName: branchName ?? this.branchName, // added
      branchId: branchId ?? this.branchId, // added
      stockQuantity: stockQuantity ?? this.stockQuantity,
      visibility: visibility ?? this.visibility,
      expiryDate: expiryDate ?? this.expiryDate,
      originalPrice: originalPrice ?? this.originalPrice,
      discountPer: discountPer ?? this.discountPer,
      discountPrice: discountPrice ?? this.discountPrice,
      productCode: productCode ?? this.productCode,
      timeStampModel: timeStampModel ?? this.timeStampModel,
    );
  }
}
