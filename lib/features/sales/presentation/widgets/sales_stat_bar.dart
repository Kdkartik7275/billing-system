import 'package:billing_system/features/sales/presentation/controller/sales_controller.dart';
import 'package:billing_system/features/sales/presentation/widgets/sales_stat_items.dart';
import 'package:flutter/material.dart';

class SalesStatsBar extends StatelessWidget {
  final SalesController controller;

  final bool vertical;

  const SalesStatsBar({
    super.key,
    required this.controller,
    this.vertical = false,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      SalesStatItem(
        icon: Icons.description_outlined,
        iconBg: const Color(0xffE3DDFF),
        iconColor: const Color(0xff6C63FF),
        label: 'Total Sales',
        value: _compactCurrency(controller.totalSales),
      ),
      SalesStatItem(
        icon: Icons.receipt_long_outlined,
        iconBg: const Color(0xffDBF3E4),
        iconColor: const Color(0xff12B76A),
        label: 'Total Bills',
        value: '${controller.totalBills}',
      ),
      SalesStatItem(
        icon: Icons.shopping_bag_outlined,
        iconBg: const Color(0xffDCEBFF),
        iconColor: const Color(0xff1565C0),
        label: 'Total Items',
        value: '${controller.totalItems}',
      ),
    ];

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: vertical ? 16 : 14,
        vertical: vertical ? 16 : 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: vertical
          ? Column(
              children: [
                for (var i = 0; i < items.length; i++) ...[
                  Align(alignment: Alignment.centerLeft, child: items[i]),
                  if (i != items.length - 1) ...[
                    const SizedBox(height: 14),
                    Divider(height: 1, color: Colors.grey.shade200),
                    const SizedBox(height: 14),
                  ],
                ],
              ],
            )
          : Row(
              children: [
                for (var i = 0; i < items.length; i++) ...[
                  Expanded(child: items[i]),
                  if (i != items.length - 1)
                    Container(
                      width: 1,
                      height: 32,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      color: Colors.grey.shade200,
                    ),
                ],
              ],
            ),
    );
  }

  String _compactCurrency(double value) {
    if (value >= 10000000) {
      return '₹${(value / 10000000).toStringAsFixed(1)}Cr';
    }
    if (value >= 100000) {
      return '₹${(value / 100000).toStringAsFixed(1)}L';
    }
    if (value >= 1000) {
      return '₹${(value / 1000).toStringAsFixed(1)}K';
    }
    return '₹${value.toStringAsFixed(0)}';
  }
}
