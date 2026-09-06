// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:billing_system/core/config/routes/app_routes.dart';
import 'package:billing_system/core/services/analytics/analytics_service.dart';
import 'package:billing_system/features/user/presentation/views/fetching_details_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:billing_system/features/authentication/domain/usecases/login_user.dart';

class LoginController extends GetxController {
  final LoginUser loginUserUseCase;
  LoginController({required this.loginUserUseCase});

  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final RxBool obscurePassword = true.obs;
  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    AnalyticsService.logScreenView('Login');
  }

  void toggleObscurePassword() =>
      obscurePassword.value = !obscurePassword.value;

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value.trim())) return 'Enter a valid email';
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  Future<void> login() async {
    errorMessage.value = null;
    if (!(formKey.currentState?.validate() ?? false)) return;

    isLoading.value = true;
    try {
      final result = await loginUserUseCase(
        LoginParams(
          email: emailController.text.trim(),
          password: passwordController.text,
        ),
      );
      result.fold(
        (failure) {
          errorMessage.value = failure.message.split(':')[1];

          AnalyticsService.logEvent(
            'login_failed',
            parameters: {'reason': failure.message},
          );
        },
        (user) {
          if (user != null) {
            AnalyticsService.logEvent('login_success');

            Get.to(
              () => FetchingDetailsPage(
                userId: user.uid,
                onDone: () {
                  debugPrint(
                    "✅ User and Shop details fetched successfully. Proceeding to the next step.",
                  );
                  Get.offAllNamed(AppRoutes.dashboard);
                },
              ),
            );
          } else {
            errorMessage.value = 'Login failed. Please try again.';

            AnalyticsService.logEvent(
              'login_failed',
              parameters: {'reason': 'user_null'},
            );
          }
        },
      );
    } catch (e) {
      errorMessage.value = 'Invalid email or password. Please try again.';

      AnalyticsService.logEvent(
        'login_failed',
        parameters: {'reason': 'unknown_error', 'error': e.toString()},
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> registerShopOwner() async {
    try {
      // 1. Create Authentication User
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: "owner@test.com",
            password: "12345678",
          );

      final uid = credential.user!.uid;
      const shopId = "SHOP_001";

      final now = DateTime.now();

      // 2. Save User
      await FirebaseFirestore.instance.collection("users").doc(uid).set({
        "uid": uid,
        "shopId": shopId,
        "name": "Kartik Dhiman",
        "email": "owner@test.com",
        "phone": "9876543210",
        "role": "owner",
        "isActive": true,
        "createdAt": now,
        "lastLogin": now,
      });

      // 3. Save Shop
      await FirebaseFirestore.instance.collection("shops").doc(shopId).set({
        "id": shopId,
        "shopName": "Kartik Super Mart",

        "ownerUid": uid,
        "ownerName": "Kartik Dhiman",
        "ownerEmail": "owner@test.com",
        "ownerPhone": "9876543210",

        "address": "Roorkee, Uttarakhand",

        "isActive": true,
        "plan": "Premium",
        "subscriptionExpiry": now.add(const Duration(days: 365)),

        // 4. Business Details
        "businessDetails": {
          "gstNumber": "05ABCDE1234F1Z5",
          "panNumber": "ABCDE1234F",
          "shopImage": null,
          "businessType": "Proprietorship",
          "state": "Uttarakhand",
          "fssaiLicense": null,
          "currency": "INR",
          "financialYearStart": "1st April",
        },

        // 5. Firebase Configuration
        "firebaseConfig": {
          "androidApiKey": "AIzaSyDur5N2OwxLW6Axo3tPwAIad7_Af4Ur_Pw",
          "iosApiKey": "AIzaSyBFDa_I0NqYbhzpr9VGnZ1lurURQXLAeuY",
          "webApiKey": "AIzaSyCLWuIxPrC175MxJaq-O4zs1sD5fxXHHsU",

          "androidAppId": "1:762462200109:android:119d167c728d47e57e73a4",
          "iosAppId": "1:762462200109:ios:b8b0e4a3f6aa30f87e73a4",
          "webAppId": "1:762462200109:web:c5d984eb2c32dc017e73a4",

          "projectId": "shopmarket-92dec",
          "messagingSenderId": "762462200109",

          "storageBucket": "shopmarket-92dec.firebasestorage.app",

          "authDomain": "shopmarket-92dec.firebaseapp.com",
        },

        "createdAt": now,
        "updatedAt": now,
      });

      debugPrint("✅ Shop Registered Successfully");
    } on FirebaseAuthException catch (e) {
      debugPrint("Auth Error: ${e.message}");
    } catch (e, stackTrace) {
      debugPrint("Error: $e");
      debugPrint(stackTrace.toString());
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
