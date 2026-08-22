import 'package:billing_system/features/suppliers/presentation/widgets/add_supplier_button.dart';
import 'package:billing_system/features/suppliers/presentation/widgets/due_payment_card.dart';
import 'package:billing_system/features/suppliers/presentation/widgets/supplier_dummy_data.dart';
import 'package:billing_system/features/suppliers/presentation/widgets/supplier_list_card.dart';
import 'package:billing_system/features/suppliers/presentation/widgets/supplier_search_bar.dart';
import 'package:billing_system/features/suppliers/presentation/widgets/supplier_stats_card.dart';
import 'package:billing_system/features/suppliers/presentation/widgets/supplier_tab_bar.dart';

import 'package:flutter/material.dart';

class SupplierMobileLayout extends StatelessWidget {
  const SupplierMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        children: [
          SupplierSearchBar(onSearchChanged: (_) {}, onFilterTap: () {}),
          const SizedBox(height: 16),
          SupplierStatsCard(
            totalSuppliers: 24,
            activeSuppliers: 18,
            totalPurchases: '₹3,45,670',
            totalDue: '₹42,560',
            suppliersWithDue: 8,
          ),
          const SizedBox(height: 16),
          DuePaymentsCard(payments: kMockDuePayments, onViewAll: () {}),
          const SizedBox(height: 16),
          SupplierTabBar(onChanged: (_) {}),
          const SizedBox(height: 16),
          SupplierListCard(suppliers: kMockSuppliers),
          const SizedBox(height: 20),
          AddSupplierButton(onPressed: () {}),
        ],
      ),
    );
  }
}