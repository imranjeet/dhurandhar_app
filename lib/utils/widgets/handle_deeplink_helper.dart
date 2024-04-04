import 'dart:convert';

import 'package:dhurandhar/main.dart';
import 'package:dhurandhar/models/core/event_data.dart';
import 'package:dhurandhar/utils/Constants.dart';
import 'package:dhurandhar/utils/custom_logger.dart';
import 'package:dhurandhar/utils/widgets/Common.dart';
import 'package:dhurandhar/views/post_event/event_details_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class HandleDeeplinkHelper {
  void handleDeepLink(Uri deepLink) {
    // Extract event ID from the deep link URL
    if (deepLink.pathSegments.contains("shareId")) {
      String eventId = deepLink.pathSegments.last;
      CustomLogger.instance.singleLine("eventId: $eventId");
      redirectToEventDetailScreen(eventId);
    }
    // String eventID = deepLink.pathSegments.last;
    // CustomLogger.instance.singleLine("eventID: $eventID");

    // Navigate to EventDetailsScreen with the eventID
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => EventDetailsScreen(eventID),
    //   ),
    // );
  }

  redirectToEventDetailScreen(String eventId) async {
    var url = Uri.parse('${mBaseUrl}api/get-event-by-id/$eventId/');
    final user = FirebaseAuth.instance.currentUser!;
    final token = await user.getIdToken();

    final header = {"Authorization": token ?? ""};

    final response = await http.get(url, headers: header);
    CustomLogger.instance.severe(
        'HTTP REQUEST: Type: GET 👉👉 {url: $url , statusCode: ${response.statusCode} , httpResponse.body: ${response.body}}');
    var decodedResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final event = EventData.fromMap(decodedResponse['event']);
      launchScreen(getContext, EventDetailsScreen(event: event),
          pageRouteAnimation: PageRouteAnimation.Slide);
    } else {
      toast(decodedResponse['error']);
    }
  }
}
