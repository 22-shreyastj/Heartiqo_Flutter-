class BlockedUserModel {
  final String id;
  final String name;
  final String avatarUrl;
  final String blockedDate;
  final String reason;

  const BlockedUserModel({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.blockedDate,
    required this.reason,
  });

  factory BlockedUserModel.fromJson(Map<String, dynamic> json) {
    return BlockedUserModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String? ?? '',
      blockedDate: json['blockedDate'] as String? ?? '',
      reason: json['reason'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatarUrl': avatarUrl,
      'blockedDate': blockedDate,
      'reason': reason,
    };
  }
}

class UserReportModel {
  final String id;
  final String reportedUserName;
  final String reason;
  final String description;
  final String timestamp;
  final String status;

  const UserReportModel({
    required this.id,
    required this.reportedUserName,
    required this.reason,
    required this.description,
    required this.timestamp,
    this.status = 'Pending Review',
  });

  factory UserReportModel.fromJson(Map<String, dynamic> json) {
    return UserReportModel(
      id: json['id'] as String? ?? '',
      reportedUserName: json['reportedUserName'] as String? ?? '',
      reason: json['reason'] as String? ?? '',
      description: json['description'] as String? ?? '',
      timestamp: json['timestamp'] as String? ?? '',
      status: json['status'] as String? ?? 'Pending Review',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reportedUserName': reportedUserName,
      'reason': reason,
      'description': description,
      'timestamp': timestamp,
      'status': status,
    };
  }
}

class PrivacySettingsModel {
  final bool hideOnlineStatus;
  final bool incognitoMode;
  final bool hideDistance;
  final bool readReceipts;
  final bool twoFactorEnabled;

  const PrivacySettingsModel({
    this.hideOnlineStatus = false,
    this.incognitoMode = false,
    this.hideDistance = false,
    this.readReceipts = true,
    this.twoFactorEnabled = true,
  });

  factory PrivacySettingsModel.fromJson(Map<String, dynamic> json) {
    return PrivacySettingsModel(
      hideOnlineStatus: json['hideOnlineStatus'] as bool? ?? false,
      incognitoMode: json['incognitoMode'] as bool? ?? false,
      hideDistance: json['hideDistance'] as bool? ?? false,
      readReceipts: json['readReceipts'] as bool? ?? true,
      twoFactorEnabled: json['twoFactorEnabled'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hideOnlineStatus': hideOnlineStatus,
      'incognitoMode': incognitoMode,
      'hideDistance': hideDistance,
      'readReceipts': readReceipts,
      'twoFactorEnabled': twoFactorEnabled,
    };
  }

  PrivacySettingsModel copyWith({
    bool? hideOnlineStatus,
    bool? incognitoMode,
    bool? hideDistance,
    bool? readReceipts,
    bool? twoFactorEnabled,
  }) {
    return PrivacySettingsModel(
      hideOnlineStatus: hideOnlineStatus ?? this.hideOnlineStatus,
      incognitoMode: incognitoMode ?? this.incognitoMode,
      hideDistance: hideDistance ?? this.hideDistance,
      readReceipts: readReceipts ?? this.readReceipts,
      twoFactorEnabled: twoFactorEnabled ?? this.twoFactorEnabled,
    );
  }
}
