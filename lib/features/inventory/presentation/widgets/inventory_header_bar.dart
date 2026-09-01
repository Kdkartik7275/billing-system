import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

class InventoryHeaderBar extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onRefresh;
  final VoidCallback? onAddProduct;
  final VoidCallback? onExport;
  final bool isExporting;

  final String addProductLabel;

  const InventoryHeaderBar({
    super.key,
    this.title = 'Inventory',
    this.subtitle,
    this.onRefresh,
    this.onAddProduct,
    this.onExport,
    this.isExporting = false,
    this.addProductLabel = 'Add Product',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xff111827),
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ],
          ),
        ),

        const SizedBox(width: 16),

        _HeaderActions(
          compact: false,
          onRefresh: onRefresh,
          onExport: onExport,
          isExporting: isExporting,
          onAddProduct: onAddProduct,
          addProductLabel: addProductLabel,
        ),
      ],
    );
  }
}

class _HeaderActions extends StatelessWidget {
  final bool compact;
  final VoidCallback? onRefresh;
  final VoidCallback? onExport;
  final bool isExporting;
  final VoidCallback? onAddProduct;
  final String addProductLabel;

  const _HeaderActions({
    required this.compact,
    required this.addProductLabel,
    this.onRefresh,
    this.onExport,
    this.isExporting = false,
    this.onAddProduct,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (onRefresh != null)
          SizedBox(
            height: 36,
            width: 36,
            child: IconButton.filledTonal(
              tooltip: 'Refresh',
              onPressed: onRefresh,
              style: IconButton.styleFrom(
                backgroundColor: AppColors.primary.withValues(alpha: 0.10),
                foregroundColor: AppColors.primary,
                padding: EdgeInsets.zero,
              ),
              icon: const Icon(Icons.refresh_rounded, size: 17),
            ),
          ),

        if (onExport != null)
          SizedBox(
            height: 36,
            width: 36,
            child: IconButton.filledTonal(
              tooltip: 'Export',
              onPressed: isExporting ? null : onExport,
              style: IconButton.styleFrom(
                backgroundColor: Colors.grey.shade100,
                foregroundColor: Colors.grey.shade700,
                disabledBackgroundColor: Colors.grey.shade100,
                padding: EdgeInsets.zero,
              ),
              icon: isExporting
                  ? SizedBox(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.grey.shade600,
                      ),
                    )
                  : const Icon(Icons.file_download_outlined, size: 17),
            ),
          ),

        if (onAddProduct != null)
          SizedBox(
            height: 36,
            child: FilledButton.icon(
              onPressed: onAddProduct,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: compact ? 12 : 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              icon: const Icon(
                Icons.add_rounded,
                size: 16,
                color: Colors.white,
              ),
              label: Text(compact ? 'Add' : addProductLabel),
            ),
          ),
      ],
    );
  }
}
