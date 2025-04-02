import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kiosk_app/features/book-qr/controller/station_list_controller.dart';
import 'package:kiosk_app/features/config/controllers/tab-controller.dart';
import 'package:kiosk_app/features/config/widgets/config-form.dart';
import 'package:kiosk_app/features/config/controllers/config-controller.dart';
import 'package:kiosk_app/features/config/widgets/stored-ticket-data.dart';
import 'package:kiosk_app/features/home/home.dart';
import 'package:kiosk_app/utils/constants/colors.dart';
import 'package:kiosk_app/utils/constants/image_strings.dart';
import 'package:kiosk_app/utils/device/device_utility.dart';
import 'package:kiosk_app/utils/local_storage/storage_utility.dart';

// Controller for managing tab state

class ConfigScreen extends StatelessWidget {
  const ConfigScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // Inject the controller
    final customTabController = Get.put(CustomTabController());
    final screenWidth = TDeviceUtils.getScreenWidth(context);
    final stationListController = Get.put(StationListController());
    final configController = Get.put(ConfigController());

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: screenWidth * .2,
        title: const Header(),
        bottom: TabBar(
          controller: customTabController.tabController,
          tabs: const [
            Tab(icon: Icon(Icons.settings), text: "Equipment Configuration"),
            Tab(icon: Icon(Icons.data_array), text: "Stored Ticket Data"),
          ],
        ),
      ),
      body: GetBuilder<CustomTabController>(
        builder: (controller) => SizedBox(
          child: Padding(
            padding: EdgeInsets.only(top: screenWidth * .02),
            child: TabBarView(
              controller: controller.tabController,
              children: [
                ConfigForm(
                  controller: configController,
                  stationListController: stationListController,
                ),
                const StoredTicketData(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = TDeviceUtils.getScreenWidth(context);
    final terminalId = TLocalStorage().readData('terminalId') ?? '';
    return Row(
      children: [
        Image.asset(
          TImages.appLogo,
          width: screenWidth * .15,
        ),
        SizedBox(
          width: screenWidth * .05,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(color: TColors.white),
            ),
            Text(
              'Easy Ticket booking for metro rides',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: TColors.white),
            ),
          ],
        ),
        const Spacer(),
        if (terminalId != '')
          IconButton(
            onPressed: () {
              Get.offAll(() => const HomeScreen());
            },
            icon: const Icon(
              Iconsax.home,
              color: TColors.white,
            ),
          ),
      ],
    );
  }
}
