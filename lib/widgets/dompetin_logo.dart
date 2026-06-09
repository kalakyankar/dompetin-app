import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class DompetinLogo extends StatelessWidget {
  final double size;
  final bool white;

  const DompetinLogo({super.key, this.size = 1.0, this.white = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36 * size,
          height: 28 * size,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: white
                  ? [Colors.white, Colors.white70]
                  : [AppTheme.primaryBlue, AppTheme.deepBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(6 * size),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                bottom: 4 * size,
                left: 5 * size,
                child: Container(
                  width: 22 * size,
                  height: 14 * size,
                  decoration: BoxDecoration(
                    color: white ? Colors.white.withOpacity(0.3) : Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(3 * size),
                    border: Border.all(
                      color: white ? Colors.white.withOpacity(0.6) : Colors.white.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 5 * size,
                right: 5 * size,
                child: Container(
                  width: 9 * size,
                  height: 6 * size,
                  decoration: BoxDecoration(
                    color: AppTheme.accentYellow,
                    borderRadius: BorderRadius.circular(2 * size),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 8 * size),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Dompet',
                style: GoogleFonts.poppins(
                  fontSize: 18 * size,
                  fontWeight: FontWeight.w700,
                  color: white ? Colors.white : AppTheme.textDark,
                ),
              ),
              TextSpan(
                text: 'in',
                style: GoogleFonts.poppins(
                  fontSize: 18 * size,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primaryBlue,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
