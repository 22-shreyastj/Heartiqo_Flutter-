class ProfileModel {
  final String name;
  final String image;
  final String distance;
  final String bio;
  final List<String> tags;
  final bool verified;

  const ProfileModel({
    required this.name,
    required this.image,
    required this.distance,
    required this.bio,
    required this.tags,
    this.verified = false,
  });
}