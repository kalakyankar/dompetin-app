import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () => Get.offAllNamed('/onboarding'));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final cardWidth = screenWidth * 0.62;
    final cardHeight = cardWidth * 0.66;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.3,
            colors: [Color(0xFFC7D8FF), Color(0xFF5B8DFF), Color(0xFF2F6BFF)],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // GLOW BESAR BELAKANG KARTU
            Positioned(
              top: screenHeight * 0.12,
              child: Container(
                width: screenWidth * 1.4,
                height: screenWidth * 1.4,
                decoration: BoxDecoration(
                  color: const Color(0xFFBFDBFE),
                  borderRadius: BorderRadius.circular(266),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFFBFDBFE),
                      blurRadius: 100,
                      spreadRadius: 20,
                    ),
                  ],
                ),
              ),
            ),

            // TIANG
            Positioned(
              bottom: screenHeight * 0.10,
              child: Container(
                width: screenWidth * 0.02,
                height: screenHeight * 0.42,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),

            // ALAS
            Positioned(
              bottom: screenHeight * 0.04,
              child: Container(
                width: screenWidth * 0.35,
                height: screenHeight * 0.06,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.white54,
                      blurRadius: 25,
                      spreadRadius: 3,
                    ),
                  ],
                ),
              ),
            ),

            // KARTU DOMPET
            Positioned(
              top: screenHeight * 0.26,
              child: SizedBox(
                width: cardWidth,
                height: cardHeight,
                child: Stack(
                  children: [
                    // LAYER BELAKANG 1
                    Positioned(
                      left: cardWidth * 0.08,
                      top: cardHeight * 0.08,
                      child: Container(
                        width: cardWidth * 0.92,
                        height: cardHeight * 0.87,
                        decoration: BoxDecoration(
                          color: const Color(0xFFC7E1FF),
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                    ),

                    // LAYER BELAKANG 2
                    Positioned(
                      left: cardWidth * 0.04,
                      top: cardHeight * 0.04,
                      child: Container(
                        width: cardWidth * 0.92,
                        height: cardHeight * 0.87,
                        decoration: BoxDecoration(
                          color: const Color(0xFF93C5FD),
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                    ),

                    // KARTU UTAMA
                    Container(
                      width: cardWidth * 0.92,
                      height: cardHeight * 0.87,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF6B8DE6),
                            Color(0xFF1C44A9),
                            Color(0xFF324E95),
                          ],
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 30,
                            offset: Offset(0, 12),
                          ),
                        ],
                      ),
                    ),

                    // STRIP TRANSPARAN
                    Positioned(
                      top: cardHeight * 0.23,
                      child: Container(
                        width: cardWidth * 0.92,
                        height: cardHeight * 0.17,
                        color: const Color(0xFF9FBDFA).withOpacity(0.54),
                      ),
                    ),

                    // CHIP KUNING
                    Positioned(
                      left: cardWidth * 0.08,
                      top: cardHeight * 0.48,
                      child: Container(
                        width: cardWidth * 0.28,
                        height: cardHeight * 0.23,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFCD34D),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
