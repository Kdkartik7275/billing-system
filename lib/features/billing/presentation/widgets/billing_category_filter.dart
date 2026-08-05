import 'dart:ui';

import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BillingCategoryFilter extends StatelessWidget {
  final List<String> categories;
  final RxString selectedCategory;
  final ValueChanged<String> onSelect;
  final double height;

  const BillingCategoryFilter({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelect,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return ScrollConfiguration(
      behavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.trackpad,
        },
      ),
      child: SizedBox(
        height: height,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          separatorBuilder: (_, _) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final categoryName = categories[index];

            return Obx(() {
              final isSelected = selectedCategory.value == categoryName;

              return GestureDetector(
                onTap: () => onSelect(categoryName),
                child: Chip(
                  backgroundColor: isSelected
                      ? AppColors.primary
                      : Colors.white,
                  side: isSelected
                      ? BorderSide.none
                      : BorderSide(color: Colors.grey.shade200),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  label: Text(
                    categoryName,
                    style: theme.titleSmall?.copyWith(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                ),
              );
            });
          },
        ),
      ),
    );
  }
}
