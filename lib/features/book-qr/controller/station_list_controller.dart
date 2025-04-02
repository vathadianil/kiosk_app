import 'dart:convert';
import 'package:get/get.dart';
import 'package:kiosk_app/features/book-qr/models/station_list_model.dart';
import 'package:kiosk_app/repositories/book-qr/station_list_repository.dart';
import 'package:kiosk_app/utils/db/database_helper.dart';
import 'package:kiosk_app/utils/local_storage/storage_utility.dart';
import 'package:kiosk_app/utils/popups/loaders.dart';

class StationListController extends GetxController {
  static StationListController get instance => Get.find();

//Variables
  final isLoading = true.obs;
  final stationListRepository = Get.put(StationListRepository());

  RxList<StationListModel> stationList = <StationListModel>[].obs;

  @override
  void onInit() async {
    super.onInit();

    try {
      // DatabaseHelperController.instance.dropTableAndCreateNewOne('ticket_info');
      final token = await TLocalStorage().readData('token') ?? '';
      final tokenExpirationTimeString =
          await TLocalStorage().readData('tokenExpirationTimeString') ?? '';

      if (token == '' || tokenExpirationTimeString == '') {
        await saveToken();
      } else {
        final tokenExpirationDateObject =
            DateTime.parse(tokenExpirationTimeString);
        if (DateTime.now().isAfter(tokenExpirationDateObject)) {
          await saveToken();
        }
      }
      getStationList();
    } catch (e) {
      print(e);
    }
  }

  saveToken() async {
    final response = await stationListRepository.getToken();
    await TLocalStorage().saveData('token', response.accessToken);
    await TLocalStorage()
        .saveData('tokenExpirationTimeString', response.tokenExpiriation);
  }

  Future<void> getStationList() async {
    //Show loader while loading categories
    isLoading.value = true;

    //Retrive station list Fetched Date
    final stationListFetchedTimestamp =
        await TLocalStorage().readData('stationListFetchedTimestamp') ?? '';

    // Retrieve station list from local storage
    final storedData = await TLocalStorage().readData('stationList') ?? '';

    List<StationListModel> storedStationList = [];

    if (stationListFetchedTimestamp != '') {
      try {
        final currentTime = DateTime.now();
        final lastFetchedTime = DateTime.parse(stationListFetchedTimestamp);
        final difference = currentTime.difference(lastFetchedTime);
        if (difference.inHours < 2 && storedData != '') {
          storedStationList = (storedData as List)
              .map((item) => StationListModel.fromJson(jsonDecode(item)))
              .toList();
          if (storedStationList.isNotEmpty) {
            stationList.assignAll(storedStationList);
            isLoading.value = false;
          } else {
            fetchStationList();
          }
        } else {
          fetchStationList();
        }
      } catch (e) {
        fetchStationList();
      }
    } else {
      fetchStationList();
    }
  }

  fetchStationList() async {
    try {
      final token = await TLocalStorage().readData('token') ?? '';

      if (token != '') {
        final stationsData =
            await stationListRepository.fetchStationList(token);
        stationList
            .assignAll(stationsData.stations as Iterable<StationListModel>);

        // Save fetched data to local storage
        await TLocalStorage().saveData(
          'stationList',
          stationsData.stations!
              .map((item) => jsonEncode(item.toJson()))
              .toList(),
        );

        await TLocalStorage().saveData(
            'stationListFetchedTimestamp', DateTime.now().toIso8601String());
      } else {
        TLoaders.errorSnackBar(
            title: 'Oh Snap!',
            message: 'Your Session has expired!. Please Login Again.');
      }
    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    } finally {
      //Remove loader
      isLoading.value = false;
    }
  }
}
