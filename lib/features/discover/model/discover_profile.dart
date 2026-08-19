class DiscoverProfile {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String? relationshipGoal;
  final String imageUrl;
  final String distance;
  final List<String> interests;
  final bool isVerified;
  final bool isFavorite;
  final bool onlineRecently;
  final bool hasPhoto;

  final String? bio;
  final String? profession;
  final String? height;
  final String? zodiac;
  final String? education;
  final String? drinking;
  final String? smoking;
  final int? matchScore;

  const DiscoverProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    this.relationshipGoal,
    required this.imageUrl,
    required this.distance,
    required this.interests,
    this.isVerified = false,
    this.isFavorite = false,
    this.onlineRecently = false,
    this.hasPhoto = true,
    this.bio,
    this.profession,
    this.height,
    this.zodiac,
    this.education,
    this.drinking,
    this.smoking,
    this.matchScore,
  });

  String get displayName => '$name, $age';

  DiscoverProfile copyWith({
    String? id,
    String? name,
    int? age,
    String? gender,
    String? relationshipGoal,
    String? imageUrl,
    String? distance,
    List<String>? interests,
    bool? isVerified,
    bool? isFavorite,
    bool? onlineRecently,
    bool? hasPhoto,
    String? bio,
    String? profession,
    String? height,
    String? zodiac,
    String? education,
    String? drinking,
    String? smoking,
    int? matchScore,
  }) {
    return DiscoverProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      relationshipGoal: relationshipGoal ?? this.relationshipGoal,
      imageUrl: imageUrl ?? this.imageUrl,
      distance: distance ?? this.distance,
      interests: interests ?? this.interests,
      isVerified: isVerified ?? this.isVerified,
      isFavorite: isFavorite ?? this.isFavorite,
      onlineRecently: onlineRecently ?? this.onlineRecently,
      hasPhoto: hasPhoto ?? this.hasPhoto,
      bio: bio ?? this.bio,
      profession: profession ?? this.profession,
      height: height ?? this.height,
      zodiac: zodiac ?? this.zodiac,
      education: education ?? this.education,
      drinking: drinking ?? this.drinking,
      smoking: smoking ?? this.smoking,
      matchScore: matchScore ?? this.matchScore,
    );
  }
}
