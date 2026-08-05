import 'package:flutter/material.dart';

class SegmentedTabBar extends StatelessWidget {
  final List<String> tabs;
  final List<IconData>? icons;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const SegmentedTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onChanged,
    this.icons,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(tabs.length, (index) {
        final isActive = index == selectedIndex;

        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(index),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isActive ? Colors.blue.shade600 : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Column(
                children: [
                  if (icons != null)
                    Icon(
                      icons![index],
                      size: 16,
                      color: isActive ? Colors.blue.shade600 : Colors.grey.shade500,
                    ),
                  if (icons != null) const SizedBox(height: 4),
                  Text(
                    tabs[index],
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontSize: 12.5,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                      color: isActive ? Colors.blue.shade600 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}