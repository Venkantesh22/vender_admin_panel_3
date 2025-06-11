class CategoryModel {
  final String id;
  final String categoryName;
  final String salonId;
  final bool haveData;
  final String? superCategoryName; // New optional field
  String? serviceFor;

  CategoryModel({
    required this.id,
    required this.categoryName,
    required this.salonId,
    this.haveData = false,
    this.superCategoryName,
    this.serviceFor = "Both",
  });

  // fromJson factory
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      categoryName: json['categoryName'],
      salonId: json['salonId'],
      haveData: json['haveData'] ?? false,
      superCategoryName: json['superCategoryName'],
      serviceFor: json['serviceFor'] ?? "Both",
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryName': categoryName,
      'salonId': salonId,
      'haveData': haveData,
      'superCategoryName': superCategoryName,
      'serviceFor': serviceFor,
    };
  }

  // copyWith method
  CategoryModel copyWith({
    String? id,
    String? categoryName,
    String? salonId,
    bool? haveData,
    String? superCategoryName,
    String? serviceFor,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      categoryName: categoryName ?? this.categoryName,
      salonId: salonId ?? this.salonId,
      haveData: haveData ?? this.haveData,
      superCategoryName: superCategoryName ?? this.superCategoryName,
      serviceFor: serviceFor ?? this.serviceFor,
    );
  }
}
