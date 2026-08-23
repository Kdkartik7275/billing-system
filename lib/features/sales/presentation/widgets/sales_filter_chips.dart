import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/features/sales/presentation/controller/sales_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SalesFilterChips extends StatefulWidget {
  final SalesController controller;

  const SalesFilterChips({super.key, required this.controller});

  @override
  State<SalesFilterChips> createState() => _SalesFilterChipsState();
}

class _SalesFilterChipsState extends State<SalesFilterChips> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  void _handlePointerSignal(PointerSignalEvent event) {
    if (event is! PointerScrollEvent) return;

    final delta = event.scrollDelta.dy.abs() > event.scrollDelta.dx.abs()
        ? event.scrollDelta.dy
        : event.scrollDelta.dx;

    final target = (_scrollController.offset + delta).clamp(
      _scrollController.position.minScrollExtent,
      _scrollController.position.maxScrollExtent,
    );

    _scrollController.jumpTo(target);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Listener(
        onPointerSignal: _handlePointerSignal,
        child: ScrollConfiguration(
          behavior: const _MouseDragScrollBehavior(),
          child: ListView.separated(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: SalesFilter.values.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (_, index) {
              final filter = SalesFilter.values[index];

              return Obx(() {
                final isSelected =
                    widget.controller.selectedFilter.value == filter;

                return InkWell(
                  onTap: () => widget.controller.selectFilter(filter),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.08)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.grey.shade200,
                        width: isSelected ? 1.4 : 1,
                      ),
                    ),
                    child: Text(
                      filter.label,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 13.5,
                        color: isSelected
                            ? AppColors.primary
                            : Colors.black87,
                      ),
                    ),
                  ),
                );
              });
            },
          ),
        ),
      ),
    );
  }
}


class _MouseDragScrollBehavior extends MaterialScrollBehavior {
  const _MouseDragScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
    PointerDeviceKind.trackpad,
  };
}