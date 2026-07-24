import 'package:billing_system/core/firebase/shop_firebase_service.dart';
import 'package:billing_system/core/network/connection_checker.dart';
import 'package:billing_system/core/services/storage/storage_service.dart';
import 'package:billing_system/features/authentication/data/data_source/authentication_remote_data_source.dart';
import 'package:billing_system/features/authentication/data/repository_impl/authentication_repository_impl.dart';
import 'package:billing_system/features/authentication/domain/repository/authentication_repository.dart';
import 'package:billing_system/features/authentication/domain/usecases/login_user.dart';
import 'package:billing_system/features/authentication/domain/usecases/request_shop_registration.dart';

import 'package:billing_system/features/user/data/data_source/user_local_data_source.dart';
import 'package:billing_system/features/user/data/data_source/user_remote_data_source.dart';
import 'package:billing_system/features/user/data/models/shop_model.dart';
import 'package:billing_system/features/user/data/models/user_model.dart';
import 'package:billing_system/features/user/data/repository_impl/user_repository_impl.dart';
import 'package:billing_system/features/user/domain/repository/user_repository.dart';
import 'package:billing_system/features/user/domain/usecases/get_shop_by_id.dart';
import 'package:billing_system/features/user/domain/usecases/get_user_by_id.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

part 'init_dependencies_main.dart';
