import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:kiosk_app/common/controllers/timer-controller.dart';
import 'package:kiosk_app/common/widgets/containers/t_glass_container.dart';
import 'package:kiosk_app/features/book-qr/models/create_terminla_transaction_model.dart';
import 'package:kiosk_app/utils/constants/image_strings.dart';
import 'package:kiosk_app/utils/constants/text_strings.dart';
import 'package:kiosk_app/utils/device/device_utility.dart';

class PaymentQrDisplaySection extends StatelessWidget {
  const PaymentQrDisplaySection({
    super.key,
    required this.createTerminalTrxData,
  });
  final CreateTerminalTransactionModel createTerminalTrxData;

  @override
  Widget build(BuildContext context) {
    final screenWidth = TDeviceUtils.getScreenWidth(context);

    Uint8List decodeBase64Image(String base64String) {
      return base64Decode(base64String);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TGlassContainer(
          onPressed: () async {
            TimerController.instance.resetTimer();
          },
          width: screenWidth * .5,
          height: screenWidth * .6,
          borderRadius: screenWidth * .05,
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Total to be Paid   '),
                  Text(
                    '${TTexts.rupeeSymbol} ${createTerminalTrxData.paymentAmount}/-',
                    style: Theme.of(context).textTheme.displaySmall,
                  )
                ],
              ),
              SizedBox(
                height: screenWidth * .05,
              ),
              if (createTerminalTrxData.qrcode != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(screenWidth * .01),
                  child: Image.memory(
                    decodeBase64Image(
                        createTerminalTrxData.qrcode!.split(',')[1]),
                    width: screenWidth * .3,
                    height: screenWidth * .3,
                    fit: BoxFit.cover,
                  ),
                ),
              SizedBox(
                height: screenWidth * .02,
              ),
              const Text('Scan to Pay'),
              SizedBox(
                height: screenWidth * .01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    TImages.appLogo,
                    width: screenWidth * .08,
                  ),
                  SizedBox(
                    width: screenWidth * .02,
                  ),
                  const Text('Hyderabad Metor Rail'),
                ],
              ),
            ],
          )),
        ),
      ],
    );
  }
}
