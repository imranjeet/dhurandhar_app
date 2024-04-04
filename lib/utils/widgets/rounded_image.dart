import 'package:dhurandhar/utils/constants/sizes.dart';
import 'package:dhurandhar/utils/widgets/Common.dart';
import 'package:flutter/material.dart';

class TRoundedImage extends StatelessWidget {
  const TRoundedImage({
    super.key,
    required this.imageUrl,
  });

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(TSizes.md)),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(TSizes.md),
            child: const Image(
                image: AssetImage("assets/card_bg.jpeg"), fit: BoxFit.cover),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                imageUrl,
                textAlign: TextAlign.center,
                style: boldTextStyle(context, size: 14, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
