import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BillingSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onScanTap;

  const BillingSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onScanTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: "Search by name, SKU or scan...",
        hintStyle: TextStyle(color: Colors.grey[500], fontSize: 13.5),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: const Icon(
          Icons.search_rounded,
          size: 22,
          color: Colors.black,
        ),
        suffixIcon: IconButton(
          icon: const Icon(
            CupertinoIcons.barcode_viewfinder,
            size: 26,
            color: AppColors.primary,
          ),
          onPressed: onScanTap,
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
