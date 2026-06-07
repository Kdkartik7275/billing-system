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

const kCardData = [
  DashboardCardModel(
    title: "Today's Sales",
    value: "₹125,680",
    growth: "+12.5% from yesterday",
    icon: Icons.attach_money,
    iconColor: Colors.green,
  ),
  DashboardCardModel(
    title: "Total Orders",
    value: "186",
    growth: "+8.2% from yesterday",
    icon: Icons.shopping_cart_outlined,
    iconColor: Colors.blue,
  ),
  DashboardCardModel(
    title: "Revenue",
    value: "₹112,340",
    growth: "+15.3% from yesterday",
    icon: Icons.show_chart,
    iconColor: Colors.deepPurple,
  ),
  DashboardCardModel(
    title: "Pending Sync Bills",
    value: "0",
    growth: "No pending bills",
    icon: Icons.pending_actions_outlined,
    iconColor: Colors.orange,
  ),
];
