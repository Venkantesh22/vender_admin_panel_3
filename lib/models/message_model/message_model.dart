// class MessageModel {
//   final String id;
//   final String? wMasForbillPFD;

//   MessageModel({
//     required this.id,
//     this.wMasForbillPFD,
//   });

//   factory MessageModel.fromJson(Map<String, dynamic> json) {
//     return MessageModel(
//       id: json['id'] as String,
//       wMasForbillPFD: json['wMasForbillPFD' ?? "NoData"] as String,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'wMasForbillPFD': wMasForbillPFD,
//     };
//   }

//   MessageModel copyWith({
//     String? id,
//     String? wMasForbillPFD,
//   }) {
//     return MessageModel(
//       id: id ?? this.id,
//       wMasForbillPFD: wMasForbillPFD ?? this.wMasForbillPFD,
//     );
//   }
// }
class MessageModel {
  final String id;
  final String? wMasForbillPFD;
  final String adminId;
  final String salonId;

  MessageModel({
    required this.id,
    this.wMasForbillPFD,
    required this.adminId,
    required this.salonId,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      wMasForbillPFD: json['wMasForbillPFD' ?? 'noDate'] as String?,
      adminId: json['adminId' ?? 'noData'] as String,
      salonId: json['salonId' ?? 'nData'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'wMasForbillPFD': wMasForbillPFD,
      'adminId': adminId,
      'salonId': salonId,
    };
  }

  MessageModel copyWith({
    String? id,
    String? wMasForbillPFD,
    String? adminId,
    String? salonId,
  }) {
    return MessageModel(
      id: id ?? this.id,
      wMasForbillPFD: wMasForbillPFD ?? this.wMasForbillPFD,
      adminId: adminId ?? this.adminId,
      salonId: salonId ?? this.salonId,
    );
  }
}
