import 'package:flutter/material.dart';

class GoogleAccountPickerSheet extends StatelessWidget {
  final VoidCallback onContinue;

  const GoogleAccountPickerSheet({
    super.key,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Choose an account',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D103A),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Select the Google account you want to continue with.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 18),
            ListTile(
              leading: Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFE5F1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.g_mobiledata,
                  color: Color(0xFFC00055),
                ),
              ),
              title: const Text('Continue with Google'),
              subtitle: const Text('Use your Google account'),
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              tileColor: Colors.grey.shade50,
              onTap: () {
                Navigator.pop(context);
                onContinue();
              },
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
