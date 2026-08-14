import 'package:flutter/foundation.dart';
import '../model/discover_profile.dart';

class DiscoverController extends ChangeNotifier {
  bool _isGridView = true;
  String _selectedFilter = 'Filters';
  List<DiscoverProfile> _profiles = const [];

  DiscoverController() {
    _loadInitialProfiles();
  }

  bool get isGridView => _isGridView;
  String get selectedFilter => _selectedFilter;
  List<DiscoverProfile> get profiles => List.unmodifiable(_profiles);

  void setViewMode(bool isGrid) {
    if (_isGridView == isGrid) return;
    _isGridView = isGrid;
    notifyListeners();
  }

  void setFilter(String filter) {
    if (_selectedFilter == filter) return;
    _selectedFilter = filter;
    notifyListeners();
  }

  void toggleFavorite(String profileId) {
    final index = _profiles.indexWhere((p) => p.id == profileId);
    if (index != -1) {
      final updatedList = List<DiscoverProfile>.from(_profiles);
      final current = updatedList[index];
      updatedList[index] = current.copyWith(isFavorite: !current.isFavorite);
      _profiles = updatedList;
      notifyListeners();
    }
  }

  void _loadInitialProfiles() {
    _profiles = const [
      DiscoverProfile(
        id: '1',
        name: 'Elena',
        age: 26,
        imageUrl:
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=600&q=80',
        distance: '2 miles away',
        interests: ['Photography', 'Cooking'],
        isVerified: true,
      ),
      DiscoverProfile(
        id: '2',
        name: 'Marcus',
        age: 28,
        imageUrl:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=600&q=80',
        distance: '5 miles away',
        interests: ['Hiking', 'Dogs'],
        isVerified: true,
      ),
      DiscoverProfile(
        id: '3',
        name: 'Sophia',
        age: 31,
        imageUrl:
            'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=600&q=80',
        distance: '1 mile away',
        interests: ['Art', 'Wine'],
        isVerified: true,
      ),
      DiscoverProfile(
        id: '4',
        name: 'David',
        age: 29,
        imageUrl:
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=600&q=80',
        distance: '8 miles away',
        interests: ['Music', 'Live Gigs'],
        isVerified: false,
      ),
      DiscoverProfile(
        id: '5',
        name: 'Sarah',
        age: 27,
        imageUrl:
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=600&q=80',
        distance: '3 miles away',
        interests: ['Dogs', 'Outdoors'],
        isVerified: true,
      ),
      DiscoverProfile(
        id: '6',
        name: 'James',
        age: 32,
        imageUrl:
            'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=600&q=80',
        distance: '4 miles away',
        interests: ['Cooking', 'Foodie'],
        isVerified: false,
      ),
    ];
  }
}
