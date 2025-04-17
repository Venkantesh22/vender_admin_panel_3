import 'package:cloud_firestore/cloud_firestore.dart';

class SaveDateModel {
  final DateTime date;
  final DateTime time; // New field
  final String id; // Unique identifier
  final int totalAppointNo; // Total number of appointments

  SaveDateModel({
    required this.date,
    required this.time,
    required this.id,
    required this.totalAppointNo,
  });

  factory SaveDateModel.fromJson(Map<String, dynamic> json) {
    return SaveDateModel(
      date: (json['date'] as Timestamp).toDate(),
      time:
          (json['time'] as Timestamp).toDate(), // Convert Timestamp to DateTime
      id: json['id'] as String,
      totalAppointNo: json['totalAppointNo'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': Timestamp.fromDate(date),
      'time': Timestamp.fromDate(time), // Convert DateTime to Timestamp
      'id': id,
      'totalAppointNo': totalAppointNo,
    };
  }

  SaveDateModel copyWith(
      {DateTime? date, DateTime? time, String? id, int? totalAppointNo}) {
    return SaveDateModel(
      date: date ?? this.date,
      time: time ?? this.time,
      id: id ?? this.id,
      totalAppointNo: totalAppointNo ?? this.totalAppointNo,
    );
  }
}
