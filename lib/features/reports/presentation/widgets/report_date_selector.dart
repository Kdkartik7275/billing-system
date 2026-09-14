import 'package:billing_system/features/reports/presentation/controller/reports_controller.dart';
import 'package:billing_system/features/reports/presentation/widgets/report_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ReportDateSelector extends StatelessWidget {
  final ReportsController controller;

  const ReportDateSelector({super.key, required this.controller});

  Future<void> _selectDate(BuildContext context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: ReportColors.primary),
          ),
          child: child!,
        );
      },
    );

    if (selected != null) {
      controller.selectDate(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => InkWell(
        onTap: () => _selectDate(context),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: ReportColors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: ReportColors.secondaryText,
              ),
              const SizedBox(width: 8),
              Text(
                DateFormat('dd MMM yyyy').format(controller.selectedDate.value),
                style: const TextStyle(
                  color: ReportColors.text,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.keyboard_arrow_down,
                size: 18,
                color: ReportColors.secondaryText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
