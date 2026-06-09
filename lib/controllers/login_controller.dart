import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';
import 'home_controller.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final isPasswordVisible = false.obs;
  final isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email tidak boleh kosong';
    if (!GetUtils.isEmail(value)) return 'Format email tidak valid';
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Kata sandi tidak boleh kosong';
    if (value.length < 6) return 'Minimal 6 karakter';
    return null;
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;
    Get.offAllNamed(AppRoutes.home);
    // Seed dummy data for demo
    Future.delayed(const Duration(milliseconds: 300), () {
      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().seedDummyData();
      }
    });
  }

  Future<void> loginWithGoogle() async {
    Get.snackbar(
      'Google',
      'Masuk dengan Google ditekan',
      snackPosition: SnackPosition.TOP,
    );
  }

  void forgotPassword() {
    Get.toNamed(AppRoutes.forgotPassword);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
