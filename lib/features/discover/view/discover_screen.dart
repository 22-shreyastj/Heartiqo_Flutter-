import 'package:flutter/material.dart';

import '../../../core/widgets/app_bottom_nav.dart';
import '../../../pages/main_navigation_page.dart';
import '../controller/discover_controller.dart';
import '../widgets/discover_filter_bar.dart';
import '../widgets/discover_header.dart';
import '../widgets/discover_profile_card.dart';
import '../widgets/discover_view_toggle.dart';
import 'discover_filter_screen.dart';
import 'discover_advanced_filter_screen.dart';
import 'discover_profile_detail_screen.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  late final DiscoverController _controller;
  int _currentNavIndex = 1; // Discover tab active

  @override
  void initState() {
    super.initState();
    _controller = DiscoverController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
            return Column(
              children: [
                Expanded(
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      // App Header
                      SliverToBoxAdapter(
                        child: DiscoverHeader(
                          avatarUrl:
                              'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=200&q=80',
                          onNotificationTap: () {},
                          onSearchTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => DiscoverFilterScreen(
                                  controller: _controller,
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SliverToBoxAdapter(child: SizedBox(height: 14)),

                      // Filter Bar
                      SliverToBoxAdapter(
                        child: DiscoverFilterBar(
                          selectedFilter: _controller.selectedFilter,
                          onFilterSelected: (_) async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => DiscoverAdvancedFilterScreen(
                                  controller: _controller,
                                ),
                              ),
                            );
                          },
                          selectedDistance: _controller.selectedDistance,
                          onDistanceSelected: _controller.setDistanceFilter,
                          selectedInterests: _controller.selectedInterests,
                          onInterestsSelected: _controller.setSelectedInterests,
                          availableInterests: _controller.availableInterests,
                        ),
                      ),

                      const SliverToBoxAdapter(child: SizedBox(height: 18)),

                      // View Toggle (Grid / Map)
                      SliverToBoxAdapter(
                        child: DiscoverViewToggle(
                          isGridView: _controller.isGridView,
                          onViewChanged: _controller.setViewMode,
                        ),
                      ),

                      const SliverToBoxAdapter(child: SizedBox(height: 16)),

                      // Main Content: Grid vs Map
                      if (_controller.isGridView)
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 4,
                          ),
                          sliver: SliverGrid(
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              final profile = _controller.profiles[index];
                              return DiscoverProfileCard(
                                profile: profile,
                                onFavoriteTap: () {
                                  _controller.toggleFavorite(profile.id);
                                },
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          DiscoverProfileDetailScreen(
                                            profile: profile,
                                            controller: _controller,
                                          ),
                                    ),
                                  );
                                },
                              );
                            }, childCount: _controller.profiles.length),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 14,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: 0.68,
                                ),
                          ),
                        )
                      else
                        const SliverFillRemaining(
                          hasScrollBody: false,
                          child: _MapViewPlaceholder(),
                        ),

                      const SliverToBoxAdapter(child: SizedBox(height: 20)),
                    ],
                  ),
                ),

              ],
            );
          },
        ),
      ),
    );
  }
}

class _MapViewPlaceholder extends StatelessWidget {
  const _MapViewPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.map_rounded, size: 54, color: Color(0xFFC41C70)),
          SizedBox(height: 12),
          Text(
            'Map View',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF8A0B3B),
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Discover nearby matches on interactive map',
            style: TextStyle(fontSize: 13.5, color: Color(0xFF7A5A66)),
          ),
        ],
      ),
    );
  }
}
