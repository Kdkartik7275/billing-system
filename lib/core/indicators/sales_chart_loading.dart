import 'package:flutter/material.dart';

class SalesChartSkeleton extends StatefulWidget {
  const SalesChartSkeleton({super.key});

  @override
  State<SalesChartSkeleton> createState() => _SalesChartSkeletonState();
}

class _SalesChartSkeletonState extends State<SalesChartSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmerController;

  static const List<double> _barHeights = [
    0.45,
    0.65,
    0.35,
    0.85,
    0.55,
    0.7,
    0.5,
  ];

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  Widget _shimmerBox({
    required double width,
    required double height,
    BorderRadius? borderRadius,
  }) {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: borderRadius ?? BorderRadius.circular(6),
            gradient: LinearGradient(
              begin: Alignment(-1.0 - _shimmerController.value * 2, 0),
              end: Alignment(1.0 - _shimmerController.value * 2, 0),
              colors: [
                Colors.grey.shade200,
                Colors.grey.shade100,
                Colors.grey.shade200,
              ],
              stops: const [0.35, 0.5, 0.65],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmerBox(width: 220, height: 16),
                const SizedBox(height: 8),
                _shimmerBox(width: 150, height: 12),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final maxBarHeight = constraints.maxHeight - 24;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(_barHeights.length, (i) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _shimmerBox(
                        width: 28,
                        height: maxBarHeight * _barHeights[i],
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _shimmerBox(width: 24, height: 10),
                    ],
                  );
                }),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        _shimmerBox(
          width: double.infinity,
          height: 34,
          borderRadius: BorderRadius.circular(10),
        ),
      ],
    );
  }
}
