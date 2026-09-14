import 'package:billing_system/features/reports/presentation/widgets/report_colors.dart';
import 'package:flutter/material.dart';

class ReportCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final double borderRadius;

  const ReportCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color = ReportColors.card,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: ReportColors.border),
      ),
      padding: padding,
      child: child,
    );
  }
}