import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';

class OnboardingController extends GetxController {
  late final PageController pageController;

  final currentPage = 0.obs;

  final slides = <OnboardingData>[
    OnboardingData(
      title: 'Pengeluaran nggak terkendali?',
      subtitle: 'Tanpa sadar, uang habis untuk hal-hal yang nggak penting.',
      illustrationKey: 'onboarding1',
    ),
    OnboardingData(
      title: 'Kenalin, Dompetin',
      subtitle:
          'Cara simpel buat lacak pengeluaran dan atur keuanganmu setiap hari.',
      illustrationKey: 'onboarding2',
    ),
    OnboardingData(
      title: 'Semua bisa kamu kontrol',
      subtitle: 'Dengan pencatatan yang jelas, kamu tahu ke mana uangmu pergi.',
      illustrationKey: 'onboarding3',
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
  }

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void nextPage() {
    if (currentPage.value < slides.length - 1) {
      pageController.animateToPage(
        currentPage.value + 1,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }

  void skip() {
    Get.offAllNamed(AppRoutes.login);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

class OnboardingData {
  final String title;
  final String subtitle;
  final String illustrationKey;

  const OnboardingData({
    required this.title,
    required this.subtitle,
    required this.illustrationKey,
  });
}
