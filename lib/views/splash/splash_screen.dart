import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/splash_controller.dart';
import '../../theme/app_theme.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<SplashController>();
    return Scaffold(
      // Hanya menggunakan primary color sesuai permintaan
      backgroundColor: AppTheme.primaryBlue,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 1. Eclipse di bawah
            Positioned(
              bottom: -20, // Sesuaikan offset letak eclipse bawah
              child: Image.asset(
                'assets/images/ellipse83.png', // Ganti dengan path eclipse bawahmu
                width: 160,
                height: 91,
                fit: BoxFit.contain,
              ),
            ),

            // 2. Garis PNG putih dari tengah (bawah kartu/logo) sampai ke eclipse bawah
            Positioned(
              top: MediaQuery.of(context).size.height * 0.5 +
                  60, // Mulai tepat dari bawah logo/kartu di tengah
              bottom: 80, // Memanjang sampai menyentuh area eclipse bawah
              child: Image.asset(
                'assets/images/line39.png', // Ganti dengan path garis putihmu
                fit: BoxFit.fitHeight,
                // Agar memanjang mengisi ruang kosong
              ),
            ),

            // 3. Eclipse gradien di tengah
            Center(
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Color(0xFFBFDBFE),
                      AppTheme.primaryBlue,
                    ],
                    center: Alignment.center,
                    radius: 0.75,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFBFDBFE).withOpacity(0.5),
                      blurRadius: 100,
                      spreadRadius: 0,
                    ),
                  ],
                ),
              ),
            ),

            // 4. Image Logo / Kartu di atas eclipse tengah (menggunakan animasi pop-up agar tetap smooth)
            Center(
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 800),
                tween: Tween(begin: 0.0, end: 1.0),
                curve: Curves.easeOutBack,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: child,
                  );
                },
                child: Image.asset(
                  'assets/images/logo.png', // Ganti dengan path logo/kartumu
                  width: 200,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // 5. Loading indicator (Opsional, posisinya diletakkan di area eclipse bawah)
            Positioned(
              bottom: 60,
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
