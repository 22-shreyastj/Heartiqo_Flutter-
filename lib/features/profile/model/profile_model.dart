class ProfileModel {
  final String name;
  final String image;
  final String distance;
  final String bio;
  final List<String> tags;
  final bool verified;
  final String matchPercentage;
  final String matchReason;

  const ProfileModel({
    required this.name,
    required this.image,
    required this.distance,
    required this.bio,
    required this.tags,
    this.verified = false,
    this.matchPercentage = '96%',
    this.matchReason = 'You both love Travel & Music!',
  });
}