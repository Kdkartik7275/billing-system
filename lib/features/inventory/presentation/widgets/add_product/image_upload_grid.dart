import 'dart:io';
import 'dart:ui';

import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/features/inventory/presentation/controller/add_product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageUploadGrid extends StatelessWidget {
  final AddProductController controller;
  final VoidCallback onUpload;
  final int maxImages;

  const ImageUploadGrid({
    super.key,
    required this.controller,
    required this.onUpload,
    this.maxImages = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          final images = controller.draftProduct.value.images;
          final canAddMore = images.length < maxImages;

          return Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ...images.map(
                (img) => _ImageTile(
                  path: img.url,
                  isPrimary: img.isPrimary,
                  onRemove: () => controller.removeImage(img.url),
                ),
              ),
              if (canAddMore) _UploadTile(onTap: onUpload),
            ],
          );
        }),
        const SizedBox(height: 10),
        const Text(
          'PNG, JPG up to 5MB. Recommended: 1000×1000px',
          style: TextStyle(fontSize: 12, color: AppColors.textPlaceholder),
        ),
      ],
    );
  }
}

class _UploadTile extends StatelessWidget {
  final VoidCallback onTap;

  const _UploadTile({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: DottedBorderBox(
        child: Container(
          width: 110,
          height: 110,
          alignment: Alignment.center,
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.file_upload_outlined,
                size: 26,
                color: AppColors.textSecondary,
              ),
              SizedBox(height: 8),
              Text(
                'Upload',
                style: TextStyle(
                  fontSize: 12.5,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImageTile extends StatelessWidget {
  final String path;
  final bool isPrimary;
  final VoidCallback onRemove;

  const _ImageTile({
    required this.path,
    required this.isPrimary,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: 110,
            height: 110,
            child: path.startsWith('http')
                ? Image.network(
                    path,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _fallback(),
                  )
                : Image.file(
                    File(path),
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _fallback(),
                  ),
          ),
        ),
        if (isPrimary)
          Positioned(
            left: 6,
            bottom: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'Primary',
                style: TextStyle(
                  fontSize: 9.5,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        Positioned(
          right: 6,
          top: 6,
          child: InkWell(
            onTap: onRemove,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close_rounded,
                size: 14,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _fallback() {
    return Container(
      color: AppColors.border.withValues(alpha: 0.3),
      alignment: Alignment.center,
      child: const Icon(
        Icons.broken_image_outlined,
        color: AppColors.textSecondary,
      ),
    );
  }
}

class DottedBorderBox extends StatelessWidget {
  final Widget child;

  const DottedBorderBox({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _DashedBorderPainter(), child: child);
  }
}

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(12),
    );

    const double dashWidth = 6;
    const double dashSpace = 4;
    final Path path = Path()..addRRect(rrect);

    for (final PathMetric metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final double next = distance + dashWidth;
        canvas.drawPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          paint,
        );
        distance = next + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
