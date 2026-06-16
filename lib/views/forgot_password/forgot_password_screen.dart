import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controllers/forgot_password_controller.dart';
import '../../theme/app_theme.dart';
import '../../widgets/buttons.dart';
import '../../widgets/dompetin_logo.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ForgotPasswordController>();

    return Scaffold(
      backgroundColor: AppTheme.white,
      body: SafeArea(
        child: Obx(() {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            transitionBuilder: (child, animation) => SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.08, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              )),
              child: FadeTransition(opacity: animation, child: child),
            ),
            child: _buildStep(controller),
          );
        }),
      ),
    );
  }

  Widget _buildStep(ForgotPasswordController controller) {
    switch (controller.currentStep.value) {
      case ForgotStep.email:
        return _EmailStep(key: const ValueKey('email'), controller: controller);
      case ForgotStep.checkEmail:
        return _CheckEmailStep(
            key: const ValueKey('checkEmail'), controller: controller);
      case ForgotStep.verify:
        return _VerifyStep(
            key: const ValueKey('verify'), controller: controller);
      case ForgotStep.resetPassword:
        return _ResetPasswordStep(
            key: const ValueKey('reset'), controller: controller);
    }
  }
}

// ─── Shared Header Widget ────────────────────────────────────────────────────

class _StepHeader extends StatelessWidget {
  final ForgotPasswordController controller;
  final String title;
  final String? subtitle;

  const _StepHeader({
    required this.controller,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: controller.goBack,
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
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Center(child: DompetinLogo(size: 0.8)),
        ),
        const SizedBox(height: 20),
        Text(title, style: AppTheme.heading2, textAlign: TextAlign.center),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            style: AppTheme.body,
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: 32),
      ],
    );
  }
}

// ─── Step 1: Email Input ──────────────────────────────────────────────────────

class _EmailStep extends StatelessWidget {
  final ForgotPasswordController controller;
  const _EmailStep({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: controller.emailFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _StepHeader(
              controller: controller,
              title: 'Lupa Kata Sandi',
              subtitle:
                  'Masukkan email yang terdaftar untuk menerima tautan reset kata sandi.',
            ),
            Text('Email', style: AppTheme.label),
            const SizedBox(height: 8),
            TextFormField(
              controller: controller.emailController,
              keyboardType: TextInputType.emailAddress,
              validator: controller.validateEmail,
              style: AppTheme.label,
              decoration: AppTheme.inputDecoration(hint: 'Alamat email'),
            ),
            const SizedBox(height: 28),
            Obx(() => PrimaryButton(
                  label: 'Kirimkan',
                  onTap: controller.sendEmail,
                  isLoading: controller.isLoading.value,
                )),
          ],
        ),
      ),
    );
  }
}

// ─── Step 2: Check Email ──────────────────────────────────────────────────────

