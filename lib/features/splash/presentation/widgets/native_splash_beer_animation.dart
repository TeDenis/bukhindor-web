import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NativeSplashBeerAnimation extends StatelessWidget {
  const NativeSplashBeerAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      height: 600,
      child: SvgPicture.asset(
        'web/icons/load.svg',
        fit: BoxFit.cover,
      ),
    );
  }
} 