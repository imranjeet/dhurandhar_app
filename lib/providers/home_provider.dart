import 'dart:convert';

import 'package:dhurandhar/models/core/apiResponse.dart';
import 'package:dhurandhar/models/core/event_data.dart';
import 'package:dhurandhar/utils/Constants.dart';
import 'package:dhurandhar/utils/custom_logger.dart';
import 'package:dhurandhar/utils/get_current_location.dart';
import 'package:dhurandhar/utils/widgets/Common.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

List<EventData> homeListEvents = [];

class HomeScreenProvider extends ChangeNotifier {
  int currentSlide = 0;
  double? lat;
  double? long;
  String? address;
  List<EventData> listEvents = [];
  bool isLoading = false;

  void updateSlide(int index, int len) {
    if (index == len) {
      currentSlide = 0;
      notifyListeners();
    } else {
      currentSlide = index;
      notifyListeners();
    }
  }

  Future<void> initUserLocation() async {
    // Check if location permission is granted
    var status = await Permission.location.status;
    if (status.isGranted) {
      // Location permission is granted, proceed with fetching location
      await fetchUserLocation();
    } else if (status.isDenied ||
        status.isRestricted ||
        status.isPermanentlyDenied) {
      // Location permission is denied, show a dialog to request permission
      var result = await Permission.location.request();
      if (result.isGranted) {
        // Permission granted, proceed with fetching location
        await fetchUserLocation();
      } else {
        // Permission denied, handle accordingly (show error message, etc.)
        CustomLogger.instance.error('Location permission is denied.');
      }
    } else {
      // Location permission is permanently denied, show app settings dialog
      openAppSettings();
    }
  }

// Method to fetch user location after permission is granted
  Future<void> fetchUserLocation() async {
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

  Future<void> getEventsInRaduis() async {
    isLoading = true;
    notifyListeners();
    var url = Uri.parse('${mBaseUrl}api/get_events_in_radius/');
    final user = FirebaseAuth.instance.currentUser!;
    final token = await user.getIdToken();
    CustomLogger.instance.severe("token: $token");
    final header = {"Authorization": token ?? ""};

    // Define your form data
    final Map<String, String> formData = {
      'latitude': lat.toString(),
      'longitude': long.toString(),
      'radius_km': "50",
    };

    final response = await http.post(url, body: formData, headers: header);

    // Read and decode the response

    CustomLogger.instance.severe(
        'HTTP REQUEST: Type: GET 👉👉 {url: $url , statusCode: ${response.statusCode} , httpResponse.body: ${response.body}}');
    var decodedResponse = jsonDecode(response.body);
    isLoading = false;
    notifyListeners();
    // Check if the request was successful (status code 200)
    if (response.statusCode == 200) {
      List<EventData> events = (decodedResponse['events'] as List)
          .map((eventData) => EventData.fromMap(eventData))
          .toList();
      listEvents = events;
      homeListEvents = events;
      notifyListeners();
      // toast(decodedResponse['message']);
    } else {
      CustomLogger.instance
          .error('Request failed with status: ${response.statusCode}');
      toast(decodedResponse['error']);
    }
  }

  Future<ProviderResponse<List<EventData>>> searchBarQuery(
      Map<String, dynamic> queryParams) async {
    String? toSearch = queryParams["search"].toLowerCase();
    CustomLogger.instance.info("query params: $queryParams");
    if (toSearch!.length < 4) {
      return ProviderResponse.error("Some Error Occurred");
    }
    // if (listEvents.isEmpty) {
    //   return ProviderResponse.error(
    //     "Events list is empty. Please try again later.",
    //   );
    // }

    try {
      // Filter the listEvents based on the search query
      List<EventData> filteredEvents = homeListEvents
          .where((event) =>
              event.title.toLowerCase().contains(toSearch) ||
              event.description.toLowerCase().contains(toSearch) ||
              event.locationName.toLowerCase().contains(toSearch))
          .toList();
      return ProviderResponse.completed(data: filteredEvents);
    } catch (er) {
      return ProviderResponse.error(
          "Some Error Occurred , Please try restarting app or Check Back later");
    }
  }
}
