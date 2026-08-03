// import 'package:billing_system/features/inventory/presentation/views/product_details/dummy_product_detail.dart';
// import 'package:billing_system/features/inventory/presentation/views/product_details/dummy_stock_transaction.dart';
// import 'package:get/get.dart';



// class ProductDetailController extends GetxController {
//   final Rx<DummyProductDetail> product;
//   final RxList<DummyStockTransaction> transactions =
//       <DummyStockTransaction>[].obs;
//   final RxInt filterIndex = 0.obs;

//   ProductDetailController({required DummyProductDetail initialProduct})
//     : product = initialProduct.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     transactions.assignAll(DummyStockTransaction.sampleList());
//   }

//   List<DummyStockTransaction> get filteredTransactions {
//     switch (filterIndex.value) {
//       case 1:
//         return transactions
//             .where((t) => t.type == StockMovementType.inward)
//             .toList();
//       case 2:
//         return transactions
//             .where((t) => t.type == StockMovementType.outward)
//             .toList();
//       case 3:
//         return transactions
//             .where((t) => t.type == StockMovementType.adjustment)
//             .toList();
//       default:
//         return transactions;
//     }
//   }

//   void setFilter(int index) => filterIndex.value = index;

//   void updateProduct(DummyProductDetail updated) => product.value = updated;

//   void addStock({
//     required StockMovementType type,
//     required String subtype,
//     required int quantity,
//     required String reference,
//     double? purchasePrice,
//     String? note,
//   }) {
//     final delta = type == StockMovementType.outward ? -quantity : quantity;
//     final current = product.value;

//     product.value = current.copyWith(
//       currentStock: current.currentStock + delta,
//       purchasePrice: purchasePrice ?? current.purchasePrice,
//     );

//     transactions.insert(
//       0,
//       DummyStockTransaction(
//         id: 'txn_${DateTime.now().microsecondsSinceEpoch}',
//         type: type,
//         subtype: subtype,
//         quantity: quantity,
//         reference: reference,
//         dateTime: DateTime.now(),
//         note: note,
//       ),
//     );
//   }

//   void deleteProduct() {
//     Get.back();
//     Get.back();
//   }
// }