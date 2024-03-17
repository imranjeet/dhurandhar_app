import 'package:dhurandhar/utils/constants/sizes.dart';
import 'package:dhurandhar/views/home/widgets/primary_header_container.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

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