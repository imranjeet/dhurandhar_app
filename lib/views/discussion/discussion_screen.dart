import 'dart:async';

import 'package:dhurandhar/models/core/event_data.dart';
import 'package:dhurandhar/models/core/user_data.dart';
import 'package:dhurandhar/providers/mobile_auth_provider.dart';
import 'package:dhurandhar/utils/Colors.dart';
import 'package:dhurandhar/utils/custom_logger.dart';
import 'package:dhurandhar/utils/widgets/Common.dart';
import 'package:dhurandhar/views/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class ChatMessage {
  final String senderId;
  final String message;
  final String userName;
  final String? userProfileImage;
  final DateTime timestamp;

  ChatMessage({
    required this.senderId,
    required this.message,
    required this.userName,
    required this.timestamp,
    this.userProfileImage,
  });
}

class ChatPage extends StatefulWidget {
  final EventData eventData;

  const ChatPage({Key? key, required this.eventData}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();

  final ChatService _chatService = ChatService();
  late String _userId;

  @override
  void initState() {
    super.initState();
    _userId = FirebaseAuth.instance.currentUser!.uid;
    _chatService.joinChatRoom(
        widget.eventData.id.toString(), _userId, widget.eventData);
  }

  // @override
  // void dispose() {
  //   _messagesSubscription.cancel();
  //   super.dispose();
  // }

  void _sendMessage(String message) {
    if (message.isNotEmpty) {
      _chatService.sendMessage(
          context, widget.eventData.id.toString(), _userId, message);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: darkColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.eventData.title.toString(),
          style: primaryTextStyle(context,
              size: 18, weight: FontWeight.w500, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream:
                  _chatService.getChatMessages(widget.eventData.id.toString()),
              builder: (context, snapshot) {
                // if (!snapshot.hasData || snapshot.data!.isNotEmpty) {
                //   return const Center(child: CircularProgressIndicator());
                // } else
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No messages available'));
                } else {
                  final List<ChatMessage> messages = snapshot.data!;
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    // controller: _scrollController,
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final reversedIndex = messages.length - 1 - index;
                      final message = messages[reversedIndex];
                      final isCurrentUser = message.senderId == _userId;
                      return ChatBubble(
                        eventData: widget.eventData,
                        message: message,
                        isCurrentUser: isCurrentUser,
                      );
                    },
                  );
                }
              },
            ),
          ),
          SizedBox(
            height: size.height * 0.09,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      cursorColor: primaryColor,
                      style: primaryTextStyle(context,
                          isStaticCol: true, color: Colors.white),
                      controller: _messageController,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.fromLTRB(20, 17, 0, 17),
                        hintText: "Type a message...",
                        hintStyle: const TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: darkGreyColor,
                        border: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide(
                              width: 1,
                              color: darkGreyColor,
                            )),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(
                            width: 1,
                            color: darkGreyColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _sendMessage(_messageController.text),
                    icon: Icon(Icons.send, color: primaryColor, size: 30),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final EventData eventData;
  final ChatMessage message;
  final bool isCurrentUser;

  const ChatBubble({
    Key? key,
    required this.message,
    required this.isCurrentUser,
    required this.eventData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return isCurrentUser
        ? Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: size.width * 0.6,
                  ),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    message.message,
                    style: primaryTextStyle(
                      context,
                      size: 13,
                      weight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.005),
              ],
            ),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      launchScreen(
                          context,
                          ProfileScreen(
                              isProfile: false, userID: message.senderId),
                          pageRouteAnimation: PageRouteAnimation.Slide);
                    },
                    child: CircleAvatar(
                      radius: 24,
                      backgroundImage: message.userProfileImage != null
                          ? NetworkImage(message.userProfileImage!)
                          : null,
                      child: message.userProfileImage != null
                          ? null
                          : Text(
                              message.userName.substring(0, 1).toUpperCase(),
                              style: const TextStyle(fontSize: 20),
                            ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: size.width * 0.6,
                    ),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message.senderId == eventData.user.userId
                                  ? "${message.userName} ⭐"
                                  : message.userName,
                              style: boldTextStyle(
                                context,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: size.height * 0.002),
                            Text(
                              message.message,
                              style: primaryTextStyle(
                                context,
                                weight: FontWeight.w600,
                                size: 13,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          DateFormat('HH:mm a').format(message.timestamp),
                          style: secondaryTextStyle(
                            context,
                            size: 10,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.005),
            ],
          );
  }
}

