import 'package:dompetin_app/app/routes/app_routes.dart';
import 'package:dompetin_app/app/themes/app_theme.dart';
import 'package:dompetin_app/modules/auth/register/register_controller.dart';
import 'package:dompetin_app/widgets/buttons.dart';
import 'package:dompetin_app/widgets/dompetinlogo.dart';
import 'package:dompetin_app/widgets/google_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegisterController());

    return Scaffold(
      backgroundColor: AppTheme.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // Back button
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.inputBorder),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 16,
                        color: AppTheme.textDark,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // Icon
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(child: DompetinLogo(size: 0.8)),
                ),
                const SizedBox(height: 20),

                // Title
                Text('Daftar', style: AppTheme.heading2),
                const SizedBox(height: 8),
                Text(
                  'Buat akun Dompetin-mu sekarang!',
                  style: AppTheme.body,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Name field
                _FieldLabel('Nama'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: controller.nameController,
                  keyboardType: TextInputType.name,
                  validator: controller.validateName,
                  style: AppTheme.label,
                  decoration: AppTheme.inputDecoration(hint: 'Alamat email'),
                ),
                const SizedBox(height: 16),

                // Email field
                _FieldLabel('Email'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: controller.validateEmail,
                  style: AppTheme.label,
                  decoration: AppTheme.inputDecoration(hint: 'Alamat email'),
                ),
                const SizedBox(height: 16),

                // Password field
                _FieldLabel('Kata Sandi'),
                const SizedBox(height: 8),
                Obx(
                  () => TextFormField(
                    controller: controller.passwordController,
                    obscureText: !controller.isPasswordVisible.value,
                    validator: controller.validatePassword,
                    style: AppTheme.label,
                    decoration: AppTheme.inputDecoration(
                      hint: 'Kata Sandi',
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordVisible.value
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppTheme.textGrey,
                          size: 20,
                        ),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Confirm password field
                _FieldLabel('Konfirmasi Kata Sandi'),
                const SizedBox(height: 8),
                Obx(
                  () => TextFormField(
                    controller: controller.confirmPasswordController,
                    obscureText: !controller.isConfirmPasswordVisible.value,
                    validator: controller.validateConfirmPassword,
                    style: AppTheme.label,
                    decoration: AppTheme.inputDecoration(
                      hint: 'Ulangi Kata sandi',
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isConfirmPasswordVisible.value
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppTheme.textGrey,
                          size: 20,
                        ),
                        onPressed: controller.toggleConfirmPasswordVisibility,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // Register button
                Obx(
                  () => PrimaryButton(
                    label: 'Daftar',
                    onTap: controller.register,
                    isLoading: controller.isLoading.value,
                  ),
                ),
                const SizedBox(height: 16),

                // Divider
                const DividerWithText(text: 'atau'),
                const SizedBox(height: 16),

                // Google sign in
                GoogleSignInButton(
                  label: 'Masuk dengan Google',
                  onTap: controller.registerWithGoogle,
                ),
                const SizedBox(height: 28),

                // Login link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Sudah punya akun? ', style: AppTheme.bodySmall),
                    GestureDetector(
                      onTap: () => Get.offNamed(AppRoutes.login),
                      child: Text(
                        'Masuk Sekarang',
                        style: TextStyle(
                          color: AppTheme.primaryBlue,
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(text, style: AppTheme.label),
    );
  }
}
