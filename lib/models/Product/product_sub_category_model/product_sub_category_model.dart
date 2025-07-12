class ProductSubCateModel {
  final String id;
  final String name;
  final String descp;
  final String image;
  final String productFor;
  final String categoryName;
  final String categoryId;
  final int order;

  ProductSubCateModel({
    required this.id,
    required this.name,
    required this.descp,
    this.image = "",
    this.productFor = "Unisex",
    required this.categoryName,
    required this.categoryId,
    required this.order,
  });

  factory ProductSubCateModel.fromJson(Map<String, dynamic> json) {
    return ProductSubCateModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      descp: json['descp'] ?? '',
      image: json['image'] ?? '',
      productFor: json['productFor'] ?? '',
      categoryName: json['categoryName'] ?? '',
      categoryId: json['categoryId'] ?? '',
      order: json['order'] is int
          ? json['order']
          : int.tryParse(json['order']?.toString() ?? '1') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'descp': descp,
      'image': image,
      'productFor': productFor,
      'categoryName': categoryName,
      'categoryId': categoryId,
      'order': order,
    };
  }

  ProductSubCateModel copyWith({
    String? id,
    String? name,
    String? descp,
    String? image,
    String? productFor,
    String? categoryName,
    String? categoryId,
    int? order,
  }) {
    return ProductSubCateModel(
      id: id ?? this.id,
      name: name ?? this.name,
      descp: descp ?? this.descp,
      image: image ?? this.image,
      productFor: productFor ?? this.productFor,
      categoryName: categoryName ?? this.categoryName,
      categoryId: categoryId ?? this.categoryId,
      order: order ?? this.order,
    );
  }
}
