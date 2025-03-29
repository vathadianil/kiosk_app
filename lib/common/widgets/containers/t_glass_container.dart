import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kiosk_app/utils/constants/colors.dart';

class TGlassContainer extends StatelessWidget {
  const TGlassContainer({
    super.key,
    this.borderRadius = 30,
    this.width = 300,
    this.height = 300,
    required this.child,
    this.onPressed,
  });
  final double borderRadius;
  final double width;
  final double height;
  final Widget child;
  final Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          width: width,
          height: height,
          color: Colors.transparent,
          child: Stack(
            children: [
              //-- Blur effect
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: Container(),
              ),

              //-- Gradient Effect

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  border: Border.all(
                    color: TColors.white,
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      TColors.white.withOpacity(0.015),
                      TColors.white.withOpacity(.4)
                    ],
                  ),
                ),
              ),

              //-- Child
              child,
            ],
          ),
        ),
      ),
    );
  }
}
