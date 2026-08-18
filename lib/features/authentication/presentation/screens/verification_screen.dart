import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../controller/signup_controller.dart';

import '../widgets/signup_header.dart';
import '../widgets/signup_progress.dart';
import '../widgets/signup_primary_button.dart';

import 'signup_success_screen.dart';

class VerificationScreen extends StatefulWidget {
  final SignupController controller;

  const VerificationScreen({super.key, required this.controller});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  bool governmentIdVerified = false;
  bool selfieVerified = false;

  File? idImage;
  File? selfieImage;

  final ImagePicker picker = ImagePicker();

  // WHY VERIFY
  void showWhyVerifyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Why verify?'),
        content: const Text(
          'Identity verification helps make Heartiqo safer.\n\n'
          '✓ Prevents fake accounts\n'
          '✓ Creates safer connections\n'
          '✓ Confirms you are a real person',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('GOT IT'),
          ),
        ],
      ),
    );
  }

  // GOVERNMENT ID CAMERA
  Future<void> verifyGovernmentId() async {
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        idImage = File(image.path);
        governmentIdVerified = true;
      });
    }
  }

  // SELFIE CAMERA
  Future<void> verifySelfie() async {
    if (!governmentIdVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Take Government ID photo first')),
      );
      return;
    }

    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
    );

    if (image != null) {
      setState(() {
        selfieImage = File(image.path);
        selfieVerified = true;
      });
    }
  }

  // COMPLETE
  void completeVerification() {
    if (!governmentIdVerified || !selfieVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Complete all verification steps')),
      );
      return;
    }

    widget.controller.nextPage(
      context,
      SignupSuccessScreen(controller: widget.controller),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool allVerified = governmentIdVerified && selfieVerified;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F9),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: Column(
            children: [
              // HEADER
              SignupHeader(
                onBack: () {
                  widget.controller.back(context);
                },
              ),

              const SignupProgress(step: 5),

              const SizedBox(height: 30),

              // ICON
              const CircleAvatar(
                radius: 42,
                backgroundColor: Color(0xFFFFE6EE),
                child: Icon(
                  Icons.verified_user,
                  size: 45,
                  color: Color(0xFFC00055),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Verify Your Identity',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 30),

              // CARD
              Container(
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Column(
                  children: [
                    // STATUS + WHY VERIFY
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Verification Status',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        TextButton(
                          onPressed: showWhyVerifyDialog,
                          child: const Text(
                            'Why verify?',
                            style: TextStyle(color: Color(0xFFC00055)),
                          ),
                        ),
                      ],
                    ),

                    // EMAIL
                    const ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.email_outlined),
                      title: Text('Email Address'),
                      trailing: Icon(Icons.check_circle, color: Colors.green),
                    ),

                    // PINK BOX
                    Container(
                      padding: const EdgeInsets.all(15),

                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE5EE),
                        borderRadius: BorderRadius.circular(15),
                      ),

                      child: Column(
                        children: [
                          // GOVERNMENT ID
                          ListTile(
                            contentPadding: EdgeInsets.zero,

                            leading: const Icon(
                              Icons.badge_outlined,
                              color: Color(0xFFC00055),
                            ),

                            title: const Text('Government ID'),

                            trailing: governmentIdVerified
                                ? const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  )
                                : const Icon(
                                    Icons.camera_alt,
                                    color: Color(0xFFC00055),
                                  ),

                            onTap: verifyGovernmentId,
                          ),

                          // SHOW ID IMAGE
                          if (idImage != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                idImage!,
                                height: 100,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),

                          const SizedBox(height: 10),

                          // SELFIE
                          ListTile(
                            contentPadding: EdgeInsets.zero,

                            leading: Icon(
                              selfieVerified
                                  ? Icons.check_circle
                                  : Icons.camera_alt_outlined,
                              color: selfieVerified
                                  ? Colors.green
                                  : const Color(0xFFC00055),
                            ),

                            title: Text(
                              selfieVerified
                                  ? 'Live Selfie Verified'
                                  : 'Live Selfie & Face Match',
                            ),

                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 17,
                            ),

                            onTap: verifySelfie,
                          ),

                          // SHOW SELFIE
                          if (selfieImage != null)
                            ClipOval(
                              child: Image.file(
                                selfieImage!,
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            ),

                          const SizedBox(height: 10),

                          Row(
                            children: [
                              Icon(
                                allVerified
                                    ? Icons.check_circle
                                    : Icons.info_outline,
                                color: allVerified
                                    ? Colors.green
                                    : const Color(0xFFC00055),
                              ),

                              const SizedBox(width: 10),

                              Expanded(
                                child: Text(
                                  allVerified
                                      ? 'Identity verification completed'
                                      : 'Complete Government ID and selfie verification',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              Opacity(
                opacity: allVerified ? 1 : 0.5,

                child: SignupPrimaryButton(
                  text: 'COMPLETE VERIFICATION',
                  icon: Icons.lock_outline,
                  onPressed: completeVerification,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
