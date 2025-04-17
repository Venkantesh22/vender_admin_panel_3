import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:samay_admin_plan/models/SamayMembership/samay_membership_model.dart';
import 'package:samay_admin_plan/models/timestamp_model/timestamp_model.dart';

class UserModel {
  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.image,
    required this.email,
    required this.password,
    required this.timeStampModel,
    this.age,
    this.gender,
    this.samayMembership,
    this.dateOfBirth,
    this.anniversaryDate,
    this.marriageStatus,
    this.marriageAge, // Default value set to 0
  });

  String id;
  String name;
  String phone;
  String image;
  String email;
  String password;
  TimeStampModel timeStampModel;
  int? age;
  String? gender;
  SamayMembership? samayMembership;
  DateTime? dateOfBirth;
  DateTime? anniversaryDate;
  String? marriageStatus;
  int? marriageAge; // New variable with default value

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      name: json["name"],
      phone: json["phone"],
      image: json["image"],
      email: json["email"],
      password: json["password"],
      timeStampModel: TimeStampModel.fromJson(json["timeStampModel"] ?? {}),
      age: json["age"] != null ? int.parse(json["age"].toString()) : null,
      gender: json["gender"],
      samayMembership: json["samayMembership"] != null
          ? SamayMembership.fromJson(json["samayMembership"])
          : null,
      dateOfBirth: json["dateOfBirth"] != null
          ? (json["dateOfBirth"] as Timestamp).toDate()
          : null,
      anniversaryDate: json["anniversaryDate"] != null
          ? (json["anniversaryDate"] as Timestamp).toDate()
          : null,
      marriageStatus: json["marriageStatus"],
      marriageAge: json["marriageAge"] != null
          ? int.parse(json["marriageAge"].toString())
          : 0, // Default to 0 if null
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
        "image": image,
        "email": email,
        "password": password,
        "timeStampModel": timeStampModel.toJson(),
        "age": age,
        "gender": gender,
        "samayMembership": samayMembership?.toJson(),
        "dateOfBirth":
            dateOfBirth != null ? Timestamp.fromDate(dateOfBirth!) : null,
        "anniversaryDate": anniversaryDate != null
            ? Timestamp.fromDate(anniversaryDate!)
            : null,
        "marriageStatus": marriageStatus,
        "marriageAge": marriageAge, // Include in JSON
      };

  UserModel copyWith({
    String? name,
    String? phone,
    String? image,
    int? age,
    String? gender,
    SamayMembership? samayMembership,
    DateTime? dateOfBirth,
    DateTime? anniversaryDate,
    String? marriageStatus,
    int? marriageAge,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      image: image ?? this.image,
      email: email,
      password: password,
      timeStampModel: timeStampModel,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      samayMembership: samayMembership ?? this.samayMembership,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      anniversaryDate: anniversaryDate ?? this.anniversaryDate,
      marriageStatus: marriageStatus ?? this.marriageStatus,
      marriageAge: marriageAge ?? this.marriageAge, // Handle copyWith
    );
  }
}
