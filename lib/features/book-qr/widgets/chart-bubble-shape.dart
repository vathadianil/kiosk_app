import 'package:flutter/material.dart';
import 'package:kiosk_app/common/widgets/shapes/triangle.dart';
import 'package:kiosk_app/utils/constants/colors.dart';

class ChatBubbleShape extends StatelessWidget {
  const ChatBubbleShape({key});

  @override
  Widget build(BuildContext context) {
    final messageTextGroup = Flexible(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: TColors.error,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
            ),
            child: const Text(
              'You are Here',
            ),
          ),
        ),
        CustomPaint(painter: Triangle(TColors.black)),
      ],
    ));

    return Padding(
      padding: const EdgeInsets.only(right: 18.0, left: 50, top: 5, bottom: 5),
      child: messageTextGroup,
    );
  }
}
