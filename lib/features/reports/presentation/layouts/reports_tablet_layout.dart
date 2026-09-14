import 'package:billing_system/features/reports/presentation/controller/reports_controller.dart';
import 'package:billing_system/features/reports/presentation/layouts/reports_mobile_layout.dart';
import 'package:billing_system/features/reports/presentation/widgets/reports_day_summary_header.dart';
import 'package:billing_system/features/reports/presentation/widgets/reports_layout_helper.dart';
import 'package:billing_system/features/reports/presentation/widgets/tender_breakdown_card.dart';
import 'package:billing_system/features/reports/presentation/widgets/z_report_preview_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportsTabletLayout extends GetView<ReportsController> {
  const ReportsTabletLayout({super.key});

  static const double maxContentWidth = 1180;

  /// Below this width there isn't enough room to show the receipt preview
  /// side-by-side with the main content, so it drops to a full-width card
  /// underneath instead.
  static const double previewSideBySideBreakpoint = 860;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: maxContentWidth),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final showSidePreview =
                  constraints.maxWidth >= previewSideBySideBreakpoint;
              final actionsWidth =
                  constraints.maxWidth < 560 ? constraints.maxWidth : 500.0;

              final reconciliationAndTender = LayoutBuilder(
                builder: (context, innerConstraints) {
                  final stack = innerConstraints.maxWidth < 620;
                  final reconciliation =
                      buildCashReconciliationSection(context, controller);
                  final tender = TenderBreakdownCard(controller: controller);

                  if (stack) {
                    return Column(
                      children: [
                        reconciliation,
                        const SizedBox(height: 16),
                        tender,
                      ],
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: reconciliation),
                      const SizedBox(width: 16),
                      Expanded(child: tender),
                    ],
                  );
                },
              );

              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  ReportsDayHeaderBar(controller: controller),
                  const SizedBox(height: 18),
                  ReportDaySummaryHeader(controller: controller),
                  const SizedBox(height: 16),
                  if (showSidePreview)
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 3, child: reconciliationAndTender),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 2,
                            child: SizedBox(
                              height: 660,
                              child: const ZReportPreviewCard(),
                            ),
                          ),
                        ],
                      ),
                    )
                  else ...[
                    reconciliationAndTender,
                    const SizedBox(height: 16),
                    SizedBox(height: 620, child: const ZReportPreviewCard()),
                  ],
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: actionsWidth,
                      child: buildReportActionButtonsSection(context, controller),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}