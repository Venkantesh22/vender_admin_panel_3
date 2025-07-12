class BrandModel {
  final String id;
  final String name;
  final String descp;
  final String brandFor;
  final String? image;
  final bool isActive;
  final int order;

  BrandModel({
    required this.id,
    required this.name,
    required this.isActive,
    required this.order,
    this.brandFor = "Unisex",
    this.descp = "",
    this.image = "",
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['id'] ?? '',
      image: json['image'] ?? '',
      name: json['name'] ?? '',
      descp: json['descp'] ?? '',
      order: json['order'] ?? 1,
      brandFor: json['brandFor'] ?? '',
      isActive: json['isActive'] is bool
          ? json['isActive']
          : json['isActive'] == 'true',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'descp': descp,
      'order': order,
      'brandFor': brandFor,
      'isActive': isActive,
      'image': image,
    };
  }

  BrandModel copyWith({
    String? id,
    String? name,
    String? descp,
    bool? isActive,
    String? image,
    String? brandFor,
    int? order,
  }) {
    return BrandModel(
      id: id ?? this.id,
      name: name ?? this.name,
      descp: descp ?? this.descp,
      isActive: isActive ?? this.isActive,
      image: image ?? this.image,
      brandFor: brandFor ?? this.brandFor,
      order: order ?? this.order,
    );
  }
}

// class ListOfCateBrand {
//   final String categoryName;
//   final String categoryId;

//   ListOfCateBrand({
//     required this.categoryName,
//     required this.categoryId,
//   });

//   factory ListOfCateBrand.fromJson(Map<String, dynamic> json) {
//     return ListOfCateBrand(
//       categoryName: json['categoryName'] ?? '',
//       categoryId: json['categoryId'] ?? '',
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'categoryName': categoryName,
//       'categoryId': categoryId,
//     };
//   }

//   ListOfCateBrand copyWith({
//     String? categoryName,
//     String? categoryId,
//   }) {
//     return ListOfCateBrand(
//       categoryName: categoryName ?? this.categoryName,
//       categoryId: categoryId ?? this.categoryId,
//     );
//   }
// }
