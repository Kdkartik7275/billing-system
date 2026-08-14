import 'package:billing_system/features/suppliers/presentation/widgets/add_supplier_button.dart';
import 'package:billing_system/features/suppliers/presentation/widgets/due_payment_card.dart';
import 'package:billing_system/features/suppliers/presentation/widgets/supplier_dummy_data.dart';
import 'package:billing_system/features/suppliers/presentation/widgets/supplier_list_card.dart';
import 'package:billing_system/features/suppliers/presentation/widgets/supplier_search_bar.dart';
import 'package:billing_system/features/suppliers/presentation/widgets/supplier_stats_card.dart';
import 'package:billing_system/features/suppliers/presentation/widgets/supplier_tab_bar.dart';
import 'package:flutter/material.dart';

class SupplierTabletLayout extends StatelessWidget {
  const SupplierTabletLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(32, 28, 32, 40),

          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Column(
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
                            SupplierListCard(suppliers: kMockSuppliers),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 2,
                        child: DuePaymentsCard(
                          payments: kMockDuePayments,
                          onViewAll: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
