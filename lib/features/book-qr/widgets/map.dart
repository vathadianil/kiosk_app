import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kiosk_app/common/controllers/timer-controller.dart';
import 'package:kiosk_app/features/book-qr/controller/book-qr-controller.dart';
import 'package:kiosk_app/features/book-qr/models/region-model.dart';
import 'package:kiosk_app/features/book-qr/widgets/book-qr-bottom-sheet.dart';
import 'package:kiosk_app/utils/constants/colors.dart';
import 'package:kiosk_app/utils/constants/image_strings.dart';
import 'package:kiosk_app/utils/device/device_utility.dart';
import 'package:kiosk_app/utils/local_storage/storage_utility.dart';
import 'package:kiosk_app/utils/popups/loaders.dart';
import 'package:lottie/lottie.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget>
    with SingleTickerProviderStateMixin {
  final controller = BookQrController.instance;
  late TransformationController transController;
  TapDownDetails? tapDownDetails;
  late AnimationController animationController;
  Animation<Matrix4>? animation;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    transController = TransformationController();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
        transController.value = animation!.value;
      });

    // Future.delayed(
    //     const Duration(
    //       milliseconds: 500,
    //     ), () {
    //   const position = Offset(700, 280);
    //   animatezoom(position, scale: 2);
    // });
  }

  void animatezoom(Offset position, {double scale = 3}) {
    final x = -position.dx * (scale - 1);
    final y = -position.dy * (scale - 1);

    final zoomed = Matrix4.identity()
      ..translate(x, y)
      ..scale(scale);

    final end =
        transController.value.isIdentity() ? zoomed : Matrix4.identity();
    animation = Matrix4Tween(
      begin: transController.value,
      end: end,
    ).animate(
      CurveTween(
        curve: Curves.easeInOut,
      ).animate(animationController),
    );
    animationController.forward(from: 0);
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
    transController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = TDeviceUtils.getScreenWidth(context);
    List<RegionModel> regionDataForOs11 = [
      RegionModel(x: 57, y: 15, color: TColors.error, stationId: '0101'),
      RegionModel(x: 100, y: 15, color: TColors.error, stationId: '0102'),
      RegionModel(x: 125, y: 37, color: TColors.error, stationId: '0103'),
      RegionModel(x: 147, y: 60, color: TColors.error, stationId: '0104'),
      RegionModel(x: 172, y: 85, color: TColors.error, stationId: '0105'),
      RegionModel(x: 192, y: 107, color: TColors.error, stationId: '0106'),
      RegionModel(x: 210, y: 125, color: TColors.error, stationId: '0107'),
      RegionModel(x: 230, y: 145, color: TColors.error, stationId: '0108'),
      RegionModel(x: 254, y: 167, color: TColors.error, stationId: '0109'),
      RegionModel(x: 275, y: 190, color: TColors.error, stationId: '0110'),
      RegionModel(x: 275, y: 225, color: TColors.primary, stationId: '0314'),
      RegionModel(x: 275, y: 265, color: TColors.error, stationId: '0112'),
      RegionModel(x: 275, y: 295, color: TColors.error, stationId: '0113'),
      RegionModel(x: 297, y: 327, color: TColors.error, stationId: '0114'),
      RegionModel(x: 315, y: 351, color: TColors.error, stationId: '0115'),
      RegionModel(x: 334, y: 377, color: TColors.error, stationId: '0116'),
      RegionModel(x: 354, y: 405, color: TColors.error, stationId: '0117'),
      RegionModel(x: 373, y: 435, color: TColors.error, stationId: '0118'),
      RegionModel(x: 393, y: 464, color: TColors.error, stationId: '0119'),
      RegionModel(x: 440, y: 468, color: TColors.success, stationId: '0120'),
      RegionModel(x: 495, y: 468, color: TColors.error, stationId: '0121'),
      RegionModel(x: 532, y: 468, color: TColors.error, stationId: '0122'),
      RegionModel(x: 565, y: 468, color: TColors.error, stationId: '0123'),
      RegionModel(x: 602, y: 468, color: TColors.error, stationId: '0124'),
      RegionModel(x: 653, y: 468, color: TColors.error, stationId: '0125'),
      RegionModel(x: 686, y: 495, color: TColors.error, stationId: '0126'),
      RegionModel(x: 687, y: 532, color: TColors.error, stationId: '0127'),
      RegionModel(x: 688, y: 326, color: TColors.primary, stationId: '0301'),
      RegionModel(x: 670, y: 305, color: TColors.primary, stationId: '0302'),
      RegionModel(x: 650, y: 285, color: TColors.primary, stationId: '0303'),
      RegionModel(x: 630, y: 267, color: TColors.primary, stationId: '0304'),
      RegionModel(x: 610, y: 247, color: TColors.primary, stationId: '0305'),
      RegionModel(x: 587, y: 227, color: TColors.primary, stationId: '0306'),
      RegionModel(x: 552, y: 227, color: TColors.primary, stationId: '0307'),
      RegionModel(x: 512, y: 227, color: TColors.primary, stationId: '0308'),
      RegionModel(x: 440, y: 227, color: TColors.primary, stationId: '0309'),
      RegionModel(x: 440, y: 191, color: TColors.success, stationId: '0309'),
      RegionModel(x: 397, y: 227, color: TColors.primary, stationId: '0310'),
      RegionModel(x: 365, y: 227, color: TColors.primary, stationId: '0311'),
      RegionModel(x: 332, y: 227, color: TColors.primary, stationId: '0312'),
      RegionModel(x: 305, y: 227, color: TColors.primary, stationId: '0313'),
      RegionModel(x: 227, y: 227, color: TColors.primary, stationId: '0315'),
      RegionModel(x: 192, y: 227, color: TColors.primary, stationId: '0316'),
      RegionModel(x: 153, y: 227, color: TColors.primary, stationId: '0317'),
      RegionModel(x: 122, y: 226, color: TColors.primary, stationId: '0318'),
      RegionModel(x: 102, y: 208, color: TColors.primary, stationId: '0319'),
      RegionModel(x: 85, y: 189, color: TColors.primary, stationId: '0320'),
      RegionModel(x: 65, y: 171, color: TColors.primary, stationId: '0321'),
      RegionModel(x: 45, y: 151, color: TColors.primary, stationId: '0322'),
      RegionModel(x: 8, y: 115, color: TColors.primary, stationId: '0323'),
      RegionModel(x: 440, y: 270, color: TColors.success, stationId: '0202'),
      RegionModel(x: 440, y: 297, color: TColors.success, stationId: '0203'),
      RegionModel(x: 440, y: 325, color: TColors.success, stationId: '0204'),
      RegionModel(x: 440, y: 353, color: TColors.success, stationId: '0205'),
      RegionModel(x: 440, y: 382, color: TColors.success, stationId: '0206'),
      RegionModel(x: 440, y: 408, color: TColors.success, stationId: '0207'),
      RegionModel(x: 440, y: 436, color: TColors.success, stationId: '0208'),
    ];

    List<RegionModel> regionDataForOs12 = [
      RegionModel(x: 59, y: 17, color: TColors.error, stationId: '0101'),
      RegionModel(x: 105, y: 15, color: TColors.error, stationId: '0102'),
      RegionModel(x: 130, y: 40, color: TColors.error, stationId: '0103'),
      RegionModel(x: 151, y: 63, color: TColors.error, stationId: '0104'),
      RegionModel(x: 172, y: 84, color: TColors.error, stationId: '0105'),
      RegionModel(x: 195, y: 109, color: TColors.error, stationId: '0106'),
      RegionModel(x: 217, y: 128, color: TColors.error, stationId: '0107'),
      RegionModel(x: 238, y: 150, color: TColors.error, stationId: '0108'),
      RegionModel(x: 264, y: 173, color: TColors.error, stationId: '0109'),
      RegionModel(x: 287, y: 195, color: TColors.error, stationId: '0110'),
      RegionModel(x: 287, y: 234, color: TColors.primary, stationId: '0314'),
      RegionModel(x: 287, y: 275, color: TColors.error, stationId: '0112'),
      RegionModel(x: 287, y: 304, color: TColors.error, stationId: '0113'),
      RegionModel(x: 308, y: 335, color: TColors.error, stationId: '0114'),
      RegionModel(x: 327, y: 365, color: TColors.error, stationId: '0115'),
      RegionModel(x: 347, y: 399, color: TColors.error, stationId: '0116'),
      RegionModel(x: 367, y: 425, color: TColors.error, stationId: '0117'),
      RegionModel(x: 393, y: 455, color: TColors.error, stationId: '0118'),
      RegionModel(x: 410, y: 484, color: TColors.error, stationId: '0119'),
      RegionModel(x: 458, y: 485, color: TColors.success, stationId: '0120'),
      RegionModel(x: 516, y: 485, color: TColors.error, stationId: '0121'),
      RegionModel(x: 555, y: 485, color: TColors.error, stationId: '0122'),
      RegionModel(x: 585, y: 485, color: TColors.error, stationId: '0123'),
      RegionModel(x: 628, y: 485, color: TColors.error, stationId: '0124'),
      RegionModel(x: 680, y: 485, color: TColors.error, stationId: '0125'),
      RegionModel(x: 715, y: 515, color: TColors.error, stationId: '0126'),
      RegionModel(x: 715, y: 553, color: TColors.error, stationId: '0127'),
      RegionModel(x: 715, y: 338, color: TColors.primary, stationId: '0301'),
      RegionModel(x: 695, y: 316, color: TColors.primary, stationId: '0302'),
      RegionModel(x: 675, y: 295, color: TColors.primary, stationId: '0303'),
      RegionModel(x: 654, y: 273, color: TColors.primary, stationId: '0304'),
      RegionModel(x: 630, y: 255, color: TColors.primary, stationId: '0305'),
      RegionModel(x: 610, y: 234, color: TColors.primary, stationId: '0306'),
      RegionModel(x: 570, y: 234, color: TColors.primary, stationId: '0307'),
      RegionModel(x: 527, y: 234, color: TColors.primary, stationId: '0308'),
      RegionModel(x: 457, y: 234, color: TColors.primary, stationId: '0309'),
      RegionModel(x: 457, y: 199, color: TColors.success, stationId: '0309'),
      RegionModel(x: 412, y: 234, color: TColors.primary, stationId: '0310'),
      RegionModel(x: 380, y: 234, color: TColors.primary, stationId: '0311'),
      RegionModel(x: 343, y: 234, color: TColors.primary, stationId: '0312'),
      RegionModel(x: 315, y: 234, color: TColors.primary, stationId: '0313'),
      RegionModel(x: 232, y: 234, color: TColors.primary, stationId: '0315'),
      RegionModel(x: 195, y: 234, color: TColors.primary, stationId: '0316'),
      RegionModel(x: 157, y: 234, color: TColors.primary, stationId: '0317'),
      RegionModel(x: 125, y: 235, color: TColors.primary, stationId: '0318'),
      RegionModel(x: 106, y: 215, color: TColors.primary, stationId: '0319'),
      RegionModel(x: 88, y: 196, color: TColors.primary, stationId: '0320'),
      RegionModel(x: 70, y: 177, color: TColors.primary, stationId: '0321'),
      RegionModel(x: 48, y: 156, color: TColors.primary, stationId: '0322'),
      RegionModel(x: 8, y: 118, color: TColors.primary, stationId: '0323'),
      RegionModel(x: 457, y: 282, color: TColors.success, stationId: '0202'),
      RegionModel(x: 457, y: 308, color: TColors.success, stationId: '0203'),
      RegionModel(x: 457, y: 337, color: TColors.success, stationId: '0204'),
      RegionModel(x: 457, y: 364, color: TColors.success, stationId: '0205'),
      RegionModel(x: 457, y: 392, color: TColors.success, stationId: '0206'),
      RegionModel(x: 457, y: 420, color: TColors.success, stationId: '0207'),
      RegionModel(x: 457, y: 447, color: TColors.success, stationId: '0208'),
    ];

    final regionData = TDeviceUtils.getOsVersion() == '11'
        ? regionDataForOs11
        : regionDataForOs12;

    final sourceStationId = TLocalStorage().readData('sourceStationId');

    return Column(
      children: [
        GestureDetector(
          onTapDown: (details) {
            tapDownDetails = details;
          },
          onTap: () async {
            TimerController.instance.resetTimer();
            final position = tapDownDetails!.localPosition;
            animatezoom(position);
          },
          child: InteractiveViewer(
            clipBehavior: Clip.none,
            transformationController: transController,
            child: Stack(
              children: [
                Image.asset(
                  TImages.networkMapJpg,
                  frameBuilder:
                      (context, child, frame, wasSynchronouslyLoaded) {
                    if (frame == null) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    Future.delayed(const Duration(milliseconds: 200), () {
                      setState(() {
                        isLoading = false;
                      });
                    });
                    return child;
                  },
                ),
                if (!isLoading)
                  ...regionData.map(
                    (region) => Positioned(
                      top: region.y.toDouble(),
                      left: region.x.toDouble(),
                      child: GestureDetector(
                        onTap: () async {
                          TimerController.instance.resetTimer();
                          if (sourceStationId == region.stationId) {
                            TLoaders.customToast(
                              message:
                                  'Source and Destination must be diffrent',
                            );
                            return;
                          }
                          controller.onDestinationTapped(region.stationId);
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
                          await controller.getFare();
                        },
                        child: Stack(
                          children: [
                            Container(
                              width: screenWidth * .03,
                              height: screenWidth * .03,
                              decoration: BoxDecoration(
                                color:
                                    // region.color,
                                    (controller.destination.value ==
                                                region.stationId ||
                                            region.stationId == sourceStationId)
                                        ? region.color
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(100),
                                boxShadow: (controller.destination.value ==
                                            region.stationId ||
                                        region.stationId == sourceStationId)
                                    ? [
                                        BoxShadow(
                                          color: region.color,
                                          offset: const Offset(6, 6),
                                          blurRadius: 6,
                                        ),
                                        const BoxShadow(
                                          color: TColors.darkGrey,
                                          offset: Offset(-3, -3),
                                          blurRadius: 6,
                                        ),
                                      ]
                                    : [],
                              ),
                              child: controller.destination.value ==
                                      region.stationId
                                  ? Icon(
                                      Iconsax.tick_circle,
                                      size: screenWidth * .015,
                                    )
                                  : region.stationId == sourceStationId
                                      ? Lottie.asset(
                                          TImages.location,
                                          width: screenWidth * .05,
                                        )
                                      : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                // ...regionData
                //     .map(
                //       (region) => Positioned(
                //         top: region.y.toDouble(),
                //         left: region.x.toDouble() + 15,
                //         child: Column(
                //           children: [
                //             if (region.stationId == sourceStationId)
                //               Container(
                //                 padding: const EdgeInsets.symmetric(
                //                   horizontal: 8,
                //                   vertical: 2,
                //                 ),
                //                 decoration: const BoxDecoration(
                //                     color: TColors.error,
                //                     borderRadius: BorderRadius.only(
                //                       topRight: Radius.circular(18),
                //                       topLeft: Radius.circular(18),
                //                       bottomRight: Radius.circular(18),
                //                     ),
                //                     boxShadow: [
                //                       BoxShadow(
                //                         color: TColors.error,
                //                         offset: Offset(3, 3),
                //                         blurRadius: 6,
                //                       ),
                //                       BoxShadow(
                //                         color: TColors.darkGrey,
                //                         offset: Offset(-3, -3),
                //                         blurRadius: 6,
                //                       ),
                //                     ]),
                //                 child: Text('You are\nHere',
                //                     style:
                //                         Theme.of(context).textTheme.labelSmall),
                //               ),
                //           ],
                //         ),
                //       ),
                //     )
                //     .toList(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
