import 'package:cloud_firestore/cloud_firestore.dart';

class TimeStampModel {
  TimeStampModel({
    required this.id,
    required this.dateAndTime,
    required this.updateBy,
  });

  String id;
  DateTime dateAndTime;
  String updateBy;

  factory TimeStampModel.fromJson(Map<String, dynamic> json) {
    return TimeStampModel(
      id: json["id"],
      dateAndTime: (json["dateAndTime"] as Timestamp).toDate(),
      updateBy: json["updateBy"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "dateAndTime": Timestamp.fromDate(dateAndTime),
        "updateBy": updateBy,
      };

  TimeStampModel copyWith({
    String? id,
    DateTime? dateAndTime,
    String? updateBy,
  }) {
    return TimeStampModel(
      id: id ?? this.id,
      dateAndTime: dateAndTime ?? this.dateAndTime,
      updateBy: updateBy ?? this.updateBy,
    );
  }
}
