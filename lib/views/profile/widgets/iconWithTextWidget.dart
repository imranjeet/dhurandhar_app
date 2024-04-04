// ignore_for_file: must_be_immutable

import 'package:dhurandhar/utils/Colors.dart';
import 'package:dhurandhar/utils/widgets/Common.dart';
import 'package:flutter/material.dart';

class IconWithTextWidget extends StatelessWidget {
  final String txt;
  final IconData icon;
  VoidCallback onTap;
  IconWithTextWidget({
    Key? key,
    required this.txt,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
        child: Container(
          height: 55,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 15,
              ),
              Icon(
                icon,
                color: primaryColor,
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                txt,
                style: primaryTextStyle(context, weight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
