import 'bill_item_entity.dart';

enum BillStatus { completed, refunded, voided }

enum BillPaymentMethod { cash, card }

class BillEntity {
  final String id;
  final String receiptNumber;
  final DateTime createdAt;

  final String? customerName;
  final String? customerPhone;

  final List<BillItemEntity> items;

  final double subtotal;
  final double taxRate;
  final double taxAmount;
  final double grandTotal;

  final BillPaymentMethod paymentMethod;
  final double amountTendered;
  final double changeGiven;

  final BillStatus status;
  final String? createdBy;
  final bool isOfflineCreated;

  const BillEntity({
    required this.id,
    required this.receiptNumber,
    required this.createdAt,
    this.customerName,
    this.customerPhone,
    required this.items,
    required this.subtotal,
    required this.taxRate,
    required this.taxAmount,
    required this.grandTotal,
    required this.paymentMethod,
    required this.amountTendered,
    required this.changeGiven,
    required this.status,
    required this.isOfflineCreated,
    this.createdBy,
  });

  BillEntity copyWith({
    String? id,
    String? receiptNumber,
    DateTime? createdAt,
    String? customerName,
    String? customerPhone,
    List<BillItemEntity>? items,
    double? subtotal,
    double? taxRate,
    double? taxAmount,
    double? grandTotal,
    BillPaymentMethod? paymentMethod,
    double? amountTendered,
    double? changeGiven,
    BillStatus? status,
    String? createdBy,
    bool? isOfflineCreated,
  }) {
    return BillEntity(
      id: id ?? this.id,
      receiptNumber: receiptNumber ?? this.receiptNumber,
      createdAt: createdAt ?? this.createdAt,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      taxRate: taxRate ?? this.taxRate,
      taxAmount: taxAmount ?? this.taxAmount,
      grandTotal: grandTotal ?? this.grandTotal,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      amountTendered: amountTendered ?? this.amountTendered,
      changeGiven: changeGiven ?? this.changeGiven,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      isOfflineCreated: isOfflineCreated ?? this.isOfflineCreated,
    );
  }
}
