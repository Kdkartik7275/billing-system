import 'package:billing_system/core/preview/image_preview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProductGallery extends StatefulWidget {
  final List<String> imageUrls;

  const ProductGallery({super.key, required this.imageUrls});

  @override
  State<ProductGallery> createState() => _ProductGalleryState();
}

class _ProductGalleryState extends State<ProductGallery> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.imageUrls;

    return Column(
      children: [
        Container(
          height: 220,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: images.isEmpty
              ? Center(
                  child: Icon(
                    Icons.image_outlined,
                    size: 48,
                    color: Colors.grey.shade400,
                  ),
                )
              : images.length == 1
              // Center single image
              ? Center(
                  child: GestureDetector(
                    onTap: () => ImagePreviewDialog.show(
                      context,
                      imageUrl: images.first,
                    ),
                    child: CachedNetworkImage(
                      imageUrl: images.first,
                      fit: BoxFit.contain,
                    ),
                  ),
                )
              // Full-width horizontal swipe
              : PageView.builder(
                  controller: _pageController,
                  itemCount: images.length,

                  itemBuilder: (_, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: GestureDetector(
                        onTap: () => ImagePreviewDialog.show(
                          context,
                          imageUrl: images[index],
                        ),
                        child: CachedNetworkImage(
                          imageUrl: images[index],
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  },
                ),
        ),

        if (images.length > 1) ...[
          const SizedBox(height: 12),

          SizedBox(
            height: 60,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 55,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(9),
                      child: CachedNetworkImage(
                        imageUrl: images[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
