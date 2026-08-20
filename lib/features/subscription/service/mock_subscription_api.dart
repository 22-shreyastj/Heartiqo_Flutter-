import '../model/subscription_model.dart';

class MockSubscriptionApi {
  static const List<SubscriptionPlanModel> _plans = [
    SubscriptionPlanModel(
      id: 'free',
      name: 'Free',
      price: '\$0',
      duration: 'Forever',
      benefits: [
        'Standard Matching',
        '10 Likes Per Day',
        'Basic Filters',
        'Direct Chat with Matches',
      ],
      isPopular: false,
    ),
    SubscriptionPlanModel(
      id: 'premium',
      name: 'Premium',
      price: '\$14.99',
      duration: '1 Month',
      benefits: [
        'Unlimited Likes',
        'See Who Likes You',
        '5 Super Likes Per Week',
        'Rewind Last Swipe',
        'Advanced Filters',
      ],
      isPopular: true,
      badge: 'MOST POPULAR',
    ),
    SubscriptionPlanModel(
      id: 'premium_plus',
      name: 'Premium Plus',
      price: '\$24.99',
      duration: '1 Month',
      benefits: [
        'All Premium Benefits',
        'Passport / Global Mode',
        'Message Before Matching',
        'Priority Likes',
        'Read Receipts',
        '1 Free Boost Per Month',
      ],
      isPopular: false,
      badge: 'BEST VALUE',
    ),
  ];

  static Future<List<SubscriptionPlanModel>> getSubscriptionPlans() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _plans;
  }

  static Future<bool> selectPlan(String planId) async {
    await Future.delayed(const Duration(milliseconds: 700));
    return true;
  }
}
