class SuperCategoryModel {
  final String id;
  final String superCategoryName;
  final String salonId;
  final bool haveData;
  final String adminId;
  final String? imgUrl; // New optional field

  SuperCategoryModel({
    required this.id,
    required this.superCategoryName,
    required this.salonId,
    this.haveData = false,
    required this.adminId,
    this.imgUrl,
  });

  /// Factory method to create a `SuperCategoryModel` from JSON with null safety
  factory SuperCategoryModel.fromJson(Map<String, dynamic> json) {
    return SuperCategoryModel(
      id: json['id'] ?? '',
      superCategoryName: json['superCategoryName'] ?? '',
      salonId: json['salonId'] ?? '',
      haveData: json['haveData'] ?? false,
      adminId: json['adminId'] ?? '',
      imgUrl: json['imgUrl'],
    );
  }

  /// Converts the `SuperCategoryModel` object to JSON format
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'superCategoryName': superCategoryName,
      'salonId': salonId,
      'haveData': haveData,
      'adminId': adminId,
      'imgUrl': imgUrl,
    };
  }

  /// Copy method to create a modified version of `SuperCategoryModel`
  SuperCategoryModel copyWith({
    String? id,
    String? superCategoryName,
    String? salonId,
    bool? haveData,
    String? adminId,
    String? imgUrl,
  }) {
    return SuperCategoryModel(
      id: id ?? this.id,
      superCategoryName: superCategoryName ?? this.superCategoryName,
      salonId: salonId ?? this.salonId,
      haveData: haveData ?? this.haveData,
      adminId: adminId ?? this.adminId,
      imgUrl: imgUrl ?? this.imgUrl,
    );
  }
}
