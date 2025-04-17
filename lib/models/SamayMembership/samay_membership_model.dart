import 'package:cloud_firestore/cloud_firestore.dart';

class SamayMembership {
  SamayMembership({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.durationInDays,
    required this.isActive,
    this.buyDate,
    this.expiryDate,
  });

  String id; // Unique ID for the membership
  String name; // Membership name (e.g., "Gold Membership")
  String description; // Details about the membership benefits
  double price; // Cost of the membership
  int durationInDays; // Duration of the membership in days
  bool isActive; // Indicates whether the membership is currently active
  DateTime? buyDate; // Date the membership was purchased
  DateTime? expiryDate; // Date the membership expires

  /// Factory method for creating an instance from JSON (Firestore)
  factory SamayMembership.fromJson(Map<String, dynamic> json) {
    return SamayMembership(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: double.parse(json['price'].toString()),
      durationInDays: json['durationInDays'],
      isActive: json['isActive'] ?? true,
      buyDate: json['buyDate'] != null
          ? (json['buyDate'] as Timestamp).toDate()
          : null,
      expiryDate: json['expiryDate'] != null
          ? (json['expiryDate'] as Timestamp).toDate()
          : null,
    );
  }

  /// Convert the object to a JSON representation (Firestore)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'durationInDays': durationInDays,
      'isActive': isActive,
      'buyDate': buyDate != null ? Timestamp.fromDate(buyDate!) : null,
      'expiryDate': expiryDate != null ? Timestamp.fromDate(expiryDate!) : null,
    };
  }

  /// Copy with method for creating a new instance with modified fields
  SamayMembership copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    int? durationInDays,
    bool? isActive,
    DateTime? buyDate,
    DateTime? expiryDate,
  }) {
    return SamayMembership(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      durationInDays: durationInDays ?? this.durationInDays,
      isActive: isActive ?? this.isActive,
      buyDate: buyDate ?? this.buyDate,
      expiryDate: expiryDate ?? this.expiryDate,
    );
  }
}
