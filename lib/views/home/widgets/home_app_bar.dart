import 'package:dhurandhar/providers/home_provider.dart';
import 'package:dhurandhar/utils/Colors.dart';
import 'package:dhurandhar/utils/widgets/Common.dart';
import 'package:dhurandhar/views/post_event/location_picker_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class THomeAppBar extends StatelessWidget {
  const THomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<HomeScreenProvider>(builder: (context, provider, child) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.001),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: size.width * 0.75,
              child: Text(
                provider.address ?? "Good day for Games",
                style:
                    boldTextStyle(context, isStaticCol: true, color: textWhite),
              ),
            ),
            IconButton(
                onPressed: () {
                  launchScreen(
                      context, const LocationPickerScreen(isFromHome: true));
                },
                icon: Icon(
                  Iconsax.location,
                  color: textWhite,
                ))
          ],
        ),
      );
      // TAppBar(
      //   title: Column(
      //     children: [
      //       Text(
      //         provider.address ?? "Good day for Games",
      //         style:
      //             boldTextStyle(context, isStaticCol: true, color: textWhite),
      //       ),
      //     ],
      //   ),
      //   action: [
      //     IconButton(
      //         onPressed: () {},
      //         icon: Icon(
      //           Iconsax.location,
      //           color: textWhite,
      //         ))
      //   ],
      // );
    });
  }
}
