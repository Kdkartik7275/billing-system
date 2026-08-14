import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SupplierSearchBar extends StatelessWidget {
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onFilterTap;

  const SupplierSearchBar({super.key, this.onSearchChanged, this.onFilterTap});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onSearchChanged,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: "Search suppliers...",
        hintStyle: TextStyle(color: Colors.grey[500], fontSize: 13.5),
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
      ),
    );
  }
}
