import 'package:dhurandhar/utils/constants/sizes.dart';
import 'package:dhurandhar/views/home/widgets/primary_header_container.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
           PrimaryHeaderContainer(
            child: Column(
              children: [
                Container(),
                // THomeAppBar(),
                SizedBox(height: TSizes.spaceBtwSections),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}