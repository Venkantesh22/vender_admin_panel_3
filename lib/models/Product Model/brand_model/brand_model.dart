class BrandModel {
  final String id;
  final String name;
  final String descp;
  final String? image;
  final String brandFor;

  BrandModel({
    required this.id,
    required this.name,
    required this.descp,
    this.image = "",
    this.brandFor = "Both",
  });

  // fromJson factory
  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      descp: json['descp'] ?? '',
      image: json['image'] ?? '',
      brandFor: json['brandFor'] ?? "Both",
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'descp': descp,
      'image': image,
      'brandFor': brandFor,
    };
  }

  // copyWith method
  BrandModel copyWith({
    String? id,
    String? name,
    String? descp,
    String? image,
    String? brandFor,
  }) {
    return BrandModel(
      id: id ?? this.id,
      name: name ?? this.name,
      descp: descp ?? this.descp,
      image: image ?? this.image,
      brandFor: brandFor ?? this.brandFor,
    );
  }
}
