import 'package:dhurandhar/providers/home_provider.dart';
import 'package:dhurandhar/utils/constants/colors.dart';
import 'package:dhurandhar/utils/constants/sizes.dart';
import 'package:dhurandhar/utils/size_config.dart';
import 'package:dhurandhar/utils/widgets/circular_container.dart';
import 'package:dhurandhar/utils/widgets/rounded_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

class PromoCarouselWidget extends StatelessWidget {
  const PromoCarouselWidget({
    super.key,
    required this.banners,
  });

  final List<String> banners;

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeScreenProvider>(builder: (context, value, child) {
      return Padding(
        padding: const EdgeInsets.all(TSizes.sm),
        child: Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                  viewportFraction: 1,
                  autoPlay: true,
                  onPageChanged: (index, _) {
                    value.updateSlide(index, banners.length);
                  }),
              items:
                  banners.map((url) => TRoundedImage(imageUrl: url)).toList(),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < banners.length; i++)
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
    });
  }
}