import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kiosk_app/common/controllers/timer-controller.dart';
import 'package:kiosk_app/common/widgets/button/t_neomarphism_btn.dart';
import 'package:kiosk_app/common/widgets/layout/t_background_gradient.dart';
import 'package:kiosk_app/features/book-qr/controller/station_list_controller.dart';
import 'package:kiosk_app/features/home/controllers/setting_controller.dart';
import 'package:kiosk_app/features/home/widgets/home-carousel.dart';
import 'package:kiosk_app/features/home/widgets/logo-section.dart';
import 'package:kiosk_app/features/home/widgets/available-service-section.dart';
import 'package:kiosk_app/utils/constants/colors.dart';
import 'package:kiosk_app/utils/constants/sizes.dart';
import 'package:kiosk_app/utils/device/device_utility.dart';
import 'package:kiosk_app/utils/validators/validation.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(StationListController());
    final settingsController = Get.put(SettingController());
    final screenWidth = TDeviceUtils.getScreenWidth(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: GestureDetector(
            onTap: () async {
              settingsController.tapCount.value = 0;
              TimerController.instance.resetTimer();
            },
            child: TBackgroundLinearGradient(
              child: Obx(
                () => Column(
                  children: [
                    SizedBox(
                      height: screenWidth * .1,
                    ),
                    const LogoSection(),
                    SizedBox(
                      height: screenWidth * .1,
                    ),
                    const AvailableServiceSection(),
                    SizedBox(
                      height: screenWidth * .2,
                    ),
                    const Hero(tag: 'img', child: HomeCarousel()),
                    SizedBox(
                      height: screenWidth * .1,
                    ),
                    if (settingsController.tapCount.value >= 4)
                      Padding(
                        padding: const EdgeInsets.only(
                          right: TSizes.defaultSpace,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {
                                Get.dialog(
                                  barrierDismissible: true,
                                  Dialog(
                                    backgroundColor: TColors.primary,
                                    child: Form(
                                      key: settingsController.passwordFormKey,
                                      child: Padding(
                                        padding: const EdgeInsets.all(
                                            TSizes.defaultSpace),
                                        child: SizedBox(
                                          width: screenWidth * .5,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Text('Enter Password'),
                                              const SizedBox(
                                                height: TSizes.spaceBtwSections,
                                              ),
                                              TextFormField(
                                                controller:
                                                    settingsController.password,
                                                obscureText: true,
                                                keyboardType:
                                                    TextInputType.number,
                                                validator: (value) =>
                                                    TValidator.validatePassword(
                                                        value),
                                                decoration: InputDecoration(
                                                  counterText: "",
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                    vertical: 0,
                                                    horizontal: TSizes.md,
                                                  ),
                                                  suffixIcon: const Icon(
                                                    Iconsax.eye_slash,
                                                    color: TColors.light,
                                                  ),
                                                  label: Text(
                                                    'Passowrd',
                                                    style: Theme.of(context)
                                                        .inputDecorationTheme
                                                        .labelStyle!
                                                        .copyWith(
                                                            color:
                                                                TColors.light),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: TSizes.spaceBtwSections,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  TNeomorphismBtn(
                                                    onPressed: () {
                                                      settingsController
                                                          .onSubmit();
                                                    },
                                                    child: const Text('Submit'),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              icon: Icon(
                                Iconsax.setting_2,
                                size: screenWidth * .05,
                              ),
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
      ),
    );
  }
}
