import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/features/inventory/presentation/widgets/add_product/field_label.dart';
import 'package:flutter/material.dart';

class LabeledDropdownField extends StatelessWidget {
  final String label;
  final bool required;
  final String? value;
  final List<String> options;
  final ValueChanged<String?> onChanged;
  final String hint;

  const LabeledDropdownField({
    super.key,
    required this.label,
    required this.options,
    required this.onChanged,
    this.value,
    this.required = false,
    this.hint = 'Select',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(label, required: required),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: value,
          isExpanded: true,
          dropdownColor: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.grey.shade500,
            size: 18,
          ),
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
            fontSize: 14.5,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: Theme.of(context).textTheme.labelLarge!.copyWith(
              color: AppColors.textPlaceholder,
              fontSize: 14.5,
            ),
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 13,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.4,
              ),
            ),
          ),
          items: options
              .map(
                (option) => DropdownMenuItem<String>(
                  value: option,
                  child: Text(
                    option,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
