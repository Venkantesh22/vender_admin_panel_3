class BrandCategoryModel {
  final String id;
  final String name;
  final String descp;
  String? image;
  final String productCateFor;
  final bool isActive;
  final int order;

  BrandCategoryModel({
    required this.id,
    required this.name,
    required this.descp,
    required this.isActive,
    this.image = "",
    this.productCateFor = "Unisex",
    this.order = 1,
  });

  // fromJson factory
  factory BrandCategoryModel.fromJson(Map<String, dynamic> json) {
    return BrandCategoryModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      isActive: json['isActive'] ?? false,
      descp: json['descp'] ?? '',
      image: json['image'] ?? '',
      productCateFor: json['productCateFor'] ?? 'both',
      order: json['order'] ?? 1,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'descp': descp,
      'isActive': isActive,
      'image': image,
      'productCateFor': productCateFor,
      'order': order,
    };
  }

  // copyWith method
  BrandCategoryModel copyWith({
    String? id,
    String? name,
    bool? isActive,
    String? descp,
    String? brandId,
    String? brandName,
    String? image,
    String? productCateFor,
    int? order,
  }) {
    return BrandCategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      descp: descp ?? this.descp,
      isActive: isActive ?? this.isActive,
      image: image ?? this.image,
      productCateFor: productCateFor ?? this.productCateFor,
      order: order ?? this.order,
    );
  }
}
