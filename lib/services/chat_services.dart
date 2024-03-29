// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';

// class ChatService {
//   final _database = FirebaseDatabase.instance;

//   Future<void> joinChatRoom(String eventId, String userId) async {
//     final chatRoomRef = _database.ref().child('chats/$eventId');
//     final snapshot = await chatRoomRef.child('users').child(userId).once();
//     if (!snapshot.snapshot.exists) {
//       await chatRoomRef.child('users').child(userId).set(true);
//     }
//   }

//   Stream<GroupChat> getChatMessages(String eventId) {
//     final chatRoomRef = _database.ref().child('chats/$eventId/messages');
//     return chatRoomRef.onChildAdded.map((snapshot) {
//       final data = snapshot.snapshot.value as Map<dynamic, dynamic>;
//       return GroupChat(
//         senderId: data['sender_id'],
//         message: data['message'],
//         timestamp: data['timestamp'],
//       );
//     });
//   }

//   Future<void> sendMessage(String eventId, String userId, String message) async {
//     final chatRoomRef = _database.ref().child('chats/$eventId/messages');
//     await chatRoomRef.push().set({
//       'sender_id': userId,
//       'message': message,
//       'timestamp': ServerValue.timestamp,
//     });
//   }

//   Future<String> getUserName(String userId) async {
//     final user = await FirebaseAuth.instance.currentUser;
//     if (user != null && userId == user.uid) {
//       return 'You';
//     } else {
//       // Fetch user data from Firebase Firestore or another data source
//       return 'User Name'; // Placeholder for demonstration
//     }
//   }

//   Future<String?> getUserProfileImage(String userId) async {
//     // Fetch user profile image URL from Firebase Firestore or another data source
//     return 'https://example.com/profile_image.jpg'; // Placeholder for demonstration
//   }

//   Future<bool> isEventCreator(String eventId, String userId) async {
//     final eventRef = _database.ref().child('events/$eventId');
//     final snapshot = await eventRef.child('creator').once();
//     return snapshot.snapshot.exists && snapshot.snapshot.value == userId;
//   }
// }

// class GroupChat {
//   final String senderId;
//   final String message;
//   final dynamic timestamp;

//   GroupChat({
//     required this.senderId,
//     required this.message,
//     required this.timestamp,
//   });
// }
