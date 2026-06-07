import 'package:billing_system/features/pos/data/models/cart_item_model.dart';


class PaymentResult {
  final List<CartItem> items;
  final double subtotal;
  final double tax;
  final double grandTotal;
  final PaymentMethod method;
  final double amountTendered;
  final double change;
  final DateTime paidAt;
  final String receiptNumber;

  PaymentResult({
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.grandTotal,
    required this.method,
    required this.amountTendered,
    required this.change,
    required this.paidAt,
    required this.receiptNumber,
  });
}

enum PaymentMethod { cash, card }

extension PaymentMethodLabel on PaymentMethod {
  String get label => switch (this) {
        PaymentMethod.cash => 'Cash',
        PaymentMethod.card => 'Card / UPI',
      };
}