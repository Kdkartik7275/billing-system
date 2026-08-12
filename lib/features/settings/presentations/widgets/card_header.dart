import 'package:flutter/material.dart';

class CardHeader extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final VoidCallback? onEdit;
  final Widget? trailing;
  final double titleFontSize;

  const CardHeader({
    super.key,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    this.onEdit,
    this.trailing,
    this.titleFontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Row(
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
            style: theme.titleSmall!.copyWith(
              fontSize: titleFontSize,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF15151A),
            ),
          ),
        ),
        ?trailing,
        if (trailing == null && onEdit != null)
          TextButton.icon(
            onPressed: onEdit,
            icon: Icon(Icons.edit_outlined, size: 15, color: iconColor),
            label: Text(
              'Edit',
              style: theme.titleSmall!.copyWith(
                color: iconColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
      ],
    );
  }
}
