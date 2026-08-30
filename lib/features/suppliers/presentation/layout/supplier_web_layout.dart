import 'package:billing_system/features/suppliers/presentation/controller/suppliers_controller.dart';
import 'package:billing_system/features/suppliers/presentation/widgets/add_supplier_button.dart';
import 'package:billing_system/features/suppliers/presentation/widgets/due_payment_card.dart';
import 'package:billing_system/features/suppliers/presentation/widgets/supplier_search_bar.dart';
import 'package:billing_system/features/suppliers/presentation/widgets/supplier_stats_card.dart';
import 'package:billing_system/features/suppliers/presentation/widgets/supplier_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SupplierWebLayout extends GetView<SuppliersController> {
  const SupplierWebLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children:[Row(
                children: [
                  Expanded(
                    child: SupplierSearchBar(
                      onSearchChanged: (_) {},
                      onFilterTap: () {},
                    ),
                  ),
                  const SizedBox(width: 16),
                  AddSupplierButton(onPressed: () {}, expand: false,compact: false),
                ],
              ),
              const SizedBox(height: 24),
              SupplierStatsCard(
                totalSuppliers: 24,
                activeSuppliers: 18,
                totalPurchases: '₹3,45,670',
                totalDue: '₹42,560',
                suppliersWithDue: 8,
              ),
              const SizedBox(height: 28),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'All Suppliers',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1A1C1E),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 340,
                              child: SupplierTabBar(onChanged: (_) {}),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        //  SupplierListCard(suppliers: kMockSuppliers),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 2,
                    child: Obx(() {
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
                  ),
                ],
              ),]
    );
  }
}
