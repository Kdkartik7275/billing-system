import 'package:billing_system/features/reports/presentation/controller/reports_controller.dart';
import 'package:billing_system/features/reports/presentation/widgets/report_date_selector.dart';
import 'package:billing_system/features/reports/presentation/widgets/reports_day_summary_header.dart';
import 'package:billing_system/features/reports/presentation/widgets/reports_layout_helper.dart';
import 'package:billing_system/features/reports/presentation/widgets/tender_breakdown_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportsMobileLayout extends GetView<ReportsController> {
  const ReportsMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 26),
        children: [
          ReportsDayHeaderBar(controller: controller),
          const SizedBox(height: 14),
          ReportDaySummaryHeader(controller: controller),
          const SizedBox(height: 14),
          buildCashReconciliationSection(context, controller),
          const SizedBox(height: 14),
          TenderBreakdownCard(controller: controller),
          const SizedBox(height: 18),
          buildReportActionButtonsSection(context, controller),
        ],
      ),
    );
  }
}

class ReportsDayHeaderBar extends StatelessWidget {
  final ReportsController controller;

  const ReportsDayHeaderBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Day Close / Z-Report',
            style: Theme.of(context).textTheme.titleMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 10),
        ReportDateSelector(controller: controller),
      ],
    );
  }
}