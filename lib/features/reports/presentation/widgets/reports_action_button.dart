import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/features/reports/presentation/controller/reports_controller.dart';
import 'package:billing_system/features/reports/presentation/widgets/report_colors.dart';
import 'package:billing_system/features/reports/presentation/widgets/reports_z_report_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportsActionButtons extends StatelessWidget {
  final ReportsController controller;

  const ReportsActionButtons({super.key, required this.controller});

  void _showCountedCashDialog(BuildContext context) {
    final textController = TextEditingController(
      text: controller.countedCash.value?.toStringAsFixed(0) ?? '',
    );

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: ReportColors.background,
          title: Text(
            'Enter Counted Cash',
            style: Theme.of(
              context,
            ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter the cash amount counted at the end of the day.',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: ReportColors.secondaryText,
                ),
              ),
              const SizedBox(height: 18),
              TextField(
                controller: textController,
                autofocus: true,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: 'Counted cash amount',
                  prefixText: '₹ ',
                  prefixStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: ReportColors.text,
                    fontWeight: FontWeight.w600,
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
              ),
              const SizedBox(height: 14),
              Obx(
                () => Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: ReportColors.primaryLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Expected Cash',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: ReportColors.secondaryText,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '₹ ${controller.expectedCash.toStringAsFixed(0)}',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: ReportColors.text,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: Get.back, child: const Text('Cancel')),
            FilledButton(
              onPressed: () {
                final amount = double.tryParse(textController.text);

                if (amount == null) {
                  return;
                }

                controller.setCountedCash(amount);
                Get.back();
              },
              child: Text(
                'Continue',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _closeDay(BuildContext context) async {
    if (!controller.hasCountedCash) {
      _showCountedCashDialog(context);
      return;
    }

    final shouldClose = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: ReportColors.background,
        title: Text(
          'Close Day',
          style: Theme.of(
            context,
          ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Closing the day will lock the current day report and reset counters for the next business day. Continue?',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.w400,
            color: ReportColors.secondaryText,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.pop(context, true),
            icon: const Icon(Icons.lock_outline, color: Colors.white, size: 17),
            label: Text(
              'Close Day',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );

    if (shouldClose != true) return;

    final success = await controller.closeDay();

    if (success) {
      Get.snackbar(
        'Day Closed',
        'The business day was closed successfully.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: ReportColors.green,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isClosed = controller.dayStatus.value == DayStatus.closed;

      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                Get.dialog(ReportsZReportDialog(controller: controller));
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(45),
                side: const BorderSide(color: ReportColors.primary),
                foregroundColor: ReportColors.primary,
              ),
              child: const Text('Preview Z-Report'),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: FilledButton.icon(
              onPressed: isClosed ? null : () => _closeDay(context),
              icon: const Icon(
                Icons.lock_outline,
                size: 17,
                color: Colors.white,
              ),
              label: Text(
                isClosed ? 'Day Closed' : 'Close Day',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(45),
                backgroundColor: ReportColors.primary,
                disabledBackgroundColor: ReportColors.secondaryText,
              ),
            ),
          ),
        ],
      );
    });
  }
}
