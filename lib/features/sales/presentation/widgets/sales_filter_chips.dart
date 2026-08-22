import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/features/sales/presentation/controller/sales_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SalesFilterChips extends StatelessWidget {
  final SalesController controller;

  const SalesFilterChips({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: SalesFilter.values.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, index) {
          final filter = SalesFilter.values[index];

          return Obx(() {
            final isSelected = controller.selectedFilter.value == filter;

            return InkWell(
              onTap: () => controller.selectFilter(filter),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.08)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : Colors.grey.shade200,
                    width: isSelected ? 1.4 : 1,
                  ),
                ),
                child: Text(
                  filter.label,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 13.5,
                    color: isSelected ? AppColors.primary : Colors.black87,
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }
}
