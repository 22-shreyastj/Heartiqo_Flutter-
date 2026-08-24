import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';
import '../model/safety_model.dart';
import '../service/mock_safety_api.dart';

class SafetyCenterScreen extends StatefulWidget {
  const SafetyCenterScreen({super.key});

  @override
  State<SafetyCenterScreen> createState() => _SafetyCenterScreenState();
}

class _SafetyCenterScreenState extends State<SafetyCenterScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<BlockedUserModel> _blockedUsers = [];
  PrivacySettingsModel _privacySettings = const PrivacySettingsModel();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadSafetyData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadSafetyData() async {
    try {
      final blocked = await MockSafetyApi.getBlockedUsers();
      final privacy = await MockSafetyApi.getPrivacySettings();
      setState(() {
        _blockedUsers = blocked;
        _privacySettings = privacy;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _unblockUser(String id, String name) async {
    final success = await MockSafetyApi.unblockUser(id);
    if (success) {
      setState(() {
        _blockedUsers.removeWhere((u) => u.id == id);
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unblocked $name successfully')),
      );
    }
  }

  void _openReportModal() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedReason = 'Inappropriate Behavior';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Report a User',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Submit a confidential report to our safety team.',
                        style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Username to Report',
                          prefixIcon: const Icon(Icons.person_search_rounded,
                              color: AppColors.brandPink),
                          filled: true,
                          fillColor: AppColors.softPinkSlot.withValues(alpha: 0.3),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: selectedReason,
                        decoration: InputDecoration(
                          labelText: 'Reason for Report',
                          prefixIcon: const Icon(Icons.report_problem_outlined,
                              color: AppColors.brandPink),
                          filled: true,
                          fillColor: AppColors.softPinkSlot.withValues(alpha: 0.3),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        items: [
                          'Inappropriate Behavior',
                          'Harassment or Bullying',
                          'Fake Account / Spam',
                          'Stolen Photos / Identity',
                          'Other'
                        ]
                            .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setModalState(() {
                              selectedReason = val;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: descriptionController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Additional Details (Optional)',
                          prefixIcon: const Icon(Icons.notes_rounded,
                              color: AppColors.brandPink),
                          filled: true,
                          fillColor: AppColors.softPinkSlot.withValues(alpha: 0.3),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () async {
                            final username = nameController.text.trim();
                            if (username.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Please enter a username')),
                              );
                              return;
                            }
                            final report = UserReportModel(
                              id: 'r_${DateTime.now().millisecondsSinceEpoch}',
                              reportedUserName: username,
                              reason: selectedReason,
                              description: descriptionController.text.trim(),
                              timestamp: 'Just now',
                            );
                            await MockSafetyApi.submitReport(report);
                            if (!mounted) return;
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Report submitted. Our team will review it shortly.'),
                                backgroundColor: AppColors.brandPink,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.brandPink,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Text(
                            'Submit Confidential Report',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Safety Center',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.brandPink,
          unselectedLabelColor: AppColors.textMuted,
          indicatorColor: AppColors.brandPink,
          labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          tabs: const [
            Tab(text: 'Privacy & Security'),
            Tab(text: 'Blocked Users'),
            Tab(text: 'Safety Tips'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.brandPink))
          : TabBarView(
              controller: _tabController,
              children: [
                _buildPrivacySecurityTab(),
                _buildBlockedUsersTab(),
                _buildSafetyTipsTab(),
              ],
            ),
    );
  }

  Widget _buildPrivacySecurityTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.softPinkSlot,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                  color: AppColors.brandPink.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.shield_rounded,
                    color: AppColors.brandPink, size: 36),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Security Is Protected',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Control your visibility, privacy toggles, and security settings anytime.',
                        style:
                            TextStyle(fontSize: 12, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Report User Quick Action
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.softPinkSlot,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.flag_rounded,
                    color: AppColors.brandPink, size: 20),
              ),
              title: const Text(
                'Report a User',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark),
              ),
              subtitle: const Text('Confidential report to support team',
                  style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
              trailing: const Icon(Icons.chevron_right_rounded,
                  color: AppColors.textMuted),
              onTap: _openReportModal,
            ),
          ),

          const SizedBox(height: 20),

          // Privacy Toggles
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Hide Online Status',
                      style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark)),
                  value: _privacySettings.hideOnlineStatus,
                  activeColor: AppColors.brandPink,
                  onChanged: (val) async {
                    final updated =
                        _privacySettings.copyWith(hideOnlineStatus: val);
                    await MockSafetyApi.updatePrivacySettings(updated);
                    setState(() {
                      _privacySettings = updated;
                    });
                  },
                ),
                const Divider(height: 1, color: AppColors.borderLight),
                SwitchListTile(
                  title: const Text('Incognito Mode',
                      style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark)),
                  subtitle: const Text('Only people you like can see you',
                      style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                  value: _privacySettings.incognitoMode,
                  activeColor: AppColors.brandPink,
                  onChanged: (val) async {
                    final updated =
                        _privacySettings.copyWith(incognitoMode: val);
                    await MockSafetyApi.updatePrivacySettings(updated);
                    setState(() {
                      _privacySettings = updated;
                    });
                  },
                ),
                const Divider(height: 1, color: AppColors.borderLight),
                SwitchListTile(
                  title: const Text('Hide Distance',
                      style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark)),
                  value: _privacySettings.hideDistance,
                  activeColor: AppColors.brandPink,
                  onChanged: (val) async {
                    final updated =
                        _privacySettings.copyWith(hideDistance: val);
                    await MockSafetyApi.updatePrivacySettings(updated);
                    setState(() {
                      _privacySettings = updated;
                    });
                  },
                ),
                const Divider(height: 1, color: AppColors.borderLight),
                SwitchListTile(
                  title: const Text('Read Receipts',
                      style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark)),
                  value: _privacySettings.readReceipts,
                  activeColor: AppColors.brandPink,
                  onChanged: (val) async {
                    final updated =
                        _privacySettings.copyWith(readReceipts: val);
                    await MockSafetyApi.updatePrivacySettings(updated);
                    setState(() {
                      _privacySettings = updated;
                    });
                  },
                ),
                const Divider(height: 1, color: AppColors.borderLight),
                SwitchListTile(
                  title: const Text('Two-Factor Authentication (2FA)',
                      style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark)),
                  subtitle: const Text('Secure account login via SMS/OTP',
                      style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                  value: _privacySettings.twoFactorEnabled,
                  activeColor: AppColors.brandPink,
                  onChanged: (val) async {
                    final updated =
                        _privacySettings.copyWith(twoFactorEnabled: val);
                    await MockSafetyApi.updatePrivacySettings(updated);
                    setState(() {
                      _privacySettings = updated;
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Emergency Help Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.red.shade100),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.phone_in_talk_rounded,
                      color: Colors.redAccent, size: 24),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Emergency Helpline',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.redAccent),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Need immediate help? Tap to connect to emergency safety services.',
                        style:
                            TextStyle(fontSize: 12, color: AppColors.textMuted),
                      ),
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

  Widget _buildBlockedUsersTab() {
    if (_blockedUsers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.block_rounded, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            const Text(
              'No Blocked Users',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Profiles you block will appear here.',
              style: TextStyle(fontSize: 13, color: AppColors.textMuted),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      itemCount: _blockedUsers.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final user = _blockedUsers[index];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.softPinkSlot,
                child: Text(
                  user.name.substring(0, 1),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: AppColors.brandPink),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Blocked on ${user.blockedDate}',
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () => _unblockUser(user.id, user.name),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.brandPink,
                  side: const BorderSide(color: AppColors.brandPink),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('Unblock'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSafetyTipsTab() {
    final tips = [
      {
        'title': 'Meet in Public Places',
        'desc':
            'Always schedule initial dates in populated, well-lit public venues like cafes or restaurants.'
      },
      {
        'title': 'Tell a Friend or Family Member',
        'desc':
            'Share your date details, location, and person\'s contact info with someone you trust before going out.'
      },
      {
        'title': 'Keep Financial Details Private',
        'desc':
            'Never send money or share bank/credit card info with anyone you meet on a dating platform.'
      },
      {
        'title': 'Use In-App Messaging First',
        'desc':
            'Stay within Heartiqo chat until you feel completely comfortable sharing personal contact numbers.'
      },
      {
        'title': 'Trust Your Instincts',
        'desc':
            'If something feels off or suspicious, don\'t hesitate to end the date, unmatch, or block the profile.'
      },
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      itemCount: tips.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final tip = tips[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.softPinkSlot,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.lightbulb_outline_rounded,
                    color: AppColors.brandPink, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tip['title']!,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tip['desc']!,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textMuted,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
