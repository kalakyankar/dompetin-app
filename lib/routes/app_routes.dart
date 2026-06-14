import 'package:get/get.dart';
import '../views/splash/splash_screen.dart';
import '../views/onboarding/onboarding_screen.dart';
import '../views/login/login_screen.dart';
import '../views/register/register_screen.dart';
import '../views/forgot_password/forgot_password_screen.dart';
import '../views/home/home_screen.dart';
import '../views/pemasukan/pemasukan_screen.dart';
import '../views/pengeluaran/pengeluaran_screen.dart';
import '../views/insight/insight_screen.dart';
import '../views/scan/scan_screen.dart';
import '../views/riwayat/detail_transaksi_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String pemasukan = '/pemasukan';
  static const String pengeluaran = '/pengeluaran';
  static const String insight = '/insight';
  static const String scan = '/scan';
  static const String detailTransaksi = '/detail-transaksi';

  static final List<GetPage> pages = [
    GetPage(
        name: splash,
        page: () => const SplashScreen(),
        transition: Transition.fadeIn),
    GetPage(
        name: onboarding,
        page: () => const OnboardingScreen(),
        transition: Transition.rightToLeft),
    GetPage(
        name: login,
        page: () => const LoginScreen(),
        transition: Transition.rightToLeft),
    GetPage(
        name: register,
        page: () => const RegisterScreen(),
        transition: Transition.rightToLeft),
    GetPage(
        name: forgotPassword,
        page: () => const ForgotPasswordScreen(),
        transition: Transition.rightToLeft),
    GetPage(
        name: home,
        page: () => const HomeScreen(),
        transition: Transition.fadeIn),
    GetPage(
        name: pemasukan,
        page: () => const PemasukanScreen(),
        transition: Transition.rightToLeft),
    GetPage(
        name: pengeluaran,
        page: () => const PengeluaranScreen(),
        transition: Transition.rightToLeft),
    GetPage(
        name: insight,
        page: () => const InsightScreen(),
        transition: Transition.rightToLeft),
    GetPage(
        name: scan,
        page: () => const ScanScreen(),
        transition: Transition.downToUp),
    GetPage(
        name: detailTransaksi,
        page: () => const DetailTransaksiScreen(),
        transition: Transition.rightToLeft),
  ];
}
