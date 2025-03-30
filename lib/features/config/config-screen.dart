import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
              child: Column(
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
                          TDropdown(
                            value: controller.stationId.value != ''
                                ? THelperFunctions.getStationFromStationId(
                                            controller.stationId.value,
                                            stationListController.stationList)
                                        .name ??
                                    ''
                                : '',
                            items: stationListController.stationList
                                .map((item) => item.stationId!)
                                .toList()
                              ..sort(),
                            labelText: 'Select Source Station Id',
                            labelColor: TColors.white,
                            onChanged: (value) {
                              if (value != '') {}
                            },
                          ),
                          const SizedBox(height: TSizes.spaceBtwSections),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            onChanged: (value) =>
                                controller.stationName.value = value,
                            decoration: InputDecoration(
                              label: Text(
                                "Station Name",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ),
                          const SizedBox(height: TSizes.spaceBtwSections),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            onChanged: (value) =>
                                controller.equipmentId.value = value,
                            decoration: InputDecoration(
                              label: Text(
                                "Equipment Id",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ),
                          const SizedBox(height: TSizes.spaceBtwSections),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            onChanged: (value) =>
                                controller.mobileNumber.value = value,
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
                            onChanged: (value) =>
                                controller.terminalId.value = value,
                            decoration: InputDecoration(
                              label: Text(
                                "Terminal Id",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ),
                          const SizedBox(height: TSizes.spaceBtwSections),
                          CustomDropdown(
                            labelText: 'Is Production',
                            value: controller.isProd.value,
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

                            onChanged:
                                (value) {}, // Set to null when not editable
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Select Field';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: TSizes.spaceBtwSections),
                          CustomDropdown(
                            labelText: 'Enable Mqtt',
                            value: controller.useMqtt.value,
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
                                  )),
                            ],
                            contentPadding: EdgeInsets.symmetric(
                              vertical: screenWidth * .013,
                              horizontal: screenWidth * .04,
                            ),

                            onChanged:
                                (value) {}, // Set to null when not editable
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
    );
  }
}
