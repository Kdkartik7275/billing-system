import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Widget? valueWidget;
  final bool showDivider;

  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    this.value = '',
    this.valueWidget,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 9),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon
              SizedBox(
                width: 24,
                child: Icon(icon, size: 16, color: Colors.grey.shade500),
              ),

              const SizedBox(width: 8),

              // Label
              Expanded(
                flex: 4,
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Value
              Flexible(
                flex: 6,
                child: Align(
                  alignment: Alignment.centerRight,
                  child:
                      valueWidget ??
                      Text(
                        value,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF15151A),
                        ),
                      ),
                ),
              ),
            ],
          ),
        ),

        if (showDivider)
          Divider(height: 1, thickness: 0.7, color: Colors.grey.shade200),
      ],
    );
  }
}
