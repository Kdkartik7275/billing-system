import 'package:billing_system/core/card/card_shell.dart';
import 'package:flutter/material.dart';

class SimpleNavRow extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String actionLabel;
  final Color actionColor;
  final VoidCallback? onTap;

  const SimpleNavRow({
    super.key,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.actionLabel,
    required this.actionColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: CardShell(
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, size: 18, color: iconColor),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF15151A),
                ),
              ),
            ),
            Text(
              actionLabel,
              style: TextStyle(
                color: actionColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            Icon(Icons.chevron_right, size: 18, color: actionColor),
          ],
        ),
      ),
    );
  }
}

