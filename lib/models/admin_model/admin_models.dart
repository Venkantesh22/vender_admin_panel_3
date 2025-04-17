import 'dart:convert';

import 'package:samay_admin_plan/models/SamayMembership/samay_membership_model.dart';
import 'package:samay_admin_plan/models/timestamp_model/timestamp_model.dart';

// AdminModel adminModelFromJson(String str) =>
//     AdminModel.fromJson(json.decode(str));

// String adminModelToJson(AdminModel data) => json.encode(data.toJson());

// class AdminModel {
//   AdminModel(
//     this.id,
//     this.name,
//     this.email,
//     this.number,
//     this.password,
//     this.timeDateModel, {
//     this.image = "",
//   });

//   String id;
//   String name;
//   String email;
//   int number;
//   String password;
//   String? image;
//   TimeDateModel timeDateModel;

//   factory AdminModel.fromJson(Map<String, dynamic> json) => AdminModel(
//         json["id"],
//         json["name"],
//         json["email"],
//         json["number"] != null ? int.parse(json["number"].toString()) : 0,
//         json["password"],
//         TimeDateModel.fromJson(json["timeDateModel"]),
//         image: json["image"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "email": email,
//         "number": number,
//         "password": password,
//         "timeDateModel": timeDateModel.toJson(),
//         "image": image,
//       };

//   AdminModel copyWith({
//     String? id,
//     String? name,
//     String? email,
//     int? number,
//     String? password,
//     String? image,
//     TimeDateModel? timeDateModel,
//   }) =>
//       AdminModel(
//         id ?? this.id,
//         name ?? this.name,
//         email ?? this.email,
//         number ?? this.number,
//         password ?? this.password,
//         timeDateModel ?? this.timeDateModel,
//         image: image ?? this.image,
//       );
// }

AdminModel adminModelFromJson(String str) =>
    AdminModel.fromJson(json.decode(str));

String adminModelToJson(AdminModel data) => json.encode(data.toJson());

class AdminModel {
  AdminModel({
    required this.id,
    required this.name,
    required this.email,
    required this.number,
    required this.password,
    required this.timeStampModel,
    required this.samayMembershipModel,
    this.image = "",
  });

  final String id;
  final String name;
  final String email;
  final int number;
  final String password;
  final TimeStampModel timeStampModel;
  final SamayMembership samayMembershipModel;
  String image;

  factory AdminModel.fromJson(Map<String, dynamic> json) => AdminModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        number:
            json["number"] != null ? int.parse(json["number"].toString()) : 0,
        password: json["password"],
        timeStampModel: TimeStampModel.fromJson(json["timeStampModel"]),
        samayMembershipModel:
            SamayMembership.fromJson(json["samayMembershipModel"]),
        image: json["image"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "number": number,
        "password": password,
        "timeStampModel": timeStampModel.toJson(),
        "samayMembershipModel": samayMembershipModel.toJson(),
        "image": image,
      };

  AdminModel copyWith({
    String? id,
    String? name,
    String? email,
    int? number,
    String? password,
    TimeStampModel? timeStampModel,
    SamayMembership? samayMembershipModel,
    String? image,
  }) =>
      AdminModel(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        number: number ?? this.number,
        password: password ?? this.password,
        timeStampModel: timeStampModel ?? this.timeStampModel,
        samayMembershipModel: samayMembershipModel ?? this.samayMembershipModel,
        image: image ?? this.image,
      );
}
