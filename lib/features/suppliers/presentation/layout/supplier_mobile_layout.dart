import 'package:billing_system/features/suppliers/presentation/controller/suppliers_controller.dart';
import 'package:billing_system/features/suppliers/presentation/widgets/add_new_supplier_dialog.dart';
import 'package:billing_system/features/suppliers/presentation/widgets/add_supplier_button.dart';
import 'package:billing_system/features/suppliers/presentation/widgets/due_payment_card.dart';
import 'package:billing_system/features/suppliers/presentation/widgets/due_payment_dialog.dart';
import 'package:billing_system/features/suppliers/presentation/widgets/supplier_list_card.dart';
import 'package:billing_system/features/suppliers/presentation/widgets/supplier_search_bar.dart';
import 'package:billing_system/features/suppliers/presentation/widgets/supplier_stats_card.dart';
import 'package:billing_system/features/suppliers/presentation/widgets/supplier_tab_bar.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SupplierMobileLayout extends GetView<SuppliersController> {
  const SupplierMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: SupplierSearchBar(
                  onSearchChanged: controller.updateSearch,
                  onFilterTap: () {},
                ),
              ),
              const SizedBox(width: 10),
              AddSupplierButton(
                expand: false,
                compact: true,
                onPressed: () => showAddSupplierDialog(context),
              ),
            ],
          ),
          const SizedBox(height: 16),

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

          const SizedBox(height: 16),

          Obx(() {
            final payments = controller.duePayments.take(3).toList();

            if (payments.isEmpty) {
              return const SizedBox.shrink();
            }

            return DuePaymentsCard(
              payments: payments,
              onViewAll: () {},
              onTapPayment: (payment) => showDuePaymentDetailDialog(context, payment: payment),
            );
          }),

          const SizedBox(height: 16),

          SupplierTabBar(onChanged: controller.selectTab),

          const SizedBox(height: 16),

          Obx(() => SupplierListCard(suppliers: controller.supplierListItems)),
        ],
      ),
    );
  }
}
