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
            image: DecorationImage(
              image: AssetImage('assets/images/logo.png'),
              fit: BoxFit.contain,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                bottom: 4 * size,
                left: 5 * size,
                child: SizedBox(
                  width: 22 * size,
                  height: 14 * size,
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
                text: 'Dompe',
                style: GoogleFonts.interTight(
                  fontSize: 18 * size,
                  fontWeight: FontWeight.w700,
                  color: white ? Colors.white : AppTheme.textDark,
                ),
              ),
              TextSpan(
                text: 'tin',
                style: GoogleFonts.interTight(
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
