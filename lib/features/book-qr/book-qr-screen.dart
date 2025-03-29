import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk_app/common/widgets/appbar/t_appbar.dart';
import 'package:kiosk_app/features/book-qr/controller/book-qr-controller.dart';
import 'package:kiosk_app/features/book-qr/controller/business_hours_controller.dart';
import 'package:kiosk_app/features/book-qr/controller/station_list_controller.dart';
import 'package:kiosk_app/features/book-qr/controller/trip-selection-btn-controller.dart';
import 'package:kiosk_app/features/book-qr/widgets/map.dart';
import 'package:kiosk_app/features/home/widgets/home-carousel.dart';
import 'package:kiosk_app/utils/constants/colors.dart';
import 'package:kiosk_app/utils/constants/text_size.dart';
import 'package:kiosk_app/utils/device/device_utility.dart';
import 'package:kiosk_app/utils/local_storage/storage_utility.dart';

class BookQrScreen extends StatelessWidget {
  const BookQrScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final screenWidth = TDeviceUtils.getScreenWidth(context);
    Get.put(StationListController());
    Get.put(TripSelectionBtnController());
    Get.put(BookQrController());
    Get.put(BusineessHoursController());

    final sourceStationId = TLocalStorage().readData('sourceStationId');
    final sourceStationName = TLocalStorage().readData('sourceStationName');
    // final adController = Get.put(AdController());

    return Scaffold(
      backgroundColor: TColors.white,
      appBar: TAppBar(
        showBackArrow: true,
        title: Text(
          'Select Destination Station',
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: TColors.black),
          textScaler: TextScaleUtil.getScaledText(context),
        ),
        actions: [
          Text(
            '$sourceStationId - $sourceStationName',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: TColors.black,
                ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: SizedBox(
                  width: screenWidth * .9,
                  height: screenWidth * .9,
                  child: const MapWidget(),
                ),
              ),
              Hero(
                tag: 'img',
                child: HomeCarousel(
                  applyBoxShadow: true,
                  boxShadowColor: TColors.accent.withOpacity(.2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
