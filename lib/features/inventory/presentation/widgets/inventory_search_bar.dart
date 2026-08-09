import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/inventory_controller.dart';

class InventorySearchBar extends StatefulWidget {
  const InventorySearchBar({super.key});

  @override
  State<InventorySearchBar> createState() => _InventorySearchBarState();
}

class _InventorySearchBarState extends State<InventorySearchBar> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();

    final controller = Get.find<InventoryController>();

    _textController = TextEditingController(text: controller.searchQuery.value);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InventoryController>();

    return TextField(
      controller: _textController,
      onChanged: controller.updateSearch,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: "Search products, SKU or barcode...",
        hintStyle: TextStyle(color: Colors.grey[500], fontSize: 13.5),

        filled: true,
        fillColor: Colors.white,

        prefixIcon: const Icon(
          Icons.search_rounded,
          size: 20,
          color: Colors.grey,
        ),

        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: _textController,
          builder: (_, value, __) {
            if (value.text.isEmpty) {
              return const SizedBox.shrink();
            }

            return IconButton(
              icon: const Icon(Icons.close_rounded, size: 18),
              onPressed: () {
                _textController.clear();
                controller.clearSearch();
              },
            );
          },
        ),

        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xffE5E7EB)),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 1.3),
        ),
      ),
    );
  }
}
