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
            child: _BrandPanel(
              navy: AppColors.primary,
              navyDeep: AppColors.darkBackground,
              amber: AppColors.secondary,
            ),
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
                      Text(
                        'Welcome back',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sign in to manage today\'s sales and stock.',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(color: Colors.black54),
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

/// ---------------------------------------------------------------------
/// Redesigned brand panel
/// ---------------------------------------------------------------------

class _BrandPanel extends StatelessWidget {
  const _BrandPanel({
    required this.navy,
    required this.navyDeep,
    required this.amber,
  });
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
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Soft glow blobs for depth
          Positioned(
            top: -120,
            left: -80,
            child: _GlowBlob(color: amber.withValues(alpha: .18), size: 320),
          ),
          Positioned(
            bottom: -140,
            right: -100,
            child: _GlowBlob(
              color: Colors.white.withValues(alpha: .06),
              size: 380,
            ),
          ),
          // Faint grid texture
          Positioned.fill(
            child: CustomPaint(
              painter: _GridPainter(Colors.white.withValues(alpha: .04)),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(56, 56, 56, 56),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Logo
                Row(
                  children: [
                    Container(
                      height: 42,
                      width: 42,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.point_of_sale_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'SmartPOS',
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: Colors.white),
                    ),
                  ],
                ),

                // Headline + feature list
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: amber.withValues(alpha: .14),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: amber.withValues(alpha: .4)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.bolt_rounded, size: 14, color: amber),
                          const SizedBox(width: 6),
                          Text(
                            'Built for busy counters',
                            style: TextStyle(
                              color: amber,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: .2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Run your\nentire store\nfrom one screen',
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            height: 1.15,
                          ),
                    ),
                    const SizedBox(height: 28),
                    _FeatureRow(
                      icon: Icons.receipt_long_rounded,
                      label: 'Instant billing & invoices',
                      amber: amber,
                    ),
                    const SizedBox(height: 14),
                    _FeatureRow(
                      icon: Icons.inventory_2_rounded,
                      label: 'Real-time stock tracking',
                      amber: amber,
                    ),
                    const SizedBox(height: 14),
                    _FeatureRow(
                      icon: Icons.insights_rounded,
                      label: 'Sales insights at a glance',
                      amber: amber,
                    ),
                  ],
                ),

                // Bottom stat strip
                Row(
                  children: [
                    _StatChip(
                      value: '12k+',
                      label: 'Shops onboarded',
                      amber: amber,
                    ),
                    const SizedBox(width: 28),
                    _StatChip(value: '99.9%', label: 'Uptime', amber: amber),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
    required this.icon,
    required this.label,
    required this.amber,
  });
  final IconData icon;
  final String label;
  final Color amber;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 32,
          width: 32,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .08),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, size: 16, color: amber),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.value,
    required this.label,
    required this.amber,
  });
  final String value;
  final String label;
  final Color amber;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            color: amber,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
      ],
    );
  }
}

class _GlowBlob extends StatelessWidget {
  const _GlowBlob({required this.color, required this.size});
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  _GridPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    const spacing = 40.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) => false;
}
