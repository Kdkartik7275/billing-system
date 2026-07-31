import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class FieldLabel extends StatelessWidget {
  final String text;
  final bool required;
  final String? info;

  const FieldLabel(this.text, {super.key, this.required = false, this.info});

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.labelLarge;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: RichText(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: labelStyle,
                children: [
                  TextSpan(text: text),
                  if (required)
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(
                        color: AppColors.danger,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                ],
              ),
            ),
          ),

          if (info != null) ...[
            const SizedBox(width: 4),
            Tooltip(
              message: info!,
              triggerMode: TooltipTriggerMode.tap,
              child: const Icon(
                Icons.info_outline,
                size: 14,
                color: AppColors.textPlaceholder,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
