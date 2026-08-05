import 'package:billing_system/features/inventory/presentation/widgets/add_product/field_label.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LabeledDateField extends StatelessWidget {
  final String label;
  final bool required;
  final DateTime? value;
  final ValueChanged<DateTime> onChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String placeholder;

  const LabeledDateField({
    super.key,
    required this.label,
    required this.onChanged,
    this.value,
    this.required = false,
    this.firstDate,
    this.lastDate,
    this.placeholder = 'Select date',
  });

  Future<void> _pick(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: value ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(2020),
      lastDate: lastDate ?? DateTime(2100),
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('dd MMM yyyy');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(label, required: required),
        const SizedBox(height: 6),
        InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => _pick(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    value != null ? dateFmt.format(value!) : placeholder,
                    style: TextStyle(
                      fontSize: 13.5,
                      color: value != null ? Colors.black87 : Colors.grey.shade400,
                    ),
                  ),
                ),
                Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: Colors.grey.shade500),
              ],
            ),
          ),
        ),
      ],
    );
  }
}