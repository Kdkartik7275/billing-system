import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddProductTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? prefixText;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final bool readOnly;

  const AddProductTextfield({
    super.key,
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.readOnly = false,
    this.keyboardType,
    this.inputFormatters,
    this.prefixText,
    this.suffixIcon,
    this.onSuffixTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      readOnly:readOnly,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      
      style: const TextStyle(fontSize: 14.5, color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: Theme.of(context).textTheme.labelLarge!.copyWith(
          color: AppColors.textPlaceholder,
          fontSize: 14.5,
        ),
        prefixText: prefixText,
        prefixStyle: Theme.of(context).textTheme.labelLarge!.copyWith(
          color: AppColors.textPrimary,
          fontSize: 14.5,
        ),
        suffixIcon: suffixIcon != null
            ? IconButton(
                icon: Icon(
                  suffixIcon,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
                onPressed: onSuffixTap,
              )
            : null,
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 14,
          vertical: maxLines > 1 ? 14 : 13,
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
    );
  }
}
