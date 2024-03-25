import 'dart:async';

import 'package:dhurandhar/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dhurandhar/providers/home_provider.dart';
import 'package:dhurandhar/utils/constants/colors.dart';
import 'package:dhurandhar/utils/constants/sizes.dart';
import 'package:dhurandhar/utils/widgets/circular_container.dart';
import 'package:dhurandhar/utils/widgets/rounded_image.dart';

class PromoCarouselWidget extends StatefulWidget {
  const PromoCarouselWidget({
    Key? key,
    required this.banners,
  }) : super(key: key);

  final List<String> banners;

  @override
  _PromoCarouselWidgetState createState() => _PromoCarouselWidgetState();
}

class _PromoCarouselWidgetState extends State<PromoCarouselWidget> {
  late PageController _pageController;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoPlay();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.page == widget.banners.length - 1) {
        _pageController.animateToPage(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeScreenProvider>(
      builder: (context, value, child) {
        return Padding(
          padding: const EdgeInsets.all(TSizes.sm),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
                width: MediaQuery.of(context).size.width * 0.9,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.banners.length,
                  onPageChanged: (index) {
                    value.updateSlide(index, widget.banners.length);
                  },
                  itemBuilder: (context, index) {
                    return TRoundedImage(imageUrl: widget.banners[index]);
                  },
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < widget.banners.length; i++)
                    TCircularContainer(
                      width: 20.fh,
                      height: 4.fh,
                      margin: const EdgeInsets.only(right: 10),
                      backgroundColor:
                          value.currentSlide == i ? Colors.green : TColors.grey,
                    ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
