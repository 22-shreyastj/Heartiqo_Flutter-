class ProfileModel {
  final String id;
  final String name;
  final int age;
  final String occupation;
  final String avatarUrl;
  final List<String> photos;
  final int likesCount;
  final int matchesCount;
  final String viewsCount;
  final String bio;
  final String jobTitle;
  final String education;
  final String gender;
  final String location;
  final List<String> selectedInterests;
  final List<String> availableInterests;
  final String distance;
  final bool verified;
  final String matchPercentage;
  final String matchReason;
  final String email;
  final String phoneNumber;
  final String dob;
  final String subscriptionPlan;
  final bool isPremium;

  const ProfileModel({
    this.id = '1',
    required this.name,
    required this.age,
    required this.occupation,
    required this.avatarUrl,
    required this.photos,
    this.likesCount = 245,
    this.matchesCount = 32,
    this.viewsCount = '1.2k',
    this.bio = '',
    this.jobTitle = 'Product Designer',
    this.education = 'University of Design',
    this.gender = 'Woman',
    this.location = 'San Francisco, CA',
    this.selectedInterests = const [
      'Art',
      'Foodie',
      'Travel',
    ],
    this.availableInterests = const [
      'Fitness',
      'Gaming',
      'Yoga',
      'Cooking',
      'Movies',
      'Music',
    ],
    this.distance = '4 km away',
    this.verified = true,
    this.matchPercentage = '96%',
    this.matchReason = 'You both love Travel & Music!',
    this.email = 'alex.morgan@example.com',
    this.phoneNumber = '+1 (555) 234-5678',
    this.dob = '1996-05-15',
    this.subscriptionPlan = 'Free',
    this.isPremium = false,
  });

  /// Compatibility getter used by existing UI code.
  String get image => avatarUrl;

  /// Compatibility getter used by existing UI code.
  List<String> get tags => selectedInterests;

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String? ?? '1',
      name: json['name'] as String? ?? '',
      age: json['age'] as int? ?? 18,
      occupation: json['occupation'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String? ?? '',
      photos: (json['photos'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      likesCount: json['likesCount'] as int? ?? 0,
      matchesCount: json['matchesCount'] as int? ?? 0,
      viewsCount: json['viewsCount'] as String? ?? '0',
      bio: json['bio'] as String? ?? '',
      jobTitle: json['jobTitle'] as String? ?? '',
      education: json['education'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      location: json['location'] as String? ?? '',
      selectedInterests: (json['selectedInterests'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      availableInterests: (json['availableInterests'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      distance: json['distance'] as String? ?? '',
      verified: json['verified'] as bool? ?? false,
      matchPercentage: json['matchPercentage'] as String? ?? '',
      matchReason: json['matchReason'] as String? ?? '',
      email: json['email'] as String? ?? 'alex.morgan@example.com',
      phoneNumber: json['phoneNumber'] as String? ?? '+1 (555) 234-5678',
      dob: json['dob'] as String? ?? '1996-05-15',
      subscriptionPlan: json['subscriptionPlan'] as String? ?? 'Free',
      isPremium: json['isPremium'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'occupation': occupation,
      'avatarUrl': avatarUrl,
      'photos': photos,
      'likesCount': likesCount,
      'matchesCount': matchesCount,
      'viewsCount': viewsCount,
      'bio': bio,
      'jobTitle': jobTitle,
      'education': education,
      'gender': gender,
      'location': location,
      'selectedInterests': selectedInterests,
      'availableInterests': availableInterests,
      'distance': distance,
      'verified': verified,
      'matchPercentage': matchPercentage,
      'matchReason': matchReason,
      'email': email,
      'phoneNumber': phoneNumber,
      'dob': dob,
      'subscriptionPlan': subscriptionPlan,
      'isPremium': isPremium,
    };
  }

  ProfileModel copyWith({
    String? id,
    String? name,
    int? age,
    String? occupation,
    String? avatarUrl,
    List<String>? photos,
    int? likesCount,
    int? matchesCount,
    String? viewsCount,
    String? bio,
    String? jobTitle,
    String? education,
    String? gender,
    String? location,
    List<String>? selectedInterests,
    List<String>? availableInterests,
    String? distance,
    bool? verified,
    String? matchPercentage,
    String? matchReason,
    String? email,
    String? phoneNumber,
    String? dob,
    String? subscriptionPlan,
    bool? isPremium,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      occupation: occupation ?? this.occupation,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      photos: photos ?? this.photos,
      likesCount: likesCount ?? this.likesCount,
      matchesCount: matchesCount ?? this.matchesCount,
      viewsCount: viewsCount ?? this.viewsCount,
      bio: bio ?? this.bio,
      jobTitle: jobTitle ?? this.jobTitle,
      education: education ?? this.education,
      gender: gender ?? this.gender,
      location: location ?? this.location,
      selectedInterests:
          selectedInterests ?? this.selectedInterests,
      availableInterests:
          availableInterests ?? this.availableInterests,
      distance: distance ?? this.distance,
      verified: verified ?? this.verified,
      matchPercentage:
          matchPercentage ?? this.matchPercentage,
      matchReason: matchReason ?? this.matchReason,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dob: dob ?? this.dob,
      subscriptionPlan: subscriptionPlan ?? this.subscriptionPlan,
      isPremium: isPremium ?? this.isPremium,
    );
  }
}