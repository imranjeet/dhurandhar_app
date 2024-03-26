import 'dart:convert';

import 'package:dhurandhar/models/core/event_data.dart';
import 'package:dhurandhar/utils/Constants.dart';
import 'package:dhurandhar/utils/custom_logger.dart';
import 'package:dhurandhar/utils/widgets/Common.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EventLikeProvider with ChangeNotifier {
  bool isLiked = false;
  int totalLikes = 0;

  checkIsLiked(EventData event) {
    totalLikes = event.totalLikes;
    var currentUserId = FirebaseAuth.instance.currentUser!.uid;
    if (event.likes.contains(currentUserId)) {
      isLiked = true;
    } else {
      isLiked = false;
    }
  }

  void tapOnLike(EventData event) async {
    isLiked = isLiked ? false : true;
    totalLikes = isLiked ? (totalLikes - 1) : (totalLikes + 1);
    notifyListeners();
    bool postLike = await postLikeEvent(event.id);
    if (postLike) {
      isLiked = isLiked ? false : true;
      totalLikes -= 1;
      notifyListeners();
    }
  }

  postLikeEvent(int id) async {
    var url = Uri.parse('${mBaseUrl}api/like_event/$id/');
    final user = FirebaseAuth.instance.currentUser!;
    final token = await user.getIdToken();

    final header = {"Authorization": token ?? ""};

    final response = await http.post(url, headers: header);
    CustomLogger.instance.severe(
        'HTTP REQUEST: Type: GET 👉👉 {url: $url , statusCode: ${response.statusCode} , httpResponse.body: ${response.body}}');
    var decodedResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      toast(decodedResponse['error']);
      return false;
    }
  }
}
