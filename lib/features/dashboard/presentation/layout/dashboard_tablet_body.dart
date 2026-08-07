import 'package:billing_system/features/dashboard/presentation/models/dashboard_card_model.dart';
import 'package:billing_system/features/dashboard/presentation/widgets/chart_card.dart';
import 'package:billing_system/core/config/theme/app_radius.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabletDashboardBody extends StatelessWidget {
  const TabletDashboardBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // padding: const EdgeInsets.symmetric(horizontal: 12),
      // child: Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     Obx(() {
      //       final cards = [
      //         DashboardCardModel(
      //           title: "Today's Sales",
      //           value: "₹${0}",
      //           growth: "${0} orders today",
      //           icon: Icons.attach_money,
      //           iconColor: Colors.green,
      //         ),
      //         DashboardCardModel(
      //           title: "Total Orders",
      //           value: "${0}",
      //           growth: "bills today",
      //           icon: Icons.shopping_cart_outlined,
      //           iconColor: Colors.blue,
      //         ),
      //         DashboardCardModel(
      //           title: "Revenue",
      //           value: "₹${0}",
      //           growth: "excl. tax",
      //           icon: Icons.show_chart,
      //           iconColor: Colors.deepPurple,
      //         ),
      //         DashboardCardModel(
      //           title: "Pending Sync",
      //           value: "${0}",
      //           growth:  "No pending bills"
      //               ,
      //           icon: Icons.pending_actions_outlined,
      //           iconColor: Colors.orange,
      //         ),
      //       ];
      //       return LayoutBuilder(
      //         builder: (context, constraints) {
      //           final cardWidth = (constraints.maxWidth - 10) / 2;
      //           final cardHeight = cardWidth * 0.38;
      //           return GridView.count(
      //             crossAxisCount: 2,
      //             shrinkWrap: true,
      //             physics: const NeverScrollableScrollPhysics(),
      //             crossAxisSpacing: 10,
      //             mainAxisSpacing: 10,
      //             childAspectRatio: cardWidth / cardHeight,
      //             children: cards
      //                 .map((c) => _TabletSummaryCard(data: c))
      //                 .toList(),
      //           );
      //         },
      //       );
      //     }),
      //     const SizedBox(height: 12),
      //     // const SalesLineChart(height: 260),
      //     // const SizedBox(height: 12),
      //     LayoutBuilder(
      //       builder: (context, constraints) {
      //         if (constraints.maxWidth >= 480) {
      //           return Row(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //             //  const Expanded(child: CategoryPieChart(height: 300)),
      //               const SizedBox(width: 10),
      //               Expanded(child: _TabletTransactions()),
      //             ],
      //           );
      //         }
      //         return Column(
      //           children: [
      //            // const CategoryPieChart(height: 280),
      //             const SizedBox(height: 12),
      //             _TabletTransactions(),
      //           ],
      //         );
      //       },
      //     ),
      //     const SizedBox(height: 24),
      //     // const LowStockAlerts(),
      //     // const SizedBox(height: 12),
      //   ],
      // ),
    );
  }
}

class _TabletSummaryCard extends StatelessWidget {
  const _TabletSummaryCard({required this.data});
  final DashboardCardModel data;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return ChartCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  data.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: tt.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  data.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: tt.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data.growth,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: tt.bodySmall?.copyWith(
                    color: Colors.green,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: data.iconColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(data.icon, color: data.iconColor, size: 22),
          ),
        ],
      ),
    );
  }
}

class _TabletTransactions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Transactions',
                  style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                Obx(
                  () => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6C63FF).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${0} today',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6C63FF),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Obx(() {
          //   final todayBills = controller.todayBills.take(5).toList();
          //   if (todayBills.isEmpty) {
          //     return Padding(
          //       padding: const EdgeInsets.symmetric(vertical: 24),
          //       child: Center(
          //         child: Text(
          //           'No transactions today',
          //           style: tt.bodyMedium?.copyWith(color: Colors.grey.shade500),
          //         ),
          //       ),
          //     );
          //   }
          //   return Column(
          //     children: todayBills.map((tx) => _TxRow(tx: tx)).toList(),
          //   );
          // }),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

// class _TxRow extends StatelessWidget {
//   const _TxRow({required this.tx});
//   final BillEntity tx;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const Divider(height: 1, color: Color(0xFFF0F0F0)),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
//           child: Row(
//             children: [
//               Container(
//                 height: 32,
//                 width: 32,
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade100,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Icon(
//                   Icons.receipt_outlined,
//                   size: 15,
//                   color: Colors.grey.shade500,
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       tx.receiptNumber,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.black,
//                       ),
//                     ),
//                     Text(
//                       tx.createdAt.toString().substring(0, 16),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                         fontSize: 11,
//                         color: Colors.grey.shade800,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Text(
//                     (tx.subtotal + tx.taxAmount).toStringAsFixed(2),
//                     style: const TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w700,
//                       color: Color(0xFF1A1A2E),
//                     ),
//                   ),
//                   const SizedBox(height: 3),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 7,
//                       vertical: 2,
//                     ),
//                     decoration: BoxDecoration(
//                       color: tx.status == BillStatus.completed
//                           ? const Color(0xFF22C55E).withValues(alpha: 0.12)
//                           : const Color(0xFFEF4444).withValues(alpha: 0.12),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Text(
//                       tx.status == BillStatus.completed ? 'Done' : 'Pending',
//                       style: TextStyle(
//                         fontSize: 9,
//                         fontWeight: FontWeight.w600,
//                         color: tx.status == BillStatus.completed
//                             ? const Color(0xFF16A34A)
//                             : const Color(0xFFDC2626),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
