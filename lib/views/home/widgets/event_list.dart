import 'package:dhurandhar/models/core/event_data.dart';
import 'package:dhurandhar/providers/home_provider.dart';
import 'package:dhurandhar/utils/Colors.dart';
import 'package:dhurandhar/utils/widgets/Common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class EventList extends StatelessWidget {
  const EventList({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<HomeScreenProvider>(builder: (context, provider, child) {
      return provider.isLoading
          ? Padding(
              padding: const EdgeInsets.only(top: 20),
              child: circleProgressLoader(),
            )
          : provider.listEvents.isEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      SvgPicture.asset("assets/empty_data.svg",
                          color: primaryColor),
                      SizedBox(height: size.height * 0.01),
                      Text(
                        "No events  found!",
                        style: boldTextStyle(context),
                      )
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: provider.listEvents.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, i) {
                    EventData event = provider.listEvents[i];
                    return Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: size.width * 0.04,
                          vertical: size.height * 0.02),
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.03,
                          vertical: size.height * 0.01),
                      height: size.height * 0.4,
                      width: size.width * 0.9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            offset: Offset(1, 1),
                            blurRadius: 8,
                            color: Color.fromRGBO(0, 0, 0, 0.16),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  event.user.profileImage == null
                                      ? CircleAvatar(
                                          radius: size.height * 0.03,
                                          backgroundImage: const AssetImage(
                                              "assets/profile_image.png"),
                                        )
                                      : CircleAvatar(
                                          radius: size.height * 0.03,
                                          backgroundImage: NetworkImage(
                                              event.user.profileImage.toString()),
                                        ),
                                  SizedBox(width: size.width * 0.03),
                                  Text(
                                      event.user.name ?? "@${event.user.username}"),
                                ],
                              ),
                               const Icon(Iconsax.more),
                            ],
                          ),
                          SizedBox(height: size.height * 0.01),
                          Container(
                            height: size.height * 0.23,
                            width: size.width * 0.9,
                            decoration: BoxDecoration(
                                // borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                    image: NetworkImage(event.eventImage),
                                    fit: BoxFit.cover)
                                // color: Colors.black,
                                // boxShadow: const [
                                //   BoxShadow(
                                //     offset: Offset(1, 1),
                                //     blurRadius: 8,
                                //     color: Color.fromRGBO(0, 0, 0, 0.16),
                                //   )
                                // ],
                                ),
                          ),
                          SizedBox(height: size.height * 0.01),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(Iconsax.location),
                              SizedBox(
                                width: size.width * 0.75,
                                child: Text(event.locationName,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: primaryTextStyle(context,
                                        color: primaryColor,
                                        weight: FontWeight.w700,
                                        size: 16)),
                              )
                            ],
                          ),
                          SizedBox(height: size.height * 0.01),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(Iconsax.alarm),
                              SizedBox(
                                width: size.width * 0.75,
                                child: Text(event.datetime,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: primaryTextStyle(context,
                                        color: primaryColor,
                                        weight: FontWeight.w700,
                                        size: 16)),
                              )
                            ],
                          ),
                          // SizedBox(
                          //   // width: size.width * 0.75,
                          //   child: RichText(
                          //     textAlign: TextAlign.start,
                          //     overflow: TextOverflow.ellipsis,
                          //     maxLines: 1,
                          //     text: TextSpan(
                          //       text: "Location: ",
                          //       style: primaryTextStyle(context,
                          //           weight: FontWeight.w400,
                          //           size: 16,
                          //           color: const Color(0XFF000000)),
                          //       children: <TextSpan>[
                          //         TextSpan(
                          //             text: event.locationName,
                          //             style: primaryTextStyle(context,
                          //                 color: secondaryColor,
                          //                 weight: FontWeight.w700,
                          //                 size: 16)),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          // SizedBox(height: size.height * 0.01),
                          // RichText(
                          //   textAlign: TextAlign.start,
                          //   text: TextSpan(
                          //     text: "Time: ",
                          //     style: primaryTextStyle(context,
                          //         weight: FontWeight.w400,
                          //         size: 16,
                          //         color: const Color(0XFF000000)),
                          //     children: <TextSpan>[
                          //       TextSpan(
                          //           text: event.datetime,
                          //           style: primaryTextStyle(context,
                          //               color: secondaryColor,
                          //               weight: FontWeight.w700,
                          //               size: 16)),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    );
                  });
    });
  }
}
