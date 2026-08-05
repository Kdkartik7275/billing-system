import 'package:flutter/material.dart';

class FieldLabel extends StatelessWidget {
  final String label;
  final bool required;

  const FieldLabel({super.key, required this.label, this.required = false});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: label,
        style: TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade800,
        ),
        children: required
            ? [
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red.shade400),
                ),
              ]
            : null,
      ),
    );
  }
}
