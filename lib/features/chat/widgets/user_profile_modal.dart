import 'package:flutter/material.dart';

class UserProfileData {
  final String name;
  final int age;
  final String occupation;
  final String image;
  final String location;
  final String bio;
  final List<String> interests;
  final String matchPercentage;
  final String matchReason;
  final bool isVerified;

  const UserProfileData({
    required this.name,
    required this.age,
    required this.occupation,
    required this.image,
    required this.location,
    required this.bio,
    required this.interests,
    required this.matchPercentage,
    required this.matchReason,
    this.isVerified = true,
  });
}

class UserProfileModal extends StatelessWidget {
  final String name;
  final String image;
  final bool isOnline;
  final bool isBlocked;
  final VoidCallback? onCallTap;
  final VoidCallback? onVideoTap;
  final VoidCallback? onToggleBlock;

  const UserProfileModal({
    super.key,
    required this.name,
    required this.image,
    required this.isOnline,
    this.isBlocked = false,
    this.onCallTap,
    this.onVideoTap,
    this.onToggleBlock,
  });

  static UserProfileData _getBioDataForUser(String name, String fallbackImage) {
    final lower = name.toLowerCase();
    if (lower.contains('elena')) {
      return UserProfileData(
        name: 'Elena',
        age: 25,
        occupation: 'Fashion Stylist & Designer',
        image: fallbackImage,
        location: '3 km away • Jubilee Hills',
        bio:
            'Passionate about sustainable fashion, vintage thrifting, and aesthetic coffee spots. Always down for art gallery walks and late-night jazz bars! ☕✨',
        interests: ['Fashion', 'Art', 'Coffee', 'Jazz', 'Thrifting', 'Travel'],
        matchPercentage: '95%',
        matchReason: 'You both love Coffee, Art & Travel!',
      );
    } else if (lower.contains('alex')) {
      return UserProfileData(
        name: 'Alex',
        age: 26,
        occupation: 'Architectural Designer',
        image: fallbackImage,
        location: '4 km away • Banjara Hills',
        bio:
            'Building design nerd, avid hiker, and specialty coffee lover. Looking for someone to explore hidden rooftop cafes with! 🏔️☕',
        interests: ['Architecture', 'Hiking', 'Specialty Coffee', 'Design', 'Photography'],
        matchPercentage: '96%',
        matchReason: 'You both love Hiking & Specialty Coffee!',
      );
    } else if (lower.contains('jordan')) {
      return UserProfileData(
        name: 'Jordan',
        age: 24,
        occupation: 'UI/UX Product Designer',
        image: fallbackImage,
        location: '5 km away • Hitech City',
        bio:
            'Pixel perfectionist by day, indie music buff by night. Let\'s exchange Spotify playlists and discover new food trucks! 🎧🍔',
        interests: ['Design', 'Indie Music', 'Foodie', 'Spotify', 'Gaming'],
        matchPercentage: '91%',
        matchReason: 'You both love Music & Design!',
      );
    } else if (lower.contains('marcus')) {
      return UserProfileData(
        name: 'Marcus',
        age: 28,
        occupation: 'Senior Software Engineer',
        image: fallbackImage,
        location: '2 km away • Gachibowli',
        bio:
            'Full-stack dev, marathon runner, and proud golden retriever dad. Searching for the best espresso brew in town ☕🐕',
        interests: ['Tech', 'Running', 'Dogs', 'Espresso', 'Fitness'],
        matchPercentage: '94%',
        matchReason: 'You both love Tech & Coffee!',
      );
    } else if (lower.contains('sophia')) {
      return UserProfileData(
        name: 'Sophia',
        age: 26,
        occupation: 'Travel Content Creator',
        image: fallbackImage,
        location: '4 km away • Madhapur',
        bio:
            'Love travel, photography, ocean sunsets, and vibrant street culture. Searching for a travel partner for weekend getaways! ✈️📸',
        interests: ['Travel', 'Photography', 'Coffee', 'Beach', 'Sunsets'],
        matchPercentage: '96%',
        matchReason: 'You both love Travel & Photography!',
      );
    } else if (lower.contains('lucas')) {
      return UserProfileData(
        name: 'Lucas',
        age: 27,
        occupation: 'Music Producer & DJ',
        image: fallbackImage,
        location: '6 km away • Kondapur',
        bio:
            'Synth-wave beat maker, collector of vintage vinyl records, and lover of spicy street tacos 🎶🌮',
        interests: ['Music Production', 'Vinyl', 'Street Food', 'Concerts'],
        matchPercentage: '88%',
        matchReason: 'You both love Live Music & Food!',
      );
    } else if (lower.contains('maya')) {
      return UserProfileData(
        name: 'Maya',
        age: 25,
        occupation: 'Portrait Photographer',
        image: fallbackImage,
        location: '3 km away • Film Nagar',
        bio:
            'Capturing golden hour moments. Obsessed with 35mm film photography, iced matcha lattes, and museum visits 🍵📷',
        interests: ['Photography', 'Matcha', 'Film Camera', 'Museums', 'Art'],
        matchPercentage: '93%',
        matchReason: 'You both love Photography & Art!',
      );
    } else if (lower.contains('liam')) {
      return UserProfileData(
        name: 'Liam',
        age: 29,
        occupation: 'Product Strategist',
        image: fallbackImage,
        location: '7 km away • Financial District',
        bio:
            'Tech strategist, craft beer enthusiast, and amateur chef. Weekend road trips into nature are my reset button 🚗🌲',
        interests: ['Tech', 'Cooking', 'Road Trips', 'Craft Beer', 'Outdoors'],
        matchPercentage: '90%',
        matchReason: 'You both love Cooking & Road Trips!',
      );
    } else if (lower.contains('chloe')) {
      return UserProfileData(
        name: 'Chloe',
        age: 23,
        occupation: 'Food & Lifestyle Blogger',
        image: fallbackImage,
        location: '2 km away • Begumpet',
        bio:
            'Exploring every culinary corner of the city. Lover of artisanal gelato, rooftop dining, and cozy reading corners 🍦📖',
        interests: ['Food Blogging', 'Gelato', 'Rooftops', 'Reading', 'Travel'],
        matchPercentage: '97%',
        matchReason: 'You both love Food & Rooftops!',
      );
    }

    return UserProfileData(
      name: name,
      age: 27,
      occupation: 'Creative Professional',
      image: fallbackImage,
      location: '3 km away • City Center',
      bio:
          'Passionate about art, travel, good music, and meaningful conversations over coffee ☕✨',
      interests: ['Travel', 'Music', 'Coffee', 'Art', 'Fitness'],
      matchPercentage: '92%',
      matchReason: 'You have high compatibility and shared interests!',
    );
  }

