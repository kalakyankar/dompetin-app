import 'package:get/get.dart';

import '../../modules/splash/splash_page.dart';
import '../../modules/onboarding/onboarding_page.dart';

class AppPages {
  static final routes = [
    GetPage(name: '/', page: () => const SplashPage()),
    GetPage(name: '/onboarding', page: () => const OnboardingPage()),
  ];
}
