class ProductBranchModel {
  final String id;
  final String name;
  final String descp;
  final String image;
  final String productFor;
  final int order;
  final String categoryName;
  final String categoryId;
  final String subCategoryName;
  final String subCategoryId;

  ProductBranchModel({
    required this.id,
    required this.name,
    required this.descp,
    this.image = "",
    this.productFor = "Unisex",
    required this.order,
    required this.categoryName,
    required this.categoryId,
    required this.subCategoryName,
    required this.subCategoryId,
  });

  factory ProductBranchModel.fromJson(Map<String, dynamic> json) {
    return ProductBranchModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      descp: json['descp'] ?? '',
      image: json['image'] ?? '',
      productFor: json['productFor'] ?? '',
      order: json['order'] is int
          ? json['order']
          : int.tryParse(json['order']?.toString() ?? '0') ?? 0,
      categoryName: json['categoryName'] ?? '',
      categoryId: json['categoryId'] ?? '',
      subCategoryName: json['subCategoryName'] ?? '',
      subCategoryId: json['subCategoryId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'descp': descp,
      'image': image,
      'productFor': productFor,
      'order': order,
      'categoryName': categoryName,
      'categoryId': categoryId,
      'subCategoryName': subCategoryName,
      'subCategoryId': subCategoryId,
    };
  }

  ProductBranchModel copyWith({
    String? id,
    String? name,
    String? descp,
    String? image,
    String? productFor,
    int? order,
    String? categoryName,
    String? categoryId,
    String? subCategoryName,
    String? subCategoryId,
  }) {
    return ProductBranchModel(
      id: id ?? this.id,
      name: name ?? this.name,
      descp: descp ?? this.descp,
      image: image ?? this.image,
      productFor: productFor ?? this.productFor,
      order: order ?? this.order,
      categoryName: categoryName ?? this.categoryName,
      categoryId: categoryId ?? this.categoryId,
      subCategoryName: subCategoryName ?? this.subCategoryName,
      subCategoryId: subCategoryId ?? this.subCategoryId,
    );
  }
}
