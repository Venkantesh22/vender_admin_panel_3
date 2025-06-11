class SuperCategoryModel {
  final String id;
  final String superCategoryName;
  final String salonId;
  final bool haveData;
  final String adminId;
  final String? imgUrl; // New optional field
  final String? serviceFor;

  SuperCategoryModel({
    required this.id,
    required this.superCategoryName,
    required this.salonId,
    this.haveData = false,
    required this.adminId,
    this.imgUrl,
    this.serviceFor = "Both",
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
      serviceFor: json['serviceFor'] ?? "Both",
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
      'serviceFor': serviceFor,
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
    String? serviceFor,
  }) {
    return SuperCategoryModel(
      id: id ?? this.id,
      superCategoryName: superCategoryName ?? this.superCategoryName,
      salonId: salonId ?? this.salonId,
      haveData: haveData ?? this.haveData,
      adminId: adminId ?? this.adminId,
      imgUrl: imgUrl ?? this.imgUrl,
      serviceFor: serviceFor ?? this.serviceFor,
    );
  }
}
