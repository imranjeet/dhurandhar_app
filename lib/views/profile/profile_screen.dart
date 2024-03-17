import 'package:cached_network_image/cached_network_image.dart';
import 'package:dhurandhar/models/core/user_data.dart';
import 'package:dhurandhar/providers/profile_provider.dart';
import 'package:dhurandhar/utils/Colors.dart';
import 'package:dhurandhar/utils/size_config.dart';
import 'package:dhurandhar/utils/widgets/Common.dart';
import 'package:dhurandhar/views/home/widgets/primary_header_container.dart';
import 'package:dhurandhar/views/profile/widgets/profile_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, this.isProfile = true, this.userData});
  final bool isProfile;
  final UserData? userData;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<ProfileScreenProvider>(
        builder: (context, value, child) {
      UserData? currUser = isProfile? value.currentUser : userData;
      // CustomLogger.instance.singleLine('value.currentUser: ${value.currentUser!.name}');
      // CustomLogger.instance.singleLine('currUser: ${currUser!.name}');
      if (currUser == null) {
          return Scaffold(body: circleProgressLoader()); // Placeholder until 
        }
      return Scaffold(
          body: SingleChildScrollView(
        child: Column(
          children: [
            PrimaryHeaderContainer(
              height: 250.fh,
              child: Column(
                children: [
                  ProfileAppBar(username: currUser.username),
                  // SizedBox(height: size.height * 0.008),
                  Center(
                    child: Column(
                      children: [
                        currUser.profileImage == null
                            ? CircleAvatar(
                                radius: size.height * 0.06,
                                backgroundImage: const AssetImage(
                                    "assets/profile_image.png"),
                              )
                            : CircleAvatar(
                                radius: size.height * 0.06,
                                backgroundImage: CachedNetworkImageProvider(
                                    currUser.profileImage ?? ""),
                              ),
                        SizedBox(height: size.height * 0.01),
                        Text(currUser.name ?? "",
                            style: boldTextStyle(context,
                                isStaticCol: true, color: textWhite)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ));
    });
  }
}