class _CheckEmailStep extends StatelessWidget {
  final ForgotPasswordController controller;
  const _CheckEmailStep({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _StepHeader(
            controller: controller,
            title: 'Lupa Kata Sandi',
          ),

          // Email check illustration
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.offWhite,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text('📧', style: TextStyle(fontSize: 56)),
                const SizedBox(height: 16),
                Text(
                  'Check Email Anda',
                  style: AppTheme.heading3,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: AppTheme.body,
                    children: [
                      const TextSpan(
                          text:
                              'Kami telah mengirimkan tautan pengaturan ulang ke '),
                      TextSpan(
                        text: controller.maskedEmail,
                        style: const TextStyle(
                          color: AppTheme.primaryBlue,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,

                        ),
                      ),
                      const TextSpan(
                          text:
                              ', masukkan 5 digit yang di sebutkan dalam email.'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // OTP input boxes
          _OtpInputRow(controller: controller),

          const SizedBox(height: 12),
          Obx(() => controller.otpError.value.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    controller.otpError.value,
                    style: const TextStyle(
                        color: AppTheme.errorRed,
                        fontSize: 12),
                  ),
                )
              : const SizedBox()),

          const SizedBox(height: 8),
          Obx(() => PrimaryButton(
                label: 'Verifikasi Kode',
                onTap: controller.verifyOtp,
                isLoading: controller.isLoading.value,
              )),

          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text('Tidak menerima email? ', style: AppTheme.bodySmall, overflow: TextOverflow.ellipsis),
              ),
              GestureDetector(
                onTap: () {
                  controller.currentStep.value = ForgotStep.email;
                },
                child: const Text(
                  'Kirim ulang',
                  style: TextStyle(
                    color: AppTheme.primaryBlue,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OtpInputRow extends StatelessWidget {
  final ForgotPasswordController controller;
  const _OtpInputRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: 64,
            child: TextField(
            controller: controller.otpControllers[index],
            focusNode: controller.otpFocusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
            ),
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: AppTheme.inputFill,
              contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppTheme.inputBorder, width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppTheme.inputBorder, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppTheme.primaryBlue, width: 2),
              ),
            ),
            onChanged: (value) => controller.onOtpChanged(value, index),
          ),
        ),
        );
      }),
    );
  }
}

// ─── Step 3: Verify Success → shown briefly, auto-advances ───────────────────
// In this design, verify step is combined with checkEmail (the button triggers it)
// So step 3 is just the "Atur Ulang Kata Sandi" confirmation screen
class _VerifyStep extends StatelessWidget {
  final ForgotPasswordController controller;
  const _VerifyStep({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _StepHeader(
            controller: controller,
            title: 'Atur Ulang Kata Sandi',
            subtitle:
                'Kata sandi Anda telah berhasil di atur ulang. Klik untuk konfirmasi setting atur kata sandi.',
          ),
          const SizedBox(height: 16),
          const Text('✅', style: TextStyle(fontSize: 72)),
          const SizedBox(height: 32),
          PrimaryButton(
            label: 'Verifikasi Kode',
            onTap: () {
              controller.currentStep.value = ForgotStep.resetPassword;
            },
          ),
        ],
      ),
    );
  }
}

// ─── Step 4: Reset Password ───────────────────────────────────────────────────

class _ResetPasswordStep extends StatelessWidget {
  final ForgotPasswordController controller;
  const _ResetPasswordStep({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: controller.resetFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _StepHeader(
              controller: controller,
              title: 'Atur Ulang Kata Sandi',
              subtitle:
                  'Buat kata sandi baru. Pastikan kata sandi tersebut berbeda dari kata sandi sebelumnya demi keamanan.',
            ),
            Text('Kata Sandi', style: AppTheme.label),
            const SizedBox(height: 8),
            Obx(() => TextFormField(
                  controller: controller.newPasswordController,
                  obscureText: !controller.isNewPasswordVisible.value,
                  validator: controller.validateNewPassword,
                  style: AppTheme.label,
                  decoration: AppTheme.inputDecoration(
                    hint: 'Kata Sandi',
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isNewPasswordVisible.value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppTheme.textGrey,
                        size: 20,
                      ),
                      onPressed: controller.toggleNewPasswordVisibility,
                    ),
                  ),
                )),
            const SizedBox(height: 16),
            Text('Konfirmasi Kata Sandi', style: AppTheme.label),
            const SizedBox(height: 8),
            Obx(() => TextFormField(
                  controller: controller.confirmPasswordController,
                  obscureText: !controller.isConfirmPasswordVisible.value,
                  validator: controller.validateConfirmPassword,
                  style: AppTheme.label,
                  decoration: AppTheme.inputDecoration(
                    hint: 'Ulangi Kata Sandi',
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
                )),
            const SizedBox(height: 28),
            Obx(() => PrimaryButton(
                  label: 'Perbaru Kata Sandi',
                  onTap: controller.resetPassword,
                  isLoading: controller.isLoading.value,
                )),
          ],
        ),
      ),
    );
  }
}
