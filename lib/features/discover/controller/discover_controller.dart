import 'package:flutter/material.dart';
import '../data/discover_mock_data.dart';
import '../model/discover_filter_state.dart';
import '../model/discover_profile.dart';
import '../model/discover_search_models.dart';
import '../utils/discover_filter_helper.dart';

export '../model/discover_filter_state.dart';
export '../model/discover_search_models.dart';

class DiscoverController extends ChangeNotifier {
  static const List<String> distanceOptions = [
    '1 mile',
    '2 miles',
    '5 miles',
    '10 miles',
    '20 miles',
    '50 miles',
    'Any distance',
  ];

  static const List<String> genderOptions = ['Women', 'Men', 'Everyone'];

  static const List<String> relationshipGoalOptions = [
    'Long-term',
    'Short-term',
    'Friendship',
  ];

  // View and Filter state
  bool _isGridView = true;
  String _selectedFilter = 'Filters';
  String _selectedDistance = 'Distance';
  final Set<String> _selectedInterests = {};
  DiscoverFilterState _filterState = const DiscoverFilterState();

  // Search state
  String _searchQuery = '';
  bool _showSuggestions = true;

  // Data
  List<DiscoverProfile> _profiles = DiscoverMockData.profiles;
  final List<RecentSearchItem> _recentSearchHistory = [];
  final List<TrendingInterestItem> _trendingInterests =
      DiscoverMockData.trendingInterests;

  // Getters
  bool get isGridView => _isGridView;
  String get selectedFilter => _selectedFilter;
  String get selectedDistance => _selectedDistance;
  Set<String> get selectedInterests => Set.unmodifiable(_selectedInterests);
  DiscoverFilterState get filterState => _filterState;

  String get genderPreference => _filterState.genderPreference;
  RangeValues get ageRange => _filterState.ageRange;
  String? get relationshipGoal => _filterState.relationshipGoal;
  bool get verifiedOnly => _filterState.verifiedOnly;
  bool get onlineRecentlyOnly => _filterState.onlineRecentlyOnly;
  bool get hasPhotoOnly => _filterState.hasPhotoOnly;

  String get searchQuery => _searchQuery;
  bool get showSuggestions => _showSuggestions;
  List<TrendingInterestItem> get trendingInterests =>
      List.unmodifiable(_trendingInterests);

  List<String> get availableInterests {
    final interests = <String>{};

    for (final profile in _profiles) {
      interests.addAll(profile.interests);
    }
    for (final trending in _trendingInterests) {
      interests.add(trending.label);
    }

    final result = interests.toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    return List.unmodifiable(result);
  }

  List<RecentSearchItem> get recentSearches {
    final result = List<RecentSearchItem>.from(_recentSearchHistory);

    result.sort((a, b) {
      final countComparison = b.count.compareTo(a.count);
      if (countComparison != 0) {
        return countComparison;
      }
      return b.lastSearchedAt.compareTo(a.lastSearchedAt);
    });

    return List.unmodifiable(result.take(5));
  }

  bool _matchesAllFilters(DiscoverProfile profile) {
    return DiscoverFilterHelper.matches(
      profile: profile,
      searchQuery: _searchQuery,
      selectedDistance: _selectedDistance,
      selectedInterests: _selectedInterests,
      filters: _filterState,
    );
  }

  List<DiscoverProfile> get profiles {
    return List.unmodifiable(_profiles.where(_matchesAllFilters).toList());
  }

  List<DiscoverProfile> get filteredProfiles {
    if (_searchQuery.trim().isEmpty) {
      return const [];
    }
    return List.unmodifiable(_profiles.where(_matchesAllFilters).toList());
  }

  List<SearchSuggestion> get suggestions {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty || !_showSuggestions) {
      return const [];
    }

    final result = <SearchSuggestion>[];
    final added = <String>{};

    for (final profile in _profiles) {
      final name = profile.name.toLowerCase();
      if (name.contains(query) && added.add(name)) {
        result.add(
          SearchSuggestion(text: profile.name, type: SearchSuggestionType.name),
        );
      }
    }

    for (final interest in availableInterests) {
      final normalized = interest.toLowerCase();
      if (normalized.contains(query) && added.add(normalized)) {
        result.add(
          SearchSuggestion(text: interest, type: SearchSuggestionType.interest),
        );
      }
    }

