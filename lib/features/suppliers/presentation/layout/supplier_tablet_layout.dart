import 'package:billing_system/features/suppliers/presentation/controller/suppliers_controller.dart';
import 'package:billing_system/features/suppliers/presentation/widgets/add_supplier_button.dart';
import 'package:billing_system/features/suppliers/presentation/widgets/due_payment_card.dart';
import 'package:billing_system/features/suppliers/presentation/widgets/supplier_search_bar.dart';
import 'package:billing_system/features/suppliers/presentation/widgets/supplier_stats_card.dart';
import 'package:billing_system/features/suppliers/presentation/widgets/supplier_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SupplierTabletLayout extends GetView<SuppliersController> {
  const SupplierTabletLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),

      children: [
        Row(
          children: [
            Expanded(
              child: SupplierSearchBar(
                onSearchChanged: (_) {},
                onFilterTap: () {},
              ),
            ),
            const SizedBox(width: 16),
            AddSupplierButton(onPressed: () {}, expand: false),
          ],
        ),
        const SizedBox(height: 20),
        SupplierStatsCard(
          totalSuppliers: 24,
          activeSuppliers: 18,
          totalPurchases: '₹3,45,670',
          totalDue: '₹42,560',
          suppliersWithDue: 8,
        ),
        const SizedBox(height: 20),
        // Main list and due payments sit side by side once there's
        // enough width for both to breathe.
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'All Suppliers',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1C1E),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 320,
                        child: SupplierTabBar(onChanged: (_) {}),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // SupplierListCard(suppliers: kMockSuppliers),
                ],
              ),
            ),
          ],
        ),
        Obx(() {
          final payments = controller.duePayments.take(3).toList();

          if (payments.isEmpty) {
            return const SizedBox.shrink();
          }

          return DuePaymentsCard(
            payments: payments,
            onViewAll: () {},
            onTapPayment: (payment) {},
          );
        }),
      ],
    );
  }
}
