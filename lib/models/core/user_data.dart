// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserData {
  String userId;
  String username;
  String? name;
  String phone;
  String? address;
  String? profileImage;
  UserData({
    required this.userId,
    required this.username,
    this.name,
    required this.phone,
    this.address,
    this.profileImage,
  });

  

  // "user": {
  //       "id": "cwNPEJvA6mNex6rerxAGFsIjQ0R2",
  //       "username": "userbhvwnl",
  //       "name": "",
  //       "phone": "+918192839378",
  //       "address": "",
  //       "profile_image": ""
  //   },

 

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': userId,
      'username': username,
      'name': name,
      'phone': phone,
      'address': address,
      'profile_image': profileImage,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      userId: map['id'] as String,
      username: map['username'] as String,
      name: map['name'] != null ? map['name'] as String : null,
      phone: map['phone'] as String,
      address: map['address'] != null ? map['address'] as String : null,
      profileImage: map['profile_image'] != null ? map['profile_image'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserData.fromJson(String source) => UserData.fromMap(json.decode(source) as Map<String, dynamic>);
}
