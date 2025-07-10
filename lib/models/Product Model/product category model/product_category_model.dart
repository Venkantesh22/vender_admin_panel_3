class ProductCategoryModel {
  final String id;
  final String name;
  final String descp;
  String? image;
  final String productCateFor;
  final String brandName;
  final String brandId;

  ProductCategoryModel({
    required this.id,
    required this.name,
    required this.descp,
    this.image = "",
    this.productCateFor = "Both",
    required this.brandName,
    required this.brandId,
  });

  // fromJson factory
  factory ProductCategoryModel.fromJson(Map<String, dynamic> json) {
    return ProductCategoryModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      descp: json['descp'] ?? '',
      image: json['image'] ?? '',
      productCateFor: json['productCateFor'] ?? 'both',
      brandName: json['brandName'] ?? '',
      brandId: json['brandId'] ?? '',
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'descp': descp,
      'image': image,
      'productCateFor': productCateFor,
      'brandName': brandName,
      'brandId': brandId,
    };
  }

  // copyWith method
  ProductCategoryModel copyWith({
    String? id,
    String? name,
    String? descp,
    String? image,
    String? productCateFor,
    String? brandName,
    String? brandId,
  }) {
    return ProductCategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      descp: descp ?? this.descp,
      image: image ?? this.image,
      productCateFor: productCateFor ?? this.productCateFor,
      brandName: brandName ?? this.brandName,
      brandId: brandId ?? this.brandId,
    );
  }
}
