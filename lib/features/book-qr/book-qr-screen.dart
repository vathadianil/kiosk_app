import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk_app/common/widgets/appbar/t_appbar.dart';
import 'package:kiosk_app/common/widgets/dropdown/t_dropdown.dart';
import 'package:kiosk_app/features/book-qr/controller/book-qr-controller.dart';
import 'package:kiosk_app/features/book-qr/controller/business_hours_controller.dart';
import 'package:kiosk_app/features/book-qr/controller/station_list_controller.dart';
import 'package:kiosk_app/features/book-qr/controller/trip-selection-btn-controller.dart';
import 'package:kiosk_app/features/book-qr/widgets/book-qr-bottom-sheet.dart';
import 'package:kiosk_app/features/book-qr/widgets/map.dart';
import 'package:kiosk_app/features/home/widgets/home-carousel.dart';
import 'package:kiosk_app/utils/constants/colors.dart';
import 'package:kiosk_app/utils/constants/sizes.dart';
import 'package:kiosk_app/utils/constants/text_size.dart';
import 'package:kiosk_app/utils/device/device_utility.dart';
import 'package:kiosk_app/utils/helpers/helper_functions.dart';
import 'package:kiosk_app/utils/loaders/shimmer_effect.dart';
import 'package:kiosk_app/utils/local_storage/storage_utility.dart';

class BookQrScreen extends StatelessWidget {
  const BookQrScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final screenWidth = TDeviceUtils.getScreenWidth(context);
    final stationController = Get.put(StationListController());
    Get.put(TripSelectionBtnController());
    final bookQrController = Get.put(BookQrController());
    Get.put(BusineessHoursController());
    final sourceStationName = TLocalStorage().readData('sourceStationName');

    return Scaffold(
      backgroundColor: TColors.white,
      appBar: TAppBar(
        showBackArrow: true,
        title: Text(
          'Destination Selection',
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: TColors.black),
          textScaler: TextScaleUtil.getScaledText(context),
        ),
        actions: [
          Text(
            'Source : $sourceStationName',
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
              Padding(
                padding: const EdgeInsets.only(
                  right: TSizes.defaultSpace,
                ),
                child: Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (stationController.isLoading.value)
                        ShimmerEffect(
                          width: screenWidth * .3,
                          height: 50,
                          color: TColors.grey,
                        )
                      else
                        SizedBox(
                          width: screenWidth * .3,
                          child: TDropdown(
                            value: bookQrController.destination.value != ''
                                ? THelperFunctions.getStationFromStationId(
                                            bookQrController.destination.value,
                                            stationController.stationList)
                                        .name ??
                                    ''
                                : '',
                            items: stationController.stationList
                                .map((item) => item.name!)
                                .toList()
                              ..sort(),
                            labelText: 'Select Your Destination',
                            onChanged: (value) {
                              if (value != '') {
                                final stationId =
                                    THelperFunctions.getStationFromStationName(
                                                value!,
                                                stationController.stationList)
                                            .stationId ??
                                        '';
                                bookQrController.destination.value = stationId;
                                showModalBottomSheet(
                                  showDragHandle: false,
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (context) => const Wrap(
                                    children: [
                                      BookQrBottomSheet(),
                                    ],
                                  ),
                                );
                                bookQrController.getFare();
                              }
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
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
