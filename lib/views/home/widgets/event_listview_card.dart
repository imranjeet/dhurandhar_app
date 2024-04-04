import 'package:dhurandhar/models/core/event_data.dart';
import 'package:dhurandhar/utils/Colors.dart';
import 'package:dhurandhar/utils/widgets/Common.dart';
import 'package:dhurandhar/views/home/widgets/event_like_widget.dart';
import 'package:dhurandhar/views/post_event/event_details_screen.dart';
import 'package:dhurandhar/views/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class EventListViewCard extends StatelessWidget {
  const EventListViewCard({super.key, required this.event});
  final EventData event;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        launchScreen(context, EventDetailsScreen(event: event),
            pageRouteAnimation: PageRouteAnimation.Slide);
      },
      child: Container(
        // margin: EdgeInsets.symmetric(
        //     horizontal: size.width * 0.04, vertical: size.height * 0.02),
        // padding: EdgeInsets.symmetric(
        //     horizontal: size.width * 0.03, vertical: size.height * 0.01),
        // height: size.height * 0.44,
        // width: size.width * 0.9,
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(20),
        //   color: Colors.white,
        //   boxShadow: const [
        //     BoxShadow(
        //       offset: Offset(1, 1),
        //       blurRadius: 8,
        //       color: Color.fromRGBO(0, 0, 0, 0.16),
        //     )
        //   ],
        // ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.03, vertical: size.height * 0.002),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                                    pageRouteAnimation:
                                        PageRouteAnimation.Slide);
                              },
                              child: CircleAvatar(
                                  radius: size.height * 0.03,
                                  child: Text(
                                    event.user.name == ""
                                        ? event.user.username
                                            .substring(0, 1)
                                            .toUpperCase()
                                        : event.user.username
                                            .substring(0, 1)
                                            .toUpperCase(),
                                    style: const TextStyle(fontSize: 24),
                                  )),
                            )
                          : GestureDetector(
                              onTap: () {
                                launchScreen(
                                    context,
                                    ProfileScreen(
                                        isProfile: false,
                                        userID: event.user.userId),
                                    pageRouteAnimation:
                                        PageRouteAnimation.Slide);
                              },
                              child: CircleAvatar(
                                radius: size.height * 0.03,
                                backgroundImage: NetworkImage(
                                    event.user.profileImage.toString()),
                              ),
                            ),
                      SizedBox(width: size.width * 0.03),
                      Text(event.user.name == "" ? event.user.username : event.user.name ?? "", style: primaryTextStyle(context,  weight: FontWeight.w600)),
                    ],
                  ),
                  const Icon(Iconsax.more),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Container(
              height: size.height * 0.24,
              // width: size.width * 0.9,
              decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                      image: NetworkImage(event.eventImage), fit: BoxFit.fill)),
            ),
            SizedBox(height: size.height * 0.01),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Iconsax.location, size: 20),
                  SizedBox(
                    width: size.width * 0.85,
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
            ),
            SizedBox(height: size.height * 0.01),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Iconsax.clock, size: 20),
                  SizedBox(
                    width: size.width * 0.85,
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
            ),
            SizedBox(height: size.height * 0.007),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
              child: EventLike(size: size, event: event),
            ),
            SizedBox(height: size.height * 0.02),
          ],
        ),
      ),
    );
  }
}

class ShimmerEventListViewCard extends StatelessWidget {
  const ShimmerEventListViewCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      // margin: EdgeInsets.symmetric(
      //     horizontal: size.width * 0.04, vertical: size.height * 0.02),
      // padding: EdgeInsets.symmetric(
      //     horizontal: size.width * 0.03, vertical: size.height * 0.01),
      // height: size.height * 0.44,
      // width: size.width * 0.9,
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(20),
      //   color: Colors.white,
      //   boxShadow: const [
      //     BoxShadow(
      //       offset: Offset(1, 1),
      //       blurRadius: 8,
      //       color: Color.fromRGBO(0, 0, 0, 0.16),
      //     )
      //   ],
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.03, vertical: size.height * 0.002),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    shimmerEffect(
                      CircleAvatar(
                        radius: size.height * 0.03,
                      ),
                    ),
                    SizedBox(width: size.width * 0.03),
                    shimmerEffect(
                      Container(
                        width: size.width * 0.4,
                        height: size.height * 0.03,
                        color: Colors.grey[300],
                      ),
                    ),
                  ],
                ),
                // const Icon(Iconsax.more),
              ],
            ),
          ),
          SizedBox(height: size.height * 0.01),
          shimmerEffect(
            Container(
              height: size.height * 0.23,
              // width: size.width * 0.9,
              color: Colors.grey[300],
            ),
          ),
          SizedBox(height: size.height * 0.01),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Iconsax.location, size: 20),
                shimmerEffect(
                  Container(
                    width: size.width * 0.85,
                    height: size.height * 0.025,
                    color: Colors.grey[300],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: size.height * 0.01),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Iconsax.clock, size: 20),
                shimmerEffect(
                  Container(
                    width: size.width * 0.85,
                    height: size.height * 0.025,
                    color: Colors.grey[300],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: size.height * 0.01),
          shimmerEffect(
            Container(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
              // width: size.width * 0.4,
              height: size.height * 0.05,
              color: Colors.grey[300],
            ),
          ),
          SizedBox(height: size.height * 0.02),
        ],
      ),
    );
  }
}
