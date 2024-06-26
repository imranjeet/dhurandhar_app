// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:dhurandhar/models/core/event_data.dart';
import 'package:dhurandhar/models/core/user_data.dart';
import 'package:dhurandhar/utils/Constants.dart';
import 'package:dhurandhar/utils/custom_logger.dart';
import 'package:dhurandhar/utils/widgets/Common.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ProfileScreenProvider extends ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  UserData? currentUser;
  UserData? otherUser;
  List<EventData> otherUserEvents = [];
  List<EventData> currentUserEvents = [];
  bool isLoading = false;

  void setCurrentUserData(UserData? value) {
    currentUser = value;
    notifyListeners();
  }

  Future<void> updateUserDataWithFile(
      BuildContext context,
      String name,
      String address,
      String gender,
      String bestGame,
      String hobbies,
      File? profileImage) async {
    var url = Uri.parse('${mBaseUrl}api/update_user/');
    final user = FirebaseAuth.instance.currentUser!;
    final token = await user.getIdToken();
    CustomLogger.instance.severe("token: $token");

    // Construct the request body
    var request = http.MultipartRequest('POST', url);

    // Add fields to the request (if any)
    request.fields['name'] = name;
    request.fields['address'] = address;
    request.fields['gender'] = gender;
    request.fields['best_game'] = bestGame;
    request.fields['hobbies'] = hobbies;

    // Add file to the request
    if (profileImage != null) {
      var file =
          await http.MultipartFile.fromPath('profile_image', profileImage.path);
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
    if (response.statusCode == 200) {
      toast(decodedResponse['message']);
      var cUser = UserData.fromMap(decodedResponse['user']);
      Provider.of<ProfileScreenProvider>(context, listen: false)
          .setCurrentUserData(cUser);
    } else {
      CustomLogger.instance
          .singleLine('Request failed with status: ${response.statusCode}');
      toast(decodedResponse['error']);
      // Handle failed response
    }
  }

  userProfileData(String uId, bool isFromProfile) async {
    isLoading = true;
    // notifyListeners();
    var url = Uri.parse('${mBaseUrl}api/get_user_events/$uId/');
    final user = FirebaseAuth.instance.currentUser!;
    final token = await user.getIdToken();
    final header = {"Authorization": token ?? ""};
    final response = await http.get(url, headers: header);
    CustomLogger.instance.severe(
        'HTTP REQUEST: Type: GET 👉👉 {url: $url , statusCode: ${response.statusCode} , httpResponse.body: ${response.body}}');
    var decodedResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      List<EventData> events = (decodedResponse['events'] as List)
          .map((eventData) => EventData.fromMap(eventData))
          .toList();
      if (!isFromProfile) {
        var cUser = UserData.fromMap(decodedResponse['user']);
        otherUser = cUser;
        otherUserEvents = events;
        isLoading = false;
        notifyListeners();
      } else {
        currentUserEvents = events;
        isLoading = false;
        notifyListeners();
      }
    } else {
      isLoading = false;
      notifyListeners();
      toast(decodedResponse['error']);
    }
  }

  Future<void> updateUsername(BuildContext context, String username) async {
    var url = Uri.parse('${mBaseUrl}api/update_username/');
    final user = FirebaseAuth.instance.currentUser!;
    final token = await user.getIdToken();
    final header = {"Authorization": token ?? ""};
    // Define your form data
    final Map<String, String> formData = {'username': username};
    final response = await http.post(url, body: formData, headers: header);
    CustomLogger.instance.severe(
        'HTTP REQUEST: Type: GET 👉👉 {url: $url , statusCode: ${response.statusCode} , httpResponse.body: ${response.body}}');
    var decodedResponse = jsonDecode(response.body);

    // // Check the response
    if (response.statusCode == 200) {
      toast(decodedResponse['message']);
      var cUser = UserData.fromMap(decodedResponse['user']);
      Provider.of<ProfileScreenProvider>(context, listen: false)
          .setCurrentUserData(cUser);
    } else {
      CustomLogger.instance
          .singleLine('Request failed with status: ${response.statusCode}');
      toast(decodedResponse['error']);
      // Handle failed response
    }
  }
}
