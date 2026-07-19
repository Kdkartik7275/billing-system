import 'package:billing_system/core/config/routes/app_routes.dart';
import 'package:billing_system/core/di/init_dependencies.dart';
import 'package:billing_system/core/firebase/shop_firebase_service.dart';
import 'package:billing_system/features/authentication/presentation/views/login_page.dart';
import 'package:billing_system/features/inventory/domain/usecases/get_products_usecase.dart';
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

  UserController({
    required GetUserByIdUseCase getUserByIdUseCase,
    required GetShopByIdUseCase getShopByIdUseCase,
    required ShopFirebaseService shopFirebaseService,
  }) : _getUserByIdUseCase = getUserByIdUseCase,
       _getShopByIdUseCase = getShopByIdUseCase,
       _shopFirebaseService = shopFirebaseService;

  final Rx<UserEntity?> user = Rx<UserEntity?>(null);
  final Rx<ShopEntity?> shop = Rx<ShopEntity?>(null);

  final RxString statusMessage = 'Getting things ready...'.obs;

  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();

  Future<void> fetchUser(String userId) async {
    final result = await _getUserByIdUseCase.call(userId);
    result.fold(
      (failure) {
        // Handle failure
        debugPrint('Error fetching user: $failure');
      },
      (fetchedUser) {
        // Handle success
        user.value = fetchedUser;
        debugPrint('Fetched user: ${fetchedUser.name}');
      },
    );
  }

  Future<void> fetchShop(String shopId) async {
    final result = await _getShopByIdUseCase.call(shopId);
    result.fold(
      (failure) {
        // Handle failure
        debugPrint('Error fetching shop: $failure');
      },
      (fetchedShop) {
        // Handle success
        shop.value = fetchedShop;
        debugPrint('Fetched shop: ${fetchedShop.shopName}');
      },
    );
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
    }

    final productsResult = await sl<GetProductsUsecase>().call();
    productsResult.fold(
      (failure) {
        debugPrint('Error fetching products: $failure');
        errorMessage.value =
            'We couldn\'t load your products. Please try again.';
        isLoading.value = false;
        return false;
      },
      (fetchedProducts) {
        debugPrint('Fetched products: ${fetchedProducts.length}');
      },
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

      statusMessage.value = 'Ready';
      isLoading.value = false;
      return true;
    } catch (e, stackTrace) {
      debugPrint(e.toString());
      debugPrint(stackTrace.toString());

      errorMessage.value = e.toString();
      isLoading.value = false;
      return false;
    }
  }

  Future<String> checkSession() async {
    final authUser = FirebaseAuth.instance.currentUser;

    if (authUser == null) {
      return AppRoutes.login;
    }

    final restored = await restoreSession();

    if (restored) {
      return AppRoutes.dashboard;
    }

    final loaded = await fetchAccountDetails(userId: authUser.uid);

    if (loaded) {
      return AppRoutes.dashboard;
    }

    await FirebaseAuth.instance.signOut();
    return AppRoutes.login;
  }
}
