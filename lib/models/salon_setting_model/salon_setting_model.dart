// class SettingModel {
//   final String id;
//   final String salonId;
//   final String diffbtwTimetap; // stored as String
//   final bool isUpdate;
//   final int dayForBooking;
//   final String gstNo;
//   final String adminId; // new field
//   final String? gSTIsIncludingOrExcluding; // new optional field

//   SettingModel({
//     required this.id,
//     required this.salonId,
//     required this.diffbtwTimetap,
//     this.isUpdate = false,
//     required this.dayForBooking,
//     required this.gstNo,
//     required this.adminId,
//     this.gSTIsIncludingOrExcluding = "",
//   });

//   factory SettingModel.fromJson(Map<String, dynamic> json) {
//     return SettingModel(
//       id: json['id'] as String,
//       salonId: json['salonId'] as String,
//       diffbtwTimetap: json['diffbtwTimetap']?.toString() ?? "30",
//       isUpdate: json['isUpdate'] as bool? ?? false,
//       dayForBooking: json['dayForBooking'] as int? ?? 0,
//       gstNo: json['gstNo'] as String? ?? '',
//       adminId: json['adminId'] as String? ?? '',
//       gSTIsIncludingOrExcluding: json['gSTIsIncludingOrExcluding'] as String?,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'salonId': salonId,
//       'diffbtwTimetap': diffbtwTimetap,
//       'isUpdate': isUpdate,
//       'dayForBooking': dayForBooking,
//       'gstNo': gstNo,
//       'adminId': adminId,
//       'gSTIsIncludingOrExcluding': gSTIsIncludingOrExcluding,
//     };
//   }

//   SettingModel copyWith({
//     String? diffbtwTimetap,
//     bool? isUpdate,
//     int? dayForBooking,
//     String? gstNo,
//     String? adminId,
//     String? gSTIsIncludingOrExcluding,
//   }) {
//     return SettingModel(
//       id: id,
//       salonId: salonId,
//       diffbtwTimetap: diffbtwTimetap ?? this.diffbtwTimetap,
//       isUpdate: isUpdate ?? this.isUpdate,
//       dayForBooking: dayForBooking ?? this.dayForBooking,
//       gstNo: gstNo ?? this.gstNo,
//       adminId: adminId ?? this.adminId,
//       gSTIsIncludingOrExcluding:
//           gSTIsIncludingOrExcluding ?? this.gSTIsIncludingOrExcluding,
//     );
//   }
// }

class SettingModel {
  final String id;
  final String salonId;
  final String diffbtwTimetap; // stored as String
  final bool isUpdate;
  final int dayForBooking;
  final String gstNo;
  final String adminId; // new field
  final String? gSTIsIncludingOrExcluding; // new optional field
  final String serviceAt; // new field with default value

  SettingModel({
    required this.id,
    required this.salonId,
    required this.diffbtwTimetap,
    this.isUpdate = false,
    required this.dayForBooking,
    required this.gstNo,
    required this.adminId,
    this.gSTIsIncludingOrExcluding = "",
    this.serviceAt = "Salon", // default value
  });

  factory SettingModel.fromJson(Map<String, dynamic> json) {
    return SettingModel(
      id: json['id'] as String,
      salonId: json['salonId'] as String,
      diffbtwTimetap: json['diffbtwTimetap']?.toString() ?? "30",
      isUpdate: json['isUpdate'] as bool? ?? false,
      dayForBooking: json['dayForBooking'] as int? ?? 0,
      gstNo: json['gstNo'] as String? ?? '',
      adminId: json['adminId'] as String? ?? '',
      gSTIsIncludingOrExcluding: json['gSTIsIncludingOrExcluding'] as String?,
      serviceAt: json['serviceAt'] as String? ?? "Salon", // default value
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'salonId': salonId,
      'diffbtwTimetap': diffbtwTimetap,
      'isUpdate': isUpdate,
      'dayForBooking': dayForBooking,
      'gstNo': gstNo,
      'adminId': adminId,
      'gSTIsIncludingOrExcluding': gSTIsIncludingOrExcluding,
      'serviceAt': serviceAt, // include in JSON
    };
  }

  SettingModel copyWith({
    String? diffbtwTimetap,
    bool? isUpdate,
    int? dayForBooking,
    String? gstNo,
    String? adminId,
    String? gSTIsIncludingOrExcluding,
    String? serviceAt, // include in copyWith
  }) {
    return SettingModel(
      id: id,
      salonId: salonId,
      diffbtwTimetap: diffbtwTimetap ?? this.diffbtwTimetap,
      isUpdate: isUpdate ?? this.isUpdate,
      dayForBooking: dayForBooking ?? this.dayForBooking,
      gstNo: gstNo ?? this.gstNo,
      adminId: adminId ?? this.adminId,
      gSTIsIncludingOrExcluding:
          gSTIsIncludingOrExcluding ?? this.gSTIsIncludingOrExcluding,
      serviceAt: serviceAt ?? this.serviceAt, // include in copyWith
    );
  }
}
