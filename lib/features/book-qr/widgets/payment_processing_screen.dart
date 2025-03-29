import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kiosk_app/common/widgets/button/t_neomarphism_btn.dart';
import 'package:kiosk_app/common/widgets/containers/t_glass_container.dart';
import 'package:kiosk_app/common/widgets/layout/t_background_gradient.dart';
import 'package:kiosk_app/features/book-qr/controller/payment_processing_controller.dart';
import 'package:kiosk_app/features/book-qr/models/create_spos_order.dart';
import 'package:kiosk_app/features/display-qr/controllers/display-qr-controller.dart';
import 'package:kiosk_app/features/display-qr/widgets/go-to-home-btn.dart';
import 'package:kiosk_app/features/payment-qr/models/payment-confim-model.dart';
import 'package:kiosk_app/utils/constants/colors.dart';
import 'package:kiosk_app/utils/constants/image_strings.dart';
import 'package:kiosk_app/utils/constants/sizes.dart';
import 'package:kiosk_app/utils/constants/text_strings.dart';
import 'package:kiosk_app/utils/device/device_utility.dart';
import 'package:kiosk_app/utils/helpers/helper_functions.dart';
import 'package:kiosk_app/utils/helpers/printer_controller.dart';
import 'package:kiosk_app/utils/loaders/animation_loader.dart';
import 'package:kiosk_app/utils/local_storage/storage_utility.dart';

class PaymentProcessingScreen extends StatelessWidget {
  const PaymentProcessingScreen({
    super.key,
    required this.verifyPayment,
    required this.generateTicketPayload,
    this.retryPurchase = true,
    this.confirmOrderData,
  });
  final CreateSposOrderModel verifyPayment;
  final Map<String, Object?> generateTicketPayload;
  final bool retryPurchase;
  final PaymentConfirmModel? confirmOrderData;

