import 'package:dhurandhar/models/core/event_data.dart';
import 'package:dhurandhar/models/core/user_data.dart';
import 'package:dhurandhar/utils/Colors.dart';
import 'package:dhurandhar/utils/widgets/Common.dart';
import 'package:dhurandhar/utils/widgets/appbar.dart';
import 'package:dhurandhar/views/discussion/discussion_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ChatsListScreen extends StatefulWidget {
  const ChatsListScreen({super.key});

  @override
  State<ChatsListScreen> createState() => _ChatsListScreenState();
}

class _ChatsListScreenState extends State<ChatsListScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  final ChatService _chatService = ChatService();
  List<Map<String, dynamic>>? chats;

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    var currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final fetchedChats = await _chatService.getAllUserChats(currentUserId);
    setState(() {
      chats = fetchedChats;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: TAppBar(
        appBarColor: primaryColor,
        title: Text(
          'Game Conversations',
          style: boldTextStyle(context, isStaticCol: true, color: Colors.white),
        ),
      ),
      body: chats?.isEmpty ?? true
          ? RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: fetchEvents,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: size.height * 0.2),
                    child: Column(
                      children: [
                        SvgPicture.asset("assets/empty_data.svg",
                            color: primaryColor),
                        SizedBox(height: size.height * 0.01),
                        Text(
                          "No chats found!",
                          style: boldTextStyle(context),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          : RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: fetchEvents,
              child: SizedBox(
                height: size.height * 0.86,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: chats?.length,
                  itemBuilder: (context, index) {
                    final event = chats![0];
                    return Dismissible(
                      key: Key(event['id']
                          .toString()), // Use a unique identifier for each item
                      direction: DismissDirection.startToEnd,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerLeft,
                        child: const Padding(
                          padding: EdgeInsets.only(left: 16.0),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                      ),
                      onDismissed: (direction) {
                        // Remove the chat from the list and perform deletion logic here
                        setState(() {
                          chats!.removeAt(index);
                        });
                        var currentUserId =
                            FirebaseAuth.instance.currentUser!.uid;
                        _chatService.removeUserFromChatList(
                            event['id'], currentUserId);
                      },
                      child: InkWell(
                        onTap: () {
                          EventData eventData = EventData(
                              id: event['id'],
                              user: UserData(
                                  userId: event['user_id'],
                                  username: event['username'],
                                  phone: ""),
                              title: event['title'],
                              description: event['description'],
                              locationName: "",
                              locationLatitude: "",
                              locationLongitude: "",
                              datetime: "",
                              eventImage: event['event_image'],
                              likes: [],
                              totalLikes: 0);
                          launchScreen(context, ChatPage(eventData: eventData),
                              pageRouteAnimation: PageRouteAnimation.Slide);
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: size.height * 0.035,
                            backgroundImage: NetworkImage(event['event_image']),
                          ),
                          title: Text(event['title']),
                          subtitle: Text(event['description']),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }
}
