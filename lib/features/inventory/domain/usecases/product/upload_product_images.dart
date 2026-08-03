import 'dart:io';

import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/usecases/usecases.dart';
import 'package:billing_system/features/inventory/domain/repositories/product_repository.dart';

class UploadProductImages
    implements UseCaseWithParams<List<String>, List<File>> {
  final ProductRepository repository;

  UploadProductImages({required this.repository});
  @override
  ResultFuture<List<String>> call(List<File> params) async {
    return await repository.uploadProductImages(params);
  }
}
