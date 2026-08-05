import 'package:flutter/material.dart';

class NumpadButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onTap;

  const NumpadButton({
    super.key,
    this.label = '',
    this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        alignment: Alignment.center,
        child: icon != null
            ? Icon(icon, color: Colors.black87, size: 20)
            : Text(
                label,
                style: theme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
      ),
    );
  }
}
