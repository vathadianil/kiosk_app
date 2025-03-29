import 'package:get/get.dart';
import 'package:kiosk_app/features/home/home.dart';
import 'package:kiosk_app/repositories/book-qr/station_list_repository.dart';
import 'package:kiosk_app/utils/helpers/helper_functions.dart';
import 'package:kiosk_app/utils/local_storage/storage_utility.dart';
import 'package:kiosk_app/utils/popups/loaders.dart';
import 'package:intl/intl.dart';

class BusineessHoursController extends GetxController {
  static BusineessHoursController get instance => Get.find();

  final _stationlistRepository = Get.put(StationListRepository());
  final isTicketSelleingTimeExpired = false.obs;
  final isLoading = false.obs;

  @override
  onInit() {
    super.onInit();
    fetchBusinessHours();
  }

  fetchBusinessHours() async {
    try {
      final token = await TLocalStorage().readData('token') ?? '';
      if (token != '') {
        final businessHoursData =
            await _stationlistRepository.fetchBusineesHours(token);

        String startDateTImeString =
            THelperFunctions.getFormattedDateTimeString(
                '${businessHoursData.ticketSellingStartime}00');
        String endDateTImeString = THelperFunctions.getFormattedDateTimeString(
            '${businessHoursData.ticketSellingEndtime}00');
        DateFormat dateFormat = DateFormat("dd-MM-yyyy hh:mm:ss");
        DateTime startDateTime = dateFormat.parse(startDateTImeString);
        DateTime endDateTime = dateFormat.parse(endDateTImeString);
        DateTime currentDateTime = DateTime.now();

        if (currentDateTime.isAfter(startDateTime) &&
            currentDateTime.isBefore(endDateTime)) {
          isTicketSelleingTimeExpired.value = false;
        } else {
          isTicketSelleingTimeExpired.value = true;
          THelperFunctions.showAlert('Booking Closed',
              'Tickets are available for purchase between ${DateFormat.Hms().format(startDateTime)} and ${DateFormat.Hms().format(endDateTime)}. Kindly ensure your booking falls within this time frame. We apologize for any inconvenience caused.',
              () {
            Get.back();
          });
        }
      } else {
        Get.offAll(
          () => const HomeScreen(),
        );
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: '', message: e.toString());
    } finally {
      //Remove loader
      isLoading.value = false;
    }
  }
}
