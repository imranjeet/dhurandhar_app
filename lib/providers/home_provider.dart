import 'package:dhurandhar/utils/custom_logger.dart';
import 'package:dhurandhar/utils/get_current_location.dart';
import 'package:flutter/material.dart';

class HomeScreenProvider extends ChangeNotifier {
  int currentSlide = 0;
  double? lat;
  double? long;
  String? address;

  void updateSlide(int index, int len) {
    if (index == len) {
      currentSlide = 0;
      notifyListeners();
    } else {
      currentSlide = index;
      notifyListeners();
    }
  }

  void initUserLocation() async {
    Map<String, dynamic> locationData = await getCurrentLocation();
    if (locationData.containsKey('error')) {
      // Handle error
      CustomLogger.instance.error("Error: ${locationData['error']}");
    } else {
      // Get location data
      lat = locationData['latitude'];
      long = locationData['longitude'];
      address = locationData['locationName'];
    }
  }

  updatePickedAddress(
      BuildContext context, String address, double lat, double lng) {
    this.address = address;
    lat = lat;
    long = lng;
    notifyListeners();
    Navigator.pop(context);
  }
}
