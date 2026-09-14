import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/core/helper/functions.dart';
import 'package:billing_system/features/reports/presentation/controller/reports_controller.dart';
import 'package:billing_system/features/reports/presentation/widgets/report_card.dart';
import 'package:billing_system/features/reports/presentation/widgets/report_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportsCashReconciliationCard extends StatelessWidget {
  final ReportsController controller;

  const ReportsCashReconciliationCard({super.key, required this.controller});

  Future<void> _editOpeningFloat(BuildContext context) async {
    final textController = TextEditingController(
      text: controller.openingCashFloat.value.toStringAsFixed(0),
    );

    final result = await showDialog<double>(
      context: context,
      builder: (_) => _AmountDialog(
        title: 'Opening Cash Float',
        label: 'Opening cash amount',
        controller: textController,
      ),
    );

    if (result != null) {
      controller.setOpeningFloat(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ReportCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionTitle(
              icon: Icons.account_balance_wallet_outlined,
              title: 'Cash Reconciliation',
              iconColor: ReportColors.green,
            ),
            const SizedBox(height: 15),
            _ReconciliationRow(
              label: 'Opening Cash Float',
              value: formatReportCurrency(controller.openingCashFloat.value),
              action: TextButton(
                onPressed: () => _editOpeningFloat(context),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Edit',
                  style: TextStyle(
                    fontSize: 11,
                    color: ReportColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const Divider(height: 22),
            _ReconciliationRow(
              label: 'Expected Cash',
              helper: '(Float + Cash Sales - Refunds - Payouts)',
              value: formatReportCurrency(controller.expectedCash),
            ),
            const Divider(height: 22),
            _ReconciliationRow(
              label: 'Counted Cash',
              value: controller.hasCountedCash
                  ? formatReportCurrency(controller.countedCash.value!)
                  : 'Not counted',
              valueColor: controller.hasCountedCash
                  ? ReportColors.text
                  : ReportColors.mutedText,
              outlined: true,
            ),
            const SizedBox(height: 13),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: controller.hasCountedCash
                    ? ReportColors.redLight
                    : ReportColors.primaryLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      controller.hasCountedCash
                          ? 'Variance'
                          : 'Cash count required',
                      style: TextStyle(
                        color: controller.hasCountedCash
                            ? ReportColors.red
                            : ReportColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (controller.hasCountedCash) ...[
                    Text(
                      formatReportCurrency(controller.variance),
                      style: TextStyle(
                        color: controller.variance == 0
                            ? ReportColors.green
                            : ReportColors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Icon(
                      controller.variance == 0
                          ? Icons.check_circle_outline
                          : Icons.warning_amber_rounded,
                      size: 17,
                      color: controller.variance == 0
                          ? ReportColors.green
                          : ReportColors.red,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      controller.varianceLabel,
                      style: TextStyle(
                        color: controller.variance == 0
                            ? ReportColors.green
                            : ReportColors.red,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color iconColor;

  const _SectionTitle({
    required this.icon,
    required this.title,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: ReportColors.text,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _ReconciliationRow extends StatelessWidget {
  final String label;
  final String value;
  final String? helper;
  final Widget? action;
  final Color? valueColor;
  final bool outlined;

  const _ReconciliationRow({
    required this.label,
    required this.value,
    this.helper,
    this.action,
    this.valueColor,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: ReportColors.secondaryText,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (helper != null) ...[
                const SizedBox(height: 3),
                Text(
                  helper!,
                  style: const TextStyle(
                    color: ReportColors.mutedText,
                    fontSize: 9,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (action != null) ...[action!, const SizedBox(width: 14)],
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? ReportColors.text,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );

    if (!outlined) return content;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
      decoration: BoxDecoration(
        border: Border.all(color: ReportColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: content,
    );
  }
}

class _AmountDialog extends StatelessWidget {
  final String title;
  final String label;
  final TextEditingController controller;

  const _AmountDialog({
    required this.title,
    required this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      content: TextField(
        controller: controller,

        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          prefixStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          hintStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: AppColors.textPlaceholder,
          ),

          labelStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
          prefixText: '₹ ',
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
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        FilledButton(
          onPressed: () {
            final value = double.tryParse(controller.text);
            Navigator.pop(context, value);
          },
          child: Text(
            'Save',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
