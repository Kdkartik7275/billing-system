import 'package:flutter/material.dart';
import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:get/get.dart';

import '../controller/login_controller.dart';
import '../widgets/login_form.dart';
import '../widgets/register_shop_link.dart';

class LoginWebLayout extends StatelessWidget {
  const LoginWebLayout({super.key});


  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoginController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          Expanded(
            flex: 5,
            child: _BrandPanel(navy: AppColors.primary, navyDeep: AppColors.darkBackground, amber: AppColors.secondary),
          ),
          Expanded(
            flex: 4,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 48),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome back', style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(height: 8),
                      Text(
                        'Sign in to manage today\'s sales and stock.',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: Colors.black54),
                      ),
                      const SizedBox(height: 34),
                      LoginForm(controller: controller),
                      const RegisterShopLink(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The signature element for this screen: a stylised receipt ticket,
/// grounding the brand panel in what the product actually is (a POS)
/// rather than a generic gradient hero.
class _BrandPanel extends StatelessWidget {
  const _BrandPanel({required this.navy, required this.navyDeep, required this.amber});
  final Color navy;
  final Color navyDeep;
  final Color amber;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [navyDeep, navy],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(56, 56, 56, 56),
      child: Stack(
        children: [
          Positioned(
            right: -60,
            top: -60,
            child: _DotGrid(color: Colors.white.withOpacity(0.06)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 42,
                    width: 42,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Center(
                      child: Icon(Icons.point_of_sale_rounded, color: amber, size: 22),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'SmartPOS',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.white),
                  ),
                ],
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: _ReceiptTicket(amber: amber),
                ),
              ),
              Text(
                'Every sale, every stock movement, one register.',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.white70, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReceiptTicket extends StatelessWidget {
  const _ReceiptTicket({required this.amber});
  final Color amber;

  @override
  Widget build(BuildContext context) {
    final lineStyle = TextStyle(
      fontFamily: 'Inter',
      fontSize: 13,
      color: Colors.black54,
      height: 1.6,
    );

    return Container(
      width: 260,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 24, offset: Offset(0, 16)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DAILY SUMMARY',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Container(height: 1, color: Colors.black12),
          const SizedBox(height: 12),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Items sold', style: lineStyle),
            Text('184', style: lineStyle.copyWith(color: Colors.black87, fontWeight: FontWeight.w600)),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Low stock alerts', style: lineStyle),
            Text('3', style: lineStyle.copyWith(color: Colors.black87, fontWeight: FontWeight.w600)),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Pending bills', style: lineStyle),
            Text('7', style: lineStyle.copyWith(color: Colors.black87, fontWeight: FontWeight.w600)),
          ]),
          const SizedBox(height: 12),
          Container(height: 1, color: Colors.black12),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'NET SALES',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                  color: Colors.black87,
                ),
              ),
              Text(
                '₹42,180',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DotGrid extends StatelessWidget {
  const _DotGrid({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 220,
      child: CustomPaint(painter: _DotGridPainter(color)),
    );
  }
}

class _DotGridPainter extends CustomPainter {
  _DotGridPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    const spacing = 18.0;
    for (double y = 0; y < size.height; y += spacing) {
      for (double x = 0; x < size.width; x += spacing) {
        canvas.drawCircle(Offset(x, y), 2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DotGridPainter oldDelegate) => false;
}