import 'dart:convert';
import 'dart:io';

import 'package:dhurandhar/utils/Constants.dart';
import 'package:dhurandhar/utils/custom_logger.dart';
import 'package:dhurandhar/utils/widgets/Common.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PostEventProvider extends ChangeNotifier {
  String? addressLatitude;
  String? addressLongitude;
  String? address;

  updatePickedAddress(
      BuildContext context, String address, double lat, double lng) {
    this.address = address;
    addressLatitude = lat.toString();
    addressLongitude = lng.toString();
    notifyListeners();
    Navigator.pop(context);
  }

  Future<void> postEventDataWithFile(
      // BuildContext context,
      String title,
      String description,
      String datetime,
      File? eventImage) async {
    var url = Uri.parse('${mBaseUrl}api/create_event/');
    final user = FirebaseAuth.instance.currentUser!;
    final token = await user.getIdToken();
    CustomLogger.instance.severe("token: $token");

    // Construct the request body
    var request = http.MultipartRequest('POST', url);

    // Add fields to the request (if any)
    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['location_name'] = address ?? "";
    request.fields['location_latitude'] = addressLatitude ?? "";
    request.fields['location_longitude'] = addressLongitude ?? "";
    request.fields['datetime'] = datetime;

    // Add file to the request
    if (eventImage != null) {
      var file =
          await http.MultipartFile.fromPath('event_image', eventImage.path);
      request.files.add(file);
    }

    // Set up headers including the token

    request.headers['Authorization'] = token ?? "";

    // Send the request
    var response = await request.send();

    // Read and decode the response
    var responseData = await response.stream.bytesToString();
    CustomLogger.instance.severe(
        'HTTP REQUEST: Type: GET 👉👉 {url: $url , statusCode: ${response.statusCode} , httpResponse.body: $responseData}');
    var decodedResponse = jsonDecode(responseData);

    // // Check the response
    if (response.statusCode == 201) {
      toast(decodedResponse['message']);
      notifyListeners();
      // Handle successful response
    } else {
      CustomLogger.instance
          .singleLine('Request failed with status: ${response.statusCode}');
      toast(decodedResponse['error']);
      // Handle failed response
    }
  }
}
