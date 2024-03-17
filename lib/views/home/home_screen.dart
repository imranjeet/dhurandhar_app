import 'package:dhurandhar/providers/home_provider.dart';
import 'package:dhurandhar/utils/Colors.dart';
import 'package:dhurandhar/utils/constants/image_strings.dart';
import 'package:dhurandhar/utils/size_config.dart';
import 'package:dhurandhar/views/home/widgets/event_list.dart';
import 'package:dhurandhar/views/home/widgets/home_app_bar.dart';
import 'package:dhurandhar/views/home/widgets/primary_header_container.dart';
import 'package:dhurandhar/views/home/widgets/promo_carousel_widget.dart';
import 'package:dhurandhar/views/home/widgets/search_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async {
    final homeProvider = Provider.of<HomeScreenProvider>(context, listen: false);
    homeProvider.initUserLocation();
  }

  final List<String> banners = [
    TImages.promoBanner1,
    TImages.promoBanner2,
    TImages.promoBanner3,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
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
                      padding: EdgeInsets.only(bottom: 20.fh),
                      child: const TSearchContainer(),
                    )
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
                    PromoCarouselWidget(banners: banners),
                    const EventList(),
                  ],
                );
              },
              childCount: 1, // Adjust this count as needed
            ),
          ),
        ],
      ),
    );
  }
}
