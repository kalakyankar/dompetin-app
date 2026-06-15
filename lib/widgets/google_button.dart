import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class GoogleSignInButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const GoogleSignInButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppTheme.inputBorder, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: AppTheme.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _GoogleIcon(),
            const SizedBox(width: 10),
            Text(
              label,
              style: GoogleFonts.interTight(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(painter: _GooglePainter()),
    );
  }
}

class _GooglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double s = size.width / 20;
    // Simplified Google "G" logo colors
    final colors = [
      const Color(0xFF4285F4), // blue
      const Color(0xFF34A853), // green
      const Color(0xFFFBBC05), // yellow
      const Color(0xFFEA4335), // red
    ];

    final paint = Paint()..style = PaintingStyle.fill;

    // Draw a simple colorful G circle
    paint.color = colors[0];
    canvas.drawArc(
      Rect.fromLTWH(0, 0, 20 * s, 20 * s),
      -0.5,
      1.5,
      false,
      paint
        ..strokeWidth = 3 * s
        ..style = PaintingStyle.stroke,
    );
    paint.color = colors[2];
    canvas.drawArc(
      Rect.fromLTWH(0, 0, 20 * s, 20 * s),
      1.0,
      1.2,
      false,
      paint,
    );
    paint.color = colors[1];
    canvas.drawArc(
      Rect.fromLTWH(0, 0, 20 * s, 20 * s),
      2.2,
      1.0,
      false,
      paint,
    );
    paint.color = colors[3];
    canvas.drawArc(
      Rect.fromLTWH(0, 0, 20 * s, 20 * s),
      3.2,
      1.5,
      false,
      paint,
    );

    // Horizontal bar for "G"
    paint
      ..color = colors[0]
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(10 * s, 8 * s, 10 * s, 4 * s),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DividerWithText extends StatelessWidget {
  final String text;
  const DividerWithText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppTheme.divider, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            text,
            style: GoogleFonts.interTight(
              fontSize: 13,
              color: AppTheme.textGrey,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const Expanded(child: Divider(color: AppTheme.divider, thickness: 1)),
      ],
    );
  }
}
