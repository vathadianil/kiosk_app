import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kiosk_app/common/widgets/button/t_neomarphism_btn.dart';
import 'package:kiosk_app/common/widgets/containers/t_glass_container.dart';
import 'package:kiosk_app/features/book-qr/models/create_spos_order.dart';
import 'package:kiosk_app/features/book-qr/models/qr_code_model.dart';
import 'package:kiosk_app/features/book-qr/models/station_list_model.dart';
import 'package:kiosk_app/features/display-qr/controllers/display-qr-controller.dart';
import 'package:kiosk_app/features/display-qr/widgets/display-info-row.dart';
import 'package:kiosk_app/features/display-qr/widgets/go-to-home-btn.dart';
import 'package:kiosk_app/features/payment-qr/models/payment-confim-model.dart';
import 'package:kiosk_app/utils/constants/colors.dart';
import 'package:kiosk_app/utils/constants/image_strings.dart';
import 'package:kiosk_app/utils/helpers/helper_functions.dart';
import 'package:kiosk_app/utils/helpers/printer_controller.dart';
import 'package:kiosk_app/utils/loaders/animation_loader.dart';
import 'package:kiosk_app/utils/local_storage/storage_utility.dart';

class DisplayQrContainer extends StatelessWidget {
  const DisplayQrContainer({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.amountPaid,
    required this.tickets,
    required this.stationList,
    required this.orderId,
    required this.pgResponse,
    required this.displayQrController,
    required this.ticketKeys,
    this.confirmOrderData,
  });

  final double screenHeight;
  final double screenWidth;
  final String amountPaid;
  final List<TicketsListModel> tickets;
  final List<StationListModel> stationList;
  final String? orderId;
  final CreateSposOrderModel pgResponse;
  final PrintSubmitController displayQrController;
  final List<GlobalKey<State<StatefulWidget>>> ticketKeys;
  final PaymentConfirmModel? confirmOrderData;

  @override
  Widget build(BuildContext context) {
    final sourceStationId = TLocalStorage().readData('sourceStationId');

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TGlassContainer(
          height: screenHeight * .47,
          width: screenWidth * .62,
          child: Padding(
            padding: EdgeInsets.all(screenWidth * .05),
            child: Column(
              children: [
                const TAnimationLoaderWidget(
                  widthFactor: .25,
                  animation: TImages.paymentSuccess,
                  text: 'Payment successful',
                ),
                Text(
                  'INR $amountPaid /-',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const Divider(
                  color: TColors.white,
                ),
                SizedBox(
                  height: screenWidth * .01,
                ),
                DisplayInfoRow(
                  title: 'Source',
                  value: THelperFunctions.getStationFromStationId(
                              sourceStationId, stationList)
                          .name ??
                      '',
                ),
                SizedBox(
                  height: screenWidth * .01,
                ),
                DisplayInfoRow(
                  title: 'Destination',
                  value: tickets[0].toStationId != null
                      ? THelperFunctions.getStationFromStationId(
                                  tickets[0].toStationId!, stationList)
                              .name ??
                          ''
                      : '',
                ),
                SizedBox(
                  height: screenWidth * .01,
                ),
                DisplayInfoRow(
                  title: 'Order Id',
                  value: orderId ?? '',
                ),
                SizedBox(
                  height: screenWidth * .01,
                ),
                if (confirmOrderData != null)
                  DisplayInfoRow(
                    title: 'Payment Method',
                    value: confirmOrderData?.paymentMethod ?? '',
                  ),
                if (confirmOrderData != null)
                  SizedBox(
                    height: screenWidth * .01,
                  ),
                if (confirmOrderData != null)
                  DisplayInfoRow(
                    title: 'Bank Refrence Number',
                    value: confirmOrderData?.bankReference ?? '',
                  ),
                SizedBox(
                  height: screenWidth * .08,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(
                      () => TNeomarphismBtn(
                          btnColor: PrinterController.instance.isPrinting.value
                              ? TColors.grey
                              : TColors.primary,
                          onPressed: () {
                            displayQrController.printTicket(
                              tickets.length,
                              ticketKeys,
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Iconsax.receipt),
                              SizedBox(
                                width: screenWidth * .01,
                              ),
                              Text(
                                PrinterController.instance.isPrinting.value
                                    ? "Printing..."
                                    : 'Re-Print Ticket',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(color: TColors.white),
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
        SizedBox(
          height: screenWidth * .1,
        ),
        GotoHomeBtn(
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          displayQrController: displayQrController,
        )
      ],
    );
  }
}