  static void show(
    BuildContext context, {
    required String name,
    required String image,
    required bool isOnline,
    bool isBlocked = false,
    VoidCallback? onCallTap,
    VoidCallback? onVideoTap,
    VoidCallback? onToggleBlock,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => UserProfileModal(
        name: name,
        image: image,
        isOnline: isOnline,
        isBlocked: isBlocked,
        onCallTap: onCallTap,
        onVideoTap: onVideoTap,
        onToggleBlock: onToggleBlock,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bioData = _getBioDataForUser(name, image);

    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Cover Image & Profile Avatar
                Stack(
                  children: [
                    Container(
                      height: 220,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                        child: Image.network(
                          bioData.image,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: const Color(0xFFFFDDEB),
                              child: Center(
                                child: Icon(Icons.person, size: 80, color: Colors.pink.shade300),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Container(
                      height: 220,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.3),
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.6),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 16,
                      right: 16,
                      child: CircleAvatar(
                        backgroundColor: Colors.black45,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 20,
                      right: 20,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD41470),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.favorite, color: Colors.white, size: 14),
                                const SizedBox(width: 5),
                                Text(
                                  '${bioData.matchPercentage} Match',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: isOnline ? Colors.green.shade600 : Colors.grey.shade700,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  isOnline ? 'Online' : 'Offline',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name & Age Row
                      Row(
                        children: [
                          Text(
                            '${bioData.name}, ${bioData.age}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (bioData.isVerified)
                            const Icon(
                              Icons.verified,
                              color: Color(0xFFD41470),
                              size: 22,
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Occupation & Location
                      Row(
                        children: [
                          const Icon(Icons.work_outline, size: 16, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(
                            bioData.occupation,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 16, color: Color(0xFFD41470)),
                          const SizedBox(width: 6),
                          Text(
                            bioData.location,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Match reason box
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFEFF5),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFFFC0D8)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.auto_awesome, color: Color(0xFFD41470), size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                bioData.matchReason,
                                style: const TextStyle(
                                  color: Color(0xFFB50068),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Bio Section
                      const Text(
                        'About Bio',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        bioData.bio,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.45,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Interests Section
                      const Text(
                        'Interests',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: bioData.interests.map((interest) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFEFF5),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFFFFB3C6), width: 0.8),
                            ),
                            child: Text(
                              interest,
                              style: const TextStyle(
                                color: Color(0xFFD41470),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 30),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.call, color: Color(0xFFD41470)),
                              label: const Text(
                                'Audio Call',
                                style: TextStyle(
                                  color: Color(0xFFD41470),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                side: const BorderSide(color: Color(0xFFD41470)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                onCallTap?.call();
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.videocam, color: Colors.white),
                              label: const Text(
                                'Video Call',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD41470),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                onVideoTap?.call();
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton.icon(
                          icon: Icon(
                            isBlocked ? Icons.lock_open : Icons.block,
                            color: isBlocked ? Colors.green : Colors.redAccent,
                            size: 20,
                          ),
                          label: Text(
                            isBlocked ? 'Unblock User' : 'Block User',
                            style: TextStyle(
                              color: isBlocked ? Colors.green : Colors.redAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            onToggleBlock?.call();
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
