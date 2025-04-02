import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kiosk_app/common/controllers/timer-controller.dart';
import 'package:kiosk_app/common/widgets/button/t_neomarphism_btn.dart';
import 'package:kiosk_app/features/book-qr/controller/book-qr-controller.dart';
import 'package:kiosk_app/features/book-qr/controller/station_list_controller.dart';
import 'package:kiosk_app/utils/constants/colors.dart';
import 'package:kiosk_app/utils/helpers/helper_functions.dart';
import 'package:kiosk_app/utils/local_storage/storage_utility.dart';

class DisplayFare extends StatelessWidget {
  const DisplayFare({
    super.key,
    required this.bookQrController,
    required this.stationListController,
    required this.screenWidth,
  });

  final BookQrController bookQrController;
  final StationListController stationListController;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  'Source',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                Text(
                  TLocalStorage().readData('sourceStationName'),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  'Destination',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                Obx(
                  () => Text(
                    THelperFunctions.getStationFromStationId(
                                bookQrController.destination.value,
                                stationListController.stationList)
                            .name ??
                        '',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: screenWidth * .02,
        ),
        const Divider(
          color: TColors.white,
        ),
        SizedBox(
          height: screenWidth * .02,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'No. of Passengers',
            ),
            TNeomorphismBtn(
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      TimerController.instance.resetTimer();
                      if (bookQrController.passengerCount.value <= 1) {
                        return;
                      }
                      bookQrController.passengerCount.value--;
                    },
                    icon: const Icon(
                      Iconsax.minus,
                    ),
                  ),
                  SizedBox(
                    width: screenWidth * .02,
                  ),
                  Obx(
                    () => Text(
                      bookQrController.passengerCount.value.toString(),
                    ),
                  ),
                  SizedBox(
                    width: screenWidth * .02,
                  ),
                  IconButton(
                    onPressed: () {
                      TimerController.instance.resetTimer();

                      if (bookQrController.passengerCount.value >= 6) {
                        return;
                      }
                      bookQrController.passengerCount.value++;
                    },
                    icon: const Icon(
                      Iconsax.add,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: screenWidth * .05,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total Fare',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Obx(
              () => Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                        text: '${bookQrController.passengerCount.value} X '),
                    TextSpan(
                        text:
                            '${bookQrController.qrFareData.first.finalFare} = '),
                    TextSpan(
                        text:
                            '${bookQrController.passengerCount.value * bookQrController.qrFareData.first.finalFare!.toInt()}/-',
                        style: Theme.of(context).textTheme.headlineMedium)
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: screenWidth * .05,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: screenWidth * .3,
              child: TNeomorphismBtn(
                onPressed: () {
                  TimerController.instance.resetTimer();
                  bookQrController.generateTicket();
                },
                child: const Text(
                  'Proceed to Pay',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
