// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:dhurandhar/models/core/apiResponse.dart';
import 'package:dhurandhar/models/core/event_data.dart';
import 'package:dhurandhar/providers/home_provider.dart';
import 'package:dhurandhar/utils/Colors.dart';
import 'package:dhurandhar/utils/constants/colors.dart';
import 'package:dhurandhar/utils/debouncing.dart';
import 'package:dhurandhar/utils/size_config.dart';
import 'package:dhurandhar/utils/widgets/Common.dart';
import 'package:dhurandhar/views/home/widgets/event_list.dart';
import 'package:dhurandhar/views/home/widgets/event_listview_card.dart';
import 'package:dhurandhar/views/home/widgets/home_app_bar.dart';
import 'package:dhurandhar/views/home/widgets/primary_header_container.dart';
import 'package:dhurandhar/views/home/widgets/promo_carousel_widget.dart';
import 'package:dhurandhar/views/home/widgets/raduis_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeScreenProvider _homeScreenProvider = HomeScreenProvider();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  TextEditingController searchController = TextEditingController();
  FocusNode desFocus = FocusNode();
  late Debouncer _debouncer;
  int _stackIndex = 0;

  @override
  void initState() {
    super.initState();
    initData();
    searchController.addListener(_handleTextFieldChange);
    _debouncer = Debouncer();
    _stackIndex = 0;
  }

  initData() async {
    final homeProvider =
        Provider.of<HomeScreenProvider>(context, listen: false);
    // await homeProvider.initUserLocation();
    await homeProvider.getEventsInRaduis();
  }

  Future<void> _refreshData() async {
    final homeProvider =
        Provider.of<HomeScreenProvider>(context, listen: false);
    await homeProvider.getEventsInRaduis();
  }

  void _handleTextFieldChange() {
    if (searchController.text.length > 3) {
      setState(() {
        _stackIndex = 4;
      });
    } else {
      setState(() {
        _stackIndex = 0;
      });
    }
  }

  void debounceFuture(
    Debouncer debouncer,
    Completer completer,
    Function delayedFuture,
    dynamic param,
  ) {
    debouncer.run(() async {
      completer.complete(await delayedFuture(param));
    });
  }

  final List<String> banners = [
    "Spread the word! Promote this app to your favorite players and gamers. Let's grow our community together!",

    "Share this app with friends and relatives. Let's expand our community and enjoy together!",

    "Post your game events here and connect with challengers. Build excitement, share your passion!",

    "Contribute to shaping India's gaming future. Develop, innovate, and collaborate through our app. Let's create legends together!",

    "We oppose betting sites and unhealthy products that harm wealth and health. Our platform promotes respect and well-being for all.",
    
  ];

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refreshData,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: primaryColor,
              pinned: true,
              floating: true,
              expandedHeight: 130.fh,
              automaticallyImplyLeading: false,
              centerTitle: false,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: PrimaryHeaderContainer(
                  // height: 150.fh,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: 5.fh),
                      Padding(
                        padding:
                            EdgeInsets.only(bottom: 20.fh, left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              height: 45.fh,
                              width: size.width * 0.81,
                              child: Center(
                                child: Container(
                                  height: 45.fh,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1.0,
                                        color: desFocus.hasFocus
                                            ? primaryColor
                                            : greyScaleColor,
                                      ),
                                      color: greyScaleColor,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Center(
                                      child: TextFormField(
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        controller: searchController,
                                        focusNode: desFocus,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            suffixIcon: searchController
                                                    .text.isNotEmpty
                                                ? IconButton(
                                                    icon: const Icon(
                                                        Icons.clear,
                                                        color:
                                                            TColors.darkerGrey),
                                                    onPressed: () {
                                                      // Clear the text field
                                                      searchController.clear();
                                                    },
                                                  )
                                                : null,
                                            prefixIcon: const Icon(
                                                Iconsax.search_normal,
                                                color: TColors.darkerGrey,
                                                size: 18),
                                            contentPadding: EdgeInsets.zero,
                                            hintText: "Search.."),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const RadiusSelectionBottomSheet();
                                    },
                                  ).whenComplete(() {
                                    _refreshData();
                                  });
                                },
                                icon: const Icon(Iconsax.filter,
                                    color: Colors.white))
                          ],
                        ),
                      ),
                      // Padding(
                      //   padding: EdgeInsets.only(bottom: 20.fh),
                      //   child: const TSearchContainer(),
                      // )
                    ],
                  ),
                ),
              ),
              title: const THomeAppBar(),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Column(
                    children: [
                      SizedBox(height: 8.fh),
                      SizedBox(
                          // height: 200.fh,
                          child: PromoCarouselWidget(banners: banners)),
                      _stackIndex == 4
                          ? _searchResults(context)
                          : const EventList(),
                    ],
                  );
                },
                childCount: 1, // Adjust this count as needed
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchResults(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final completer = Completer<ProviderResponse<List<EventData>>>();
    debounceFuture(_debouncer, completer, _homeScreenProvider.searchBarQuery,
        {"search": searchController.text});
    return FutureBuilder<ProviderResponse<List<EventData>>>(
      future: completer.future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final eventList = snapshot.data!.data;
          if (eventList?.isEmpty ?? true) {
            return Padding(
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
            );
          } else {
            return ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: eventList?.length ?? 0,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, i) {
                  EventData event = eventList![i];
                  return EventListViewCard(event: event);
                });
          }
        } else {
          return ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: 5,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, i) {
                return const ShimmerEventListViewCard();
              });
        }
      },
    );
  }
}
