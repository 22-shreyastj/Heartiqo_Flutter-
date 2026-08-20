import '../model/profile_model.dart';

const List<ProfileModel> sampleProfiles = [
  ProfileModel(
    name: 'Sophia, 26',
    age: 26,
    occupation: 'Travel Creator',
    avatarUrl: 'assets/images/profiles/imageee.jpeg',
    photos: ['assets/images/profiles/imageee.jpeg'],
    distance: '4 km away',
    bio:
        'Love travel, music, coffee and discovering new places. Looking for someone to explore hidden cafes with!',
    selectedInterests: ['Travel', 'Photography', 'Coffee'],
    verified: true,
    matchPercentage: '96%',
    matchReason: 'You both love Travel & Coffee!',
  ),
  ProfileModel(
    name: 'Emma, 25',
    age: 25,
    occupation: 'Fitness Coach',
    avatarUrl: 'assets/images/profiles/image2.avif',
    photos: ['assets/images/profiles/image2.avif'],
    distance: '6 km away',
    bio:
        'Fitness enthusiast, dog lover, and weekend baker. Let’s grab boba and talk about books!',
    selectedInterests: ['Music', 'Travel', 'Food'],
    verified: true,
    matchPercentage: '92%',
    matchReason: 'You both love Music & Food!',
  ),
  ProfileModel(
    name: 'Olivia, 27',
    age: 27,
    occupation: 'Art Director',
    avatarUrl: 'assets/images/profiles/image3.avif',
    photos: ['assets/images/profiles/image3.avif'],
    distance: '3 km away',
    bio:
        'Art director by day, indie film buff by night. Always down for live concerts!',
    selectedInterests: ['Photography', 'Movies', 'Coffee'],
    verified: false,
    matchPercentage: '89%',
    matchReason: 'You both love Photography & Movies!',
  ),
  ProfileModel(
    name: 'Isabella, 27',
    age: 27,
    occupation: 'Software Developer',
    avatarUrl: 'assets/images/profiles/image4.webp',
    photos: ['assets/images/profiles/image4.webp'],
    distance: '3 km away',
    bio:
        'Software developer who loves hiking, board games, and sunset photography.',
    selectedInterests: ['Tech', 'Hiking', 'Board Games', 'Sunset'],
    verified: true,
    matchPercentage: '94%',
    matchReason: 'You both love Tech & Hiking!',
  ),
];
