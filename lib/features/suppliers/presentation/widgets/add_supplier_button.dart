import 'package:flutter/material.dart';

class AddSupplierButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool expand;
  final bool compact;

  const AddSupplierButton({
    super.key,
    this.onPressed,
    this.expand = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1B8A4C),
        foregroundColor: Colors.white,
        elevation: 0,
        padding: compact
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: compact
          ? const Icon(Icons.add_rounded, size: 28)
          : const Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_rounded, size: 22),
                SizedBox(width: 8),
                Text(
                  'Add New Supplier',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ],
            ),
    );

    if (expand) {
      return SizedBox(width: double.infinity, height: 50, child: button);
    }
    if (compact) {
      return SizedBox(width: 54, height: 50, child: button);
    }
    return SizedBox(height: 50, child: button);
  }
}
