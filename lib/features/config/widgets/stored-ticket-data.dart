import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kiosk_app/features/book-qr/controller/station_list_controller.dart';
import 'package:kiosk_app/features/config/controllers/data-controller.dart';
import 'package:kiosk_app/utils/device/device_utility.dart';
import 'package:kiosk_app/utils/helpers/helper_functions.dart';

class StoredTicketData extends StatelessWidget {
  const StoredTicketData({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dataController = Get.put(DataController());
    final screenWidth = TDeviceUtils.getScreenWidth(context);
    return Obx(
      () => Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * .03),
        child: dataController.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      // width: screenWidth * .9,
                      height: screenWidth,
                      child: Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: DataTable(
                                  columnSpacing: 10,
                                  columns: const [
                                    DataColumn(label: Text("Type")),
                                    DataColumn(label: Text("Source")),
                                    DataColumn(label: Text("Destination")),
                                    DataColumn(label: Text("Ticket ID")),
                                    DataColumn(label: Text("Amount")),
                                    DataColumn(label: Text("Actions")),
                                  ],
                                  rows: dataController.ticketData.map((ticket) {
                                    return DataRow(cells: [
                                      DataCell(Text(
                                        ticket.ticketTypeId.toString() == '10'
                                            ? 'SJT'
                                            : 'RJT',
                                      )),
                                      DataCell(Text(THelperFunctions
                                                  .getStationFromStationId(
                                                      ticket.fromStationId ??
                                                          '',
                                                      StationListController
                                                          .instance.stationList)
                                              .name ??
                                          '')),
                                      DataCell(Text(THelperFunctions
                                                  .getStationFromStationId(
                                                      ticket.toStationId ?? '',
                                                      StationListController
                                                          .instance.stationList)
                                              .name ??
                                          '')),
                                      DataCell(Text(ticket.ticketId ?? '')),
                                      DataCell(
                                          Text(ticket.amountPaid.toString())),
                                      DataCell(TextButton(
                                        onPressed: () {},
                                        child: const Text('Print'),
                                      )),
                                    ]);
                                  }).toList()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
