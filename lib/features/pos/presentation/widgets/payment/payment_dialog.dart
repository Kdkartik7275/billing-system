import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/core/di/init_dependencies.dart';
import 'package:billing_system/features/pos/data/models/payment_result.dart';
import 'package:billing_system/features/pos/presentation/controller/payment_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'receipt_dialog.dart';

class PaymentDialog extends StatefulWidget {
  const PaymentDialog({super.key});

  static Future<void> show() async {
    Get.put(PaymentController(saveBillUsecase: sl()));
    await showDialog(
      context: Get.context!,
      barrierDismissible: true,
      builder: (_) => const PaymentDialog(),
    );
    if (Get.isRegistered<PaymentController>()) {
      Get.find<PaymentController>().reset();
      Get.delete<PaymentController>();
    }
  }

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  late final PaymentController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = Get.find<PaymentController>();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _DialogHeader(total: _ctrl.grandTotal),
              _MethodTabs(ctrl: _ctrl),
              Obx(
                () => _ctrl.selectedMethod.value == PaymentMethod.cash
                    ? _CashTab(ctrl: _ctrl)
                    : _CardTab(ctrl: _ctrl),
              ),
              _ConfirmButton(ctrl: _ctrl),
            ],
          ),
        ),
      ),
    );
  }
}

class _DialogHeader extends StatelessWidget {
  final double total;
  const _DialogHeader({required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Text(
                '₹${total.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: AppColors.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              margin: const EdgeInsets.only(left: 16),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.07),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 20, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

class _MethodTabs extends StatelessWidget {
  final PaymentController ctrl;
  const _MethodTabs({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Obx(
        () => Row(
          children: PaymentMethod.values.map((method) {
            final selected = ctrl.selectedMethod.value == method;
            return Expanded(
              child: GestureDetector(
                onTap: () => ctrl.selectMethod(method),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: EdgeInsets.only(
                    right: method == PaymentMethod.cash ? 8 : 0,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.primary.withValues(alpha: 0.15)
                        : Colors.black.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: selected
                          ? AppColors.primary.withValues(alpha: 0.6)
                          : Colors.transparent,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        method == PaymentMethod.cash
                            ? Icons.payments_rounded
                            : Icons.qr_code_rounded,
                        size: 16,
                        color: selected ? AppColors.primary : Colors.black,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        method.label,
                        style: TextStyle(
                          color: selected ? AppColors.primary : Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _CashTab extends StatelessWidget {
  final PaymentController ctrl;
  const _CashTab({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Amount Tendered',
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: Colors.black87,
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '₹',
                        style: Theme.of(context).textTheme.titleMedium!
                            .copyWith(
                              color: AppColors.primary,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: TextField(
                          controller: ctrl.tenderedController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}'),
                            ),
                          ],
                          style: Theme.of(context).textTheme.titleMedium!
                              .copyWith(
                                color: AppColors.primary,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: '0.00',
                            hintStyle: TextStyle(color: Colors.black26),
                          ),
                          onChanged: ctrl.updateTendered,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: ctrl.setExactAmount,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Text(
                    'Exact',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _QuickAmounts(ctrl: ctrl),
          const SizedBox(height: 16),
          Obx(() {
            final tendered = ctrl.tendered;
            if (tendered == 0) return const SizedBox.shrink();

            final isShort = tendered < ctrl.grandTotal;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: isShort
                    ? Colors.red.shade900.withValues(alpha: 0.05)
                    : Colors.green.shade900.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isShort
                      ? Colors.red.shade800.withValues(alpha: 0.4)
                      : Colors.green.shade800.withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isShort
                        ? Icons.warning_amber_rounded
                        : Icons.check_circle_rounded,
                    color: isShort
                        ? Colors.red.shade700
                        : Colors.green.shade700,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    isShort
                        ? 'Short by ₹${(ctrl.grandTotal - tendered).toStringAsFixed(2)}'
                        : 'Change: ₹${ctrl.change.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: isShort
                          ? Colors.red.shade700
                          : Colors.green.shade700,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }),
          Obx(() {
            final err = ctrl.errorMessage.value;
            if (err.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                err,
                style: TextStyle(color: Colors.red.shade400, fontSize: 12.5),
              ),
            );
          }),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _QuickAmounts extends StatelessWidget {
  final PaymentController ctrl;
  const _QuickAmounts({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final amounts = _quickAmounts(ctrl.grandTotal);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick amounts',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Colors.black87,
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: amounts.map((amount) {
            return GestureDetector(
              onTap: () {
                final str = amount.toStringAsFixed(2);
                ctrl.tenderedController.text = str;
                ctrl.updateTendered(str);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black12),
                ),
                child: Text(
                  '₹${amount % 1 == 0 ? amount.toInt() : amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  List<double> _quickAmounts(double total) {
    final rounded = <double>[];
    final steps = [1, 5, 10, 20, 50, 100, 200, 500];
    for (final step in steps) {
      final candidate = (total / step).ceil() * step.toDouble();
      if (candidate >= total && !rounded.contains(candidate)) {
        rounded.add(candidate);
      }
      if (rounded.length >= 4) break;
    }
    return rounded;
  }
}

class _CardTab extends StatelessWidget {
  final PaymentController ctrl;
  const _CardTab({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final upiString =
        'upi://pay?pa=yourshop@upi&pn=YourShop&am=${ctrl.grandTotal.toStringAsFixed(2)}&cu=INR';

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            child: QrImageView(
              data: upiString,
              version: QrVersions.auto,
              size: 200,
              backgroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Scan with any UPI app to pay',
            style: TextStyle(color: Colors.white54, fontSize: 13),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'yourshop@upi',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Amount: ₹${ctrl.grandTotal.toStringAsFixed(2)}',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  final PaymentController ctrl;
  const _ConfirmButton({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
      child: Obx(() {
        final enabled = ctrl.canConfirm;
        return GestureDetector(
          onTap: enabled
              ? () async {
                  final result = ctrl.confirmPayment();
                  if (result != null) {
                    Navigator.of(context).pop();
                    ReceiptDialog.show(result);
                    await ctrl.saveBill(result);
                  }
                }
              : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: enabled
                  ? AppColors.primary
                  : AppColors.primary.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_rounded,
                  color: enabled ? Colors.white : Colors.white38,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  ctrl.selectedMethod.value == PaymentMethod.cash
                      ? 'Confirm Cash Payment'
                      : 'Confirm Card / UPI Payment',
                  style: TextStyle(
                    color: enabled ? Colors.white : Colors.white38,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
