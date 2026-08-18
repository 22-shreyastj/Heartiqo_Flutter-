import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';
import '../controller/profile_controller.dart';
import '../model/profile_model.dart';
import '../widgets/interests_selector.dart';
import '../widgets/photo_upload_grid.dart';

class EditProfileScreen extends StatefulWidget {
  final ProfileController controller;

  const EditProfileScreen({
    super.key,
    required this.controller,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _bioController;
  late TextEditingController _jobController;
  late TextEditingController _educationController;

  @override
  void initState() {
    super.initState();
    _bioController = TextEditingController(text: widget.controller.profile.bio);
    _jobController = TextEditingController(text: widget.controller.profile.jobTitle);
    _educationController = TextEditingController(text: widget.controller.profile.education);

    widget.controller.addListener(_onControllerChange);
  }

  void _onControllerChange() {
    if (_bioController.text != widget.controller.profile.bio) {
      _bioController.text = widget.controller.profile.bio;
    }
    if (_jobController.text != widget.controller.profile.jobTitle) {
      _jobController.text = widget.controller.profile.jobTitle;
    }
    if (_educationController.text != widget.controller.profile.education) {
      _educationController.text = widget.controller.profile.education;
    }
    setState(() {});
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChange);
    _bioController.dispose();
    _jobController.dispose();
    _educationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.controller.profile;

    return Scaffold(
      backgroundColor: AppColors.authBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Custom Top App Bar
            _buildAppBar(context),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Save Button Row
                    _buildTitleRow(context),

                    const SizedBox(height: 24),

                    // Photos Section
                    PhotoUploadGrid(
                      photos: profile.photos,
                      onAddPhoto: (index) {
                        widget.controller.addPhoto('assets/images/profiles/image1.jpg');
                      },
                      onRemovePhoto: (index) {
                        widget.controller.removePhoto(index);
                      },
                    ),

                    const SizedBox(height: 28),

                    // About Me Section
                    _buildAboutMeSection(),

                    const SizedBox(height: 28),

                    // Basic Info Section
                    _buildBasicInfoSection(profile),

                    const SizedBox(height: 28),

                    // Interests Section
                    InterestsSelector(
                      selectedInterests: profile.selectedInterests,
                      availableInterests: profile.availableInterests,
                      onToggleInterest: (interest) {
                        widget.controller.toggleInterest(interest);
                      },
                      onAddCustomInterest: (customInterest) {
                        widget.controller.addCustomInterest(customInterest);
                      },
                      onEditTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Tap on any tag to select or remove.')),
                        );
                      },
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.brandPink.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: AppColors.brandPink,
                size: 20,
              ),
            ),
          ),
          const Text(
            'Heartiqo',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.brandPink,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(width: 42), // Balance row layout
        ],
      ),
    );
  }

  Widget _buildTitleRow(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit Profile',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Update your details to stand out.',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 38,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.brandPink.withValues(alpha: 0.35),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {
              widget.controller.saveProfile();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile saved successfully! ✨'),
                  backgroundColor: AppColors.brandPink,
                ),
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
            ),
            child: const Text(
              'Save',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAboutMeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About Me',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.borderLight,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _bioController,
                maxLength: 500,
                maxLines: 4,
                onChanged: (text) {
                  widget.controller.updateBio(text);
                },
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textDark,
                  height: 1.4,
                ),
                decoration: const InputDecoration(
                  hintText: 'Write something interesting about yourself...',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: AppColors.textMuted,
                  ),
                  border: InputBorder.none,
                  counterText: '',
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_bioController.text.length} / 500',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textMuted,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.controller.generateAiBio();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('AI generated a bio for you! ✨'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: AppColors.softPinkSlot,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.auto_awesome_rounded,
                        size: 18,
                        color: AppColors.brandPink,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInfoSection(ProfileModel profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Basic Info',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 12),
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
              _buildInfoTile(
                icon: Icons.business_center_outlined,
                label: 'Job Title',
                value: profile.jobTitle,
                onTap: () => _editInfoDialog('Job Title', profile.jobTitle, widget.controller.updateJobTitle),
              ),
              const Divider(height: 1, indent: 56, endIndent: 16, color: AppColors.borderLight),
              _buildInfoTile(
                icon: Icons.school_outlined,
                label: 'Education',
                value: profile.education,
                onTap: () => _editInfoDialog('Education', profile.education, widget.controller.updateEducation),
              ),
              const Divider(height: 1, indent: 56, endIndent: 16, color: AppColors.borderLight),
              _buildInfoTile(
                icon: Icons.person_outline_rounded,
                label: 'Gender',
                value: profile.gender,
                hasChevron: true,
                onTap: () => _selectGenderDialog(profile.gender),
              ),
              const Divider(height: 1, indent: 56, endIndent: 16, color: AppColors.borderLight),
              _buildInfoTile(
                icon: Icons.location_on_outlined,
                label: 'Location',
                value: profile.location,
                hasChevron: true,
                onTap: () => _editInfoDialog('Location', profile.location, widget.controller.updateLocation),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
    bool hasChevron = false,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(
                icon,
                size: 22,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),
              if (hasChevron)
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 22,
                  color: AppColors.textMuted,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _editInfoDialog(String title, String currentValue, Function(String) onSave) {
    final controller = TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Edit $title'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.softPinkSlot,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: AppColors.textMuted)),
            ),
            ElevatedButton(
              onPressed: () {
                onSave(controller.text.trim());
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandPink,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _selectGenderDialog(String currentGender) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Gender',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              ...['Woman', 'Man', 'Non-binary', 'Other'].map((g) {
                return ListTile(
                  title: Text(g),
                  trailing: g == currentGender
                      ? const Icon(Icons.check_rounded, color: AppColors.brandPink)
                      : null,
                  onTap: () {
                    widget.controller.updateGender(g);
                    Navigator.pop(ctx);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
