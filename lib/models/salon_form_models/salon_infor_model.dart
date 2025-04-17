import 'package:flutter/material.dart';
import 'package:samay_admin_plan/models/timestamp_model/timestamp_model.dart';

class SalonModel {
  SalonModel({
    required this.id,
    required this.adminId,
    required this.name,
    required this.email,
    required this.number,
    required this.whatApp,
    required this.salonType,
    required this.description,
    this.openTime,
    this.closeTime,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.pinCode,
    this.instagram,
    this.facebook,
    this.googleMap,
    this.linked,
    this.image,
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
    this.sunday,
    this.isDefaultCategoryCreate = false,
    required this.timeStampModel, // Updated field: single TimeStampModel
    this.isSettingAdd = false,
    this.isAccountValidBySamay = false,
    this.isAccountBanBySamay = false,
  });

  String id;
  String adminId;
  String name;
  String email;
  int number;
  int whatApp;
  String salonType;
  String description;
  TimeOfDay? openTime;
  TimeOfDay? closeTime;
  String address;
  String city;
  String state;
  String country;
  String pinCode;
  String? instagram;
  String? facebook;
  String? googleMap;
  String? linked;
  String? image;
  String? monday;
  String? tuesday;
  String? wednesday;
  String? thursday;
  String? friday;
  String? saturday;
  String? sunday;
  bool isDefaultCategoryCreate;
  bool isSettingAdd;
  bool isAccountValidBySamay;
  bool isAccountBanBySamay;
  TimeStampModel timeStampModel; // Updated field

  /// Factory method for creating an instance from JSON
  factory SalonModel.fromJson(Map<String, dynamic> json, String? id) {
    return SalonModel(
      id: json["id"],
      adminId: json["adminId"],
      name: json["name"],
      email: json["email"],
      number: json["number"] != null ? int.parse(json["number"].toString()) : 0,
      whatApp:
          json["whatApp"] != null ? int.parse(json["whatApp"].toString()) : 0,
      salonType: json["salonType"],
      description: json["description"],
      openTime:
          json["openTime"] != null ? _parseTimeOfDay(json["openTime"]) : null,
      closeTime:
          json["closeTime"] != null ? _parseTimeOfDay(json["closeTime"]) : null,
      address: json["address"],
      city: json['city'],
      state: json['state'],
      country: json['country'] ?? '',
      pinCode: json['pinCode'],
      instagram: json["instagram"],
      facebook: json["facebook"],
      googleMap: json["googleMap"],
      linked: json["linked"],
      image: json["image"],
      monday: json['monday'],
      tuesday: json['tuesday'],
      wednesday: json['wednesday'],
      thursday: json['thursday'],
      friday: json['friday'],
      saturday: json['saturday'],
      sunday: json['sunday'],
      isDefaultCategoryCreate: json['isDefaultCategoryCreate'] ?? false,
      isSettingAdd: json['isSettingAdd'] ?? false,
      isAccountValidBySamay: json['isAccountValidBySamay'] ?? false,
      isAccountBanBySamay: json['isAccountBanBySamay'] ?? false,
      // Deserialize a single TimeStampModel
      timeStampModel: TimeStampModel.fromJson(json["timeStampModel"]),
    );
  }

  /// Convert the object to a JSON representation
  Map<String, dynamic> toJson() => {
        "id": id,
        "adminId": adminId,
        "name": name,
        "email": email,
        "number": number,
        "whatApp": whatApp,
        "salonType": salonType,
        "description": description,
        "openTime": openTime != null ? _formatTimeOfDay(openTime!) : null,
        "closeTime": closeTime != null ? _formatTimeOfDay(closeTime!) : null,
        "address": address,
        'city': city,
        'state': state,
        'pinCode': pinCode,
        'country': country,
        "instagram": instagram,
        "facebook": facebook,
        "googleMap": googleMap,
        "linked": linked,
        "image": image,
        'monday': monday,
        'tuesday': tuesday,
        'wednesday': wednesday,
        'thursday': thursday,
        'friday': friday,
        'saturday': saturday,
        'sunday': sunday,
        'isDefaultCategoryCreate': isDefaultCategoryCreate,
        'isSettingAdd': isSettingAdd,
        'isAccountValidBySamay': isAccountValidBySamay,
        'isAccountBanBySamay': isAccountBanBySamay,
        // Serialize a single TimeStampModel
        'timeStampModel': timeStampModel.toJson(),
      };

