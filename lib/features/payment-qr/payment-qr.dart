import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk_app/common/controllers/timer-controller.dart';
import 'package:kiosk_app/common/widgets/appbar/t_appbar.dart';
import 'package:kiosk_app/features/book-qr/controller/station_list_controller.dart';
import 'package:kiosk_app/features/book-qr/models/create_spos_order.dart';
import 'package:kiosk_app/features/book-qr/models/create_terminla_transaction_model.dart';
import 'package:kiosk_app/features/home/widgets/home-carousel.dart';
import 'package:kiosk_app/features/payment-qr/controllers/payment-timer.dart';
import 'package:kiosk_app/features/payment-qr/widgets/payment-qr-display-section.dart';
import 'package:kiosk_app/features/payment-qr/widgets/time-elapse-container.dart';
import 'package:kiosk_app/utils/constants/colors.dart';
// import 'package:kiosk_app/utils/constants/image_strings.dart';
import 'package:kiosk_app/utils/constants/text_size.dart';
import 'package:kiosk_app/utils/device/device_utility.dart';
import 'package:kiosk_app/features/payment-qr/controllers/generate_ticket_controller.dart';
// import 'package:kiosk_app/utils/loaders/animation_loader.dart';
import 'package:kiosk_app/utils/local_storage/storage_utility.dart';

class PaymentQrScreen extends StatelessWidget {
  const PaymentQrScreen({
    super.key,
    required this.createTerminalTrxData,
    required this.ticketType,
    required this.destination,
    required this.createOrderData,
    required this.passengerCount,
    required this.finalFare,
    required this.fareQouteId,
  });
  final CreateTerminalTransactionModel createTerminalTrxData;
  final String ticketType;
  final String destination;
  final int passengerCount;
  final CreateSposOrderModel createOrderData;
  final int finalFare;
  final String fareQouteId;

  @override
  Widget build(BuildContext context) {
    final sourceStationId = TLocalStorage().readData('sourceStationId');
    final sourceStationName = TLocalStorage().readData('sourceStationName');
    Get.put(StationListController());
    final paymentTimerController = Get.put(PaymentTimerController(
      ticketType: ticketType,
      destination: destination,
      createOrderData: createOrderData,
      passengerCount: passengerCount,
      finalFare: finalFare,
      fareQouteId: fareQouteId,
    ));
    Get.put(GenerateTicketController(
      ticketType: ticketType,
      destination: destination,
      createOrderData: createOrderData,
      passengerCount: passengerCount,
      finalFare: finalFare,
      fareQouteId: fareQouteId,
    ));

    final screenWidth = TDeviceUtils.getScreenWidth(context);
    return Scaffold(
      backgroundColor: TColors.black,
      appBar: TAppBar(
        showBackArrow: false,
        iconColor: TColors.white,
        title: Text(
          'Scan to Pay',
          style: Theme.of(context).textTheme.bodyLarge,
          textScaler: TextScaleUtil.getScaledText(context),
        ),
        actions: [
          Text(
            '$sourceStationId - $sourceStationName',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: GestureDetector(
            onTap: () async {
              TimerController.instance.resetTimer();
            },
            child:
                // Obx(
                //   () =>
                Column(
              children: [
                // if (GenerateTicketController.instance.isConnected.value)
                PaymentQrDisplaySection(
                    createTerminalTrxData: createTerminalTrxData),
                // else
                //   const TAnimationLoaderWidget(
                //     animation: TImages.trainAnimation,
                //     widthFactor: .5,
                //     text: 'Generating Payment QR Code. Please wait...',
                //   ),
                SizedBox(
                  height: screenWidth * .06,
                ),
                Stack(
                  children: [
                    const TimeElaspseContainerScreen(),
                    Positioned(
                        top: 37,
                        left: 30,
                        child: Obx(
                          () => Text(
                            '${(paymentTimerController.secondsElapsed.value ~/ 60).toString().padLeft(2, "0")}:${(paymentTimerController.secondsElapsed.value % 60).toString().padLeft(2, '0')}',
                          ),
                        ))
                  ],
                ),
                SizedBox(
                  height: screenWidth * .02,
                ),
                const Text('Waitng for Payment Confirmation'),
                SizedBox(
                  height: screenWidth * .1,
                ),
                const Hero(tag: 'img', child: HomeCarousel()),
              ],
            ),
            // ),
          ),
        ),
      ),
    );
  }
}
