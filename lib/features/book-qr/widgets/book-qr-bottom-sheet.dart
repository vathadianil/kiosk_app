import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kiosk_app/common/controllers/timer-controller.dart';
import 'package:kiosk_app/common/widgets/button/t_neomarphism_btn.dart';
import 'package:kiosk_app/common/widgets/containers/t_glass_container.dart';
import 'package:kiosk_app/common/widgets/layout/t_background_gradient.dart';
import 'package:kiosk_app/features/book-qr/controller/book-qr-controller.dart';
import 'package:kiosk_app/features/book-qr/controller/station_list_controller.dart';
import 'package:kiosk_app/features/book-qr/controller/trip-selection-btn-controller.dart';
import 'package:kiosk_app/features/book-qr/widgets/display-fare.dart';
import 'package:kiosk_app/features/book-qr/widgets/qr_shimmer_container.dart';
import 'package:kiosk_app/utils/constants/colors.dart';
import 'package:kiosk_app/utils/constants/ticket_status_codes.dart';
import 'package:kiosk_app/utils/device/device_utility.dart';

class BookQrBottomSheet extends StatelessWidget {
  const BookQrBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = TDeviceUtils.getScreenWidth(context);

    final stationListController = StationListController.instance;
    final tripSelectionController = TripSelectionBtnController.instance;
    final bookQrController = BookQrController.instance;

    bool isSingleTrip() {
      return tripSelectionController.selectedBtnValue.value == 'single'
          ? true
          : false;
    }

    bool isRoundTrip() {
      return tripSelectionController.selectedBtnValue.value == 'round'
          ? true
          : false;
    }

    return GestureDetector(
      onTap: () {
        TimerController.instance.resetTimer();
      },
      child: SizedBox(
        height: screenWidth,
        child: TBackgroundLinearGradient(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * .05),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(),
                    Text(
                      'Your Trip Details',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(color: TColors.white),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Iconsax.close_circle,
                        size: screenWidth * .04,
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
                    Obx(
                      () => TNeomarphismBtn(
                        onPressed: () {
                          if (bookQrController.loading.value) {
                            return;
                          }
                          TimerController.instance.resetTimer();
                          tripSelectionController.onChange('single');
                          bookQrController.ticketType.value =
                              TicketStatusCodes.ticketTypeSjt.toString();
                          bookQrController.getFare();
                        },
                        btnColor:
                            isSingleTrip() ? TColors.primary : TColors.grey,
                        showBoxShadow: isSingleTrip() ? true : false,
                        child: Row(
                          children: [
                            Icon(
                              Iconsax.arrow_right_1,
                              color: isSingleTrip()
                                  ? TColors.white
                                  : TColors.black,
                            ),
                            SizedBox(
                              width: screenWidth * .01,
                            ),
                            Text(
                              'One way',
                              style: TextStyle(
                                color: isSingleTrip()
                                    ? TColors.white
                                    : TColors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * .05,
                    ),
                    Obx(
                      () => TNeomarphismBtn(
                        onPressed: () {
                          if (bookQrController.loading.value) {
                            return;
                          }
                          TimerController.instance.resetTimer();
                          tripSelectionController.onChange('round');
                          bookQrController.ticketType.value =
                              TicketStatusCodes.ticketTypeRjt.toString();
                          bookQrController.getFare();
                        },
                        btnColor:
                            isRoundTrip() ? TColors.primary : TColors.grey,
                        showBoxShadow: isRoundTrip() ? true : false,
                        child: Row(
                          children: [
                            Icon(
                              Iconsax.repeat,
                              color:
                                  isRoundTrip() ? TColors.white : TColors.black,
                            ),
                            SizedBox(
                              width: screenWidth * .01,
                            ),
                            Text(
                              'Round Trip',
                              style: TextStyle(
                                color: isRoundTrip()
                                    ? TColors.white
                                    : TColors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenWidth * .05,
                ),
                TGlassContainer(
                  width: screenWidth * .7,
                  height: screenWidth * .5,
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * .05),
                    child: Obx(
                      () => Column(
                        children: [
                          if (bookQrController.loading.value)
                            const QrShimmerContainer(),
                          if (bookQrController.qrFareData.isNotEmpty &&
                              !bookQrController.loading.value)
                            DisplayFare(
                              bookQrController: bookQrController,
                              stationListController: stationListController,
                              screenWidth: screenWidth,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
