import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/features/sales/presentation/controller/sales_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SalesDatePicker extends StatelessWidget {
  final SalesController controller;

  const SalesDatePicker({super.key, required this.controller});

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('EEE, dd MMM yyyy');

    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: controller.selectedDate.value,
          firstDate: DateTime.now().subtract(const Duration(days: 60)),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  surface: Colors.white,
                  primary: AppColors.primary,
                  onPrimary: Colors.white,
                  onSurface: Colors.black,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) controller.selectDate(picked);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: 18,
              color: Colors.grey.shade700,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _isToday(controller.selectedDate.value)
                    ? 'Today, ${DateFormat('dd MMM yyyy').format(controller.selectedDate.value)}'
                    : dateFmt.format(controller.selectedDate.value),
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.5,
                ),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
