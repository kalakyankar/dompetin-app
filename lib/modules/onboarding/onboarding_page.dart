import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: size.height * 0.03),

            // Logo
            Image.asset('assets/images/logo.png', width: size.width * 0.45),

            SizedBox(height: size.height * 0.04),

            // Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
              child: const Text(
                'Pengeluaran nggak terkendali?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF102C6B),
                ),
              ),
            ),

            SizedBox(height: size.height * 0.015),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
              child: const Text(
                'Tanpa sadar, uang habis untuk hal-hal yang nggak penting.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Color(0xFF455A7A),
                ),
              ),
            ),

            SizedBox(height: size.height * 0.03),

            Expanded(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  // Background biru
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: size.width * 0.65,
                      height: size.height * 0.45,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF5B9BFF), Color(0xFF2F6BFF)],
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(120),
                          topRight: Radius.circular(120),
                        ),
                      ),
                    ),
                  ),

                  // Ilustrasi
                  Positioned(
                    top: 0,
                    child: Image.asset(
                      'assets/images/onboarding1.png',
                      width: size.width * 0.85,
                      fit: BoxFit.contain,
                    ),
                  ),

                  // Bottom content
                  Positioned(
                    bottom: 35,
                    left: 20,
                    right: 20,
                    child: Column(
                      children: [
                        // Indicator
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 45,
                              height: 8,
                              decoration: BoxDecoration(
                                color: const Color(0xFF0B2D74),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 20,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 20,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: size.height * 0.03),

                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size(0, 58),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  side: const BorderSide(
                                    color: Color(0xFF2F6BFF),
                                  ),
                                ),
                                child: const Text(
                                  'Lewati',
                                  style: TextStyle(
                                    color: Color(0xFF2F6BFF),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 16),

                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2F6BFF),
                                  elevation: 0,
                                  minimumSize: const Size(0, 58),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                                child: const Text(
                                  'Next',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
