import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:kiosk_app/common/components/custom_drop_down.dart';
import 'package:kiosk_app/common/widgets/button/t_neomarphism_btn.dart';
import 'package:kiosk_app/common/widgets/dropdown/t_dropdown.dart';
import 'package:kiosk_app/common/widgets/layout/t_background_gradient.dart';
import 'package:kiosk_app/features/book-qr/controller/station_list_controller.dart';
import 'package:kiosk_app/features/config/controllers/config-controller.dart';
import 'package:kiosk_app/utils/constants/colors.dart';
import 'package:kiosk_app/utils/constants/image_strings.dart';
import 'package:kiosk_app/utils/constants/sizes.dart';
import 'package:kiosk_app/utils/device/device_utility.dart';
import 'package:kiosk_app/utils/helpers/helper_functions.dart';

class ConfigScreen extends StatelessWidget {
  const ConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ConfigControoler());
    final screenWidth = TDeviceUtils.getScreenWidth(context);
    final stationListController = Get.put(StationListController());
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: TBackgroundLinearGradient(
            child: Padding(
              padding: const EdgeInsets.only(
                top: TSizes.appBarHeight,
                left: TSizes.defaultSpace,
                right: TSizes.defaultSpace,
              ),
              child: Obx(
                () => Column(
                  children: [
                    Row(
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
                      ],
                    ),
                    const SizedBox(
                      height: TSizes.spaceBtwSections * 2,
                    ),
                    SizedBox(
                      width: screenWidth * .5,
                      child: Form(
                        key: controller.formKey,
                        child: Column(
                          children: [
                            Obx(
                              () => TDropdown(
                                value: controller.stationName.value != ''
                                    ? THelperFunctions
                                                .getStationFromStationName(
                                                    controller
                                                        .stationName.value,
                                                    stationListController
                                                        .stationList)
                                            .name ??
                                        ''
                                    : '',
                                items: stationListController.stationList
                                    .map((item) => item.name!)
                                    .toList()
                                  ..sort(),
                                labelText: 'Source Station Name',
                                labelColor: TColors.white,
                                onChanged: (value) {
                                  if (value != '') {
                                    controller.stationName.value = value!;
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: TSizes.spaceBtwSections),
                            Obx(
                              () => CustomDropdown(
                                labelText: 'Equipment Id',
                                value: controller.equipmentId.value,
                                items: const [
                                  DropdownMenuItem(
                                    value: "0001",
                                    child: Text(
                                      "0001",
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: "0002",
                                    child: Text(
                                      "0002",
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: "0011",
                                    child: Text(
                                      "0011",
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: "0012",
                                    child: Text(
                                      "0012",
                                    ),
                                  ),
                                ],
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: screenWidth * .013,
                                  horizontal: screenWidth * .04,
                                ),

                                onChanged: (value) {
                                  if (value != '') {
                                    controller.equipmentId.value = value!;
                                  }
                                }, // Set to null when not editable
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Select Field';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: TSizes.spaceBtwSections),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              controller: controller.mobileController,
                              onChanged: (value) =>
                                  controller.mobileController.text = value,
                              decoration: InputDecoration(
                                label: Text(
                                  "Mobile Number",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ),
                            const SizedBox(height: TSizes.spaceBtwSections),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              controller: controller.terminalController,
                              onChanged: (value) =>
                                  controller.terminalController.text = value,
                              decoration: InputDecoration(
                                label: Text(
                                  "Terminal Id",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ),
                            const SizedBox(height: TSizes.spaceBtwSections),
                            CustomDropdown(
                              labelText: 'Enable Mqtt',
                              value: controller.useMqtt.value,
                              helperText: 'Yes -> Mqtt      No -> Api Polling',
                              items: const [
                                DropdownMenuItem(
                                  value: "Y",
                                  child: Text(
                                    "Yes",
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: "N",
                                  child: Text(
                                    "No",
                                  ),
                                ),
                              ],
                              contentPadding: EdgeInsets.symmetric(
                                vertical: screenWidth * .013,
                                horizontal: screenWidth * .04,
                              ),

                              onChanged: (value) {
                                if (value != '') {
                                  controller.useMqtt.value = value!;
                                }
                              }, // Set to null when not editable
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Select Field';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: TSizes.spaceBtwSections),
                            if (controller.useMqtt.value == 'Y')
                              CustomDropdown(
                                labelText: 'Swith to Api Polling',
                                value: controller.swtichToApiPolling.value,
                                helperText:
                                    'Yes -> Switches to Api polling after 90 seconds',
                                items: const [
                                  DropdownMenuItem(
                                    value: "Y",
                                    child: Text(
                                      "Yes",
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: "N",
                                    child: Text(
                                      "No",
                                    ),
                                  ),
                                ],
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: screenWidth * .013,
                                  horizontal: screenWidth * .04,
                                ),

                                onChanged: (value) {
                                  if (value != '') {
                                    controller.swtichToApiPolling.value =
                                        value!;
                                  }
                                }, // Set to null when not editable
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Select Field';
                                  }
                                  return null;
                                },
                              ),
                            const SizedBox(height: TSizes.spaceBtwSections * 2),
                            TNeomarphismBtn(
                              onPressed: () {
                                controller.submitDetails();
                              },
                              child: const Text('Submit'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
