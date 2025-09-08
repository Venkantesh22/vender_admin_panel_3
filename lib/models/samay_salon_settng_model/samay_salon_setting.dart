class SamaySalonSettingModel {
  final String id;
  final String platformFee;
  final int appointmentNo;
  final double gstPer; // New GST percentage field
  final String version
;

  SamaySalonSettingModel({
    required this.id,
    required this.platformFee,
    required this.appointmentNo,
    required this.gstPer, // Added to constructor
    required this.version, 
  });

  factory SamaySalonSettingModel.fromJson(Map<String, dynamic> json) {
    return SamaySalonSettingModel(
      id: json['id'] as String,
      platformFee: json['platformFee'] as String,
      appointmentNo: json['appointmentNo'] as int,
      gstPer: json['gstPer'] as double, // Added to fromJson
      version : json['version'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'platformFee': platformFee,
      'appointmentNo': appointmentNo,
      'gstPer': gstPer, // Added to toJson
      'version' : version
    };
  }

  SamaySalonSettingModel copyWith({
    String? id,
    String? platformFee,
    int? appointmentNo,
    double? gstPer, // Added to copyWith
    String? version,
  }) {
    return SamaySalonSettingModel(
      id: id ?? this.id,
      platformFee: platformFee ?? this.platformFee,
      appointmentNo: appointmentNo ?? this.appointmentNo,
      gstPer: gstPer ?? this.gstPer, // Added to copyWith
      version : version ?? this.version,
    );
  }
}
