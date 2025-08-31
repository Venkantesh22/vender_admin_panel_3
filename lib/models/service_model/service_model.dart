// class ServiceModel {
//   final String id;
//   final String salonId;
//   final String categoryId;
//   final String categoryName;
//   final String superCategoryName; // New field added
//   final String servicesName;
//   final String serviceCode;
//   final double price;
//   final int serviceDurationMin; // Total duration in minutes
//   final String? description; // Made nullable
//   final String
//       serviceFor; // New: Service For (e.g., "Male", "Female", or "Both")
//   double? discountInPer; // Discount percentage (nullable)
//   double? discountAmount; // Discount amount (nullable)
//   double? originalPrice; // Price before discount (nullable)

//   ServiceModel({
//     required this.id,
//     required this.salonId,
//     required this.categoryId,
//     required this.categoryName,
//     required this.superCategoryName, // New field added to constructor
//     required this.servicesName,
//     required this.serviceCode,
//     required this.price,
//     required this.serviceDurationMin,
//     this.description,
//     required this.serviceFor, // New field added to constructor
//     this.discountInPer = 0.0, 
//     this.discountAmount = 0.0,
//     this.originalPrice = 0.0,
//   });

//   /// Factory method to create a `ServiceModel` from JSON with null safety.
//   factory ServiceModel.fromJson(Map<String, dynamic> json) {
//     return ServiceModel(
//       id: json['id'] ?? '',
//       salonId: json['salonId'] ?? '',
//       categoryId: json['categoryId'] ?? '',
//       categoryName: json['categoryName'] ?? '',
//       superCategoryName:
//           json['superCategoryName'] ?? '', // New field in fromJson
//       servicesName: json['servicesName'] ?? '',
//       serviceCode: json['serviceCode'] ?? '',
//       price: (json['price'] as num?)?.toDouble() ?? 0.0,
//       serviceDurationMin: json['serviceDurationMin'] ?? 0,
//       description: json['description'] ?? '',
//       serviceFor: json['serviceFor'] ?? 'Both', // Default value if not provided
//       discountInPer: (json['discountInPer'] as num?)?.toDouble(),
//       discountAmount: (json['discountAmount'] as num?)?.toDouble(),
//       originalPrice: (json['originalPrice'] as num?)?.toDouble(),
//     );
//   }

//   /// Converts the `ServiceModel` object to JSON format.
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'salonId': salonId,
//       'categoryId': categoryId,
//       'categoryName': categoryName,
//       'superCategoryName': superCategoryName, // New field in toJson
//       'servicesName': servicesName,
//       'serviceCode': serviceCode,
//       'price': price,
//       'serviceDurationMin': serviceDurationMin,
//       'description': description,
//       'serviceFor': serviceFor, // Added field in JSON conversion
//       'discountInPer': discountInPer,
//       'discountAmount': discountAmount,
//       'originalPrice': originalPrice,
//     };
//   }

//   /// Copy method to create a modified version of `ServiceModel`
//   ServiceModel copyWith({
//     String? id,
//     String? salonId,
//     String? categoryId,
//     String? categoryName,
//     String? superCategoryName, // New field in copyWith
//     String? servicesName,
//     String? serviceCode,
//     double? price,
//     int? serviceDurationMin,
//     String? description,
//     String? serviceFor, // New field in copyWith
//     double? discountInPer,
//     double? discountAmount,
//     double? originalPrice,
//   }) {
//     return ServiceModel(
//       id: id ?? this.id,
//       salonId: salonId ?? this.salonId,
//       categoryId: categoryId ?? this.categoryId,
//       categoryName: categoryName ?? this.categoryName,
//       superCategoryName: superCategoryName ?? this.superCategoryName,
//       servicesName: servicesName ?? this.servicesName,
//       serviceCode: serviceCode ?? this.serviceCode,
//       price: price ?? this.price,
//       serviceDurationMin: serviceDurationMin ?? this.serviceDurationMin,
//       description: description ?? this.description,
//       serviceFor: serviceFor ?? this.serviceFor,
//       discountInPer: discountInPer ?? this.discountInPer,
//       discountAmount: discountAmount ?? this.discountAmount,
//       originalPrice: originalPrice ?? this.originalPrice,
//     );
//   }
// }
class ServiceModel {
  final String id;
  final String salonId;
  final String categoryId;
  final String categoryName;
  final String superCategoryName; // New field
  final String servicesName;
  final String serviceCode;
  final double price;
  final int serviceDurationMin; // Total duration in minutes
  final String? description; // Nullable
  final String serviceFor; // Male / Female / Both
  final double? discountInPer; // Nullable
  final double? discountAmount; // Nullable
  final double? originalPrice; // Nullable
  final String adminId; // New field
  final String superCategoryId; // New field

