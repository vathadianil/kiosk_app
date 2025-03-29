import 'package:flutter/material.dart';
import 'package:kiosk_app/utils/constants/colors.dart';
import 'package:kiosk_app/utils/device/device_utility.dart';

class TNeomarphismBtn extends StatelessWidget {
  const TNeomarphismBtn({
    super.key,
    required this.child,
    this.onPressed,
    this.btnColor = TColors.primary,
    this.showBoxShadow = true,
  });

  final Widget child;
  final Function()? onPressed;
  final Color btnColor;

  final bool showBoxShadow;

  @override
  Widget build(BuildContext context) {
    final screenWidth = TDeviceUtils.getScreenWidth(context);
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsetsDirectional.symmetric(
            horizontal: screenWidth * .05, vertical: screenWidth * .01),
        decoration: BoxDecoration(
          color: btnColor.withOpacity(.9),
          borderRadius: BorderRadius.circular(screenWidth * .1),
          boxShadow: showBoxShadow
              ? const [
                  //bottom right shadow is darker
                  BoxShadow(
                    color: TColors.black,
                    offset: Offset(6, 6),
                    blurRadius: 6,
                  ),
                  BoxShadow(
                    color: TColors.white,
                    offset: Offset(-3, -3),
                    blurRadius: 6,
                  ),
                ]
              : [],
        ),
        child: child,
      ),
    );
  }
}
