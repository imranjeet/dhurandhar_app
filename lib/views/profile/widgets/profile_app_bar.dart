import 'package:dhurandhar/utils/Colors.dart';
import 'package:dhurandhar/utils/widgets/Common.dart';
import 'package:dhurandhar/utils/widgets/appbar.dart';
import 'package:dhurandhar/views/profile/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ProfileAppBar extends StatelessWidget {
  const ProfileAppBar({
    super.key,
    required this.username,
    required this.isProfile,
  });

  final String username;
  final bool isProfile;

  @override
  Widget build(BuildContext context) {
    return TAppBar(
      showBackArrow: !isProfile,
      title: Column(
        children: [
          Text(
            "@$username",
            style: boldTextStyle(context, isStaticCol: true, color: textWhite),
          ),
        ],
      ),
      action: [
        if (isProfile)
          IconButton(
              onPressed: () {
                launchScreen(context, const SettingsScreen(),
                    pageRouteAnimation: PageRouteAnimation.Slide);
              },
              icon: Icon(
                Iconsax.setting,
                color: textWhite,
              ))
      ],
    );
  }
}
