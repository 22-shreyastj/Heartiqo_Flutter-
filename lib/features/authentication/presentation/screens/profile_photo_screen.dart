import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../controller/signup_controller.dart';

import '../widgets/signup_header.dart';
import '../widgets/signup_progress.dart';
import '../widgets/signup_primary_button.dart';

import 'personal_details_screen.dart';

class ProfilePhotoScreen extends StatefulWidget {
  final SignupController controller;

  const ProfilePhotoScreen({
    super.key,
    required this.controller,
  });

  @override
  State<ProfilePhotoScreen> createState() =>
      _ProfilePhotoScreenState();
}

class _ProfilePhotoScreenState
    extends State<ProfilePhotoScreen> {
  final ImagePicker picker = ImagePicker();

  XFile? selectedImage;

  // Pick image from gallery
  Future<void> chooseFromGallery() async {
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() => selectedImage = image);
    }
  }

  // Take image using camera
  Future<void> takePhoto() async {
    final XFile? image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() => selectedImage = image);
    }
  }

  // For now Upload Photo also opens gallery
  Future<void> uploadPhoto() async =>
      chooseFromGallery();

  // Go to next page
  void nextPage() => widget.controller.nextPage(
        context,
        PersonalDetailsScreen(
          controller: widget.controller,
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFFFFF9F9),

        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 10,
            ),

            child: Column(
              children: [
                SignupHeader(
                  onBack: () =>
                      widget.controller.back(context),
                ),

                const SignupProgress(
                  step: 3,
                ),

                const SizedBox(height: 25),

                const Text(
                  'Add Your Profile Photo',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 29,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Help others recognize the real you.',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 30),

                // PHOTO PREVIEW
                Container(
                  width: 220,
                  height: 190,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE8EF),
                    borderRadius: BorderRadius.circular(40),
                  ),

                  child: selectedImage == null

                      // No image selected
                      ? const Icon(
                          Icons.add_a_photo_outlined,
                          size: 70,
                          color: Color(0xFFC65B7D),
                        )

                      // Selected image
                      : ClipRRect(
                          borderRadius:
                              BorderRadius.circular(40),
                          child: Image.file(
                            File(selectedImage!.path),
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),

                const SizedBox(height: 35),

                // UPLOAD PHOTO
                photoButton(
                  icon: Icons.upload_file,
                  title: 'Upload Photo',
                  onPressed: uploadPhoto,
                ),

                // TAKE PHOTO
                photoButton(
                  icon: Icons.camera_alt_outlined,
                  title: 'Take Photo',
                  onPressed: takePhoto,
                ),

                // GALLERY
                photoButton(
                  icon: Icons.photo_library_outlined,
                  title: 'Choose from Gallery',
                  onPressed: chooseFromGallery,
                ),

                const SizedBox(height: 25),

                // Information Box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE8EF),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.verified_user_outlined,
                        color: Color(0xFFC00055),
                      ),

                      SizedBox(width: 14),

                      Expanded(
                        child: Text(
                          'Clear photos help create genuine '
                          'connections. Ensure your face is '
                          'clearly visible.',
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 35),

                // CONTINUE
                SignupPrimaryButton(
                  text: 'CONTINUE',
                  onPressed: nextPage,
                ),

                const SizedBox(height: 8),

                // SKIP
                TextButton(
                  onPressed: nextPage,
                  child: const Text(
                    'Skip for Now',
                    style: TextStyle(
                      color: Color(0xFFC00055),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      );

  Widget photoButton({
    required IconData icon,
    required String title,
    required VoidCallback onPressed,
  }) =>
      Container(
        width: double.infinity,
        margin: const EdgeInsets.only(
          bottom: 14,
        ),
        height: 68,
        child: ElevatedButton.icon(
          onPressed: onPressed,

          icon: Icon(
            icon,
            color: const Color(0xFFE5005A),
          ),

          label: Text(
            title,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),

          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor:
                const Color(0xFFFFE8EF),

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35),
            ),
          ),
        ),
      );
}