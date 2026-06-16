import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../controllers/login_controller.dart';
import '../controllers/onboarding_controller.dart';
import '../controllers/pemasukan_controller.dart';
import '../controllers/pengeluaran_controller.dart';
import '../controllers/register_controller.dart';
import '../controllers/forgot_password_controller.dart';
import '../controllers/target_controller.dart';
import '../controllers/profil_controller.dart';
import '../controllers/scan_controller.dart';
import '../controllers/riwayat_controller.dart';
import '../controllers/splash_controller.dart';
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
        binding: BindingsBuilder(() {
          Get.lazyPut<SplashController>(() => SplashController());
        }),
        transition: Transition.fadeIn),
    GetPage(
        name: onboarding,
        page: () => const OnboardingScreen(),
        binding: BindingsBuilder(() {
          Get.lazyPut<OnboardingController>(() => OnboardingController());
        }),
        transition: Transition.rightToLeft),
    GetPage(
        name: login,
        page: () => const LoginScreen(),
        binding: BindingsBuilder(() {
          Get.lazyPut<LoginController>(() => LoginController());
        }),
        transition: Transition.rightToLeft),
    GetPage(
        name: register,
        page: () => const RegisterScreen(),
        binding: BindingsBuilder(() {
          Get.lazyPut<RegisterController>(() => RegisterController());
        }),
        transition: Transition.rightToLeft),
    GetPage(
        name: forgotPassword,
        page: () => const ForgotPasswordScreen(),
        binding: BindingsBuilder(() {
          Get.lazyPut<ForgotPasswordController>(() => ForgotPasswordController());
        }),
        transition: Transition.rightToLeft),
    GetPage(
        name: home,
        page: () => const HomeScreen(),
        binding: BindingsBuilder(() {
          Get.lazyPut<HomeController>(() => HomeController());
          Get.put<TargetController>(TargetController());
          Get.put<RiwayatController>(RiwayatController());
          Get.put<ProfilController>(ProfilController());
        }),
        transition: Transition.fadeIn),
    GetPage(
        name: pemasukan,
        page: () => const PemasukanScreen(),
        binding: BindingsBuilder(() {
          Get.put<PemasukanController>(PemasukanController());
        }),
        transition: Transition.rightToLeft),
    GetPage(
        name: pengeluaran,
        page: () => const PengeluaranScreen(),
        binding: BindingsBuilder(() {
          Get.put<PengeluaranController>(PengeluaranController());
        }),
        transition: Transition.rightToLeft),
    GetPage(
        name: insight,
        page: () => const InsightScreen(),
        transition: Transition.rightToLeft),
    GetPage(
        name: scan,
        page: () => const ScanScreen(),
        binding: BindingsBuilder(() {
          Get.lazyPut<ScanController>(() => ScanController());
        }),
        transition: Transition.downToUp),
    GetPage(
        name: detailTransaksi,
        page: () => const DetailTransaksiScreen(),
        transition: Transition.rightToLeft),
  ];
}