  /// Copy with method to create a modified copy
  SalonModel copyWith({
    String? id,
    String? adminId,
    String? name,
    String? email,
    int? number,
    int? whatApp,
    String? salonType,
    String? description,
    TimeOfDay? openTime,
    TimeOfDay? closeTime,
    String? address,
    String? city,
    String? state,
    String? pinCode,
    String? instagram,
    String? facebook,
    String? googleMap,
    String? linked,
    String? image,
    String? monday,
    String? tuesday,
    String? wednesday,
    String? thursday,
    String? friday,
    String? saturday,
    String? sunday,
    bool? isDefaultCategoryCreate,
    bool? isSettingAdd,
    bool? isAccountValidBySamay,
    bool? isAccountBanBySamay,
    String? country,
    TimeStampModel? timeStampModel, // Updated field
  }) {
    return SalonModel(
      id: id ?? this.id,
      adminId: adminId ?? this.adminId,
      name: name ?? this.name,
      email: email ?? this.email,
      number: number ?? this.number,
      whatApp: whatApp ?? this.whatApp,
      salonType: salonType ?? this.salonType,
      description: description ?? this.description,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      pinCode: pinCode ?? this.pinCode,
      country: country ?? this.country,
      instagram: instagram ?? this.instagram,
      facebook: facebook ?? this.facebook,
      googleMap: googleMap ?? this.googleMap,
      linked: linked ?? this.linked,
      image: image ?? this.image,
      monday: monday ?? this.monday,
      tuesday: tuesday ?? this.tuesday,
      wednesday: wednesday ?? this.wednesday,
      thursday: thursday ?? this.thursday,
      friday: friday ?? this.friday,
      saturday: saturday ?? this.saturday,
      sunday: sunday ?? this.sunday,
      isDefaultCategoryCreate:
          isDefaultCategoryCreate ?? this.isDefaultCategoryCreate,
      isSettingAdd: isSettingAdd ?? this.isSettingAdd,
      isAccountValidBySamay:
          isAccountValidBySamay ?? this.isAccountValidBySamay,
      isAccountBanBySamay: isAccountBanBySamay ?? this.isAccountBanBySamay,
      timeStampModel: timeStampModel ?? this.timeStampModel, // Updated field
    );
  }

  static TimeOfDay _parseTimeOfDay(String timeString) {
    // Ensure string is properly trimmed and split
    final parts = timeString.trim().split(':');
    if (parts.length != 2) {
      throw FormatException("Invalid time format: $timeString");
    }

    final hour = int.parse(parts[0].trim());
    final minuteAndPeriod = parts[1].trim().split(' ');
    if (minuteAndPeriod.length != 2) {
      throw FormatException("Invalid minute and period format: ${parts[1]}");
    }

    final minute = int.parse(minuteAndPeriod[0].trim());
    final period = minuteAndPeriod[1].trim().toUpperCase();

    // Ensure period is valid
    if (period != 'AM' && period != 'PM') {
      throw FormatException("Invalid period (AM/PM): $period");
    }

    // Handle AM/PM conversion logic
    final convertedHour = period == 'PM' && hour != 12
        ? hour + 12
        : period == 'AM' && hour == 12
            ? 0
            : hour;

    return TimeOfDay(
      hour: convertedHour,
      minute: minute,
    );
  }

// Helper method to format TimeOfDay as a time string in "10:00 PM" format
  static String _formatTimeOfDay(TimeOfDay timeOfDay) {
    final hour = timeOfDay.hourOfPeriod == 0 ? 12 : timeOfDay.hourOfPeriod;
    final minute = timeOfDay.minute.toString().padLeft(2, '0');
    final period = timeOfDay.period == DayPeriod.am ? 'AM' : 'PM';

    return '$hour:$minute $period';
  }
}
