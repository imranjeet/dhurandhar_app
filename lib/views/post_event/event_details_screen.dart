import 'package:dhurandhar/models/core/event_data.dart';
import 'package:dhurandhar/utils/Colors.dart';
import 'package:dhurandhar/utils/constants/sizes.dart';
import 'package:dhurandhar/utils/widgets/Common.dart';
import 'package:dhurandhar/utils/widgets/appbar.dart';
import 'package:dhurandhar/views/home/widgets/event_like_widget.dart';
import 'package:dhurandhar/views/home/widgets/primary_header_container.dart';
import 'package:dhurandhar/views/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class EventDetailsScreen extends StatelessWidget {
  final EventData event;
  const EventDetailsScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          PrimaryHeaderContainer(
            height: size.height * 0.15,
            child: Column(
              children: [
                Container(),
                TAppBar(
                  title: Column(
                    children: [
                      Text(
                        event.title,
                        style: boldTextStyle(context,
                            size: 22, isStaticCol: true, color: textWhite),
                      ),
                    ],
                  ),
                  showBackArrow: true,
                  // action: [
                  //   IconButton(
                  //       onPressed: () {},
                  //       icon: Icon(
                  //         Iconsax.location,
                  //         color: textWhite,
                  //       ))
                  // ],
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
              ],
            ),
          ),
          SizedBox(
            width: size.width * 0.9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: size.height * 0.3,
                  width: size.width * 0.9,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: NetworkImage(event.eventImage),
                          fit: BoxFit.fill)),
                ),
                SizedBox(height: size.height * 0.02),
                Row(
                  children: [
                    event.user.profileImage == ""
                        ? GestureDetector(
                            onTap: () {
                              launchScreen(
                                  context,
                                  ProfileScreen(
                                      isProfile: false,
                                      userID: event.user.userId),
                                  pageRouteAnimation: PageRouteAnimation.Slide);
                            },
                            child: CircleAvatar(
                                radius: size.height * 0.04,
                                child: Text(
                                  event.user.name == ""
                                      ? event.user.username
                                          .substring(0, 1)
                                          .toUpperCase()
                                      : event.user.username
                                          .substring(0, 1)
                                          .toUpperCase(),
                                  style: const TextStyle(fontSize: 30),
                                )),
                          )
                        : GestureDetector(
                            onTap: () {
                              launchScreen(
                                  context,
                                  ProfileScreen(
                                      isProfile: false,
                                      userID: event.user.userId),
                                  pageRouteAnimation: PageRouteAnimation.Slide);
                            },
                            child: CircleAvatar(
                              radius: size.height * 0.03,
                              backgroundImage: NetworkImage(
                                  event.user.profileImage.toString()),
                            ),
                          ),
                    SizedBox(width: size.width * 0.03),
                    Text(
                        event.user.name == ""
                            ? event.user.username
                            : event.user.name ?? "",
                        style:
                            primaryTextStyle(context, weight: FontWeight.w600)),
                  ],
                ),
                SizedBox(height: size.height * 0.02),
                Text("Description", style: secondaryTextStyle(context)),
                SizedBox(height: size.height * 0.005),
                Text(
                  event.description,
                  style: primaryTextStyle(context),
                ),
                SizedBox(height: size.height * 0.02),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Iconsax.location, size: 20),
                    SizedBox(width: size.width * 0.03),
                    SizedBox(
                      width: size.width * 0.75,
                      child: Text(event.locationName,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: primaryTextStyle(context,
                              color: primaryColor,
                              weight: FontWeight.w500,
                              size: 14)),
                    )
                  ],
                ),
                SizedBox(height: size.height * 0.01),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Iconsax.clock, size: 20),
                    SizedBox(width: size.width * 0.03),
                    SizedBox(
                      width: size.width * 0.75,
                      child: Text(event.datetime,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: primaryTextStyle(context,
                              color: primaryColor,
                              weight: FontWeight.w500,
                              size: 14)),
                    )
                  ],
                ),
                SizedBox(height: size.height * 0.03),
                EventLike(size: size, event: event),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
