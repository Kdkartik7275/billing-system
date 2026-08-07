import 'package:billing_system/features/inventory/domain/entities/product_entity.dart';
import 'package:billing_system/features/inventory/presentation/controller/inventory_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannedLineItem {
  final ProductEntity product;
  int count;

  ScannedLineItem({required this.product, required this.count});
}

class BillingMultiScanPage extends StatefulWidget {
  final InventoryController inventoryController;

  const BillingMultiScanPage({super.key, required this.inventoryController});

  @override
  State<BillingMultiScanPage> createState() => _BillingMultiScanPageState();
}

class _BillingMultiScanPageState extends State<BillingMultiScanPage> {
  final MobileScannerController _controller = MobileScannerController();

  final RxMap<String, ScannedLineItem> scannedItems =
      <String, ScannedLineItem>{}.obs;
  final RxString lastMessage = ''.obs;
  final RxBool lastMessageIsError = false.obs;

  String? _lastCode;
  DateTime? _lastScanTime;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ---------------- SCAN HANDLER ----------------

  void _onDetect(BarcodeCapture capture) {
    final code = capture.barcodes.firstOrNull?.rawValue;
    if (code == null || code.isEmpty) return;

    // ---------------- DEBOUNCE DUPLICATE SCANS ----------------
    final now = DateTime.now();
    if (_lastCode == code &&
        _lastScanTime != null &&
        now.difference(_lastScanTime!) < const Duration(seconds: 2)) {
      return;
    }
    _lastCode = code;
    _lastScanTime = now;

    final product = widget.inventoryController.products.firstWhereOrNull(
      (p) => p.barcode == code,
    );

    if (product == null) {
      HapticFeedback.heavyImpact();
      _setMessage('No product found for "$code"', isError: true);
      return;
    }

    final stock = widget.inventoryController
        .stockQuantityFor(product.id)
        .toInt();
    final alreadyScanned = scannedItems[product.id]?.count ?? 0;

    if (alreadyScanned + 1 > stock) {
      HapticFeedback.heavyImpact();
      _setMessage('${product.name} is out of stock', isError: true);
      return;
    }

    final existing = scannedItems[product.id];
    if (existing != null) {
      existing.count++;
    } else {
      scannedItems[product.id] = ScannedLineItem(product: product, count: 1);
    }
    scannedItems.refresh();

    HapticFeedback.mediumImpact();
    _setMessage('${product.name} added', isError: false);
  }

  void _setMessage(String message, {required bool isError}) {
    lastMessage.value = message;
    lastMessageIsError.value = isError;
  }

  // ---------------- LINE ACTIONS ----------------

  void _increment(String productId) {
    final item = scannedItems[productId];
    if (item == null) return;
    final stock = widget.inventoryController
        .stockQuantityFor(productId)
        .toInt();
    if (item.count + 1 > stock) return;
    item.count++;
    scannedItems.refresh();
  }

  void _decrement(String productId) {
    final item = scannedItems[productId];
    if (item == null) return;
    if (item.count <= 1) {
      scannedItems.remove(productId);
    } else {
      item.count--;
      scannedItems.refresh();
    }
  }

  // ---------------- DONE ----------------

  void _complete() {
    Navigator.of(context).pop(scannedItems.values.toList());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text("Scan Products"),
        actions: [
          IconButton(
            onPressed: () => _controller.toggleTorch(),
            icon: const Icon(Icons.flash_on_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          // ---------------- CAMERA + VIEWFINDER ----------------
          Expanded(
            flex: 3,
            child: Stack(
              fit: StackFit.expand,
              children: [
                MobileScanner(controller: _controller, onDetect: _onDetect),

                Center(
                  child: Container(
                    height: 140,
                    width: 300,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),

                // ---------------- SCAN FEEDBACK TOAST ----------------
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Obx(() {
                    if (lastMessage.value.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: lastMessageIsError.value
                            ? const Color(0xffD32F2F)
                            : const Color(0xff2E7D32),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            lastMessageIsError.value
                                ? Icons.error_outline_rounded
                                : Icons.check_circle_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              lastMessage.value,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),

          // ---------------- SCANNED ITEMS LIST ----------------
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    height: 4,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Text(
                          "Scanned Items",
                          style: theme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        Obx(
                          () => Text(
                            "${scannedItems.values.fold<int>(0, (sum, e) => sum + e.count)} items",
                            style: theme.bodySmall?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  Expanded(
                    child: Obx(() {
                      final items = scannedItems.values.toList();

                      if (items.isEmpty) {
                        return Center(
                          child: Text(
                            "Scan a barcode to add items",
                            style: theme.bodyMedium?.copyWith(
                              color: Colors.grey.shade500,
                            ),
                          ),
                        );
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: items.length,
                        separatorBuilder: (_, _) => const Divider(height: 20),
                        itemBuilder: (_, index) {
                          final item = items[index];

                          return Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.product.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      "SKU: ${item.product.sku}",
                                      style: theme.bodySmall?.copyWith(
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 30,
                                decoration: BoxDecoration(
                                  color: const Color(0xff2962FF),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      onTap: () => _decrement(item.product.id),
                                      borderRadius: BorderRadius.circular(10),
                                      child: const SizedBox(
                                        width: 30,
                                        child: Icon(
                                          Icons.remove,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 24,
                                      child: Text(
                                        "${item.count}",
                                        textAlign: TextAlign.center,
                                        style: theme.bodyMedium?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () => _increment(item.product.id),
                                      borderRadius: BorderRadius.circular(10),
                                      child: const SizedBox(
                                        width: 30,
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }),
                  ),

                  // ---------------- DONE BUTTON ----------------
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      child: Obx(
                        () => ElevatedButton(
                          onPressed: scannedItems.isEmpty ? null : _complete,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff2962FF),
                            disabledBackgroundColor: Colors.grey.shade300,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            scannedItems.isEmpty
                                ? "Done"
                                : "Done  •  Add ${scannedItems.values.fold<int>(0, (sum, e) => sum + e.count)} items",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
