import 'package:dompetin_app/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) return 'Nama tidak boleh kosong';
    if (value.length < 2) return 'Nama terlalu pendek';
    return null;
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

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty)
      return 'Konfirmasi kata sandi tidak boleh kosong';
    if (value != passwordController.text) return 'Kata sandi tidak sama';
    return null;
  }

  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;
    Get.snackbar(
      'Berhasil!',
      'Akun berhasil dibuat. Silakan masuk.',
      backgroundColor: const Color(0xFF1A6BFF),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
    Get.offNamed(AppRoutes.login);
  }

  Future<void> registerWithGoogle() async {
    Get.snackbar(
      'Google',
      'Daftar dengan Google ditekan',
      snackPosition: SnackPosition.TOP,
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
