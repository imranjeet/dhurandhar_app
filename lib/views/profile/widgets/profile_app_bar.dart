import 'package:dhurandhar/utils/Colors.dart';
import 'package:dhurandhar/utils/widgets/Common.dart';
import 'package:dhurandhar/utils/widgets/appbar.dart';
import 'package:dhurandhar/views/authenication/upload_user_data.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ProfileAppBar extends StatelessWidget {
  const ProfileAppBar({
    super.key,
    required this.username,
  });

  final String username;

  @override
  Widget build(BuildContext context) {
    return TAppBar(
      title: Column(
        children: [
          Text(
            "@$username",
            style: boldTextStyle(context, isStaticCol: true, color: textWhite),
          ),
        ],
      ),
      action: [
        IconButton(
            onPressed: () {
              launchScreen(context, UploadUserData(), pageRouteAnimation: PageRouteAnimation.Slide);
            },
            icon: Icon(
              Iconsax.setting,
              color: textWhite,
            ))
      ],
    );
  }
}
