import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:flutter/material.dart';

const kStockUnits = ['kg', 'g', 'liter', 'ml', 'piece', 'pack', 'bottle', 'box', 'dozen'];

// ─── Form row ─────────────────────────────────────────────────────────────────

class FormRow extends StatelessWidget {
  final List<Widget> children;
  const FormRow({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start, // align tops when errors shift height
      children: children
          .expand((w) => [Expanded(child: w), const SizedBox(width: 12)])
          .toList()
        ..removeLast(),
    );
  }
}

// ─── Text field ───────────────────────────────────────────────────────────────

class FormTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool isNumber;
  final String? prefix;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  const FormTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.isNumber = false,
    this.prefix,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            color: hasError ? Colors.red.shade400 : Colors.grey.shade500,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          style: const TextStyle(fontSize: 13),
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            prefixText: prefix,
            errorText: errorText,
            errorStyle: const TextStyle(fontSize: 10.5, height: 1.2),
            hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
            filled: true,
            fillColor: hasError ? Colors.red.shade50 : Colors.grey.shade50,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: hasError ? Colors.red.shade300 : Colors.grey.withValues(alpha: 0.25),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: hasError ? Colors.red.shade300 : Colors.grey.withValues(alpha: 0.25),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: hasError ? Colors.red.shade400 : AppColors.primary.withValues(alpha: 0.6),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Dropdown field ───────────────────────────────────────────────────────────

class FormDropdownField extends StatelessWidget {
  final String label;
  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? errorText;

  const FormDropdownField({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            color: hasError ? Colors.red.shade400 : Colors.grey.shade500,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: hasError ? Colors.red.shade50 : Colors.grey.shade50,
            border: Border.all(
              color: hasError ? Colors.red.shade300 : Colors.grey.withValues(alpha: 0.25),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              hint: Text(hint, style: TextStyle(fontSize: 13, color: Colors.grey.shade400)),
              dropdownColor: Colors.white,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
              icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey.shade400, size: 18),
              borderRadius: BorderRadius.circular(10),
              items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 4),
          Text(
            errorText!,
            style: TextStyle(fontSize: 10.5, color: Colors.red.shade600, height: 1.2),
          ),
        ],
      ],
    );
  }
}