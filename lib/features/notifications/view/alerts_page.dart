import 'package:flutter/material.dart';
import '../../../match_success_page.dart';
import '../../../profile_details_page.dart';
import '../../chat/view/chat_list_page.dart';
import '../../chat/view/chat_page.dart';
import '../../profile/model/profile_model.dart';
import '../controller/alert_controller.dart';
import '../model/alert_model.dart';
import '../widgets/alert_card.dart';
import '../widgets/alerts_header.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  State<AlertsPage> createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  final AlertController _controller = AlertController();
  final TextEditingController _searchController = TextEditingController();

  late List<AlertModel> _recentAlerts;
  late List<AlertModel> _earlierAlerts;

  bool _isSearchVisible = false;
  String _searchQuery = '';
  int _selectedFilterTab = 0; // 0 = All, 1 = Unread

  @override
  void initState() {
    super.initState();
    _recentAlerts = List.from(_controller.getRecentAlerts());
    _earlierAlerts = List.from(_controller.getEarlierAlerts());
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (_searchQuery != _searchController.text) {
      setState(() {
        _searchQuery = _searchController.text;
      });
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearchVisible = !_isSearchVisible;
      if (!_isSearchVisible) {
        _searchController.clear();
        _searchQuery = '';
      }
    });
  }

  void _markAsRead(AlertModel alert) {
    setState(() {
      final rIndex = _recentAlerts.indexWhere((a) => a.id == alert.id);
      if (rIndex != -1) {
        _recentAlerts[rIndex] = AlertModel(
          id: alert.id,
          icon: alert.icon,
          title: alert.title,
          description: alert.description,
          time: alert.time,
          isUnread: false,
        );
        return;
      }

      final eIndex = _earlierAlerts.indexWhere((a) => a.id == alert.id);
      if (eIndex != -1) {
        _earlierAlerts[eIndex] = AlertModel(
          id: alert.id,
          icon: alert.icon,
          title: alert.title,
          description: alert.description,
          time: alert.time,
          isUnread: false,
        );
      }
    });
  }

  void _markAllAsRead() {
    setState(() {
      _recentAlerts = _recentAlerts
          .map((a) => AlertModel(
                id: a.id,
                icon: a.icon,
                title: a.title,
                description: a.description,
                time: a.time,
                isUnread: false,
              ))
          .toList();

      _earlierAlerts = _earlierAlerts
          .map((a) => AlertModel(
                id: a.id,
                icon: a.icon,
                title: a.title,
                description: a.description,
                time: a.time,
                isUnread: false,
              ))
          .toList();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _removeAlert(AlertModel alert) {
    setState(() {
      _recentAlerts.removeWhere((a) => a.id == alert.id);
      _earlierAlerts.removeWhere((a) => a.id == alert.id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Alert "${alert.title}" removed'),
        action: SnackBarAction(
          label: 'Undo',
          textColor: const Color(0xFFFF3B70),
          onPressed: () {
            setState(() {
              _recentAlerts.add(alert);
            });
          },
        ),
      ),
    );
  }

  Widget _buildMilestoneStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFFE65100),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _showAlertDetails(AlertModel alert) {
    _markAsRead(alert);

    if (alert.title.toLowerCase().contains('weekly')) {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFFB300), Color(0xFFFF8F00)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.emoji_events_rounded, color: Colors.white, size: 36),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Weekly Matches Milestone! 🏆',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  alert.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF9E6),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFFFE082)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMilestoneStat('10', 'This Week'),
                      Container(width: 1, height: 32, color: Colors.amber.shade200),
                      _buildMilestoneStat('32', 'Total Matches'),
                      Container(width: 1, height: 32, color: Colors.amber.shade200),
                      _buildMilestoneStat('Top 5%', 'Trending'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF3B70),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ChatListPage()),
                    );
                  },
                  child: const Text(
                    'View All Matches in Messages',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Keep Exploring', style: TextStyle(color: Colors.grey)),
                ),
              ],
            ),
          );
        },
      );
      return;
    } else if (alert.title.toLowerCase().contains('match')) {
      final isDavid = alert.description.toLowerCase().contains('david');
      final name = isDavid ? 'David' : 'Sarah';
      final image = isDavid ? 'assets/images/profiles/image4.webp' : 'assets/images/profiles/image1.jpg';
      final age = isDavid ? 27 : 24;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MatchSuccessPage(
            matchedProfile: ProfileModel(
              name: '$name, $age',
              image: image,
              distance: '2 km away',
              bio: alert.description,
              tags: const ['Travel', 'Music', 'Coffee'],
              verified: true,
            ),
          ),
        ),
      );
      return;
    } else if (alert.title.toLowerCase().contains('message') ||
        alert.description.toLowerCase().contains('sent you a message')) {
      String senderName = 'Alex';
      String senderImage = 'assets/images/alex.jpg';
      String chatId = '1';

      if (alert.description.contains('Jordan')) {
        senderName = 'Jordan';
        senderImage = 'assets/images/jordan.jpg';
        chatId = '2';
      } else if (alert.description.contains('Marcus')) {
        senderName = 'Marcus';
        senderImage = 'assets/images/marcus.jpg';
        chatId = '3';
      } else if (alert.description.contains('Elena')) {
        senderName = 'Elena';
        senderImage = 'assets/images/elena.jpg';
        chatId = '4';
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatPage(
            chatId: chatId,
            name: senderName,
            image: senderImage,
          ),
        ),
      );
      return;
    } else if (alert.title.toLowerCase().contains('like') ||
        alert.description.toLowerCase().contains('liked your profile')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ProfileDetailsPage(
            profile: ProfileModel(
              name: 'Emma, 24',
              image: 'assets/images/profiles/image2.avif',
              distance: '2 km away',
              bio: 'Fitness enthusiast, dog lover, and weekend baker.',
              tags: ['Fitness', 'Baking', 'Books'],
              verified: true,
            ),
          ),
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFEBF0),
                  shape: BoxShape.circle,
                ),
                child: Icon(alert.icon, color: const Color(0xFFFF3B70), size: 28),
              ),
              const SizedBox(height: 16),
              Text(
                alert.title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                alert.description,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 6),
              Text(
                alert.time,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        _removeAlert(alert);
                      },
                      child: const Text('Delete', style: TextStyle(color: Colors.red)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF3B70),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchQuery.toLowerCase().trim();

    bool alertMatches(AlertModel alert) {
      if (_selectedFilterTab == 1 && !alert.isUnread) return false;
      if (query.isEmpty) return true;
      return alert.title.toLowerCase().contains(query) ||
          alert.description.toLowerCase().contains(query) ||
          alert.time.toLowerCase().contains(query);
    }

    final recentAlerts = _recentAlerts.where(alertMatches).toList();
    final earlierAlerts = _earlierAlerts.where(alertMatches).toList();
    final hasResults = recentAlerts.isNotEmpty || earlierAlerts.isNotEmpty;

    final unreadCount = _recentAlerts.where((a) => a.isUnread).length +
        _earlierAlerts.where((a) => a.isUnread).length;

    return SafeArea(
      child: Column(
        children: [
          AlertsHeader(
            onSearchTap: _toggleSearch,
            unreadCount: unreadCount,
            onNotificationTap: () {
              if (unreadCount > 0) {
                setState(() {
                  _selectedFilterTab = (_selectedFilterTab == 1) ? 0 : 1;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      _selectedFilterTab == 1
                          ? 'Showing $unreadCount unread notification${unreadCount > 1 ? 's' : ''}'
                          : 'Showing all notifications',
                    ),
                    duration: const Duration(seconds: 2),
                    action: _selectedFilterTab == 1
                        ? SnackBarAction(
                            label: 'Mark Read',
                            textColor: const Color(0xFFFF3B70),
                            onPressed: _markAllAsRead,
                          )
                        : null,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("You're all caught up! No unread notifications."),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
          ),

          if (_isSearchVisible)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search alerts...',
                  prefixIcon: const Icon(Icons.search, color: Color(0xFFFF3B70)),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                      : IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey),
                          onPressed: _toggleSearch,
                        ),
                  filled: true,
                  fillColor: const Color(0xFFFFF0F3),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Alerts',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Stay updated on your latest connections.',
                          style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                    if (unreadCount > 0)
                      TextButton.icon(
                        onPressed: _markAllAsRead,
                        icon: const Icon(Icons.done_all, size: 16, color: Color(0xFFFF3B70)),
                        label: const Text(
                          'Mark read',
                          style: TextStyle(fontSize: 12, color: Color(0xFFFF3B70)),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 12),

                // Filter Tabs: All vs Unread
                Row(
                  children: [
                    ChoiceChip(
                      label: const Text('All'),
                      selected: _selectedFilterTab == 0,
                      selectedColor: const Color(0xFFFFEBF0),
                      backgroundColor: Colors.grey.shade100,
                      labelStyle: TextStyle(
                        color: _selectedFilterTab == 0
                            ? const Color(0xFFFF3B70)
                            : Colors.grey.shade700,
                        fontWeight: _selectedFilterTab == 0 ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (_) {
                        setState(() {
                          _selectedFilterTab = 0;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: Text('Unread ($unreadCount)'),
                      selected: _selectedFilterTab == 1,
                      selectedColor: const Color(0xFFFFEBF0),
                      backgroundColor: Colors.grey.shade100,
                      labelStyle: TextStyle(
                        color: _selectedFilterTab == 1
                            ? const Color(0xFFFF3B70)
                            : Colors.grey.shade700,
                        fontWeight: _selectedFilterTab == 1 ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (_) {
                        setState(() {
                          _selectedFilterTab = 1;
                        });
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                if (!hasResults)
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            _isSearchVisible ? Icons.search_off_rounded : Icons.notifications_none,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _isSearchVisible
                                ? 'No alerts found matching "$_searchQuery"'
                                : 'No notifications to display',
                            style: const TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  )
                else ...[
                  // Recent Section
                  if (recentAlerts.isNotEmpty) ...[
                    ...recentAlerts.map(
                      (alert) => AlertCard(
                        alert: alert,
                        onTap: () => _showAlertDetails(alert),
                        onDismiss: () => _removeAlert(alert),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Earlier Section
                  if (earlierAlerts.isNotEmpty) ...[
                    const Text(
                      'Earlier',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 12),
                    ...earlierAlerts.map(
                      (alert) => AlertCard(
                        alert: alert,
                        onTap: () => _showAlertDetails(alert),
                        onDismiss: () => _removeAlert(alert),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}