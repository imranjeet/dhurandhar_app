import 'package:dhurandhar/models/core/user_data.dart';
import 'package:dhurandhar/providers/profile_provider.dart';
import 'package:dhurandhar/utils/Colors.dart';
import 'package:dhurandhar/utils/size_config.dart';
import 'package:dhurandhar/utils/widgets/Common.dart';
import 'package:dhurandhar/views/home/widgets/primary_header_container.dart';
import 'package:dhurandhar/views/profile/widgets/events_gridview.dart';
import 'package:dhurandhar/views/profile/widgets/profile_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, this.isProfile = true, this.userID});
  final bool isProfile;
  final String? userID;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    final profileProvider =
        Provider.of<ProfileScreenProvider>(context, listen: false);
    final currentUserId = profileProvider.currentUser?.userId;
    String? userId = widget.isProfile ? currentUserId : widget.userID;
    await profileProvider.userProfileData(userId!, widget.isProfile);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<ProfileScreenProvider>(builder: (context, value, child) {
      UserData? currUser =
          widget.isProfile ? value.currentUser : value.otherUser;

      // if (currUser == null) {
      //   return Scaffold(body: circleProgressLoader()); // Placeholder until
      // }
      return Scaffold(
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: initData,
          child: Column(
            children: [
              PrimaryHeaderContainer(
                height: 250.fh,
                child: Column(
                  children: [
                    value.isLoading
                        ? shimmerEffect(
                            ProfileAppBar(
                            username: "",
                            isProfile: widget.isProfile),
                          )
                        : ProfileAppBar(
                            username: currUser?.username ?? "",
                            isProfile: widget.isProfile),
                    // SizedBox(height: size.height * 0.008),
                    Center(
                      child: value.isLoading
                          ? Column(
                              children: [
                                shimmerEffect(
                                  CircleAvatar(
                                    radius: size.height * 0.06,
                                    backgroundColor: Colors.grey[300],
                                  ),
                                ),
                                SizedBox(height: size.height * 0.01),
                                shimmerEffect(
                                  Container(
                                    width: size.width * 0.4,
                                    height: size.height * 0.02,
                                    color: Colors.grey[300],
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                currUser?.profileImage == ""
                                    ? CircleAvatar(
                                        radius: size.height * 0.06,
                                        child: Text(
                                          currUser?.name == ""
                                              ? currUser?.username
                                                  .substring(0, 1)
                                                  .toUpperCase() ?? "A"
                                              : currUser?.username
                                                  .substring(0, 1)
                                                  .toUpperCase() ?? "A",
                                          style: const TextStyle(fontSize: 40),
                                        )
                                        // backgroundImage: const AssetImage(
                                        //     "assets/profile_image.png"),
                                        )
                                    : CircleAvatar(
                                        radius: size.height * 0.06,
                                        backgroundImage: NetworkImage(
                                            currUser?.profileImage ?? ""),
                                      ),
                                SizedBox(height: size.height * 0.01),
                                Text(currUser?.name ?? "",
                                    style: boldTextStyle(context,
                                        isStaticCol: true, color: textWhite)),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: EventGridView(isProfile: widget.isProfile))
            ],
          ),
        ),
      );
    });
  }
}
