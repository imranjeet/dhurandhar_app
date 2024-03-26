import 'dart:convert';

import 'package:dhurandhar/models/core/event_data.dart';
import 'package:dhurandhar/utils/Constants.dart';
import 'package:dhurandhar/utils/StringExtensions.dart';
import 'package:dhurandhar/utils/custom_logger.dart';
import 'package:dhurandhar/utils/widgets/Common.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:http/http.dart' as http;

class EventLike extends StatefulWidget {
  const EventLike({
    super.key,
    required this.size,
    required this.event,
  });

  final Size size;
  final EventData event;

  @override
  State<EventLike> createState() => _EventLikeState();
}

class _EventLikeState extends State<EventLike> {
  bool isLiked = false;
  int totalLikes = 0;

  @override
  void initState() {
    super.initState();
    checkIsLiked(widget.event);
  }

  checkIsLiked(EventData event) {
    totalLikes = event.totalLikes;
    var currentUserId = FirebaseAuth.instance.currentUser!.uid;
    if (event.likes.contains(currentUserId)) {
      isLiked = true;
    } else {
      isLiked = false;
    }
  }

  onTapLike() async {
    setState(() {
      totalLikes = isLiked ? (totalLikes - 1) : (totalLikes + 1);
      isLiked = !isLiked;
    });
    bool postLike = await postLikeEvent(widget.event.id);
    if (!postLike) {
      setState(() {
        totalLikes = isLiked ? (totalLikes - 1) : (totalLikes + 1);
        isLiked = !isLiked;
      });
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

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
            onTap: () async {
              onTapLike();
            },
            child: isLiked
                ? const Icon(Icons.favorite, size: 32, color: Colors.red)
                : const Icon(Iconsax.heart, size: 28, color: Colors.red)),
        SizedBox(width: widget.size.width * 0.01),
        Text(formatNumberToString(totalLikes),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style:
                primaryTextStyle(context, weight: FontWeight.w700, size: 16)),
        SizedBox(width: widget.size.width * 0.03),
        const Icon(Iconsax.message, size: 28),
      ],
    );
  }
}
