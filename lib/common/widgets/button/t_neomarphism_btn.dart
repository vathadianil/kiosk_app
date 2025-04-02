import 'package:flutter/material.dart';
import 'package:kiosk_app/utils/constants/colors.dart';
import 'package:kiosk_app/utils/device/device_utility.dart';

class TNeomorphismBtn extends StatefulWidget {
  const TNeomorphismBtn({
    super.key,
    required this.child,
    this.onPressed,
    this.btnColor = TColors.primary,
    this.showBoxShadow = true, // Controls shadow visibility
    this.animateBoxShadow = false, // Controls animation
  });

  final Widget child;
  final Function()? onPressed;
  final Color btnColor;
  final bool showBoxShadow;
  final bool animateBoxShadow;

  @override
  _TNeomorphismBtnState createState() => _TNeomorphismBtnState();
}

class _TNeomorphismBtnState extends State<TNeomorphismBtn>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shadowIntensity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _shadowIntensity = Tween<double>(begin: 2, end: 6).animate(_controller);

    // Start animation if animateBoxShadow is true at the beginning
    if (widget.showBoxShadow && widget.animateBoxShadow) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant TNeomorphismBtn oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.showBoxShadow) {
      if (widget.animateBoxShadow && !oldWidget.animateBoxShadow) {
        // Start animation when animateBoxShadow becomes true
        _controller.repeat(reverse: true);
      } else if (!widget.animateBoxShadow && oldWidget.animateBoxShadow) {
        // Stop animation when animateBoxShadow becomes false
        _controller.stop();
      }
    } else {
      // Stop animation and reset if showBoxShadow is false
      _controller.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = TDeviceUtils.getScreenWidth(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return InkWell(
          onTap: widget.onPressed,
          child: Container(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: screenWidth * .05,
              vertical: screenWidth * .01,
            ),
            decoration: BoxDecoration(
              color: widget.btnColor.withOpacity(.9),
              borderRadius: BorderRadius.circular(screenWidth * .1),
              boxShadow: widget.showBoxShadow
                  ? [
                      BoxShadow(
                        color: TColors.black.withOpacity(0.5),
                        offset: Offset(
                          widget.animateBoxShadow
                              ? _shadowIntensity.value
                              : 6, // Static or animated
                          widget.animateBoxShadow ? _shadowIntensity.value : 6,
                        ),
                        blurRadius: widget.animateBoxShadow
                            ? _shadowIntensity.value
                            : 6,
                      ),
                      BoxShadow(
                        color: TColors.white.withOpacity(0.5),
                        offset: Offset(
                          widget.animateBoxShadow
                              ? -_shadowIntensity.value / 2
                              : -3, // Static or animated
                          widget.animateBoxShadow
                              ? -_shadowIntensity.value / 2
                              : -3,
                        ),
                        blurRadius: widget.animateBoxShadow
                            ? _shadowIntensity.value
                            : 6,
                      ),
                    ]
                  : [],
            ),
            child: widget.child,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
