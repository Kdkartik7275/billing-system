import 'package:billing_system/core/extensions/stock_transactions_type_x.dart';
import 'package:billing_system/features/inventory/domain/entity/stock_transactions_entity.dart';
import 'package:billing_system/features/inventory/presentation/widgets/product_details/sheet_field.dart';
import 'package:billing_system/features/inventory/presentation/widgets/product_details/type_badge.dart';
import 'package:flutter/material.dart';

class AddMovementSheet extends StatelessWidget {
  final StockTransactionType type;
  final String productId;
  final int currentStock;
  final void Function(
    StockTransaction transaction,
    double? purchasePrice,
    double? sellingPrice,
  )
  onSave;

  const AddMovementSheet({
    super.key,
    required this.type,
    required this.productId,
    required this.currentStock,
    required this.onSave,
  });

  bool get _isPurchase => type == StockTransactionType.purchase;

  @override
  Widget build(BuildContext context) {
    final qtyCtrl = TextEditingController();
    final noteCtrl = TextEditingController();
    final purchasePriceCtrl = TextEditingController();
    final sellingPriceCtrl = TextEditingController();

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                TypeBadge(type: type),
                const SizedBox(width: 10),
                Text(
                  type.sheetTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SheetField(
              controller: qtyCtrl,
              label: 'Quantity',
              hint: '0',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            // Conditional fields for purchase type
            if (_isPurchase) ...[
              SheetField(
                controller: purchasePriceCtrl,
                label: 'Purchase Price (per unit)',
                hint: '0.00',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              SheetField(
                controller: sellingPriceCtrl,
                label: 'Selling Price (per unit)',
                hint: '0.00',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
            ],
            SheetField(
              controller: noteCtrl,
              label: 'Note / Reference',
              hint: 'e.g. PO number, invoice ref…',
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: type.color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  final qty = int.tryParse(qtyCtrl.text) ?? 0;
                  if (qty == 0) return;

                  final signed = type.isIncoming ? qty.abs() : -qty.abs();

                  // Build notes with price info if purchase type
                  String? notes = noteCtrl.text.trim();
                  if (_isPurchase) {
                    final purchasePrice = purchasePriceCtrl.text.trim();
                    final sellingPrice = sellingPriceCtrl.text.trim();

                    final priceNotes = [
                      if (purchasePrice.isNotEmpty) 'Purchase: $purchasePrice',
                      if (sellingPrice.isNotEmpty) 'Selling: $sellingPrice',
                      if (notes.isNotEmpty) notes,
                    ].join(' | ');

                    notes = priceNotes.isEmpty ? null : priceNotes;
                  } else {
                    notes = notes.isEmpty ? null : notes;
                  }

                  onSave(
                    StockTransaction(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      productId: productId,
                      type: type,
                      previousStock: currentStock,
                      quantityChanged: signed,
                      newStock: currentStock + signed,
                      notes: notes,
                      createdAt: DateTime.now(),
                    ),
                    _isPurchase ? double.tryParse(purchasePriceCtrl.text) : null,
                    _isPurchase ? double.tryParse(sellingPriceCtrl.text) : null,
                  );
                  Navigator.pop(context);
                },
                child: const Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
