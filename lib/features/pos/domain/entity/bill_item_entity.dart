class BillItemEntity {
  final String productId;
  final String productName;
  final String sku;
  final double unitPrice;
  final int quantity;
  final double totalPrice;

  const BillItemEntity({
    required this.productId,
    required this.productName,
    required this.sku,
    required this.unitPrice,
    required this.quantity,
    required this.totalPrice,
  });
}
