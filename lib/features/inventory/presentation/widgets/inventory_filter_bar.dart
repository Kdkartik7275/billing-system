import 'package:billing_system/core/config/constants/categories.dart';
import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/core/config/theme/app_radius.dart';
import 'package:billing_system/features/inventory/presentation/controller/inventory_controller.dart';
import 'package:billing_system/features/inventory/presentation/widgets/add_product_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class InventoryFilterBar extends StatefulWidget {
  final bool compact;
  const InventoryFilterBar({super.key, this.compact = false});

  @override
  State<InventoryFilterBar> createState() => _InventoryFilterBarState();
}

class _InventoryFilterBarState extends State<InventoryFilterBar> {
  final _textController = TextEditingController();

  late final MobileScannerController _scannerController;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
      torchEnabled: false,
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scannerController.dispose();
    super.dispose();
  }

  void _openScanner() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          child: RepaintBoundary(
            child: Container(
              height: 200,
              width: 200,
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: MobileScanner(
                  controller: _scannerController,
                  onDetect: _onBarcodeDetected,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onBarcodeDetected(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final raw = capture.barcodes.firstOrNull?.rawValue;
    if (raw == null) return;

    _isProcessing = true;
    final controller = Get.find<InventoryController>();
    try {
      await controller.productExist(raw);
    } finally {
      _isProcessing = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InventoryController>();

    final searchField = RepaintBoundary(
      child: _SearchField(
        textController: _textController,
        onChanged: controller.updateSearch,
        onClear: () {
          _textController.clear();
          controller.clearSearch();
        },
      ),
    );

    final categoryDropdown = RepaintBoundary(
      child: Obx(
        () => _CategoryDropdown(
          value: controller.selectedCategory.value,
          onChanged: (v) => controller.selectCategory(v ?? 'All'),
        ),
      ),
    );

    final actionButtons = RepaintBoundary(
      child: _ActionButtons(onScanTap: _openScanner),
    );

    if (widget.compact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          searchField,
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: categoryDropdown),
              const SizedBox(width: 10),
            ],
          ),
          const SizedBox(height: 12),
          actionButtons,
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: searchField),
        const SizedBox(width: 14),
        SizedBox(width: 200, child: categoryDropdown),
        const SizedBox(width: 14),
        actionButtons,
      ],
    );
  }
}

// ─── Action buttons (static besides the onTap callback) ───────────────────

class _ActionButtons extends StatelessWidget {
  final VoidCallback onScanTap;

  const _ActionButtons({required this.onScanTap});

  static final ButtonStyle _scanButtonStyle = ElevatedButton.styleFrom(
    elevation: 0,
    backgroundColor: Colors.white,
    foregroundColor: AppColors.primary,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      side: const BorderSide(color: AppColors.primary, width: .8),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const AddProductButton(),
        const SizedBox(width: 8),
        SizedBox(
          height: 46,
          child: ElevatedButton.icon(
            onPressed: onScanTap,
            icon: const Icon(
              Icons.qr_code_2,
              size: 20,
              color: AppColors.primary,
            ),
            label: const Text(
              'SCAN',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.1,
              ),
            ),
            style: _scanButtonStyle,
          ),
        ),
      ],
    );
  }
}

// ─── Search field ─────────────────────────────────────────────────────────────

class _SearchField extends StatelessWidget {
  final TextEditingController textController;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchField({
    required this.textController,
    required this.onChanged,
    required this.onClear,
  });

  static final OutlineInputBorder _border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppRadius.sm),
    borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.4)),
  );

  static final OutlineInputBorder _focusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppRadius.sm),
    borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.6)),
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: TextField(
        controller: textController,
        onChanged: onChanged,
        textAlignVertical: TextAlignVertical.center,
        style: const TextStyle(fontSize: 13.5),
        decoration: InputDecoration(
          hintText: 'Search by name, SKU, or barcode...',
          hintStyle: TextStyle(fontSize: 13.5, color: Colors.grey.shade600),
          filled: true,
          fillColor: Colors.white,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          prefixIcon: Icon(
            Icons.search_rounded,
            size: 20,
            color: Colors.grey.shade600,
          ),
          suffixIcon: ValueListenableBuilder(
            valueListenable: textController,
            builder: (_, v, __) => v.text.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      size: 17,
                      color: Colors.grey.shade600,
                    ),
                    onPressed: onClear,
                  )
                : const SizedBox.shrink(),
          ),
          border: _border,
          enabledBorder: _border,
          focusedBorder: _focusedBorder,
        ),
      ),
    );
  }
}

// ─── Category dropdown ────────────────────────────────────────────────────────

class _CategoryDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;

  const _CategoryDropdown({required this.value, required this.onChanged});

  static final BoxDecoration _decoration = BoxDecoration(
    color: Colors.white,
    border: Border.all(color: Colors.grey.withValues(alpha: 0.4)),
    borderRadius: BorderRadius.circular(AppRadius.sm),
  );

  static const TextStyle _itemStyle = TextStyle(
    fontSize: 14,
    color: Colors.black,
    fontWeight: FontWeight.w500,
  );

  static final List<DropdownMenuItem<String>> _items = productCategories
      .map(
        (cat) => DropdownMenuItem(
          value: cat,
          child: Text(cat, style: _itemStyle),
        ),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: _decoration,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          dropdownColor: Colors.white,
          style: _itemStyle,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.grey.shade600,
            size: 20,
          ),
          borderRadius: BorderRadius.circular(12),
          items: _items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}