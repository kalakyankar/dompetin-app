import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../controllers/onboarding_controller.dart'
    show OnboardingController, OnboardingData;
import '../../theme/app_theme.dart';
import '../../widgets/buttons.dart';
import '../../widgets/dompetin_logo.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();

    return Scaffold(
      backgroundColor: AppTheme.onboardingBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Top logo bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const DompetinLogo(),
                ],
              ),
            ),

            // Page view
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                itemCount: controller.slides.length,
                itemBuilder: (context, index) {
                  return _OnboardingPage(
                    data: controller.slides[index],
                    index: index,
                  );
                },
              ),
            ),

            // Bottom controls
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: Column(
                children: [
                  // Page indicator
                  SmoothPageIndicator(
                    controller: controller.pageController,
                    count: controller.slides.length,
                    effect: ExpandingDotsEffect(
                      activeDotColor: AppTheme.primaryBlue,
                      dotColor: AppTheme.inputBorder,
                      dotHeight: 8,
                      dotWidth: 8,
                      expansionFactor: 3,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Navigation buttons
                  Obx(() => Row(
                        children: [
                          if (controller.currentPage.value > 0) ...[
                            OutlineButton(
                              label: 'Lewati',
                              onTap: controller.skip,
                            ),
                            const SizedBox(width: 12),
                          ],
                          Expanded(
                            child: PrimaryButton(
                              label: controller.currentPage.value ==
                                      controller.slides.length - 1
                                  ? 'Mulai Sekarang'
                                  : 'Next',
                              onTap: controller.nextPage,
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final OnboardingData data;
  final int index;

  const _OnboardingPage({required this.data, required this.index});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Illustration area with diagonal blue background
        Expanded(
          flex: 3,
          child: _OnboardingIllustration(index: index),
        ),

        // Text content
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  data.title,
                  textAlign: TextAlign.center,
                  style: AppTheme.heading2,
                ),
                const SizedBox(height: 12),
                Text(
                  data.subtitle,
                  textAlign: TextAlign.center,
                  style: AppTheme.body,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _OnboardingIllustration extends StatelessWidget {
  final int index;
  const _OnboardingIllustration({required this.index});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          // Blue diagonal background
          ClipRect(
            child: CustomPaint(
              size: Size(constraints.maxWidth, constraints.maxHeight),
              painter: _DiagonalPainter(index: index),
            ),
          ),

          // Centered illustration placeholder
          Center(
            child: _IllustrationWidget(index: index),
          ),
        ],
      );
    });
  }
}

class _DiagonalPainter extends CustomPainter {
  final int index;
  _DiagonalPainter({required this.index});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primaryBlue
      ..style = PaintingStyle.fill;

    if (index == 0) {
      // Full blue background with white bottom diagonal
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
      paint.color = AppTheme.white;
      final path = Path()
        ..moveTo(0, size.height * 0.72)
        ..lineTo(size.width, size.height * 0.55)
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close();
      canvas.drawPath(path, paint);
    } else if (index == 1) {
      // White bg with blue diagonal
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height),
          Paint()..color = AppTheme.offWhite);
      final path = Path()
        ..moveTo(0, 0)
        ..lineTo(size.width * 0.55, 0)
        ..lineTo(size.width * 0.38, size.height)
        ..lineTo(0, size.height)
        ..close();
      canvas.drawPath(path, paint);
    } else {
      // Blue bottom half diagonal
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height),
          Paint()..color = AppTheme.white);
      final path = Path()
        ..moveTo(0, size.height * 0.3)
        ..lineTo(size.width, size.height * 0.15)
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _IllustrationWidget extends StatelessWidget {
  final int index;
  const _IllustrationWidget({required this.index});

  @override
  Widget build(BuildContext context) {
    // Placeholder illustrations using shapes & emojis
    // Replace with actual Lottie animations or image assets
    final illustrations = [
      _Slide1Illustration(),
      _Slide2Illustration(),
      _Slide3Illustration(),
    ];
    return illustrations[index];
  }
}

class _Slide1Illustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: Image.asset(
            'assets/images/onboarding1.png',
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            fit: BoxFit.contain,
          ),
        );
      },
    );
  }
}

class _Slide2Illustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: Image.asset(
            'assets/images/onboarding2.png',
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            fit: BoxFit.contain,
          ),
        );
      },
    );
  }
}

class _Slide3Illustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: Image.asset(
            'assets/images/onboarding3.png',
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            fit: BoxFit.contain,
          ),
        );
      },
    );
  }
}
