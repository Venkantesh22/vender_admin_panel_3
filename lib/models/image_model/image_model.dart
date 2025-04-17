class ImageModel {
  String id;
  String image;
  String name;

  ImageModel({required this.id, required this.image, required this.name});

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'],
      image: json['image'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'name': name,
    };
  }

  ImageModel copyWith({
    String? id,
    String? image,
    String? name,
  }) {
    return ImageModel(
      id: id ?? this.id,
      image: image ?? this.image,
      name: name ?? this.name,
    );
  }
}
