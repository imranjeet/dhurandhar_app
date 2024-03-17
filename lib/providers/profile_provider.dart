import 'dart:convert';
import 'dart:io';

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

  void setCurrentUserData(UserData? value) {
    currentUser = value;
    notifyListeners();
  }

  Future<void> updateUserDataWithFile(
    BuildContext context,
      String name, String address, File? profileImage) async {
    var url = Uri.parse('${mBaseUrl}api/update_user/');
    final user = FirebaseAuth.instance.currentUser!;
    final token = await user.getIdToken();
    CustomLogger.instance.severe("token: $token");

    // Construct the request body
    var request = http.MultipartRequest('POST', url);

    // Add fields to the request (if any)
    request.fields['name'] = name;
    request.fields['address'] = address;

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
      Provider.of<ProfileScreenProvider>(context, listen: false).setCurrentUserData(cUser);
      // CustomLogger.instance.singleLine('cUser: ${currentUser?.name}');
      // currentUser = cUser;
      // CustomLogger.instance.singleLine('cUser: ${currentUser?.name}');
      // notifyListeners();
      // Handle successful response
    } else {
      CustomLogger.instance
          .singleLine('Request failed with status: ${response.statusCode}');
      toast(decodedResponse['error']);
      // Handle failed response
    }
  }
}
