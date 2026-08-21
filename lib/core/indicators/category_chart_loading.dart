import 'package:flutter/material.dart';

class CategoryPieChartSkeleton extends StatefulWidget {
  const CategoryPieChartSkeleton({super.key});

  @override
  State<CategoryPieChartSkeleton> createState() =>
      _CategoryPieChartSkeletonState();
}

class _CategoryPieChartSkeletonState extends State<CategoryPieChartSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmerController;

  static const List<double> _legendWidths = [0.9, 0.65, 0.75, 0.5, 0.6];

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

  Widget _shimmerCircle(double diameter) {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        return Container(
          width: diameter,
          height: diameter,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
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
        _shimmerBox(width: 160, height: 16),
        const SizedBox(height: 8),
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 5,
                child: Center(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final diameter =
                          constraints.maxHeight < constraints.maxWidth
                          ? constraints.maxHeight
                          : constraints.maxWidth;
                      return _shimmerCircle(diameter * 0.85);
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(_legendWidths.length, (i) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          _shimmerBox(
                            width: 11,
                            height: 11,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _shimmerBox(
                              width: double.infinity,
                              height: 12,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 4),
                          _shimmerBox(width: 24, height: 12),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
