import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk_app/common/widgets/button/t_neomarphism_btn.dart';
import 'package:kiosk_app/common/widgets/layout/t_background_gradient.dart';
import 'package:kiosk_app/features/config/controllers/config-controller.dart';
import 'package:kiosk_app/utils/constants/colors.dart';
import 'package:kiosk_app/utils/constants/image_strings.dart';
import 'package:kiosk_app/utils/constants/sizes.dart';
import 'package:kiosk_app/utils/device/device_utility.dart';

class ConfigScreen extends StatelessWidget {
  const ConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ConfigControoler());
    final screenWidth = TDeviceUtils.getScreenWidth(context);
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
                  Form(
                    key: controller.formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.number,
                          onChanged: (value) =>
                              controller.stationId.value = value,
                          decoration: InputDecoration(
                            label: Text(
                              "Station Id",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
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
                        TextFormField(
                          keyboardType: TextInputType.text,
                          onChanged: (value) => controller.isProd.value = value,
                          decoration: InputDecoration(
                            label: Text(
                              "Is Production",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
