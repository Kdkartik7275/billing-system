import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/core/helper/export_sales_data.dart';
import 'package:billing_system/features/sales/presentation/controller/sales_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum _SalesExportPreset {
  thisWeek,
  lastWeek,
  thisMonth,
  lastMonth,
  customRange,
}

class SalesExportButton extends StatelessWidget {
  final SalesController controller;
  final bool compact;

  const SalesExportButton({
    super.key,
    required this.controller,
    this.compact = true,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isExporting = controller.isExporting.value;

      return PopupMenuButton<_SalesExportPreset>(
        // Disabling via `enabled` rather than hiding keeps the header layout
        // stable while a report is building.
        enabled: !isExporting,
        tooltip: isExporting ? 'Preparing report…' : 'Export sales report',
        position: PopupMenuPosition.under,
        offset: const Offset(0, 6),
        elevation: 6,
        // Explicit white + a fixed border, rather than pulling from
        // Theme.of(context).colorScheme, so the menu stays a light card
        // even though the app's own ColorScheme/PopupMenuTheme is dark.
        color: Colors.white,
        shadowColor: Colors.black.withValues(alpha: 0.15),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        constraints: const BoxConstraints(minWidth: 220),
        onSelected: (preset) => _handlePreset(context, preset),
        itemBuilder: (_) => [
          const PopupMenuItem<_SalesExportPreset>(
            enabled: false,
            height: 28,
            padding: EdgeInsets.zero,
            child: _MenuSectionLabel('QUICK RANGES'),
          ),
          const PopupMenuItem(
            value: _SalesExportPreset.thisWeek,
            height: 46,
            child: _MenuRow(
              icon: Icons.calendar_view_week_rounded,
              label: 'This week',
              hint: 'Mon – Sun',
            ),
          ),
          const PopupMenuItem(
            value: _SalesExportPreset.lastWeek,
            height: 46,
            child: _MenuRow(
              icon: Icons.history_rounded,
              label: 'Last week',
              hint: 'Mon – Sun',
            ),
          ),
          const PopupMenuItem(
            value: _SalesExportPreset.thisMonth,
            height: 46,
            child: _MenuRow(
              icon: Icons.calendar_month_rounded,
              label: 'This month',
            ),
          ),
          const PopupMenuItem(
            value: _SalesExportPreset.lastMonth,
            height: 46,
            child: _MenuRow(
              icon: Icons.event_repeat_rounded,
              label: 'Last month',
            ),
          ),
          const PopupMenuDivider(height: 12),
          const PopupMenuItem<_SalesExportPreset>(
            enabled: false,
            height: 28,
            padding: EdgeInsets.zero,
            child: _MenuSectionLabel('CUSTOM'),
          ),
          const PopupMenuItem(
            value: _SalesExportPreset.customRange,
            height: 46,
            child: _MenuRow(
              icon: Icons.date_range_rounded,
              label: 'Custom range…',
            ),
          ),
        ],
        child: compact
            ? _CompactTrigger(isExporting: isExporting)
            : _LabelledTrigger(isExporting: isExporting),
      );
    });
  }

  Future<void> _handlePreset(
    BuildContext context,
    _SalesExportPreset preset,
  ) async {
    final now = DateTime.now();

    switch (preset) {
      case _SalesExportPreset.thisWeek:
        await controller.exportSales(SalesExportRange.week(now));
      case _SalesExportPreset.lastWeek:
        await controller.exportSales(SalesExportRange.week(now, weeksAgo: 1));
      case _SalesExportPreset.thisMonth:
        await controller.exportSales(SalesExportRange.month(now));
      case _SalesExportPreset.lastMonth:
        await controller.exportSales(SalesExportRange.month(now, monthsAgo: 1));
      case _SalesExportPreset.customRange:
        await _pickCustomRange(context, now);
    }
  }

  Future<void> _pickCustomRange(BuildContext context, DateTime now) async {
    final start = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 2),
      lastDate: now,
      initialDate: now.subtract(const Duration(days: 6)),
      helpText: 'Select start date',

      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
            colorScheme: const ColorScheme.light(
              surface: Colors.white,
              onSurface: Colors.black,
              primary: AppColors.primary,
              onPrimary: Colors.white,
            ),
            textTheme: const TextTheme(
              headlineSmall: TextStyle(color: Colors.black),
              titleMedium: TextStyle(color: Colors.black),
              bodyLarge: TextStyle(color: Colors.black),
              bodyMedium: TextStyle(color: Colors.black),
              labelLarge: TextStyle(color: Colors.black),
            ),
          ),
          child: child!,
        );
      },
    );

    if (start == null || !context.mounted) return;

    final end = await showDatePicker(
      context: context,
      firstDate: start,
      lastDate: now,
      initialDate: now.isBefore(start) ? start : now,
      helpText: 'Select end date',

      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
            colorScheme: const ColorScheme.light(
              surface: Colors.white,
              onSurface: Colors.black,
              primary: AppColors.primary,
              onPrimary: Colors.white,
            ),
            textTheme: const TextTheme(
              headlineSmall: TextStyle(color: Colors.black),
              titleMedium: TextStyle(color: Colors.black),
              bodyLarge: TextStyle(color: Colors.black),
              bodyMedium: TextStyle(color: Colors.black),
              labelLarge: TextStyle(color: Colors.black),
            ),
          ),
          child: child!,
        );
      },
    );

    if (end == null || !context.mounted) return;

    await controller.exportSales(SalesExportRange.custom(start, end));
  }
}

/// Small caps section header used to group related menu items.
class _MenuSectionLabel extends StatelessWidget {
  final String text;

  const _MenuSectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
          color: Colors.grey.shade500,
        ),
      ),
    );
  }
}

class _CompactTrigger extends StatelessWidget {
  final bool isExporting;

  const _CompactTrigger({required this.isExporting});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: isExporting
            ? AppColors.primary.withValues(alpha: 0.08)
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isExporting
              ? AppColors.primary.withValues(alpha: 0.3)
              : Colors.grey.shade200,
        ),
      ),
      alignment: Alignment.center,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 180),
        child: isExporting
            ? SizedBox(
                key: const ValueKey('spinner'),
                height: 16,
                width: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              )
            : Icon(
                Icons.file_download_outlined,
                key: const ValueKey('icon'),
                size: 19,
                color: Colors.grey.shade700,
              ),
      ),
    );
  }
}

class _LabelledTrigger extends StatelessWidget {
  final bool isExporting;

  const _LabelledTrigger({required this.isExporting});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: isExporting ? 0.05 : 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: isExporting ? 0.15 : 0.25),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: isExporting
                ? const SizedBox(
                    key: ValueKey('spinner'),
                    height: 15,
                    width: 15,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  )
                : const Icon(
                    Icons.file_download_outlined,
                    key: ValueKey('icon'),
                    size: 17,
                    color: AppColors.primary,
                  ),
          ),
          const SizedBox(width: 8),
          Text(
            isExporting ? 'Preparing…' : 'Export',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          if (!isExporting) ...[
            const SizedBox(width: 2),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18,
              color: AppColors.primary,
            ),
          ],
        ],
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? hint;

  const _MenuRow({required this.icon, required this.label, this.hint});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 28,
          width: 28,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 15, color: Colors.grey.shade700),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
        if (hint != null) ...[
          const SizedBox(width: 8),
          Text(
            hint!,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
          ),
        ],
      ],
    );
  }
}
