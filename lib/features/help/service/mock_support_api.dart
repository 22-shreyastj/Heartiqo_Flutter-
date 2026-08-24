import '../model/support_ticket_model.dart';

class MockSupportApi {
  static const List<FaqModel> _faqs = [
    FaqModel(
      id: 'f1',
      question: 'How does Heartiqo matching work?',
      answer:
          'Heartiqo matches you with people based on mutual likes, distance, age preferences, and shared interests.',
      category: 'Matching',
    ),
    FaqModel(
      id: 'f2',
      question: 'How do I edit my profile information?',
      answer:
          'Go to your Profile tab and tap on "Account" or the edit pencil on your avatar to modify your details, photos, and bio.',
      category: 'Account',
    ),
    FaqModel(
      id: 'f3',
      question: 'How do I cancel or manage my subscription?',
      answer:
          'You can upgrade, change, or manage your subscription tier anytime from the Upgrade Now section in your Profile.',
      category: 'Subscription',
    ),
    FaqModel(
      id: 'f4',
      question: 'How does safety verification work?',
      answer:
          'Verified profiles have passed photo verification. Look for the blue checkmark badge next to user profiles for extra safety.',
      category: 'Safety',
    ),
    FaqModel(
      id: 'f5',
      question: 'Can I unblock someone I accidentally blocked?',
      answer:
          'Yes! Visit Safety -> Blocked Users in your Profile settings to view and unblock any user at any time.',
      category: 'Safety',
    ),
  ];

  static Future<List<FaqModel>> getFaqs() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _faqs;
  }

  static Future<SupportTicketModel> submitSupportTicket(
      String subject, String category, String description) async {
    await Future.delayed(const Duration(milliseconds: 700));
    final ticketId = 'HT-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    return SupportTicketModel(
      id: ticketId,
      subject: subject,
      category: category,
      description: description,
      status: 'Open',
      createdAt: 'Just now',
    );
  }
}
