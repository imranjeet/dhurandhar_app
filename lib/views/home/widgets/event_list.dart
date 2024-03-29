import 'package:dhurandhar/models/core/event_data.dart';
import 'package:dhurandhar/providers/home_provider.dart';
import 'package:dhurandhar/utils/Colors.dart';
import 'package:dhurandhar/utils/widgets/Common.dart';
import 'package:dhurandhar/views/home/widgets/event_listview_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class EventList extends StatelessWidget {
  const EventList({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<HomeScreenProvider>(builder: (context, provider, child) {
      return provider.isLoading
          ? ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: 5,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, i) {
                return const ShimmerEventListViewCard();
              })
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
                      ),
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
                    return EventListViewCard(event: event);
                  });
    });
  }
}
