import 'package:billing_system/features/inventory/presentation/widgets/add_product/field_label.dart';
import 'package:flutter/material.dart';

class LabeledTextField extends StatelessWidget {
  final String label;
  final bool required;
  final TextEditingController controller;
  final String? hintText;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final String? suffixText;
  final Widget? suffixIcon;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final bool showCounter;

  const LabeledTextField({
    super.key,
    required this.label,
    required this.controller,
    this.required = false,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixText,
    this.suffixIcon,
    this.maxLength,
    this.onChanged,
    this.showCounter = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(label, required: required),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLength: maxLength,
          onChanged: onChanged,
          style: const TextStyle(fontSize: 13.5),
          decoration: InputDecoration(
            isDense: true,
            hintText: hintText,
            hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            suffixText: suffixText,
            counterText: showCounter ? null : '',
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.blue.shade400, width: 1.4),
            ),
          ),
        ),
      ],
    );
  }
}
