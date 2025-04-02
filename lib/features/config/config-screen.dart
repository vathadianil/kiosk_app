import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk_app/features/book-qr/controller/station_list_controller.dart';
import 'package:kiosk_app/features/config/controllers/tab-controller.dart';
import 'package:kiosk_app/features/config/widgets/config-form.dart';
import 'package:kiosk_app/features/config/controllers/config-controller.dart';
import 'package:kiosk_app/features/config/widgets/stored-ticket-data.dart';
import 'package:kiosk_app/features/home/widgets/logo-section.dart';
import 'package:kiosk_app/utils/device/device_utility.dart';

class ConfigScreen extends StatelessWidget {
  const ConfigScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final customTabController = Get.put(CustomTabController());
    final screenWidth = TDeviceUtils.getScreenWidth(context);
    final stationListController = Get.put(StationListController());
    final configController = Get.put(ConfigController());

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: screenWidth * .2,
        title: const LogoSection(),
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
