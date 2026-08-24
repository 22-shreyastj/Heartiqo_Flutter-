import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';
import '../../profile/controller/profile_controller.dart';
import '../model/subscription_model.dart';
import '../service/mock_subscription_api.dart';

class UpgradeSubscriptionScreen extends StatefulWidget {
  final ProfileController? controller;

  const UpgradeSubscriptionScreen({super.key, this.controller});

  @override
  State<UpgradeSubscriptionScreen> createState() =>
      _UpgradeSubscriptionScreenState();
}

class _UpgradeSubscriptionScreenState
    extends State<UpgradeSubscriptionScreen> {
  List<SubscriptionPlanModel> _plans = [];
  bool _isLoading = true;
  String? _selectedPlanId;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadPlans();
  }

  Future<void> _loadPlans() async {
    try {
      final plans = await MockSubscriptionApi.getSubscriptionPlans();
      setState(() {
        _plans = plans;
        final currentPlanName = widget.controller?.profile.subscriptionPlan ?? 'Free';
        final match = plans.firstWhere(
          (p) => p.name.toLowerCase() == currentPlanName.toLowerCase(),
          orElse: () => plans.first,
        );
        _selectedPlanId = match.id;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleUpgrade() async {
    if (_selectedPlanId == null) return;
    final selectedPlan =
        _plans.firstWhere((p) => p.id == _selectedPlanId);

    setState(() {
      _isSubmitting = true;
    });

    bool success = false;
    if (widget.controller != null) {
      success = await widget.controller!.upgradeSubscription(selectedPlan.name);
    } else {
      success = await MockSubscriptionApi.selectPlan(selectedPlan.id);
    }

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
    });

    if (success) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.stars_rounded, color: AppColors.brandPink, size: 28),
              SizedBox(width: 10),
              Text('Congratulations!'),
            ],
          ),
          content: Text(
            'You have successfully subscribed to Heartiqo ${selectedPlan.name} plan.',
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx); // Close dialog
                Navigator.pop(context, true); // Close upgrade screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandPink,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update subscription. Please try again.')),
      );
    }
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
          'Upgrade Subscription',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.brandPink))
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Banner header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF3B70), Color(0xFFFF6584)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.brandPink.withValues(alpha: 0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Colors.white24,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.workspace_premium_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Heartiqo Premium',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Get 3x more matches, unlimited likes, and exclusive VIP features!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.5,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Choose Your Plan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Plans list
                  ..._plans.map((plan) => _buildPlanCard(plan)),

                  const SizedBox(height: 24),

                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _handleUpgrade,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brandPink,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                        elevation: 4,
                      ),
                      child: _isSubmitting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Select & Upgrade Now',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
    );
  }

  Widget _buildPlanCard(SubscriptionPlanModel plan) {
    final isSelected = plan.id == _selectedPlanId;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPlanId = plan.id;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.brandPink : AppColors.borderLight,
            width: isSelected ? 2.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.brandPink.withValues(alpha: 0.12)
                  : Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        plan.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDark,
                        ),
                      ),
                      if (plan.badge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.brandPink,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            plan.badge!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Radio<String>(
                  value: plan.id,
                  groupValue: _selectedPlanId,
                  activeColor: AppColors.brandPink,
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedPlanId = val;
                      });
                    }
                  },
                ),
              ],
            ),

            const SizedBox(height: 6),

            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  plan.price,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: AppColors.brandPink,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '/ ${plan.duration}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),

            const Divider(height: 24, color: AppColors.borderLight),

            ...plan.benefits.map(
              (benefit) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.brandPink,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        benefit,
                        style: const TextStyle(
                          fontSize: 13.5,
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
