class DiscoverProfile {
  final String id;
  final String name;
  final int age;
  final String imageUrl;
  final String distance;
  final List<String> interests;
  final bool isVerified;
  final bool isFavorite;

  const DiscoverProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.imageUrl,
    required this.distance,
    required this.interests,
    this.isVerified = false,
    this.isFavorite = false,
  });

  String get displayName => '$name, $age';

  DiscoverProfile copyWith({
    String? id,
    String? name,
    int? age,
    String? imageUrl,
    String? distance,
    List<String>? interests,
    bool? isVerified,
    bool? isFavorite,
  }) {
    return DiscoverProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      imageUrl: imageUrl ?? this.imageUrl,
      distance: distance ?? this.distance,
      interests: interests ?? this.interests,
      isVerified: isVerified ?? this.isVerified,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
