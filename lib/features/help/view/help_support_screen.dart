import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';
import '../model/support_ticket_model.dart';
import '../service/mock_support_api.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  List<FaqModel> _faqs = [];
  bool _isLoading = true;

  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCategory = 'General Issue';
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadFaqs();
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadFaqs() async {
    try {
      final faqs = await MockSupportApi.getFaqs();
      setState(() {
        _faqs = faqs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _submitSupportForm() async {
    final subject = _subjectController.text.trim();
    final description = _descriptionController.text.trim();

    if (subject.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out subject and description')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final ticket = await MockSupportApi.submitSupportTicket(
      subject,
      _selectedCategory,
      description,
    );

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
      _subjectController.clear();
      _descriptionController.clear();
    });

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.check_circle_rounded,
                color: AppColors.brandPink, size: 28),
            SizedBox(width: 10),
            Text('Ticket Submitted'),
          ],
        ),
        content: Text(
          'Your support ticket #${ticket.id} has been submitted. Our team will contact you within 24 hours.',
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
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
  }

  void _showLegalDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(
            content,
            style: const TextStyle(fontSize: 13, height: 1.5, color: AppColors.textDark),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close', style: TextStyle(color: AppColors.brandPink)),
          ),
        ],
      ),
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
          'Help & Support',
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
                  // FAQ Header
                  const Text(
                    'Frequently Asked Questions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // FAQ List using ExpansionTile
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
                      children: _faqs.map((faq) {
                        return ExpansionTile(
                          title: Text(
                            faq.question,
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                            ),
                          ),
                          iconColor: AppColors.brandPink,
                          collapsedIconColor: AppColors.textMuted,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, bottom: 16),
                              child: Text(
                                faq.answer,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textMuted,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Contact Support Section
                  const Text(
                    'Contact Support & Report Problem',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.all(20),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButtonFormField<String>(
                          value: _selectedCategory,
                          decoration: InputDecoration(
                            labelText: 'Category',
                            prefixIcon: const Icon(Icons.category_outlined,
                                color: AppColors.brandPink),
                            filled: true,
                            fillColor:
                                AppColors.softPinkSlot.withValues(alpha: 0.3),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          items: [
                            'General Issue',
                            'Account & Billing',
                            'Bug Report',
                            'Safety Concern',
                            'Feedback'
                          ]
                              .map((c) =>
                                  DropdownMenuItem(value: c, child: Text(c)))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                _selectedCategory = val;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: _subjectController,
                          decoration: InputDecoration(
                            labelText: 'Subject',
                            prefixIcon: const Icon(Icons.title_rounded,
                                color: AppColors.brandPink),
                            filled: true,
                            fillColor:
                                AppColors.softPinkSlot.withValues(alpha: 0.3),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: _descriptionController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            labelText: 'Describe your issue in detail',
                            prefixIcon: const Icon(Icons.description_outlined,
                                color: AppColors.brandPink),
                            filled: true,
                            fillColor:
                                AppColors.softPinkSlot.withValues(alpha: 0.3),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _isSubmitting ? null : _submitSupportForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.brandPink,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: _isSubmitting
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const Text(
                                    'Submit Support Ticket',
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

                  const SizedBox(height: 24),

                  // Legal Links Card
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
                        ListTile(
                          leading: const Icon(Icons.description_outlined,
                              color: AppColors.brandPink),
                          title: const Text('Terms & Conditions',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textDark)),
                          trailing: const Icon(Icons.chevron_right_rounded,
                              color: AppColors.textMuted),
                          onTap: () => _showLegalDialog(
                            'Terms & Conditions',
                            'Welcome to Heartiqo. By creating a Heartiqo account, you agree to our Terms of Use. Heartiqo provides dating, matching, and messaging services to adult users (18+). You agree to provide accurate information and respect other community members. Any form of harassment, hate speech, or commercial solicitation is strictly prohibited.',
                          ),
                        ),
                        const Divider(height: 1, color: AppColors.borderLight),
                        ListTile(
                          leading: const Icon(Icons.privacy_tip_outlined,
                              color: AppColors.brandPink),
                          title: const Text('Privacy Policy',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textDark)),
                          trailing: const Icon(Icons.chevron_right_rounded,
                              color: AppColors.textMuted),
                          onTap: () => _showLegalDialog(
                            'Privacy Policy',
                            'Your privacy is our top priority. Heartiqo collects profile information, location preferences, and user interactions to deliver personalized matching experiences. We do not sell your personal data to third parties. You have complete control to update, hide, or delete your account data at any time through Account & Safety Settings.',
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}
