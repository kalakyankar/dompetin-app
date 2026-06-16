import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/login_controller.dart';
import '../../theme/app_theme.dart';
import '../../widgets/buttons.dart';
import '../../widgets/dompetin_logo.dart';
import '../../widgets/google_button.dart';
import '../../routes/app_routes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

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
                    onTap: () => Get.offNamed(AppRoutes.onboarding),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.inputBorder),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          size: 16, color: AppTheme.textDark),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // Icon
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: DompetinLogo(size: 0.8),
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                Text('Masuk', style: AppTheme.heading2),
                const SizedBox(height: 8),
                Text(
                  'Selamat datang kembali di Dompetin!',
                  style: AppTheme.body,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

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
                Obx(() => TextFormField(
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
                    )),
                const SizedBox(height: 24),

                // Login button
                Obx(() => PrimaryButton(
                      label: 'Masuk',
                      onTap: controller.login,
                      isLoading: controller.isLoading.value,
                    )),
                const SizedBox(height: 14),

                // Forgot password
                Center(
                  child: TextButton(
                    onPressed: controller.forgotPassword,
                    child: Text(
                      'Lupa Kata Sandi?',
                      style: TextStyle(
                        color: AppTheme.primaryBlue,
                        fontSize: 13,

                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Divider
                const DividerWithText(text: 'atau'),
                const SizedBox(height: 16),

                // Google sign in
                GoogleSignInButton(
                  label: 'Masuk dengan Google',
                  onTap: controller.loginWithGoogle,
                ),
                const SizedBox(height: 28),

                // Register link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        'Tidak punya akun? ',
                        style: AppTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.register),
                      child: Text(
                        'Daftar Sekarang',
                        style: TextStyle(
                          color: AppTheme.primaryBlue,
                          fontSize: 12,
  
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
