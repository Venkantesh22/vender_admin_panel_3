import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:samay_admin_plan/models/timestamp_model/timestamp_model.dart';

class ProductModel {
  final String? id;
  final String? name;
  final String? description;
  final String? imgUrl;
  final String? productFor;
  final String? brandName;
  final String? brandID;
  final String? brandCateName;
  final String? brandCateId;
  final int? stockQuantity;
  final bool? isAvailable;
  final DateTime? expiryDate;
  final double? originalPrice;
  final double? discountPer;
  final double? discountPrice;
  final String? productCode;
  final TimeStampModel? timeStampModel;

  ProductModel({
    this.id,
    this.name,
    this.description,
    this.imgUrl,
    this.productFor = "Both",
    this.brandName,
    this.brandID,
    this.brandCateName,
    this.brandCateId,
    this.stockQuantity,
    this.isAvailable,
    this.expiryDate,
    this.originalPrice,
    this.discountPer,
    this.discountPrice,
    this.productCode,
    this.timeStampModel,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imgUrl: json['imgUrl'],
      productFor: json['productFor'],
      brandName: json['brandName'],
      brandID: json['brandID'],
      brandCateName: json['brandCateName'],
      brandCateId: json['brandCateId'],
      stockQuantity: json['stockQuantity'],
      isAvailable: json['isAvailable'],
      expiryDate:
          (json['expiryDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      originalPrice: (json['originalPrice'] as num?)?.toDouble(),
      discountPer: (json['discountPer'] as num?)?.toDouble(),
      discountPrice: (json['discountPrice'] as num?)?.toDouble(),
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
      'brandName': brandName,
      'brandID': brandID,
      'brandCateName': brandCateName,
      'brandCateId': brandCateId,
      'stockQuantity': stockQuantity,
      'isAvailable': isAvailable,
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
    String? brandName,
    String? brandID,
    String? brandCateName,
    String? brandCateId,
    int? stockQuantity,
    bool? isAvailable,
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
      brandName: brandName ?? this.brandName,
      brandID: brandID ?? this.brandID,
      brandCateName: brandCateName ?? this.brandCateName,
      brandCateId: brandCateId ?? this.brandCateId,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      isAvailable: isAvailable ?? this.isAvailable,
      expiryDate: expiryDate ?? this.expiryDate,
      originalPrice: originalPrice ?? this.originalPrice,
      discountPer: discountPer ?? this.discountPer,
      discountPrice: discountPrice ?? this.discountPrice,
      productCode: productCode ?? this.productCode,
      timeStampModel: timeStampModel ?? this.timeStampModel,
    );
  }
}
