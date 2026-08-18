import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';

class InterestsSelector extends StatelessWidget {
  final List<String> selectedInterests;
  final List<String> availableInterests;
  final Function(String interest)? onToggleInterest;
  final Function(String customInterest)? onAddCustomInterest;
  final VoidCallback? onEditTap;

  const InterestsSelector({
    super.key,
    required this.selectedInterests,
    required this.availableInterests,
    this.onToggleInterest,
    this.onAddCustomInterest,
    this.onEditTap,
  });

  IconData _getInterestIcon(String name) {
    switch (name.toLowerCase()) {
      case 'art':
        return Icons.language_rounded;
      case 'foodie':
        return Icons.restaurant_rounded;
      case 'travel':
        return Icons.flight_takeoff_rounded;
      case 'fitness':
        return Icons.fit_screen_rounded;
      case 'gaming':
        return Icons.sports_esports_rounded;
      case 'yoga':
        return Icons.self_improvement_rounded;
      case 'cooking':
        return Icons.soup_kitchen_rounded;
      case 'movies':
        return Icons.movie_creation_rounded;
      case 'music':
        return Icons.music_note_rounded;
      default:
        return Icons.favorite_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Interests',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            GestureDetector(
              onTap: onEditTap,
              child: const Text(
                'Edit',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.brandPink,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            // Selected Interests Chips
            ...selectedInterests.map((interest) {
              return _buildChip(
                label: interest,
                icon: _getInterestIcon(interest),
                isSelected: true,
                onTap: () => onToggleInterest?.call(interest),
              );
            }),

            // Available Interests Chips
            ...availableInterests.map((interest) {
              return _buildChip(
                label: interest,
                icon: _getInterestIcon(interest),
                isSelected: false,
                onTap: () => onToggleInterest?.call(interest),
              );
            }),

            // Add More Chip
            GestureDetector(
              onTap: () => _showAddInterestDialog(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.softPinkSlot,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.brandPink.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add_rounded,
                      size: 16,
                      color: AppColors.brandPink,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Add more',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.brandPink,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChip({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.brandPink : AppColors.softPinkSlot,
          gradient: isSelected ? AppColors.primaryGradient : null,
          borderRadius: BorderRadius.circular(22),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.brandPink.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : AppColors.darkPurple,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.darkPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddInterestDialog(BuildContext context) {
    final TextEditingController textController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'Add New Interest',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: AppColors.textDark,
            ),
          ),
          content: TextField(
            controller: textController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'e.g. Photography, Anime',
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
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.textMuted),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final value = textController.text.trim();
                if (value.isNotEmpty) {
                  onAddCustomInterest?.call(value);
                }
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandPink,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
