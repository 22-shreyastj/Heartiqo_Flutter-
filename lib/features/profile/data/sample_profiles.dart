import '../model/profile_model.dart';

final List<ProfileModel> sampleProfiles = const [
  ProfileModel(
    name: 'Sophia, 26',
    image: 'assets/images/profiles/image1.jpg',
    distance: '4 km away',
    bio:
        'Love travel, music, coffee and discovering new places. Looking for someone to explore hidden cafes with!',
    tags: ['Travel', 'Photography', 'Coffee'],
    verified: true,
    matchPercentage: '96%',
    matchReason: 'You both love Travel & Coffee!',
  ),
  ProfileModel(
    name: 'Emma, 25',
    image: 'assets/images/profiles/image2.avif',
    distance: '6 km away',
    bio:
        'Fitness enthusiast, dog lover, and weekend baker. Let’s grab boba and talk about books!',
    tags: ['Music', 'Travel', 'Food'],
    verified: true,
    matchPercentage: '92%',
    matchReason: 'You both love Music & Food!',
  ),
  ProfileModel(
    name: 'Olivia, 27',
    image: 'assets/images/profiles/image3.avif',
    distance: '3 km away',
    bio:
        'Art director by day, indie film buff by night. Always down for live concerts!',
    tags: ['Photography', 'Movies', 'Coffee'],
    verified: false,
    matchPercentage: '89%',
    matchReason: 'You both love Photography & Movies!',
  ),
  ProfileModel(
    name: 'Isabella, 27',
    image: 'assets/images/profiles/image4.webp',
    distance: '3 km away',
    bio:
        'Software developer who loves hiking, board games, and sunset photography.',
    tags: ['Tech', 'Hiking', 'Board Games', 'Sunset'],
    verified: true,
    matchPercentage: '94%',
    matchReason: 'You both love Tech & Hiking!',
  ),
];
