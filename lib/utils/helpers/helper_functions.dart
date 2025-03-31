import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kiosk_app/features/book-qr/models/station_list_model.dart';
import 'package:kiosk_app/utils/constants/colors.dart';

class THelperFunctions {
  static Color? getColor(String value) {
    /// Define your product specific colors here and it will match the attribute colors and show specific 🟠🟡🟢🔵🟣🟤

    if (value == 'Green') {
      return Colors.green;
    } else if (value == 'Green') {
      return Colors.green;
    } else if (value == 'Red') {
      return Colors.red;
    } else if (value == 'Blue') {
      return Colors.blue;
    } else if (value == 'Pink') {
      return Colors.pink;
    } else if (value == 'Grey') {
      return Colors.grey;
    } else if (value == 'Purple') {
      return Colors.purple;
    } else if (value == 'Black') {
      return Colors.black;
    } else if (value == 'White') {
      return Colors.white;
    } else if (value == 'Yellow') {
      return Colors.yellow;
    } else if (value == 'Orange') {
      return Colors.deepOrange;
    } else if (value == 'Brown') {
      return Colors.brown;
    } else if (value == 'Teal') {
      return Colors.teal;
    } else if (value == 'Indigo') {
      return Colors.indigo;
    } else {
      return null;
    }
  }

  static void showSnackBar(String message) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  static void showAlert(String title, String message, Function callbackFun,
      {dismisable = false}) {
    final isDarkMode = THelperFunctions.isDarkMode(Get.context!);
    showDialog(
      context: Get.context!,
      barrierDismissible: dismisable,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDarkMode ? TColors.dark : TColors.white,
          title: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: isDarkMode ? TColors.accent : TColors.primary),
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                callbackFun();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static void showPaymentCancelAlert(
      String title, String message, Function callbackFun,
      {dismisable = false}) {
    showDialog(
      context: Get.context!,
      barrierDismissible: dismisable,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: TColors.primary,
          title: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: TColors.white),
          ),
          content: SizedBox(width: screenWidth() * .5, child: Text(message)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'No',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(color: TColors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                callbackFun();
              },
              child: Text(
                'Yes',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(color: TColors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  static String getCurrentDateTime() {
    DateTime now = DateTime.now();
    return DateFormat('dd-MM-yyyy HH:mm:ss').format(now);
  }

  static String getFormattedDateTimeString(String dateString) {
    final day = dateString.substring(0, 2);
    final month = dateString.substring(2, 4);
    final year = dateString.substring(4, 8);
    final hours = dateString.substring(8, 10);
    final minutes = dateString.substring(10, 12);
    final seconds = dateString.substring(12, 14);
    return '$day-$month-$year $hours:$minutes:$seconds';
  }

  static void navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return '${text.substring(0, maxLength)}...';
    }
  }

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Size screenSize() {
    return MediaQuery.of(Get.context!).size;
  }

  static double screenHeight() {
    return MediaQuery.of(Get.context!).size.height;
  }

  static double screenWidth() {
    return MediaQuery.of(Get.context!).size.width;
  }

  static String getFormattedDate(DateTime date,
      {String format = 'dd MMM yyyy'}) {
    return DateFormat(format).format(date);
  }

  static List<T> removeDuplicates<T>(List<T> list) {
    return list.toSet().toList();
  }

  static List<Widget> wrapWidgets(List<Widget> widgets, int rowSize) {
    final wrappedList = <Widget>[];
    for (var i = 0; i < widgets.length; i += rowSize) {
      final rowChildren = widgets.sublist(
          i, i + rowSize > widgets.length ? widgets.length : i + rowSize);
      wrappedList.add(Row(children: rowChildren));
    }
    return wrappedList;
  }

  static StationListModel getStationFromStationName(
      String stationName, List<StationListModel> stationList) {
    final station =
        stationList.firstWhere((station) => station.name == stationName);
    return station;
  }

  static StationListModel getStationFromStationId(
      String stationId, List<StationListModel> stationList) {
    final station =
        stationList.firstWhere((station) => station.stationId == stationId);
    return station;
  }

  static String getFormattedDateTimeString2(String dateTimeString) {
    // Original DateTime string
    String convertedDateTimeString = dateTimeString.split('+')[0];
    // Parse the string to a DateTime object
    DateTime dateTime = DateTime.parse(convertedDateTimeString);
    // Format the DateTime object
    String formattedDate = DateFormat('dd-MMM-yyyy hh:mm:ss').format(dateTime);
    return formattedDate;
  }
}