class ChatService {
  final _database = FirebaseDatabase.instance;

  Future<void> joinChatRoom(
      String eventId, String userId, EventData event) async {
    try {
      final chatRoomRef = _database.ref().child('chats/$eventId');
      final uSnapshot = await chatRoomRef.child('users').child(userId).once();
      final eSnapshot = await chatRoomRef.child('event').once();
      if (!uSnapshot.snapshot.exists) {
        await chatRoomRef.child('users').child(userId).set(true);
      }
      if (!eSnapshot.snapshot.exists) {
        await chatRoomRef.child('event').set({
          'id': event.id,
          'title': event.title,
          'description': event.description,
          'event_image': event.eventImage,
          'user_id': event.user.userId,
          'username': event.user.name ?? event.user.username,
          'profileImage': event.user.profileImage,
        });
      }
    } on FirebaseException catch (e) {
      CustomLogger.instance.singleLine("Error joining chat room: $e");
    }
  }

  Stream<List<ChatMessage>> getChatMessages(String eventId) {
    final chatRoomRef = _database.ref().child('chats/$eventId/messages');
    return chatRoomRef.onChildAdded.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      return ChatMessage(
        senderId: data['sender_id'],
        message: data['message'],
        userName: data['user_name'] ?? 'Unknown',
        userProfileImage: data['user_profile_image'],
        timestamp: DateTime.fromMillisecondsSinceEpoch(data['timestamp']),
      );
    }).scan<List<ChatMessage>>(
      (acc, val, _) => acc..add(val),
      <ChatMessage>[],
    );
  }

  Future<void> sendMessage(BuildContext context, String eventId, String userId,
      String message) async {
    try {
      // final user = FirebaseAuth.instance.currentUser;
      UserData? currentUserData =
          Provider.of<MobileAuthenicationProvider>(context, listen: false)
              .currentUser;
      final chatRoomRef = _database.ref().child('chats/$eventId/messages');
      final newMessageRef = chatRoomRef.push();
      await newMessageRef.set({
        'sender_id': userId,
        'message': message,
        'timestamp': ServerValue.timestamp,
        'user_name': currentUserData != null
            ? currentUserData.name ?? currentUserData.userId
            : 'Unknown',
        'user_profile_image': currentUserData?.profileImage,
      });
      CustomLogger.instance.singleLine("Message sent successfully");
    } catch (e) {
      CustomLogger.instance.singleLine("Error sending message: $e");
    }
  }

  Future<String> getUserName(String userId) async {
    final userSnapshot = await _database.ref().child('users/$userId').once();
    final userData = userSnapshot.snapshot.value as Map<dynamic, dynamic>;
    return userData['name'] ?? 'Unknown';
  }

  Future<String?> getUserProfileImage(String userId) async {
    final userSnapshot = await _database.ref().child('users/$userId').once();
    final userData = userSnapshot.snapshot.value as Map<dynamic, dynamic>;
    return userData['profile_image'];
  }

  Future<bool> isEventCreator(String eventId, String userId) async {
    final eventRef = _database.ref().child('events/$eventId');
    final snapshot = await eventRef.child('creator').once();
    return snapshot.snapshot.exists && snapshot.snapshot.value == userId;
  }

  Future<List<Map<String, dynamic>>?> getAllUserChats(String userId) async {
    try {
      final chatRoomsSnapshot = await _database.ref().child('chats').once();
      final chatRoomsData = chatRoomsSnapshot.snapshot.value;
      if (chatRoomsData == null || chatRoomsData is! List) {
        return null; // Return null if data is missing or not in the expected format
      }

      final List<Map<String, dynamic>> events = [];

      for (var entry in chatRoomsData) {
        if (entry != null && entry is Map) {
          if (entry.containsKey('users') &&
              entry['users'] is Map &&
              entry['users'].containsKey(userId) &&
              entry.containsKey('event')) {
            final eventData = entry['event'];
            if (eventData != null && eventData is Map) {
              events.add(Map<String, dynamic>.from(eventData));
            }
          }
        }
      }

      return events;
    } catch (e) {
      CustomLogger.instance.error("Error getting events by user ID: $e");
      return null;
    }
  }

  Future<void> removeUserFromChatList(int eventId, String userId) async {
    try {
      final chatRoomRef = _database.ref().child('chats/$eventId');
      await chatRoomRef.child('users').child(userId).remove();
    } catch (e) {
      CustomLogger.instance.singleLine("Error removing user from chat: $e");
    }
  }
}
