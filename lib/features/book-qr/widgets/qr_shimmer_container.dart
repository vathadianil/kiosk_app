import 'package:flutter/material.dart';
import 'package:kiosk_app/utils/constants/sizes.dart';
import 'package:kiosk_app/utils/device/device_utility.dart';
import 'package:kiosk_app/utils/loaders/shimmer_effect.dart';

class QrShimmerContainer extends StatelessWidget {
  const QrShimmerContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerEffect(
                width: TDeviceUtils.getScreenWidth(context) * .3,
                height: 30,
                radius: 30,
              ),
              ShimmerEffect(
                width: TDeviceUtils.getScreenWidth(context) * .1,
                height: 30,
                radius: 30,
              ),
            ],
          ),
          const SizedBox(
            height: TSizes.defaultSpace / 2,
          ),
          const ShimmerEffect(
            width: double.infinity,
            height: 10,
            radius: 10,
          ),
          const SizedBox(
            height: TSizes.spaceBtwSections,
          ),
          const ShimmerEffect(
            width: double.infinity,
            height: 35,
            radius: 10,
          ),
          const SizedBox(
            height: TSizes.spaceBtwSections * 2,
          ),
          Center(
            child: ShimmerEffect(
              width: TDeviceUtils.getScreenWidth(context) * .2,
              height: 35,
              radius: 10,
            ),
          ),
        ],
      ),
    );
  }
}
