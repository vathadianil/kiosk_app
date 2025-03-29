import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk_app/common/widgets/layout/t_background_gradient.dart';
import 'package:kiosk_app/features/book-qr/models/create_spos_order.dart';
import 'package:kiosk_app/features/book-qr/models/qr_code_model.dart';
import 'package:kiosk_app/features/book-qr/models/station_list_model.dart';
import 'package:kiosk_app/features/display-qr/controllers/display-qr-controller.dart';
import 'package:kiosk_app/features/display-qr/widgets/display-qr-container.dart';
import 'package:kiosk_app/features/payment-qr/models/payment-confim-model.dart';
import 'package:kiosk_app/utils/constants/colors.dart';
import 'package:kiosk_app/utils/constants/image_strings.dart';

import 'package:kiosk_app/utils/device/device_utility.dart';
import 'package:kiosk_app/utils/helpers/helper_functions.dart';
import 'package:kiosk_app/utils/local_storage/storage_utility.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DisplayQrScreen extends StatelessWidget {
  const DisplayQrScreen({
    super.key,
    required this.tickets,
    required this.stationList,
    required this.orderId,
    required this.amountPaid,
    required this.pgResponse,
    this.confirmOrderData,
  });

  final List<TicketsListModel> tickets;
  final List<StationListModel> stationList;
  final String orderId;
  final String amountPaid;
  final CreateSposOrderModel pgResponse;
  final PaymentConfirmModel? confirmOrderData;

  @override
  Widget build(BuildContext context) {
    final displayQrController = Get.put(PrintSubmitController());
    List<GlobalKey> ticketKeys = [];
    final screenHeight = TDeviceUtils.getScreenHeight();
    final screenWidth = TDeviceUtils.getScreenWidth(context);

    void generateTicketKeys(int count) {
      ticketKeys = List.generate(count, (index) => GlobalKey());
    }

    generateTicketKeys(tickets.length);

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: TBackgroundLinearGradient(
            child: Stack(
              children: [
                SizedBox(
                  height: screenHeight * .9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      DisplayQrContainer(
                        screenHeight: screenHeight,
                        screenWidth: screenWidth,
                        amountPaid: amountPaid,
                        tickets: tickets,
                        stationList: stationList,
                        orderId: orderId,
                        pgResponse: pgResponse,
                        displayQrController: displayQrController,
                        ticketKeys: ticketKeys,
                        confirmOrderData: confirmOrderData,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: -5000,
                  // left: 0,
                  child: BuildTicket(
                    ticketKeys: ticketKeys,
                    tickets: tickets,
                    orderId: orderId,
                    amountPaid: amountPaid,
                    pgResponse: pgResponse,
                    stationList: stationList,
                    confirmOrderData: confirmOrderData,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BuildTicket extends StatelessWidget {
  BuildTicket({
    super.key,
    required this.ticketKeys,
    required this.tickets,
    required this.stationList,
    required this.orderId,
    required this.amountPaid,
    required this.pgResponse,
    this.confirmOrderData,
  });

  List<GlobalKey> ticketKeys;
  final List<TicketsListModel> tickets;
  final List<StationListModel> stationList;
  final String? orderId;
  final String amountPaid;
  final CreateSposOrderModel pgResponse;
  final PaymentConfirmModel? confirmOrderData;
  List<String> getPlatFormArray(String platform) {
    return platform.split(',');
  }

  final sourceStationId = TLocalStorage().readData('sourceStationId');
  final equipmentId = TLocalStorage().readData('equipmentId');

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 390,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return RepaintBoundary(
            key: ticketKeys[index],
            child: Container(
              width: 280,
              color: Colors.white, // Background color
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Ticket ${index + 1} / ${tickets.length}',
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                              color: TColors.black,
                              fontSize: 8,
                            ),
                      ),
                    ],
                  ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Source",
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                  color: TColors.black,
                                  fontSize: 10,
                                ),
                          ),
                          Row(
                            children: [
                              Text(
                                THelperFunctions.getStationFromStationId(
                                        tickets[index].fromStationId!,
                                        stationList)
                                    .name!
                                    .replaceFirst(' ', '\n'),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(
                                      color: TColors.black,
                                      fontSize: 10,
                                    ),
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                  horizontal: 4,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                      width: 1, color: TColors.black),
                                ),
                                child: Text(
                                  'P${getPlatFormArray(tickets[index].platFormNo!)[0]}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .copyWith(
                                        color: TColors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (getPlatFormArray(tickets[index].platFormNo!).length >
                          2)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Interchange At',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .copyWith(
                                    color: TColors.black,
                                    fontSize: 10,
                                  ),
                            ),
                            Row(
                              children: [
                                Text(
                                  (getPlatFormArray(
                                      tickets[index].platFormNo!)[1]),
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .copyWith(
                                        color: TColors.black,
                                        fontSize: 10,
                                      ),
                                ),
                                const SizedBox(
                                  width: 2,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                    horizontal: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                        width: 1, color: TColors.black),
                                  ),
                                  child: Text(
                                    'P${getPlatFormArray(tickets[index].platFormNo!)[2]}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall!
                                        .copyWith(
                                          color: TColors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Destination",
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                  color: TColors.black,
                                  fontSize: 10,
                                ),
                          ),
                          Text(
                            tickets[index].toStationId != null
                                ? THelperFunctions.getStationFromStationId(
                                        tickets[index].toStationId!,
                                        stationList)
                                    .name!
                                    .replaceFirst(' ', '\n')
                                : '',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                  color: TColors.black,
                                  fontSize: 10,
                                ),
                            textAlign: TextAlign.end,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  QrImageView(
                    data: tickets[index].ticketContent ?? '',
                    size: 120, // Adjust QR size
                    backgroundColor: Colors.white,
                  ),
                  Text(
                    'TKT ID : ${tickets[index].ticketId}',
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: TColors.black,
                          fontSize: 10,
                        ),
                  ),
                  const Divider(),
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
                        "Purchase Time: ",
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall!
                            .copyWith(color: TColors.black),
                      ),
                      Text(
                        THelperFunctions.getCurrentDateTime(),
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
                        "Amount:",
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall!
                            .copyWith(color: TColors.black),
                      ),
                      Text(
                        'Rs ${(double.tryParse(amountPaid) ?? 0 / tickets.length).toString()} /-',
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
                        "Order Id:",
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall!
                            .copyWith(color: TColors.black),
                      ),
                      Text(
                        pgResponse.orderId ?? '',
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall!
                            .copyWith(color: TColors.black),
                      ),
                    ],
                  ),
                  if (confirmOrderData != null)
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
                        SizedBox(
                          width: 150,
                          child: Text(
                            confirmOrderData?.paymentMethod ?? '',
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(color: TColors.black),
                          ),
                        ),
                      ],
                    ),
                  if (confirmOrderData != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Bank Ref Number: ",
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(color: TColors.black),
                        ),
                        Text(
                          confirmOrderData?.bankReference ?? '',
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
                        "Valid Till: ",
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall!
                            .copyWith(color: TColors.black),
                      ),
                      Text(
                        tickets[index].ticketExpiryTime != null
                            ? THelperFunctions.getFormattedDateTimeString(
                                tickets[index].ticketExpiryTime!)
                            : '',
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall!
                            .copyWith(color: TColors.black),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: ticketKeys.length,
      ),
    );
  }
}
