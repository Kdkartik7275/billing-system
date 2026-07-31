import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AddProductDropdown extends StatelessWidget {
  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const AddProductDropdown({
    super.key,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: AppColors.textSecondary,
      ),
      style:  Theme.of(context).textTheme.labelLarge!.copyWith(fontSize: 14.5, color: AppColors.textPrimary),
      dropdownColor: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:  Theme.of(context).textTheme.labelLarge!.copyWith(
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
          borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
        ),
      ),
      items: items
          .map((e) => DropdownMenuItem<String>(value: e, child: Text(e,style: Theme.of(context).textTheme.labelLarge!.copyWith(),)))
          .toList(),
      onChanged: onChanged,
    );
  }
}
