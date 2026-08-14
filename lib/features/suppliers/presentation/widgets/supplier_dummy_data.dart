
import 'package:billing_system/features/suppliers/presentation/widgets/due_payment_card.dart';
import 'package:billing_system/features/suppliers/presentation/widgets/supplier_list_card.dart';
import 'package:flutter/material.dart';


final List<DuePayment> kMockDuePayments = [
  DuePayment(
    initials: 'SK',
    avatarColor: const Color(0xFFE23744),
    avatarBgColor: const Color(0xFFFCE7E9),
    supplierName: 'Shree Krishna Traders',
    amount: '₹18,750.00',
    statusText: 'Overdue by 12 days',
    statusColor: const Color(0xFFE23744),
  ),
  DuePayment(
    initials: 'VM',
    avatarColor: const Color(0xFFF7941D),
    avatarBgColor: const Color(0xFFFDEEDC),
    supplierName: 'Vishal Marketing',
    amount: '₹9,850.00',
    statusText: 'Overdue by 5 days',
    statusColor: const Color(0xFFE23744),
  ),
  DuePayment(
    initials: 'GP',
    avatarColor: const Color(0xFF2F6FE4),
    avatarBgColor: const Color(0xFFE8F0FE),
    supplierName: 'Goyal Provision Store',
    amount: '₹6,420.00',
    statusText: 'Due in 3 days',
    statusColor: const Color(0xFFF7941D),
  ),
];

final List<SupplierListItem> kMockSuppliers = [
  SupplierListItem(
    initials: 'SK',
    avatarColor: const Color(0xFF1B8A4C),
    avatarBgColor: const Color(0xFFE6F5EB),
    name: 'Shree Krishna Traders',
    phone: '9876543210',
    location: 'Roorkee, Uttarakhand',
    isActive: true,
  ),
  SupplierListItem(
    initials: 'VM',
    avatarColor: const Color(0xFF2F6FE4),
    avatarBgColor: const Color(0xFFE8F0FE),
    name: 'Vishal Marketing',
    phone: '9765432109',
    location: 'Haridwar, Uttarakhand',
    isActive: true,
  ),
  SupplierListItem(
    initials: 'GP',
    avatarColor: const Color(0xFFF7941D),
    avatarBgColor: const Color(0xFFFDEEDC),
    name: 'Goyal Provision Store',
    phone: '9654321098',
    location: 'Dehradun, Uttarakhand',
    isActive: true,
  ),
  SupplierListItem(
    initials: 'RT',
    avatarColor: const Color(0xFF8B5CF6),
    avatarBgColor: const Color(0xFFF1EAFE),
    name: 'Rathi Traders',
    phone: '9523109876',
    location: 'Roorkee, Uttarakhand',
    isActive: false,
  ),
];