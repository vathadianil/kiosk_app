import 'package:flutter/material.dart';
import 'package:kiosk_app/features/home/controllers/setting_controller.dart';
import 'package:kiosk_app/utils/constants/colors.dart';
import 'package:kiosk_app/utils/constants/image_strings.dart';
import 'package:kiosk_app/utils/device/device_utility.dart';
import 'package:kiosk_app/utils/local_storage/storage_utility.dart';

class LogoSection extends StatelessWidget {
  const LogoSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final sourceStationId = TLocalStorage().readData('sourceStationId');
    final sourceStationName = TLocalStorage().readData('sourceStationName');
    final equipmentId = TLocalStorage().readData('equipmentId');
    final screenWidth = TDeviceUtils.getScreenWidth(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * .05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  SettingController.instance.onLogoTapped();
                },
                child: Image.asset(
                  TImages.appLogo,
                  width: screenWidth * .15,
                ),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('$sourceStationId - $sourceStationName'),
              Text(equipmentId)
            ],
          ),
        ],
      ),
    );
  }
}
