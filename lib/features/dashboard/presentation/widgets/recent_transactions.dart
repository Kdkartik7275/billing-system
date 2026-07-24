
// import 'package:billing_system/features/dashboard/presentation/widgets/chart_card.dart';
// import 'package:billing_system/features/pos/domain/entity/bill_entity.dart';
// import 'package:billing_system/features/pos/presentation/controller/bills_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class RecentTransactions extends GetView<BillsController> {
//   const RecentTransactions({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final tt = Theme.of(context).textTheme;
//     return ChartCard(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text('Recent Transactions', style: tt.titleMedium),
//               Obx(
//                 () => Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 10,
//                     vertical: 4,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.blue.withValues(alpha: 0.08),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Text(
//                     '${controller.todayOrderCount} today',
//                     style: tt.bodySmall?.copyWith(
//                       color: Colors.blue,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Obx(() {
//             final todayBills = controller.todayBills.take(5).toList();
//             return Column(
//               children: todayBills.isEmpty
//                   ? [
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         child: Text(
//                           'No transactions today',
//                           style: tt.bodyMedium?.copyWith(
//                             color: Colors.grey.shade500,
//                           ),
//                         ),
//                       ),
//                     ]
//                   : todayBills.map((tx) => _TransactionRow(tx: tx)).toList(),
//             );
//           }),
//         ],
//       ),
//     );
//   }
// }

// class _TransactionRow extends StatelessWidget {
//   const _TransactionRow({required this.tx});
//   final BillEntity tx;

//   @override
//   Widget build(BuildContext context) {
//     final tt = Theme.of(context).textTheme;
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         children: [
//           Container(
//             height: 36,
//             width: 36,
//             decoration: BoxDecoration(
//               color: Colors.grey.shade100,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Icon(
//               Icons.receipt_outlined,
//               size: 18,
//               color: Colors.grey.shade500,
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   tx.receiptNumber,
//                   style: tt.bodySmall?.copyWith(
//                     fontWeight: FontWeight.w600,
//                     color: Colors.black,
//                     fontSize: 12,
//                   ),
//                 ),
//                 Text(
//                   tx.createdAt.toString().substring(0, 16),
//                   style: tt.bodySmall?.copyWith(
//                     color: Colors.grey.shade800,
//                     fontSize: 11,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(
//                 (tx.subtotal + tx.taxAmount).toStringAsFixed(2),
//                 style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
//               ),
//               const SizedBox(height: 2),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                 decoration: BoxDecoration(
//                   color: tx.status == BillStatus.completed
//                       ? Colors.green.withValues(alpha: 0.10)
//                       : Colors.orange.withValues(alpha: 0.10),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Text(
//                   tx.status == BillStatus.completed ? 'Completed' : 'Pending',
//                   style: TextStyle(
//                     fontSize: 10,
//                     fontWeight: FontWeight.w600,
//                     color: tx.status == BillStatus.completed
//                         ? Colors.green
//                         : Colors.orange,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