    return List.unmodifiable(result.take(6));
  }

  // View Mode
  void setViewMode(bool isGrid) {
    if (_isGridView == isGrid) return;
    _isGridView = isGrid;
    notifyListeners();
  }

  // Filter Bar Actions
  void setFilter(String filter) {
    if (_selectedFilter == filter) return;
    _selectedFilter = filter;
    notifyListeners();
  }

  void setDistanceFilter(String distance) {
    if (_selectedDistance == distance) return;
    _selectedDistance = distance;
    notifyListeners();
  }

  void setSelectedInterests(Iterable<String> interests) {
    final next = interests.toSet();
    if (_selectedInterests.length == next.length &&
        _selectedInterests.containsAll(next)) {
      return;
    }
    _selectedInterests
      ..clear()
      ..addAll(next);
    notifyListeners();
  }

  // Advanced Filter Actions
  void setGenderPreference(String value) {
    if (_filterState.genderPreference == value) return;
    _filterState = _filterState.copyWith(genderPreference: value);
    notifyListeners();
  }

  void setAgeRange(RangeValues value) {
    if (_filterState.ageRange == value) return;
    _filterState = _filterState.copyWith(ageRange: value);
    notifyListeners();
  }

  void setRelationshipGoal(String? value) {
    if (_filterState.relationshipGoal == value) return;
    _filterState = _filterState.copyWith(
      relationshipGoal: value,
      clearRelationshipGoal: value == null,
    );
    notifyListeners();
  }

  void setVerifiedOnly(bool value) {
    if (_filterState.verifiedOnly == value) return;
    _filterState = _filterState.copyWith(verifiedOnly: value);
    notifyListeners();
  }

  void setOnlineRecentlyOnly(bool value) {
    if (_filterState.onlineRecentlyOnly == value) return;
    _filterState = _filterState.copyWith(onlineRecentlyOnly: value);
    notifyListeners();
  }

  void setHasPhotoOnly(bool value) {
    if (_filterState.hasPhotoOnly == value) return;
    _filterState = _filterState.copyWith(hasPhotoOnly: value);
    notifyListeners();
  }

  void resetAdvancedFilters() {
    _filterState = const DiscoverFilterState();
    notifyListeners();
  }

  void resetAllFilters() {
    _selectedFilter = 'Filters';
    _selectedDistance = 'Distance';
    _selectedInterests.clear();
    _filterState = const DiscoverFilterState();
    notifyListeners();
  }

  // Search Actions
  void setSearchQuery(String query, {bool hideSuggestions = false}) {
    _searchQuery = query;
    _showSuggestions = !hideSuggestions;
    notifyListeners();
  }

  void selectSuggestion(String value) {
    setSearchQuery(value, hideSuggestions: true);
    registerCompletedSearch(value);
  }

  void clearSearch() {
    if (_searchQuery.isEmpty && !_showSuggestions) return;
    _searchQuery = '';
    _showSuggestions = false;
    notifyListeners();
  }

  // Recent Searches
  void registerCompletedSearch(String rawQuery) {
    final query = rawQuery.trim();
    if (query.isEmpty) return;

    final now = DateTime.now();
    final index = _recentSearchHistory.indexWhere(
      (item) => item.query.toLowerCase() == query.toLowerCase(),
    );

    if (index >= 0) {
      final existing = _recentSearchHistory[index];
      _recentSearchHistory[index] = existing.copyWith(
        count: existing.count + 1,
        lastSearchedAt: now,
      );
      notifyListeners();
      return;
    }

    DiscoverProfile? matchedProfile;
    for (final profile in _profiles) {
      if (profile.name.toLowerCase() == query.toLowerCase()) {
        matchedProfile = profile;
        break;
      }
    }

    _recentSearchHistory.add(
      RecentSearchItem(
        id: now.microsecondsSinceEpoch.toString(),
        query: query,
        count: 1,
        lastSearchedAt: now,
        profileName: matchedProfile?.name ?? query,
        age: matchedProfile?.age,
        imageUrl: matchedProfile?.imageUrl,
      ),
    );

    notifyListeners();
  }

  void clearRecentSearches() {
    if (_recentSearchHistory.isEmpty) return;
    _recentSearchHistory.clear();
    notifyListeners();
  }

  void removeRecentSearch(String id) {
    final previousLength = _recentSearchHistory.length;
    _recentSearchHistory.removeWhere((item) => item.id == id);
    if (previousLength != _recentSearchHistory.length) {
      notifyListeners();
    }
  }

  // Favorites
  void toggleFavorite(String profileId) {
    final index = _profiles.indexWhere((profile) => profile.id == profileId);
    if (index == -1) return;

    final updated = List<DiscoverProfile>.from(_profiles);
    final current = updated[index];
    updated[index] = current.copyWith(isFavorite: !current.isFavorite);
    _profiles = updated;
    notifyListeners();
  }
}
