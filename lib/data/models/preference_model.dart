class PreferenceModel {
  final List<String> preferFacilities;
  final List<String> preferAtmosphere;
  final List<String> preferLocation;

  PreferenceModel({
    this.preferFacilities = const [],
    this.preferAtmosphere = const [],
    this.preferLocation = const [],
  });

  factory PreferenceModel.fromJson(Map<String, dynamic> json) {
    return PreferenceModel(
      preferFacilities: json['preferFacilities'] != null
          ? List<String>.from(json['preferFacilities'])
          : [],
      preferAtmosphere: json['preferAtmosphere'] != null
          ? List<String>.from(json['preferAtmosphere'])
          : [],
      preferLocation: json['preferLocation'] != null
          ? List<String>.from(json['preferLocation'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'preferFacilities': preferFacilities,
      'preferAtmosphere': preferAtmosphere,
      'preferLocation': preferLocation,
    };
  }
}