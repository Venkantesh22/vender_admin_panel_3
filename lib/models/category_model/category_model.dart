class CategoryModel {
  final String id;
  final String categoryName;
  final String salonId;
  final bool haveData;
  final String? superCategoryName; // New optional field

  CategoryModel({
    required this.id,
    required this.categoryName,
    required this.salonId,
    this.haveData = false,
    this.superCategoryName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoryName': categoryName,
      'salonId': salonId,
      'haveData': haveData,
      'superCategoryName': superCategoryName,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'],
      categoryName: map['categoryName'],
      salonId: map['salonId'],
      haveData: map['haveData'],
      superCategoryName: map['superCategoryName'],
    );
  }

  factory CategoryModel.fromJson(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'],
      categoryName: map['categoryName'],
      salonId: map['salonId'],
      haveData: map['haveData'],
      superCategoryName: map['superCategoryName'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "categoryName": categoryName,
        "salonId": salonId,
        "haveData": haveData,
        "superCategoryName": superCategoryName,
      };

  CategoryModel copyWith({
    String? categoryName,
    bool? haveData,
    String? superCategoryName,
  }) {
    return CategoryModel(
      id: id,
      categoryName: categoryName ?? this.categoryName,
      salonId: salonId,
      haveData: haveData ?? this.haveData,
      superCategoryName: superCategoryName ?? this.superCategoryName,
    );
  }
}
