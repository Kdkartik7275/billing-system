import 'package:flutter/material.dart';

class DashboardCardModel {
  const DashboardCardModel({
    required this.title,
    required this.value,
    required this.growth,
    required this.icon,
    required this.iconColor,
  });
  final String title;
  final String value;
  final String growth;
  final IconData icon;
  final Color iconColor;
}

class CategoryData {
  const CategoryData(this.label, this.percentage, this.color);
  final String label;
  final int percentage;
  final Color color;
}

class TransactionData {
  const TransactionData(
    this.invoice,
    this.customer,
    this.amount,
    this.completed,
  );
  final String invoice;
  final String customer;
  final String amount;
  final bool completed;
}
