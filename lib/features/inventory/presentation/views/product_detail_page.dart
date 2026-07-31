// import 'package:billing_system/core/config/theme/app_colors.dart';
// import 'package:billing_system/core/config/theme/app_radius.dart';
// import 'package:billing_system/features/inventory/domain/entities/product_entity.dart';
// import 'package:billing_system/features/inventory/presentation/controller/inventory_controller.dart';
// import 'package:billing_system/features/inventory/presentation/widgets/product_details_content.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class ProductDetailPage extends StatelessWidget {
//   final ProductEntity product;

//   const ProductDetailPage({super.key, required this.product});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<InventoryController>();

//     return Obx(() {
//       final current =
//           controller.products.firstWhereOrNull((p) => p.id == product.id) ??
//           product;

//       return Scaffold(
//         backgroundColor: AppColors.background,
//         appBar: AppBar(
//           backgroundColor: AppColors.surface,
//           elevation: 0,
//           scrolledUnderElevation: 1,
//           surfaceTintColor: AppColors.surface,
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back_ios_new, size: 18),
//             onPressed: () => Get.back(),
//           ),
//           title: Text(
//             'Product Details',
//             style: Theme.of(context).textTheme.titleMedium,
//           ),
//           actions: [
//             PopupMenuButton<String>(
//               onSelected: (v) {
//                 if (v == 'delete') {
//                   controller.deleteProduct(current.id);
//                   Get.back();
//                 }
//               },
//               itemBuilder: (_) => const [
//                 PopupMenuItem(value: 'edit', child: Text('Edit')),
//                 PopupMenuItem(value: 'delete', child: Text('Delete')),
//               ],
//               icon: const Icon(Icons.more_vert_rounded),
//             ),
//             const SizedBox(width: 8),
//           ],
//         ),
//         body: SafeArea(
//           child: ListView(
//             padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(AppRadius.md),
//                   border: Border.all(color: Colors.grey.shade200),
//                 ),
//                 child: ProductDetailContent(product: current),
//               ),
//             ],
//           ),
//         ),
//       );
//     });
//   }
// }