class DiscoverySettingsModel {
  final String preferredGender;
  final int minAge;
  final int maxAge;
  final double maxDistance;
  final bool showMeOnApp;
  final bool globalMode;

  const DiscoverySettingsModel({
    this.preferredGender = 'Everyone',
    this.minAge = 21,
    this.maxAge = 35,
    this.maxDistance = 25.0,
    this.showMeOnApp = true,
    this.globalMode = false,
  });

  factory DiscoverySettingsModel.fromJson(Map<String, dynamic> json) {
    return DiscoverySettingsModel(
      preferredGender: json['preferredGender'] as String? ?? 'Everyone',
      minAge: json['minAge'] as int? ?? 21,
      maxAge: json['maxAge'] as int? ?? 35,
      maxDistance: (json['maxDistance'] as num?)?.toDouble() ?? 25.0,
      showMeOnApp: json['showMeOnApp'] as bool? ?? true,
      globalMode: json['globalMode'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'preferredGender': preferredGender,
      'minAge': minAge,
      'maxAge': maxAge,
      'maxDistance': maxDistance,
      'showMeOnApp': showMeOnApp,
      'globalMode': globalMode,
    };
  }

  DiscoverySettingsModel copyWith({
    String? preferredGender,
    int? minAge,
    int? maxAge,
    double? maxDistance,
    bool? showMeOnApp,
    bool? globalMode,
  }) {
    return DiscoverySettingsModel(
      preferredGender: preferredGender ?? this.preferredGender,
      minAge: minAge ?? this.minAge,
      maxAge: maxAge ?? this.maxAge,
      maxDistance: maxDistance ?? this.maxDistance,
      showMeOnApp: showMeOnApp ?? this.showMeOnApp,
      globalMode: globalMode ?? this.globalMode,
    );
  }
}
