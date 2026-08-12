import 'package:flutter/material.dart';

class LogoutCard extends StatelessWidget {
  final VoidCallback? onTap;
  const LogoutCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFDEDED),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF6C9C7)),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.logout_rounded,
              color: Color(0xFFE0554F),
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Logout',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Sign out from your account',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.red.withValues(alpha: .8),
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFFE0554F), size: 20),
          ],
        ),
      ),
    );
  }
}
