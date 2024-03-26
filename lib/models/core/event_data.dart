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
  List likes;
  int totalLikes;
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
    required this.likes,
    required this.totalLikes,
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
      'event_image': eventImage,
      'likes': likes,
      'total_likes': totalLikes,
    };
  }

  factory EventData.fromMap(Map<String, dynamic> map) {
    return EventData(
      id: map['id'] as int,
      user: UserData.fromMap(map['user'] as Map<String, dynamic>),
      title: map['title'] as String,
      description: map['description'] as String,
      locationName: map['location_name'] as String,
      locationLatitude: map['location_latitude'] as String,
      locationLongitude: map['location_longitude'] as String,
      datetime: map['datetime'] as String,
      eventImage: map['event_image'] as String,
      likes: map['likes'] as List,
      totalLikes: map['total_likes'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory EventData.fromJson(String source) =>
      EventData.fromMap(json.decode(source) as Map<String, dynamic>);
}