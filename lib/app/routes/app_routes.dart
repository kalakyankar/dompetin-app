import 'package:dompetin_app/modules/auth/forgot_password/forgot_password_screen.dart';
import 'package:dompetin_app/modules/auth/login/login_page.dart';
import 'package:dompetin_app/modules/auth/register/register_screen.dart';
import 'package:dompetin_app/modules/home/home_screen.dart';
import 'package:dompetin_app/modules/onboarding/onboarding_page.dart';
import 'package:dompetin_app/modules/splash/splash_page.dart';
import 'package:dompetin_app/modules/transaction/pemasukan_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String pemasukan = '/pemasukan';

  static final List<GetPage> pages = [
    GetPage(
      name: splash,
      page: () => const SplashPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: onboarding,
      page: () => const OnboardingScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: login,
      page: () => const LoginScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: register,
      page: () => const RegisterScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: forgotPassword,
      page: () => const ForgotPasswordScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: home,
      page: () => const HomeScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: pemasukan,
      page: () => const PemasukanScreen(),
      transition: Transition.rightToLeft,
    ),
  ];
}
