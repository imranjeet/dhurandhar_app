// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dhurandhar/models/core/user_data.dart';

class EventData {
  int id;
  UserData user;
  String title;
  String description;
  String locationName;
  String locationLatitude;
  String locationLongitude;
  String datetime;
  String eventImage;
  EventData({
    required this.id,
    required this.user,
    required this.title,
    required this.description,
    required this.locationName,
    required this.locationLatitude,
    required this.locationLongitude,
    required this.datetime,
    required this.eventImage,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user': user.toMap(),
      'title': title,
      'description': description,
      'locationName': locationName,
      'locationLatitude': locationLatitude,
      'locationLongitude': locationLongitude,
      'datetime': datetime,
      'eventImage': eventImage,
    };
  }

  factory EventData.fromMap(Map<String, dynamic> map) {
    return EventData(
      id: map['id'] as int,
      user: UserData.fromMap(map['user'] as Map<String,dynamic>),
      title: map['title'] as String,
      description: map['description'] as String,
      locationName: map['location_name'] as String,
      locationLatitude: map['location_latitude'] as String,
      locationLongitude: map['location_longitude'] as String,
      datetime: map['datetime'] as String,
      eventImage: map['event_image'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory EventData.fromJson(String source) => EventData.fromMap(json.decode(source) as Map<String, dynamic>);
}

// {
//             "id": 8,
//             
//             "title": "Event 2",
//             "description": "Description of the event",
//             "location_name": "Location 2",
//             "location_latitude": "28.834722",
//             "location_longitude": "78.243889",
//             "datetime": "2024-03-15 16:39:00",
//             "event_image": "http://127.0.0.1:8000/event_images/cwNPEJvA6mNex6rerxAGFsIjQ0R2_download_g42Aa1d.jpeg"
//         },