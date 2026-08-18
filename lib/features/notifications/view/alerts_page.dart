import 'package:flutter/material.dart';
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
  }

  @override
  void dispose() {
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

  void _showAlertDetails(AlertModel alert) {
    _markAsRead(alert);

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
          alert.description.toLowerCase().contains(query);
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