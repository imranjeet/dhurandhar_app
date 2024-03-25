// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserData {
  String userId;
  String username;
  String? name;
  String phone;
  String? address;
  String? gender;
  String? profileImage;
  String? bestGame;
  String? hobbies;
  UserData({
    required this.userId,
    required this.username,
    this.name,
    required this.phone,
    this.address,
    this.gender,
    this.profileImage,
    this.bestGame,
    this.hobbies,
  });


 

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': userId,
      'username': username,
      'name': name,
      'phone': phone,
      'address': address,
      'gender': gender,
      'profile_image': profileImage,
      'best_game': bestGame,
      'hobbies': hobbies,
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      userId: map['id'] as String,
      username: map['username'] as String,
      name: map['name'] != null ? map['name'] as String : null,
      phone: map['phone'] as String,
      address: map['address'] != null ? map['address'] as String : null,
      gender: map['gender'] != null ? map['gender'] as String : null,
      profileImage: map['profile_image'] != null ? map['profile_image'] as String : null,
      bestGame: map['best_game'] != null ? map['best_game'] as String : null,
      hobbies: map['hobbies'] != null ? map['hobbies'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserData.fromJson(String source) => UserData.fromMap(json.decode(source) as Map<String, dynamic>);
}
