import 'package:dompetin_app/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum ForgotStep { email, checkEmail, verify, resetPassword }

class ForgotPasswordController extends GetxController {
  // Step management
  final currentStep = ForgotStep.email.obs;

  // Email step
  final emailController = TextEditingController();
  final emailFormKey = GlobalKey<FormState>();
  String maskedEmail = '';

  // OTP step
  final List<TextEditingController> otpControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> otpFocusNodes = List.generate(4, (_) => FocusNode());
  final otpError = ''.obs;

  // Reset password step
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final resetFormKey = GlobalKey<FormState>();
  final isNewPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

  // Loading
  final isLoading = false.obs;

  // --- Email Step ---
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email tidak boleh kosong';
    if (!GetUtils.isEmail(value)) return 'Format email tidak valid';
    return null;
  }

  Future<void> sendEmail() async {
    if (!emailFormKey.currentState!.validate()) return;
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;

    // Mask email: b***@gmail.com
    final email = emailController.text;
    final parts = email.split('@');
    if (parts.length == 2) {
      maskedEmail = '${parts[0][0]}***@${parts[1]}';
    } else {
      maskedEmail = email;
    }

    currentStep.value = ForgotStep.checkEmail;
  }

  // --- OTP Step ---
  void onOtpChanged(String value, int index) {
    otpError.value = '';
    if (value.length == 1 && index < 3) {
      otpFocusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      otpFocusNodes[index - 1].requestFocus();
    }
  }

  Future<void> verifyOtp() async {
    final otp = otpControllers.map((c) => c.text).join();
    if (otp.length < 4) {
      otpError.value = 'Masukkan 4 digit kode OTP';
      return;
    }
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;

    // For demo: any 4-digit code works
    currentStep.value = ForgotStep.resetPassword;
  }

  // --- Reset Password Step ---
  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  String? validateNewPassword(String? value) {
    if (value == null || value.isEmpty) return 'Kata sandi tidak boleh kosong';
    if (value.length < 6) return 'Minimal 6 karakter';
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'Konfirmasi kata sandi kosong';
    if (value != newPasswordController.text) return 'Kata sandi tidak sama';
    return null;
  }

  Future<void> resetPassword() async {
    if (!resetFormKey.currentState!.validate()) return;
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;

    Get.snackbar(
      'Berhasil! 🎉',
      'Kata sandi berhasil diperbarui. Silakan masuk.',
      backgroundColor: const Color(0xFF1A6BFF),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
    Get.offNamed(AppRoutes.login);
  }

  void goBack() {
    switch (currentStep.value) {
      case ForgotStep.email:
        Get.back();
        break;
      case ForgotStep.checkEmail:
        currentStep.value = ForgotStep.email;
        break;
      case ForgotStep.verify:
        currentStep.value = ForgotStep.checkEmail;
        break;
      case ForgotStep.resetPassword:
        currentStep.value = ForgotStep.verify;
        break;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    for (final c in otpControllers) {
      c.dispose();
    }
    for (final f in otpFocusNodes) {
      f.dispose();
    }
    super.onClose();
  }
}
