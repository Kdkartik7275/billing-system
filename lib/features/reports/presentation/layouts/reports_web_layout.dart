import 'package:billing_system/features/reports/presentation/controller/reports_controller.dart';
import 'package:billing_system/features/reports/presentation/layouts/reports_mobile_layout.dart';
import 'package:billing_system/features/reports/presentation/widgets/reports_day_summary_header.dart';
import 'package:billing_system/features/reports/presentation/widgets/reports_layout_helper.dart';
import 'package:billing_system/features/reports/presentation/widgets/tender_breakdown_card.dart';
import 'package:billing_system/features/reports/presentation/widgets/z_report_preview_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportsWebLayout extends GetView<ReportsController> {
  const ReportsWebLayout({super.key});

  static const double maxContentWidth = 1600;
  static const double receiptPanelWidth = 360;

  /// Below this width the receipt preview panel no longer fits comfortably
  /// alongside the main content, so it moves to a full-width card instead
  /// (matching the tablet layout's behaviour).
  static const double receiptPanelBreakpoint = 1120;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: maxContentWidth),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final showSidePreview =
                  constraints.maxWidth >= receiptPanelBreakpoint;
              final actionsWidth =
                  constraints.maxWidth < 560 ? constraints.maxWidth : 480.0;

              final mainColumn = ListView(
                padding: EdgeInsets.fromLTRB(28, 22, showSidePreview ? 0 : 28, 32),
                children: [
                  ReportsDayHeaderBar(controller: controller),
                  const SizedBox(height: 20),
                  ReportDaySummaryHeader(controller: controller),
                  const SizedBox(height: 20),
                  LayoutBuilder(
                    builder: (context, innerConstraints) {
                      final stack = innerConstraints.maxWidth < 760;
                      final reconciliation =
                          buildCashReconciliationSection(context, controller);
                      final tender = TenderBreakdownCard(controller: controller);

                      if (stack) {
                        return Column(
                          children: [
                            reconciliation,
                            const SizedBox(height: 20),
                            tender,
                          ],
                        );
                      }

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 3, child: reconciliation),
                          const SizedBox(width: 20),
                          Expanded(flex: 2, child: tender),
                        ],
                      );
                    },
                  ),
                  if (!showSidePreview) ...[
                    const SizedBox(height: 20),
                    SizedBox(height: 760, child: const ZReportPreviewCard()),
                  ],
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: actionsWidth,
                      child: buildReportActionButtonsSection(context, controller),
                    ),
                  ),
                ],
              );

              if (!showSidePreview) {
                return mainColumn;
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: mainColumn),
                  const SizedBox(width: 24),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 22, 28, 32),
                    child: SizedBox(
                      width: receiptPanelWidth,
                      height: 760,
                      child: const ZReportPreviewCard(),
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