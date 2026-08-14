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
    this.selectedInterests = const ['Art', 'Foodie', 'Travel'],
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
  });

  List<String> get tags => selectedInterests;
  String get image => avatarUrl;

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
      selectedInterests: selectedInterests ?? this.selectedInterests,
      availableInterests: availableInterests ?? this.availableInterests,
      distance: distance ?? this.distance,
      verified: verified ?? this.verified,
    );
  }
}