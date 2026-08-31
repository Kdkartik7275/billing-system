import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BillingProductCard extends StatefulWidget {
  final String imageUrl;
  final String name;
  final String sku;
  final int stock;
  final double price;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  /// Called when the user types a new quantity directly into the field.
  /// You're responsible for clamping/validating (e.g. against [stock])
  /// and updating whatever state drives [quantity].
  final ValueChanged<int> onQuantityChanged;

  const BillingProductCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.sku,
    required this.stock,
    required this.price,
    required this.quantity,
    required this.onAdd,
    required this.onIncrement,
    required this.onDecrement,
    required this.onQuantityChanged,
  });

  @override
  State<BillingProductCard> createState() => _BillingProductCardState();
}

class _BillingProductCardState extends State<BillingProductCard> {
  late final TextEditingController _qtyController;
  late final FocusNode _qtyFocusNode;

  @override
  void initState() {
    super.initState();
    _qtyController = TextEditingController(text: widget.quantity.toString());
    _qtyFocusNode = FocusNode();
    _qtyFocusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(covariant BillingProductCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!_qtyFocusNode.hasFocus &&
        widget.quantity.toString() != _qtyController.text) {
      _qtyController.text = widget.quantity.toString();
    }
  }

  void _onFocusChange() {
    if (!_qtyFocusNode.hasFocus) {
      _commitQuantity();
    } else {
      _qtyController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _qtyController.text.length,
      );
    }
  }

  void _handleLiveChange(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return;

    final parsed = int.tryParse(trimmed);
    if (parsed == null) return;

    if (parsed == 0) return;

    final clamped = parsed.clamp(0, widget.stock);
    if (clamped != widget.quantity) {
      widget.onQuantityChanged(clamped);
    }
  }

  void _commitQuantity() {
    final raw = _qtyController.text.trim();

    int parsed = raw.isEmpty ? 0 : (int.tryParse(raw) ?? widget.quantity);

    if (parsed < 0) parsed = 0;
    if (parsed > widget.stock) parsed = widget.stock;

    _qtyController.text = parsed.toString();

    if (parsed != widget.quantity) {
      widget.onQuantityChanged(parsed);
    }
  }

  @override
  void dispose() {
    _qtyFocusNode.removeListener(_onFocusChange);
    _qtyFocusNode.dispose();
    _qtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------- IMAGE ----------------
            Expanded(
              flex: 3,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 130),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: widget.imageUrl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    memCacheWidth: 300,
                    placeholder: (context, url) {
                      return const Center(child: CircularProgressIndicator());
                    },

                    errorWidget: (context, url, error) {
                      return Center(
                        child: Icon(
                          Icons.broken_image_outlined,
                          color: Colors.grey.shade500,
                          size: 40,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // ---------------- NAME / SKU ----------------
            Text(
              widget.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),

            const SizedBox(height: 2),

            Text(
              "SKU: ${widget.sku}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.bodySmall?.copyWith(color: Colors.grey.shade500),
            ),

            const SizedBox(height: 6),

            // ---------------- STOCK CHIP ----------------
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xffEAF8ED),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "In Stock: ${widget.stock}",
                style: theme.bodySmall?.copyWith(
                  color: const Color(0xff2E7D32),
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // ---------------- PRICE / CART ACTION ----------------
            Row(
              children: [
                Expanded(
                  child: Text(
                    "₹${widget.price.toStringAsFixed(2)}",
                    overflow: TextOverflow.ellipsis,
                    style: theme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                (widget.quantity == 0 && !_qtyFocusNode.hasFocus)
                    ? InkWell(
                        onTap: widget.onAdd,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          height: 32,
                          width: 32,
                          decoration: BoxDecoration(
                            color: const Color(0xff2962FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      )
                    : Container(
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xff2962FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: widget.onDecrement,
                              borderRadius: BorderRadius.circular(12),
                              child: const SizedBox(
                                width: 28,
                                child: Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 34,
                              child: TextField(
                                controller: _qtyController,
                                focusNode: _qtyFocusNode,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                style: theme.bodySmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                                cursorColor: Colors.white,
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                ),
                                onChanged: _handleLiveChange,
                                onSubmitted: (_) => _commitQuantity(),
                                onTapOutside: (_) => _qtyFocusNode.unfocus(),
                              ),
                            ),
                            InkWell(
                              onTap: widget.onIncrement,
                              borderRadius: BorderRadius.circular(12),
                              child: const SizedBox(
                                width: 28,
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
            ),
          ],
        ),
      ),
    );
  }
}
