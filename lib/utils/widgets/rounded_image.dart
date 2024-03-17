import 'package:dhurandhar/utils/constants/sizes.dart';
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
      child: ClipRRect(
          borderRadius: BorderRadius.circular(TSizes.md),
          child: Image(image: AssetImage(imageUrl), fit: BoxFit.contain)),
    );
  }
}