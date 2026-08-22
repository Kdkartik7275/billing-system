import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SalesSearchField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const SalesSearchField({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Search bill / customer',
        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: const Icon(
          Icons.search_rounded,
          size: 22,
          color: Colors.black,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xffE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 1.3),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
