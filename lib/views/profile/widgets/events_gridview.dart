import 'package:dhurandhar/models/core/event_data.dart';
import 'package:dhurandhar/providers/profile_provider.dart';
import 'package:dhurandhar/utils/Colors.dart';
import 'package:dhurandhar/utils/widgets/Common.dart';
import 'package:dhurandhar/views/post_event/event_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class EventGridView extends StatelessWidget {
  const EventGridView({super.key, required this.isProfile});
  final bool isProfile;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<ProfileScreenProvider>(builder: (context, provider, child) {
      List<EventData> eventsList =
          isProfile ? provider.currentUserEvents : provider.otherUserEvents;
      return eventsList.isEmpty
          ? Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  SvgPicture.asset("assets/empty_data.svg",
                      color: primaryColor),
                  SizedBox(height: size.height * 0.01),
                  Text(
                    "No events found!",
                    style: boldTextStyle(context),
                  )
                ],
              ),
            )
          : GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
              itemCount: eventsList.length,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns
                crossAxisSpacing: 10.0, // Spacing between columns
                mainAxisSpacing: 10.0, // Spacing between rows
                childAspectRatio: 0.8, // Aspect ratio of each item
              ),
              itemBuilder: (context, i) {
                EventData event = eventsList[i];
                return GestureDetector(
                  onTap: () {
                    launchScreen(context, EventDetailsScreen(event: event),
                        pageRouteAnimation: PageRouteAnimation.Slide);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(1, 1),
                          blurRadius: 8,
                          color: Color.fromRGBO(0, 0, 0, 0.16),
                        )
                      ],
                    ),
                    child: Stack(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        provider.isLoading
                            ? shimmerEffect(
                                Container(
                                  // height: size.height * 0.23,
                                  // width: size.width * 0.4,
                                  color: Colors.grey[300],
                                ),
                              )
                            : Container(
                                // height: size.height * 0.23,
                                // width: size.width * 0.4,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                        image: NetworkImage(event.eventImage),
                                        fit: BoxFit.fill)),
                              ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: provider.isLoading
                              ? Shimmer.fromColors(
                                  baseColor: Colors.black54,
                                  highlightColor: greyColor,
                                  child: Container(
                                    width: size.width * 0.4,
                                    height: size.height * 0.2,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5)),
                                  ))
                              : Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.black54),
                                  child: SizedBox(
                                    width: size.width * 0.4,
                                    child: Text(event.title,
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: boldTextStyle(context,
                                            color: Colors.white,
                                            weight: FontWeight.w500,
                                            size: 17)),
                                  ),
                                ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
    });
  }
}
