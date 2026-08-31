import 'package:billing_system/features/suppliers/presentation/controller/suppliers_controller.dart';
import 'package:billing_system/features/suppliers/presentation/widgets/add_supplier_button.dart';
import 'package:billing_system/features/suppliers/presentation/widgets/due_payment_card.dart';
import 'package:billing_system/features/suppliers/presentation/widgets/due_payment_dialog.dart';
import 'package:billing_system/features/suppliers/presentation/widgets/supplier_list_card.dart';
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
        Obx(
          () => SupplierStatsCard(
            totalSuppliers: controller.totalSuppliers,
            activeSuppliers: controller.activeSuppliers,
            totalPurchases:
                '₹${controller.totalPurchaseAmount.toStringAsFixed(2)}',
            totalDue: '₹${controller.totalDueAmount.toStringAsFixed(2)}',
            suppliersWithDue: controller.suppliersWithDueCount,
          ),
        ),
        const SizedBox(height: 20),

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
                        child: SupplierTabBar(onChanged: controller.selectTab),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Obx(
                    () => SupplierListCard(
                      suppliers: controller.supplierListItems,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() {
          final payments = controller.duePayments.take(3).toList();

          if (payments.isEmpty) {
            return const SizedBox.shrink();
          }

          return DuePaymentsCard(
            payments: payments,
            onViewAll: () {},
            onTapPayment: (payment) =>
                showDuePaymentDetailDialog(context, payment: payment),
          );
        }),
      ],
    );
  }
}
