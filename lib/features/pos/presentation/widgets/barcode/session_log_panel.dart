import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/features/pos/data/models/product_model.dart';
import 'package:billing_system/features/pos/data/models/scan_entry.dart';
import 'package:billing_system/features/pos/presentation/controller/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SessionLogPanel extends StatelessWidget {
  final RxList<ScanEntry> sessionLog;
  final VoidCallback onDone;

  const SessionLogPanel({
    super.key,
    required this.sessionLog,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF111318),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 10),
            child: Row(
              children: [
                const Text(
                  'Scanned this session',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Obx(
                  () => _CartBadge(
                    count: cart.cartItems.fold(0, (s, i) => s + i.quantity),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: onDone,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (sessionLog.isEmpty) return const _EmptyLog();
              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                itemCount: sessionLog.length,
                separatorBuilder: (_, __) => Divider(
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.06),
                ),
                itemBuilder: (_, i) => _SessionLogTile(entry: sessionLog[i]),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _SessionLogTile extends StatelessWidget {
  final ScanEntry entry;

  const _SessionLogTile({required this.entry});

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();
    final timeStr =
        '${entry.time.hour.toString().padLeft(2, '0')}:'
        '${entry.time.minute.toString().padLeft(2, '0')}';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color:
                  (entry.success ? Colors.green.shade600 : Colors.red.shade600)
                      .withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              entry.success ? Icons.check_rounded : Icons.close_rounded,
              size: 17,
              color: entry.success
                  ? Colors.green.shade400
                  : Colors.red.shade400,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.productName ?? 'Unknown product',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: entry.success ? Colors.white : Colors.white54,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  entry.barcode,
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 11,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (entry.success && entry.productId != null)
            Obx(() {
              final qty = cart.cartQty(entry.productId!);
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _QtyBtn(
                    icon: Icons.remove,
                    onTap: () => cart.removeFromCart(entry.productId!),
                  ),
                  SizedBox(
                    width: 28,
                    child: Text(
                      '$qty',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  _QtyBtn(
                    icon: Icons.add,
                    onTap: () {
                      final product = cart.inventoryProducts.firstWhereOrNull(
                        (p) => p.id == entry.productId,
                      );
                      if (product != null) {
                        cart.addToCart(
                          ProductModel(
                            id: product.id,
                            name: product.name,
                            category: product.category,
                            price: product.price,
                            stock: product.stock,
                            imageUrl: product.imageUrl,
                            barcode: product.barcode,
                            sku: product.sku,
                          ),
                        );
                      }
                    },
                  ),
                ],
              );
            })
          else
            Text(
              timeStr,
              style: const TextStyle(color: Colors.white30, fontSize: 11.5),
            ),
        ],
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 14, color: Colors.white54),
      ),
    );
  }
}

class _CartBadge extends StatelessWidget {
  final int count;
  const _CartBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    if (count == 0) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$count in cart',
        style: const TextStyle(
          color: Colors.white54,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _EmptyLog extends StatelessWidget {
  const _EmptyLog();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.qr_code_2_rounded, size: 36, color: Colors.white12),
          const SizedBox(height: 10),
          const Text(
            'No scans yet',
            style: TextStyle(
              color: Colors.white30,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Scanned items will appear here',
            style: TextStyle(color: Colors.white24, fontSize: 11.5),
          ),
        ],
      ),
    );
  }
}
