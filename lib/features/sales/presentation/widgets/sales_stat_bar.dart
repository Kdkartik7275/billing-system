import 'package:billing_system/features/sales/presentation/controller/sales_controller.dart';
import 'package:billing_system/features/sales/presentation/widgets/sales_stat_items.dart';
import 'package:flutter/material.dart';

class SalesStatsBar extends StatelessWidget {
  final SalesController controller;

  const SalesStatsBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 16,
            spreadRadius: 2,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: SalesStatItem(
              icon: Icons.description_outlined,
              iconBg: const Color(0xffE3DDFF),
              iconColor: const Color(0xff6C63FF),
              label: 'Total Sales',
              value: '₹${controller.totalSales.toStringAsFixed(0)}',
            ),
          ),
          Container(width: 1, height: 36, color: Colors.grey.shade300),
          Expanded(
            child: SalesStatItem(
              icon: Icons.receipt_long_outlined,
              iconBg: const Color(0xffDBF3E4),
              iconColor: const Color(0xff12B76A),
              label: 'Total Bills',
              value: '${controller.totalBills}',
            ),
          ),
          Container(width: 1, height: 36, color: Colors.grey.shade300),
          Expanded(
            child: SalesStatItem(
              icon: Icons.shopping_bag_outlined,
              iconBg: const Color(0xffDCEBFF),
              iconColor: const Color(0xff1565C0),
              label: 'Total Items',
              value: '${controller.totalItems}',
            ),
          ),
        ],
      ),
    );
  }
}
