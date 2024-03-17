import 'package:dhurandhar/utils/Colors.dart';
import 'package:dhurandhar/utils/constants/colors.dart';
import 'package:dhurandhar/utils/constants/sizes.dart';
import 'package:dhurandhar/utils/size_config.dart';
import 'package:dhurandhar/utils/widgets/Common.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class TSearchContainer extends StatelessWidget {
  const TSearchContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
      child: Container(
        height: 45.fh,
        width: double.maxFinite,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(TSizes.md),
            border: Border.all(color: greyColor)),
        child: Center(
          child: Row(
            children: [
              const Icon(Iconsax.search_normal,
                  color: TColors.darkerGrey, size: 18),
              const SizedBox(width: TSizes.spaceBtwItems),
              Text(
                "Search",
                style: primaryTextStyle(context,
                    size: 16, isStaticCol: true, color: TColors.darkGrey),
              )
            ],
          ),
        ),
      ),
    );
  }
}
