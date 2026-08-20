import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';
import '../controller/profile_controller.dart';

class AccountScreen extends StatefulWidget {
  final ProfileController controller;

  const AccountScreen({super.key, required this.controller});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _dobController;
  late TextEditingController _genderController;
  late TextEditingController _bioController;
  late TextEditingController _locationController;

  bool _isEditing = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final profile = widget.controller.profile;
    _nameController = TextEditingController(text: profile.name);
    _emailController = TextEditingController(text: profile.email);
    _phoneController = TextEditingController(text: profile.phoneNumber);
    _dobController = TextEditingController(text: profile.dob);
    _genderController = TextEditingController(text: profile.gender);
    _bioController = TextEditingController(text: profile.bio);
    _locationController = TextEditingController(text: profile.location);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _genderController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    final success = await widget.controller.updateAccountDetails(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      dob: _dobController.text.trim(),
      gender: _genderController.text.trim(),
      bio: _bioController.text.trim(),
      location: _locationController.text.trim(),
    );

    if (!mounted) return;

    setState(() {
      _isSaving = false;
      _isEditing = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account details updated successfully!'),
          backgroundColor: AppColors.brandPink,
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update account details. Try again.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _selectDateOfBirth() async {
    if (!_isEditing) return;
    DateTime initial = DateTime.tryParse(_dobController.text) ?? DateTime(1998, 1, 1);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1950),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.brandPink,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dobController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.controller.profile;

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
          'Account Details',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _isEditing ? Icons.close_rounded : Icons.edit_rounded,
              color: AppColors.brandPink,
            ),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Avatar photo display
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.softPinkSlot,
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        image: profile.avatarUrl.isNotEmpty
                            ? DecorationImage(
                                image: AssetImage(profile.avatarUrl),
                                fit: BoxFit.cover,
                                onError: (exception, stackTrace) {},
                              )
                            : null,
                      ),
                      child: profile.avatarUrl.isEmpty
                          ? const Icon(
                              Icons.person_rounded,
                              size: 48,
                              color: AppColors.brandPink,
                            )
                          : null,
                    ),
                    if (_isEditing)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppColors.brandPink,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Form fields card
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
                  children: [
                    _buildField(
                      label: 'Full Name',
                      icon: Icons.person_outline_rounded,
                      controller: _nameController,
                      enabled: _isEditing,
                      validator: (val) =>
                          val == null || val.trim().isEmpty ? 'Name is required' : null,
                    ),
                    const SizedBox(height: 16),
                    _buildField(
                      label: 'Email Address',
                      icon: Icons.email_outlined,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      enabled: _isEditing,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Email is required';
                        }
                        if (!val.contains('@')) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildField(
                      label: 'Phone Number',
                      icon: Icons.phone_outlined,
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      enabled: _isEditing,
                      validator: (val) =>
                          val == null || val.trim().isEmpty ? 'Phone number is required' : null,
                    ),
                    const SizedBox(height: 16),
                    _buildField(
                      label: 'Date of Birth',
                      icon: Icons.cake_outlined,
                      controller: _dobController,
                      enabled: _isEditing,
                      readOnly: true,
                      onTap: _selectDateOfBirth,
                    ),
                    const SizedBox(height: 16),
                    _buildGenderField(),
                    const SizedBox(height: 16),
                    _buildField(
                      label: 'Location',
                      icon: Icons.location_on_outlined,
                      controller: _locationController,
                      enabled: _isEditing,
                    ),
                    const SizedBox(height: 16),
                    _buildField(
                      label: 'Bio',
                      icon: Icons.notes_rounded,
                      controller: _bioController,
                      maxLines: 3,
                      enabled: _isEditing,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Action Buttons
              if (_isEditing) ...[
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _handleSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brandPink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 2,
                    ),
                    child: _isSaving
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Save Changes',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _isEditing = false;
                      });
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    bool enabled = true,
    bool readOnly = false,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    VoidCallback? onTap,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      readOnly: readOnly,
      maxLines: maxLines,
      keyboardType: keyboardType,
      onTap: onTap,
      validator: validator,
      style: const TextStyle(
        fontSize: 14.5,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
        prefixIcon: Icon(icon, color: AppColors.brandPink, size: 20),
        filled: true,
        fillColor: enabled ? AppColors.softPinkSlot.withValues(alpha: 0.4) : Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.brandPink, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildGenderField() {
    return DropdownButtonFormField<String>(
      value: ['Woman', 'Man', 'Non-binary', 'Other']
              .contains(_genderController.text)
          ? _genderController.text
          : 'Woman',
      onChanged: _isEditing
          ? (val) {
              if (val != null) {
                setState(() {
                  _genderController.text = val;
                });
              }
            }
          : null,
      decoration: InputDecoration(
        labelText: 'Gender',
        labelStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
        prefixIcon: const Icon(Icons.people_outline_rounded, color: AppColors.brandPink, size: 20),
        filled: true,
        fillColor: _isEditing ? AppColors.softPinkSlot.withValues(alpha: 0.4) : Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      items: ['Woman', 'Man', 'Non-binary', 'Other']
          .map((g) => DropdownMenuItem(
                value: g,
                child: Text(
                  g,
                  style: const TextStyle(fontSize: 14.5, color: AppColors.textDark),
                ),
              ))
          .toList(),
    );
  }
}