  @override
  Widget build(BuildContext context) {
    final printKey = GlobalKey();
    final screenWidth = TDeviceUtils.getScreenWidth(context);
    final screenHeight = TDeviceUtils.getScreenHeight();
    final displayQrController = Get.put(PrintSubmitController());
    final paymentProcessingController = Get.put(PaymentProcessingController(
      verifyPaymentData: verifyPayment,
      requestPayload: generateTicketPayload,
      retryPurchase: retryPurchase,
      confirmOrderData: confirmOrderData,
    ));
    final equipmentId = TLocalStorage().readData('equipmentId');
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Stack(
            children: [
              TBackgroundLinearGradient(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TGlassContainer(
                          width: screenWidth * .6,
                          height: screenHeight * .6,
                          child: Padding(
                            padding: EdgeInsets.all(screenWidth * .05),
                            child: Obx(
                              () => Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (paymentProcessingController
                                          .isPaymentVerifing.value &&
                                      !paymentProcessingController
                                          .hasPaymentVerifyRetriesCompleted
                                          .value)
                                    Text(
                                      'Payment in Progress',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall,
                                    ),

                                  if (paymentProcessingController
                                          .hasVerifyPaymentSuccess.value &&
                                      !paymentProcessingController
                                          .isGenerateTicketError.value)
                                    Text(
                                      'Payment Success',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .copyWith(color: TColors.success),
                                    ),

                                  if (!retryPurchase)
                                    Text(
                                      'Payment Failed',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .copyWith(color: TColors.error),
                                    ),

                                  if (!paymentProcessingController
                                          .hasVerifyPaymentSuccess.value &&
                                      paymentProcessingController
                                          .hasPaymentVerifyRetriesCompleted
                                          .value)
                                    Text(
                                      'Payment Failed',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .copyWith(color: TColors.error),
                                    ),
                                  if (paymentProcessingController
                                          .hasVerifyPaymentSuccess.value &&
                                      paymentProcessingController
                                          .isGenerateTicketError.value)
                                    Text(
                                      'Ticket Generation Failed',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall!
                                          .copyWith(color: TColors.error),
                                    ),
                                  const SizedBox(
                                    height: TSizes.spaceBtwSections,
                                  ),
                                  //-- Payment in Progress animation
                                  if (paymentProcessingController
                                          .isPaymentVerifing.value &&
                                      !paymentProcessingController
                                          .hasPaymentVerifyRetriesCompleted
                                          .value)
                                    const TAnimationLoaderWidget(
                                      animation: TImages.trainAnimation,
                                      text: 'Please Wait...',
                                    ),
                                  //-- Payment Success animation
                                  if (paymentProcessingController
                                      .hasVerifyPaymentSuccess.value)
                                    const TAnimationLoaderWidget(
                                      animation: TImages.paymentSuccess,
                                      text: 'Generating Ticket Please Wait...',
                                    ),

                                  //-- Payment failed animation

                                  if (!retryPurchase ||
                                      !paymentProcessingController
                                              .hasVerifyPaymentSuccess.value &&
                                          paymentProcessingController
                                              .hasPaymentVerifyRetriesCompleted
                                              .value)
                                    const TAnimationLoaderWidget(
                                      animation: TImages.paymentFailed,
                                      text:
                                          'If any amount deducted will be refuned in 2-3 business days',
                                    ),
                                  const SizedBox(
                                    height: TSizes.spaceBtwItems,
                                  ),
                                  if (retryPurchase &&
                                      !paymentProcessingController
                                          .hasPaymentVerifyRetriesCompleted
                                          .value)
                                    Text(
                                      'Do not close the app',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),

                                  const SizedBox(
                                    height: TSizes.spaceBtwSections * 2,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Date:',
                                      ),
                                      Text(
                                        verifyPayment.createdAt != null
                                            ? THelperFunctions
                                                .getFormattedDateTimeString2(
                                                    verifyPayment.createdAt!)
                                            : '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: TSizes.spaceBtwItems,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Order Id:',
                                      ),
                                      Text(
                                        verifyPayment.orderId ?? '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: TSizes.spaceBtwItems,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Equipment Id:",
                                      ),
                                      Text(
                                        equipmentId,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: TSizes.spaceBtwItems,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Payment Method:",
                                      ),
                                      Text(
                                        'UPI',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: TSizes.spaceBtwItems,
                                  ),
                                  const Divider(
                                    color: TColors.white,
                                  ),
                                  const SizedBox(
                                    height: TSizes.spaceBtwItems,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Amount:',
                                      ),
                                      Text(
                                        '${TTexts.rupeeSymbol}${verifyPayment.orderAmount!.toString()}/-',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium,
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: TSizes.spaceBtwItems * 2,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Obx(
                                        () => TNeomarphismBtn(
                                            btnColor: PrinterController
                                                    .instance.isPrinting.value
                                                ? TColors.grey
                                                : TColors.primary,
                                            onPressed: () async {
                                              displayQrController
                                                  .isPrintSubmitted
                                                  .value = true;
                                              if (PrinterController
                                                  .instance.isPrinting.value) {
                                                return;
                                              }

                                              PrinterController.instance
                                                  .isPrinting.value = true;
                                              await PrinterController.instance
                                                  .printTicket(printKey);
                                              PrinterController.instance
                                                  .isPrinting.value = false;
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const Icon(Iconsax.receipt),
                                                SizedBox(
                                                  width: screenWidth * .01,
                                                ),
                                                Text(
                                                  PrinterController.instance
                                                          .isPrinting.value
                                                      ? "Printing..."
                                                      : 'Print Receipt',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .copyWith(
                                                          color: TColors.white),
                                                ),
                                              ],
                                            )),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: screenWidth * .1,
                    ),
                    if (!retryPurchase
                        // ||
                        //     paymentProcessingController
                        //         .hasPaymentVerifyRetriesCompleted.value
                        )
                      SizedBox(
                        width: screenWidth * .28,
                        child: GotoHomeBtn(
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                          displayQrController: displayQrController,
                          checkSubmittedStutus: false,
                        ),
                      )
                  ],
                ),
              ),
              Positioned(
                left: -500,
                child: BuildTicket(
                  printKey: printKey,
                  verifyPayment: verifyPayment,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BuildTicket extends StatelessWidget {
  BuildTicket({
    super.key,
    required this.printKey,
    required this.verifyPayment,
  });

  GlobalKey printKey;
  CreateSposOrderModel verifyPayment;
  final equipmentId = TLocalStorage().readData('equipmentId');

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: RepaintBoundary(
        key: printKey,
        child: Container(
          width: 250,
          color: Colors.white, // Background color
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    TImages.appLogo,
                    width: 40,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Hyderabad Metro Rail",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: TColors.black),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                'Payment Failed Receipt',
                style: Theme.of(context)
                    .textTheme
                    .labelSmall!
                    .copyWith(color: TColors.black),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Date",
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall!
                        .copyWith(color: TColors.black),
                  ),
                  Text(
                    verifyPayment.createdAt != null
                        ? THelperFunctions.getFormattedDateTimeString2(
                            verifyPayment.createdAt!)
                        : '',
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall!
                        .copyWith(color: TColors.black),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order Id',
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: TColors.black,
                          fontSize: 10,
                        ),
                  ),
                  Text(
                    verifyPayment.orderId ?? '',
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: TColors.black,
                          fontSize: 10,
                        ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Equipment Id:",
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall!
                        .copyWith(color: TColors.black),
                  ),
                  Text(
                    equipmentId,
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall!
                        .copyWith(color: TColors.black),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Payment Method:",
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall!
                        .copyWith(color: TColors.black),
                  ),
                  Text(
                    'UPI',
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall!
                        .copyWith(color: TColors.black),
                  ),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Amount:",
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall!
                        .copyWith(color: TColors.black),
                  ),
                  Text(
                    'Rs ${verifyPayment.orderAmount} /-',
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall!
                        .copyWith(color: TColors.black),
                  ),
                ],
              ),
              Text(
                'If any amount deducted will be refuned in 2-3 business days',
                style: Theme.of(context)
                    .textTheme
                    .labelSmall!
                    .copyWith(color: TColors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
