import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/value_objects/product_image.dart';

part 'product_image_model.g.dart';

@HiveType(typeId: 10)
class ProductImageModel extends HiveObject {
  @HiveField(0)
  final String url;

  @HiveField(1)
  final bool isPrimary;

  @HiveField(2)
  final String? altText;

  ProductImageModel({required this.url, this.isPrimary = false, this.altText});

  factory ProductImageModel.fromEntity(ProductImage entity) {
    return ProductImageModel(
      url: entity.url,
      isPrimary: entity.isPrimary,
      altText: entity.altText,
    );
  }

  ProductImage toEntity() {
    return ProductImage(url: url, isPrimary: isPrimary, altText: altText);
  }

  factory ProductImageModel.fromJson(Map<String, dynamic> json) {
    return ProductImageModel(
      url: json['url'] ?? '',
      isPrimary: json['isPrimary'] ?? false,
      altText: json['altText'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'url': url, 'isPrimary': isPrimary, 'altText': altText};
  }

  ProductImageModel copyWith({String? url, bool? isPrimary, String? altText}) {
    return ProductImageModel(
      url: url ?? this.url,
      isPrimary: isPrimary ?? this.isPrimary,
      altText: altText ?? this.altText,
    );
  }
}
