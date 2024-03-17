import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../utils/custom_logger.dart';

class RequestHelper {
  static Future<dynamic> getApiRequest(String url, {hasHeader = false}) async {
    final user = FirebaseAuth.instance.currentUser!;
    final token = await user.getIdToken();
    CustomLogger.instance.severe("token: $token");
    final header = {"Authorization": token ?? ""};

    http.Response httpResponse =
        await http.get(Uri.parse(url), headers: hasHeader ? header : null);
    CustomLogger.instance.severe(
        'HTTP REQUEST: Type: GET 👉👉 {url: $url , statusCode: ${httpResponse.statusCode} , httpResponse.body: ${httpResponse.body}}');

    return httpResponse;

    // try {
    //   if (httpResponse.statusCode == 200) //successful
    //   {
    //     String responseData = httpResponse.body; //json

    //     var decodeResponseData = jsonDecode(responseData);

    //     return decodeResponseData;
    //   } else if (httpResponse.statusCode == 502) {
    //     return "502";
    //   } else {
    //     return "Failed";
    //   }
    // } catch (exp) {
    //   return "Failed";
    // }
  }

  static Future<dynamic> putApiRequest(String url, Map mapBody,
      {hasHeader = false}) async {
    final user = FirebaseAuth.instance.currentUser!;
    final token = await user.getIdToken();
    debugPrint("token: $token");
    final header = {
      "Content-Type": "application/json",
      "authorization": token ?? ""
    };
    final body = jsonEncode(mapBody);

    http.Response httpResponse =
        await http.put(Uri.parse(url), headers: header, body: body);
    CustomLogger.instance.severe(
        'HTTP REQUEST: Type: PUT 👉👉 {url: $url , statusCode: ${httpResponse.statusCode} , body: $body, httpResponse.body: ${httpResponse.body}}');
    // debugPrint(
    //     "HTTP REQUEST: Type: PUT 👉👉 {url: $url , statusCode: ${httpResponse.statusCode} , body: $body, httpResponse.body: ${httpResponse.body}}");
    return httpResponse;
  }

  static Future<dynamic> postApiRequest(String url, Map mapBody,
      {hasHeader = false}) async {
    final user = FirebaseAuth.instance.currentUser!;
    final token = await user.getIdToken();
    debugPrint("token: $token");
    final header = {
      "Content-Type": "application/json",
      "authorization": token ?? ""
    };
    final body = jsonEncode(mapBody);

    http.Response httpResponse =
        await http.post(Uri.parse(url), headers: header, body: body);
    CustomLogger.instance.severe(
        'HTTP REQUEST: Type: POST 👉👉 {url: $url , statusCode: ${httpResponse.statusCode} , body: $body, httpResponse.body: ${httpResponse.body}}');

    // debugPrint(
    //     "HTTP REQUEST: Type: POST 👉👉 {url: $url , statusCode: ${httpResponse.statusCode} , body: $body, httpResponse.body: ${httpResponse.body}}");

    return httpResponse;
  }
}
