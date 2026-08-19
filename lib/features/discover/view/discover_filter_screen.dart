import 'package:flutter/material.dart';
import '../../../core/widgets/app_bottom_nav.dart';
import '../../profile/view/profile_screen.dart';
import '../controller/discover_controller.dart';
import '../widgets/discover_header.dart';
import '../widgets/discover_profile_card.dart';
import '../widgets/discover_recent_searches.dart';
import '../widgets/discover_search_input.dart';
import '../widgets/discover_search_suggestions.dart';
import '../widgets/discover_trending_interests.dart';
import 'discover_profile_detail_screen.dart';

class DiscoverFilterScreen extends StatefulWidget {
  final DiscoverController? controller;

  const DiscoverFilterScreen({super.key, this.controller});

  @override
  State<DiscoverFilterScreen> createState() => _DiscoverFilterScreenState();
}

class _DiscoverFilterScreenState extends State<DiscoverFilterScreen> {
  late final DiscoverController _controller;
  late final TextEditingController _searchEditingController;
  bool _isOwnedController = false;
  int _currentNavIndex = 1; // Discover tab active

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
      _isOwnedController = false;
    } else {
      _controller = DiscoverController();
      _isOwnedController = true;
    }
    _searchEditingController = TextEditingController(
      text: _controller.searchQuery,
    );
  }

  @override
  void dispose() {
    _searchEditingController.dispose();
    if (_isOwnedController) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onSuggestionSelected(String value) {
    _searchEditingController.text = value;
    _searchEditingController.selection = TextSelection.fromPosition(
      TextPosition(offset: value.length),
    );
    _controller.selectSuggestion(value);
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFFFF8F8);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _controller,
          builder: (context, _) {
            final isSearchEmpty = _controller.searchQuery.trim().isEmpty;
            final suggestions = _controller.suggestions;
            final filteredProfiles = _controller.filteredProfiles;

            return Column(
              children: [
                // Header (Back button on left, Heartiqo title, Alert button on right)
                DiscoverHeader(
                  showBackButton: true,
                  onBackTap: () {
                    Navigator.of(context).pop();
                  },
                  onNotificationTap: () {},
                ),

                const SizedBox(height: 10),

                // Search Input Field
                DiscoverSearchInput(
                  controller: _searchEditingController,
                  onChanged: (query) {
                    _controller.setSearchQuery(query);
                  },
                  onSubmitted: (query) {
                    if (query.trim().isNotEmpty) {
                      _controller.registerCompletedSearch(query);
                    }
                  },
                  onClear: () {
                    _controller.clearSearch();
                  },
                ),

                // Live Dropdown Suggestion List (below search bar)
                if (suggestions.isNotEmpty)
                  DiscoverSearchSuggestions(
                    suggestions: suggestions,
                    onSelect: _onSuggestionSelected,
                  ),

                const SizedBox(height: 16),

                // Main Content Body
                Expanded(
                  child: isSearchEmpty
                      ? SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Recent Searches
                              DiscoverRecentSearches(
                                items: _controller.recentSearches,
                                onClear: () {
                                  _controller.clearRecentSearches();
                                },
                                onItemTap: (item) {
                                  _onSuggestionSelected(item.query);
                                },
                              ),

                              if (_controller.recentSearches.isNotEmpty)
                                const SizedBox(height: 28),

                              // Trending Interests
                              DiscoverTrendingInterests(
                                items: _controller.trendingInterests,
                                onItemTap: (interest) {
                                  _onSuggestionSelected(interest.label);
                                },
                              ),

                              const SizedBox(height: 24),
                            ],
                          ),
                        )
                      : filteredProfiles.isNotEmpty
                      ? GridView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          physics: const BouncingScrollPhysics(),
                          itemCount: filteredProfiles.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 14,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.68,
                              ),
                          itemBuilder: (context, index) {
                            final profile = filteredProfiles[index];
                            return DiscoverProfileCard(
                              profile: profile,
                              onFavoriteTap: () {
                                _controller.toggleFavorite(profile.id);
                              },
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => DiscoverProfileDetailScreen(
                                      profile: profile,
                                      controller: _controller,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        )
                      : const Center(child: _NoResultsPlaceholder()),
                ),

                // Reused App Bottom Navigation Bar
                AppBottomNav(
                  currentIndex: _currentNavIndex,
                  onItemSelected: (index) {
                    setState(() {
                      _currentNavIndex = index;
                    });
                    if (index == 1) {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      }
                    } else if (index == 4 || index == 0) {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      } else {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const ProfileScreen(),
                          ),
                        );
                      }
                    }
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _NoResultsPlaceholder extends StatelessWidget {
  const _NoResultsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.search_off_rounded, size: 54, color: Color(0xFFC41C70)),
        SizedBox(height: 12),
        Text(
          'No results found',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF8A0B3B),
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Try searching for a different name or interest',
          style: TextStyle(fontSize: 13.5, color: Color(0xFF7A5A66)),
        ),
      ],
    );
  }
}
