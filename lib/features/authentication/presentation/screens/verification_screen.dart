import 'package:flutter/material.dart';

import '../../controller/signup_controller.dart';

import '../widgets/signup_header.dart';
import '../widgets/signup_progress.dart';
import '../widgets/signup_primary_button.dart';

import 'signup_success_screen.dart';

class VerificationScreen extends StatefulWidget {
  final SignupController controller;

  const VerificationScreen({
    super.key,
    required this.controller,
  });

  @override
  State<VerificationScreen> createState() =>
      _VerificationScreenState();
}

class _VerificationScreenState
    extends State<VerificationScreen> {

  bool governmentIdVerified = false;
  bool selfieVerified = false;

  // ==========================================
  // WHY VERIFY POPUP
  // ==========================================

  void showWhyVerifyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),

        title: const Row(
          children: [
            Icon(
              Icons.verified_user_outlined,
              color: Color(0xFFC00055),
            ),

            SizedBox(width: 10),

            Expanded(
              child: Text(
                'Why verify?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        content: const Text(
          'Identity verification helps make Heartiqo '
          'safer and more trustworthy.\n\n'
          '✓ Confirms you are a real person\n\n'
          '✓ Helps prevent fake accounts\n\n'
          '✓ Creates safer connections\n\n'
          '✓ Helps protect against impersonation',
          style: TextStyle(
            fontSize: 15,
            height: 1.4,
          ),
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'GOT IT',
              style: TextStyle(
                color: Color(0xFFC00055),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // GOVERNMENT ID
  // ==========================================

  void verifyGovernmentId() {
    setState(() {
      governmentIdVerified = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Government ID verified successfully',
        ),
      ),
    );
  }

  // ==========================================
  // SELFIE
  // ==========================================

  void verifySelfie() {
    if (!governmentIdVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please verify Government ID first',
          ),
        ),
      );

      return;
    }

    setState(() {
      selfieVerified = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Live selfie verified successfully',
        ),
      ),
    );
  }

  // ==========================================
  // COMPLETE VERIFICATION
  // ==========================================

  void completeVerification() {
    if (!governmentIdVerified ||
        !selfieVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please complete all verification steps',
          ),
        ),
      );

      return;
    }

    widget.controller.nextPage(
      context,
      SignupSuccessScreen(
        controller: widget.controller,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool allVerified =
        governmentIdVerified && selfieVerified;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F9),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),

          child: Column(
            children: [

              // =====================================
              // HEADER
              // =====================================

              SignupHeader(
                onBack: () =>
                    widget.controller.back(context),
              ),

              const SignupProgress(step: 5),

              const SizedBox(height: 30),

              // =====================================
              // VERIFICATION ICON
              // =====================================

              Container(
                height: 85,
                width: 85,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFFE6EE),
                ),
                child: const Icon(
                  Icons.verified_user,
                  size: 48,
                  color: Color(0xFFC00055),
                ),
              ),

              const SizedBox(height: 25),

              // =====================================
              // TITLE
              // =====================================

              const Text(
                'Verify Your Identity',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 29,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              // =====================================
              // VERIFICATION CARD
              // =====================================

              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius:
                      BorderRadius.circular(20),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: 0.05,
                      ),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),

                child: Column(
                  children: [

                    // =================================
                    // VERIFICATION STATUS + WHY VERIFY
                    // =================================

                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Verification Status',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),

                        TextButton(
                          onPressed:
                              showWhyVerifyDialog,

                          style: TextButton.styleFrom(
                            padding:
                                const EdgeInsets.all(4),
                          ),

                          child: const Row(
                            mainAxisSize:
                                MainAxisSize.min,
                            children: [
                              Text(
                                'Why verify?',
                                style: TextStyle(
                                  color:
                                      Color(0xFFC00055),
                                  fontSize: 15,
                                ),
                              ),

                              SizedBox(width: 4),

                              Icon(
                                Icons.info_outline,
                                size: 17,
                                color:
                                    Color(0xFFC00055),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // =================================
                    // EMAIL VERIFIED
                    // =================================

                    const ListTile(
                      contentPadding:
                          EdgeInsets.zero,

                      leading: Icon(
                        Icons.email_outlined,
                        size: 28,
                      ),

                      title: Text(
                        'Email Address',
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),

                      trailing: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 27,
                      ),
                    ),

                    const SizedBox(height: 5),

                    // =================================
                    // GOVERNMENT ID SECTION
                    // =================================

                    Container(
                      width: double.infinity,

                      padding:
                          const EdgeInsets.all(16),

                      decoration: BoxDecoration(
                        color:
                            const Color(0xFFFFE5EE),

                        borderRadius:
                            BorderRadius.circular(15),
                      ),

                      child: Column(
                        children: [

                          // Government ID
                          Row(
                            children: [
                              const Icon(
                                Icons.badge_outlined,
                                color:
                                    Color(0xFFC00055),
                                size: 28,
                              ),

                              const SizedBox(width: 12),

                              const Expanded(
                                child: Text(
                                  'Government ID',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ),

                              TextButton(
                                onPressed:
                                    governmentIdVerified
                                        ? null
                                        : verifyGovernmentId,

                                child: Text(
                                  governmentIdVerified
                                      ? 'Verified'
                                      : 'Required',

                                  style: TextStyle(
                                    color:
                                        governmentIdVerified
                                            ? Colors.green
                                            : const Color(
                                                0xFFC00055,
                                              ),
                                    fontWeight:
                                        FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 15),

                          // =================================
                          // SELFIE
                          // =================================

                          InkWell(
                            onTap: verifySelfie,

                            borderRadius:
                                BorderRadius.circular(10),

                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(
                                vertical: 8,
                              ),

                              child: Row(
                                children: [
                                  Icon(
                                    selfieVerified
                                        ? Icons
                                            .check_circle
                                        : Icons
                                            .camera_alt_outlined,

                                    color:
                                        selfieVerified
                                            ? Colors.green
                                            : Colors.black87,
                                  ),

                                  const SizedBox(
                                    width: 12,
                                  ),

                                  Expanded(
                                    child: Text(
                                      selfieVerified
                                          ? 'Live Selfie Verified'
                                          : 'Live Selfie & Face Match',

                                      style: TextStyle(
                                        fontSize: 16,
                                        color:
                                            selfieVerified
                                                ? Colors.green
                                                : Colors.black87,
                                      ),
                                    ),
                                  ),

                                  if (!selfieVerified)
                                    const Icon(
                                      Icons
                                          .arrow_forward_ios,
                                      size: 18,
                                    ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // =================================
                          // STATUS MESSAGE
                          // =================================

                          Align(
                            alignment:
                                Alignment.centerLeft,

                            child: Row(
                              children: [
                                Icon(
                                  allVerified
                                      ? Icons.check_circle
                                      : Icons.info_outline,

                                  color: allVerified
                                      ? Colors.green
                                      : const Color(
                                          0xFFC00055,
                                        ),

                                  size: 21,
                                ),

                                const SizedBox(width: 10),

                                Expanded(
                                  child: Text(
                                    allVerified
                                        ? 'Identity verification completed'
                                        : 'Complete Government ID and selfie verification',

                                    style: TextStyle(
                                      color: allVerified
                                          ? Colors.green
                                          : const Color(
                                              0xFFC00055,
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 45),

              // =====================================
              // COMPLETE VERIFICATION
              // =====================================

              Opacity(
                opacity: allVerified ? 1 : 0.45,

                child: SignupPrimaryButton(
                  text: 'COMPLETE VERIFICATION',
                  icon: Icons.lock_outline,

                  onPressed: completeVerification,
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}