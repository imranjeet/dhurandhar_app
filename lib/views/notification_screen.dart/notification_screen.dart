import 'package:dhurandhar/utils/Colors.dart';
import 'package:dhurandhar/utils/widgets/Common.dart';
import 'package:dhurandhar/utils/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: TAppBar(
          appBarColor: primaryColor,
          title: Text(
            'Notifications',
            style:
                boldTextStyle(context, isStaticCol: true, color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(top: size.height * 0.2),
              child: Column(
                children: [
                  SvgPicture.asset("assets/empty_data.svg",
                      color: primaryColor),
                  SizedBox(height: size.height * 0.01),
                  Text(
                    "No chats found!",
                    style: boldTextStyle(context),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
