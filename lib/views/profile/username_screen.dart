import 'package:dhurandhar/models/core/user_data.dart';
import 'package:dhurandhar/providers/mobile_auth_provider.dart';
import 'package:dhurandhar/providers/profile_provider.dart';
import 'package:dhurandhar/utils/Colors.dart';
import 'package:dhurandhar/utils/widgets/Common.dart';
import 'package:dhurandhar/utils/widgets/app_textfield.dart';
import 'package:dhurandhar/utils/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsernameScreen extends StatefulWidget {
  const UsernameScreen({super.key});

  @override
  State<UsernameScreen> createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
  TextEditingController usernameController = TextEditingController();
  bool isLoading = false;
  UserData? currentUser;

  @override
  void initState() {
    super.initState();
    initValues();
  }

  initValues() {
    currentUser =
        Provider.of<MobileAuthenicationProvider>(context, listen: false)
            .currentUser;
    usernameController.text = currentUser?.username ?? "";
  }

  onTapUpdate() async {
    if (currentUser?.username == usernameController.text) {
      onBack();
    } else {
      setState(() {
        isLoading = true;
      });
      final provider =
          Provider.of<ProfileScreenProvider>(context, listen: false);
      await provider
          .updateUsername(context, usernameController.text)
          .whenComplete(() {
        setState(() {
          isLoading = false;
        });
        onBack();
      });
    }
  }

  onBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: TAppBar(
        appBarColor: primaryColor,
        showBackArrow: true,
        title: Text(
          'Username',
          style: boldTextStyle(context, isStaticCol: true, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: size.height * 0.02, horizontal: size.width * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              // height: size.height * 0.067,
              child: AppTextField(
                controller: usernameController,
                textFieldType: TextFieldType.USERNAME,
                isValidationRequired: true,
                textStyle: primaryTextStyle(
                  context,
                ),
                errorThisFieldRequired: "Username is invalid.",
                hintText: "Username",
              ),
            ),
            isLoading
                ? circleProgressLoader()
                : bottomCustomButton(context, () {
                    onTapUpdate();
                  }, "Update")
          ],
        ),
      ),
    );
  }
}