  ServiceModel({
    required this.id,
    required this.salonId,
    required this.categoryId,
    required this.categoryName,
    required this.superCategoryName,
    required this.servicesName,
    required this.serviceCode,
    required this.price,
    required this.serviceDurationMin,
    this.description,
    required this.serviceFor,
    this.discountInPer,
    this.discountAmount,
    this.originalPrice,
    required this.adminId,
    required this.superCategoryId,
  });

  /// Factory constructor - JSON to Model
  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] ?? '',
      salonId: json['salonId'] ?? '',
      categoryId: json['categoryId'] ?? '',
      categoryName: json['categoryName'] ?? '',
      superCategoryName: json['superCategoryName'] ?? '',
      servicesName: json['servicesName'] ?? '',
      serviceCode: json['serviceCode'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      serviceDurationMin: json['serviceDurationMin'] ?? 0,
      description: json['description'],
      serviceFor: json['serviceFor'] ?? 'Both',
      discountInPer: (json['discountInPer'] != null)
          ? (json['discountInPer'] as num).toDouble()
          : null,
      discountAmount: (json['discountAmount'] != null)
          ? (json['discountAmount'] as num).toDouble()
          : null,
      originalPrice: (json['originalPrice'] != null)
          ? (json['originalPrice'] as num).toDouble()
          : null,
      adminId: json['adminId'] ?? '',
      superCategoryId: json['superCategoryId'] ?? '',
    );
  }

  /// Convert Model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'salonId': salonId,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'superCategoryName': superCategoryName,
      'servicesName': servicesName,
      'serviceCode': serviceCode,
      'price': price,
      'serviceDurationMin': serviceDurationMin,
      'description': description,
      'serviceFor': serviceFor,
      'discountInPer': discountInPer,
      'discountAmount': discountAmount,
      'originalPrice': originalPrice,
      'adminId': adminId,
      'superCategoryId': superCategoryId,
    };
  }

  /// CopyWith method for immutability
  ServiceModel copyWith({
    String? id,
    String? salonId,
    String? categoryId,
    String? categoryName,
    String? superCategoryName,
    String? servicesName,
    String? serviceCode,
    double? price,
    int? serviceDurationMin,
    String? description,
    String? serviceFor,
    double? discountInPer,
    double? discountAmount,
    double? originalPrice,
    String? adminId,
    String? superCategoryId,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      salonId: salonId ?? this.salonId,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      superCategoryName: superCategoryName ?? this.superCategoryName,
      servicesName: servicesName ?? this.servicesName,
      serviceCode: serviceCode ?? this.serviceCode,
      price: price ?? this.price,
      serviceDurationMin: serviceDurationMin ?? this.serviceDurationMin,
      description: description ?? this.description,
      serviceFor: serviceFor ?? this.serviceFor,
      discountInPer: discountInPer ?? this.discountInPer,
      discountAmount: discountAmount ?? this.discountAmount,
      originalPrice: originalPrice ?? this.originalPrice,
      adminId: adminId ?? this.adminId,
      superCategoryId: superCategoryId ?? this.superCategoryId,
    );
  }
}
