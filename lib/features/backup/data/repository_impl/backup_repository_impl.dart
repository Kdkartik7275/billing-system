import 'dart:convert';
import 'dart:io';

import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/core/errors/failure.dart';
import 'package:billing_system/features/backup/data/data_source/backup_local_data_source.dart';
import 'package:billing_system/features/backup/data/model/backup_info_model.dart';
import 'package:billing_system/features/backup/data/model/backup_manifest_model.dart';
import 'package:billing_system/features/backup/domain/entity/backup_entity.dart';
import 'package:billing_system/features/backup/domain/repository/backup_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:path/path.dart' as path;

class BackupRepositoryImpl implements BackupRepository {
  final BackupLocalDataSource localDataSource;

  BackupRepositoryImpl({required this.localDataSource});

  static const int _backupVersion = 1;
  static const String _backupFormat = 'smartpos_backup';

  @override
  ResultFuture<String> exportBackup() async {
    try {
      // TODO:
      // Collect data from all registered Hive boxes.
      //
      // This should eventually be handled by BackupRegistry.
      //
      // Example:
      //
      // final products = await localDataSource.exportBox<ProductModel>(
      //   box: productBox,
      //   toJson: (product) => product.toJson(),
      // );

      final now = DateTime.now();

      final manifest = BackupManifestModel(
        format: _backupFormat,
        version: _backupVersion,
        appVersion: '1.0.0',
        createdAt: now,
        shopId: null,
        shopName: null,
        boxes: const [],
      );

      final backupData = <String, dynamic>{
        'manifest': manifest.toJson(),
        'boxes': <String, dynamic>{},
      };

      /*
       * For now this creates the JSON representation.
       *
       * The next step is to send this data to a
       * BackupFileDataSource which will create the
       * .smartposbackup ZIP file.
       */

      final json = jsonEncode(backupData);

      final tempDirectory = Directory.systemTemp;
      final filePath = path.join(
        tempDirectory.path,
        'smartpos-backup-${now.millisecondsSinceEpoch}.json',
      );

      final file = File(filePath);

      await file.writeAsString(json);

      final backupInfo = BackupInfo(
        filePath: filePath,
        appVersion: '1.0.0',
        formatVersion: _backupVersion,
        createdAt: now,
        shopId: null,
        shopName: null,
        productsCount: 0,
        categoriesCount: 0,
        customersCount: 0,
        suppliersCount: 0,
        billsCount: 0,
      );

      await localDataSource.saveLastBackupInfo(
        BackupInfoModel.fromEntity(backupInfo),
      );

      return right(filePath);
    } catch (e) {
      return left(ServerFailure(message: 'Failed to export backup: $e'));
    }
  }

  @override
  ResultFuture<BackupInfo?> getLastBackup() async {
    try {
      final result = await localDataSource.getLastBackupInfo();

      if (result == null) {
        return right(null);
      }

      return right(result.toEntity());
    } catch (e) {
      return left(ServerFailure(message: 'Failed to get last backup: $e'));
    }
  }

  @override
  ResultFuture<void> importBackup(
    String filePath, {
    BackupImportMode mode = BackupImportMode.replace,
  }) async {
    try {
      final file = File(filePath);

      if (!await file.exists()) {
        return left(ServerFailure(message: 'Backup file does not exist.'));
      }

      final content = await file.readAsString();

      final decoded = jsonDecode(content);

      if (decoded is! Map<String, dynamic>) {
        return left(ServerFailure(message: 'Invalid backup format.'));
      }

      final manifestJson = decoded['manifest'];

      if (manifestJson is! Map<String, dynamic>) {
        return left(ServerFailure(message: 'Backup manifest is missing.'));
      }

      final manifest = BackupManifestModel.fromJson(
        Map<String, dynamic>.from(manifestJson),
      );

      if (manifest.format != _backupFormat) {
        return left(ServerFailure(message: 'Unsupported backup format.'));
      }

      if (manifest.version > _backupVersion) {
        return left(
          ServerFailure(
            message: 'This backup was created with a newer version of the app.',
          ),
        );
      }

      final boxes = decoded['boxes'];

      if (boxes is! Map<String, dynamic>) {
        return left(
          ServerFailure(message: 'Backup contains no valid box data.'),
        );
      }

      /*
       * IMPORTANT:
       *
       * Do not clear any Hive box until the complete
       * backup has been validated.
       *
       * Actual restoration should be performed by
       * BackupRegistry.
       */

      if (mode == BackupImportMode.replace) {
        // BackupRegistry will clear and restore the boxes.
      }

      if (mode == BackupImportMode.merge) {
        // BackupRegistry will restore without clearing.
      }

      return right(null);
    } catch (e) {
      return left(ServerFailure(message: 'Failed to import backup: $e'));
    }
  }

  @override
  ResultFuture<BackupInfo> validateBackup(String filePath) async {
    try {
      final file = File(filePath);

      if (!await file.exists()) {
        return left(ServerFailure(message: 'Backup file does not exist.'));
      }

      final content = await file.readAsString();

      dynamic decoded;

      try {
        decoded = jsonDecode(content);
      } catch (_) {
        return left(
          ServerFailure(message: 'Backup file contains invalid JSON.'),
        );
      }

      if (decoded is! Map<String, dynamic>) {
        return left(ServerFailure(message: 'Invalid backup structure.'));
      }

      final manifestJson = decoded['manifest'];

      if (manifestJson is! Map<String, dynamic>) {
        return left(ServerFailure(message: 'Backup manifest is missing.'));
      }

      final manifest = BackupManifestModel.fromJson(
        Map<String, dynamic>.from(manifestJson),
      );

      if (manifest.format != _backupFormat) {
        return left(ServerFailure(message: 'Invalid SmartPOS backup file.'));
      }

      if (manifest.version > _backupVersion) {
        return left(
          ServerFailure(
            message: 'This backup requires a newer version of SmartPOS.',
          ),
        );
      }

      final boxes = decoded['boxes'];

      if (boxes is! Map<String, dynamic>) {
        return left(
          ServerFailure(message: 'Backup contains invalid box data.'),
        );
      }

      int getCount(String boxName) {
        final data = boxes[boxName];

        if (data is! List) {
          return 0;
        }

        return data.length;
      }

      final backupInfo = BackupInfo(
        filePath: filePath,
        appVersion: manifest.appVersion,
        formatVersion: manifest.version,
        createdAt: manifest.createdAt,
        shopId: manifest.shopId,
        shopName: manifest.shopName,
        productsCount: getCount('products'),
        categoriesCount: getCount('categories'),
        customersCount: getCount('customers'),
        suppliersCount: getCount('suppliers'),
        billsCount: getCount('bills'),
      );

      return right(backupInfo);
    } catch (e) {
      return left(ServerFailure(message: 'Failed to validate backup: $e'));
    }
  }
}
