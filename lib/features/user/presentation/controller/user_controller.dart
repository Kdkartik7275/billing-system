import 'package:billing_system/app/app_settings.dart';
import 'package:billing_system/core/config/routes/app_routes.dart';
import 'package:billing_system/core/di/init_dependencies.dart';
import 'package:billing_system/core/firebase/shop_firebase_service.dart';
import 'package:billing_system/core/security/biometric_service.dart';
import 'package:billing_system/core/services/analytics/analytics_service.dart';
import 'package:billing_system/core/services/crash/crashlytics_service.dart';
import 'package:billing_system/features/authentication/domain/usecases/logout_usecase.dart';
import 'package:billing_system/features/user/data/models/shop_model.dart';
import 'package:billing_system/features/user/data/models/user_model.dart';
import 'package:billing_system/features/user/domain/entity/shop_entity.dart';
import 'package:billing_system/features/user/domain/entity/user_entity.dart';
import 'package:billing_system/features/user/domain/usecases/get_shop_by_id.dart';
import 'package:billing_system/features/user/domain/usecases/get_user_by_id.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class UserController extends GetxController {
  final GetUserByIdUseCase _getUserByIdUseCase;
  final GetShopByIdUseCase _getShopByIdUseCase;
  final ShopFirebaseService _shopFirebaseService;
  final LogoutUsecase _logoutUsecase;
  final BiometricService _biometricService;

  UserController({
    required GetUserByIdUseCase getUserByIdUseCase,
    required GetShopByIdUseCase getShopByIdUseCase,
    required ShopFirebaseService shopFirebaseService,
    required LogoutUsecase logoutUsecase,
    required BiometricService biometricService,
  }) : _getUserByIdUseCase = getUserByIdUseCase,
       _getShopByIdUseCase = getShopByIdUseCase,
       _logoutUsecase = logoutUsecase,
       _biometricService = biometricService,
       _shopFirebaseService = shopFirebaseService;

  final Rx<UserEntity?> user = Rx<UserEntity?>(null);
  final Rx<ShopEntity?> shop = Rx<ShopEntity?>(null);

  final RxString statusMessage = 'Getting things ready...'.obs;

  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();

  Future<void> _tagSessionContext() async {
    final currentUser = user.value;
    final currentShop = shop.value;
    if (currentUser == null || currentShop == null) return;

    await CrashlyticsService.setUserId(currentUser.uid);
    await CrashlyticsService.setCustomKey('shop_id', currentShop.id);
    await CrashlyticsService.setCustomKey('shop_name', currentShop.shopName);
    await CrashlyticsService.setCustomKey('user_role', currentUser.role.name);

    await AnalyticsService.setUserId(currentUser.uid);
    await AnalyticsService.setUserProperty('shop_id', currentShop.id);
    await AnalyticsService.setUserProperty('user_role', currentUser.role.name);
  }

  Future<bool> fetchAccountDetails({required String userId}) async {
    isLoading.value = true;
    errorMessage.value = null;

    statusMessage.value = 'Fetching your account...';
    final userResult = await _getUserByIdUseCase.call(userId);

    bool userOk = true;
    userResult.fold(
      (failure) {
        userOk = false;
        debugPrint('Error fetching user: $failure');
        CrashlyticsService.recordError(
          failure,
          StackTrace.current,
          reason: 'UserController.fetchAccountDetails - get user failed',
        );
        errorMessage.value =
            'We couldn\'t load your account. Please try again.';
      },
      (fetchedUser) {
        user.value = fetchedUser;
      },
    );

    if (!userOk) {
      isLoading.value = false;
      return false;
    }

    statusMessage.value = 'Fetching your shop details...';
    final shopResult = await _getShopByIdUseCase.call(user.value!.shopId);

    bool shopOk = true;
    shopResult.fold(
      (failure) {
        shopOk = false;
        debugPrint('Error fetching shop: $failure');
        CrashlyticsService.recordError(
          failure,
          StackTrace.current,
          reason: 'UserController.fetchAccountDetails - get shop failed',
        );
        errorMessage.value =
            'We couldn\'t load your shop details. Please try again.';
      },
      (fetchedShop) {
        shop.value = fetchedShop;
      },
    );

    if (!shopOk) {
      isLoading.value = false;
      return false;
    }

    statusMessage.value = 'Initializing shop...';

    try {
      await _shopFirebaseService.initialize(shop.value!.firebaseConfig);
    } catch (e, stackTrace) {
      debugPrint(e.toString());
      debugPrint(stackTrace.toString());
      await CrashlyticsService.recordError(
        e,
        stackTrace,
        reason:
            'UserController.fetchAccountDetails - shop firebase init failed',
      );
    }

    await _tagSessionContext();
    await AnalyticsService.logEvent(
      'login_success',
      parameters: {'method': 'fresh_fetch'},
    );

    statusMessage.value = 'All set!';
    isLoading.value = false;

    return true;
  }

  Future<bool> restoreSession() async {
    debugPrint('Restoring session...');
    isLoading.value = true;
    errorMessage.value = null;

    try {
      statusMessage.value = 'Restoring your session...';

      final userBox = sl<Box<UserModel>>();
      final shopBox = sl<Box<ShopModel>>();

      if (userBox.isEmpty || shopBox.isEmpty) {
        isLoading.value = false;
        return false;
      }

      user.value = userBox.get('current_user')?.toEntity();
      shop.value = shopBox.get('current_shop')?.toEntity();

      if (user.value == null || shop.value == null) {
        isLoading.value = false;
        return false;
      }

      statusMessage.value = 'Initializing shop...';

      await _shopFirebaseService.initialize(shop.value!.firebaseConfig);

      await _tagSessionContext();
      await AnalyticsService.logEvent(
        'login_success',
        parameters: {'method': 'restored_session'},
      );

      statusMessage.value = 'Ready';
      isLoading.value = false;
      return true;
    } catch (e, stackTrace) {
      debugPrint(e.toString());
      debugPrint(stackTrace.toString());
      await CrashlyticsService.recordError(
        e,
        stackTrace,
        reason: 'UserController.restoreSession',
      );

      errorMessage.value = e.toString();
      isLoading.value = false;
      return false;
    }
  }

  Future<bool> authenticateWithBiometric() async {
    try {
      if (!AppSettings.biometricEnabled) {
        debugPrint('[UserController] Biometric login is disabled');
        return true;
      }

      final available = await _biometricService.isAvailable();

      if (!available) {
        debugPrint('[UserController] Biometric authentication unavailable');
        return true;
      }

      final biometrics = await _biometricService.getAvailableBiometrics();

      if (biometrics.isEmpty) {
        debugPrint('[UserController] No enrolled biometrics');
        return true;
      }

      debugPrint('[UserController] Requesting biometric authentication');

      final authenticated = await _biometricService.authenticate(
        reason: 'Authenticate to access your billing software',
      );

      debugPrint('[UserController] Biometric result: $authenticated');

      await AnalyticsService.logEvent(
        'biometric_auth_attempt',
        parameters: {'result': authenticated},
      );

      return authenticated;
    } catch (e, stackTrace) {
      debugPrint('[UserController] Biometric authentication error: $e');
      debugPrint('[UserController] StackTrace: $stackTrace');
      await CrashlyticsService.recordError(
        e,
        stackTrace,
        reason: 'UserController.authenticateWithBiometric',
      );

      return false;
    }
  }

  Future<String> checkSession() async {
    try {
      final authUser = FirebaseAuth.instance.currentUser;

      if (authUser == null) {
        debugPrint('[UserController] No Firebase session found');
        return AppRoutes.login;
      }

      debugPrint('[UserController] Firebase session found');

      final restored = await restoreSession();

      if (restored) {
        debugPrint('[UserController] Session restored successfully');

        final authenticated = await authenticateWithBiometric();

        if (!authenticated) {
          debugPrint('[UserController] Biometric authentication failed');
          return AppRoutes.login;
        }

        return AppRoutes.dashboard;
      }

      debugPrint('[UserController] Local session restore failed');

      final loaded = await fetchAccountDetails(userId: authUser.uid);

      if (loaded) {
        debugPrint('[UserController] Account details loaded');

        final authenticated = await authenticateWithBiometric();

        if (!authenticated) {
          debugPrint('[UserController] Biometric authentication failed');
          return AppRoutes.login;
        }

        return AppRoutes.dashboard;
      }

      debugPrint('[UserController] Unable to load account');

      await FirebaseAuth.instance.signOut();

      return AppRoutes.login;
    } catch (e, stackTrace) {
      debugPrint('[UserController] checkSession error: $e');
      debugPrint('[UserController] StackTrace: $stackTrace');
      await CrashlyticsService.recordError(
        e,
        stackTrace,
        reason: 'UserController.checkSession',
      );

      return AppRoutes.login;
    }
  }

  Future<bool> logout() async {
    final result = await _logoutUsecase.call();

    return result.fold(
      (failure) {
        debugPrint('Error logging out: ${failure.message}');
        CrashlyticsService.recordError(
          failure,
          StackTrace.current,
          reason: 'UserController.logout',
        );
        errorMessage.value = failure.message;
        return false;
      },
      (_) {
        AnalyticsService.logEvent('logout');
        user.value = null;
        shop.value = null;
        errorMessage.value = null;
        statusMessage.value = 'Getting things ready...';
        return true;
      },
    );
  }
}
