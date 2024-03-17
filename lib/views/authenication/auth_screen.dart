import 'package:dhurandhar/utils/Colors.dart';
import 'package:dhurandhar/utils/widgets/Common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../providers/mobile_auth_provider.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = "AuthScreen";
  const AuthScreen({Key? key}) : super(key: key);

  static String verificationId = "";

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLoading = false;
  var phoneNumber = "";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<MobileAuthenicationProvider>(
        builder: (context, value, child) {
      return Scaffold(
        body: Container(
          margin: const EdgeInsets.only(
            left: 25,
            right: 25,
          ),
          // alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: size.height * 0.1,
                ),
                Text(
                  " Let’s get \n started!",
                  style:
                      boldTextStyle(context, size: 40, color: darkBlackColor),
                ),
                SizedBox(
                  height: size.height * 0.15,
                ),

                Container(
                  height: size.height * 0.07,
                  decoration: BoxDecoration(
                      color: greyScaleColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      // Text(
                      //   "+91 ",
                      //   style: primaryTextStyle(),
                      // ),
                      Image.asset(
                        'assets/india.png',
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextField(
                          // maxLength: 10,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                          ],
                          onChanged: (value) {
                            phoneNumber = value;
                          },
                          keyboardType: TextInputType.phone,
                          style: primaryTextStyle(context,
                              isStaticCol: true, color: darkBlackColor),
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Your Phone Number",
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF9E9E9E))),
                        ),
                      ),
                      // IconButton(
                      //     onPressed:
                      //     icon: Container(
                      //         height: 55,
                      //         width: 55,
                      //         decoration: const BoxDecoration(
                      //             shape: BoxShape.circle, color: Colors.black),
                      //         child: const Icon(
                      //           Icons.arrow_forward_ios_outlined,
                      //           color: Colors.white,
                      //           size: 22,
                      //         ))),
                    ],
                  ),
                ),
                // const SizedBox(
                //   height: 20,
                // ),
                // Text(
                //   "Enter your mobile number to continue.",
                //   style: secondaryTextStyle(),
                // ),
                Padding(
                  padding: EdgeInsets.only(top: size.height * 0.04),
                  child: value.isLoading
                      ? circleProgressLoader()
                      : bottomCustomButton(context, () {
                          if (phoneNumber.length != 10) {
                            showScafoldSnackBar(context,
                                "Invalid mobile number. Please enter your 10-digit mobile number.");
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   const SnackBar(
                            //     content: Text(
                            //         "Please Enter a Valid 10 digit Mobile Number!"),
                            //   ),
                            // );
                          } else if (phoneNumber[0] != "6" &&
                              phoneNumber[0] != "7" &&
                              phoneNumber[0] != "8" &&
                              phoneNumber[0] != "9") {
                            showScafoldSnackBar(context,
                                "Invalid mobile number. Please enter your 10-digit mobile number.");
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   const SnackBar(
                            //     content: Text(
                            //         "Please Enter a Valid Mobile Number!"),
                            //   ),
                            // );
                          } else {
                            SystemChannels.textInput
                                .invokeMethod('TextInput.hide');
                            value.loginWithPhone(context, phoneNumber);
                            // try {
                            //   setState(() {
                            //     isLoading = true;
                            //   });
                            //   await FirebaseAuth.instance.verifyPhoneNumber(
                            //     phoneNumber: '+91 $phoneNumber',
                            //     verificationCompleted:
                            //         (PhoneAuthCredential credential) {},
                            //     verificationFailed:
                            //         (FirebaseAuthException e) {},
                            //     codeSent: (String verificationId,
                            //         int? resendToken) {
                            //       AuthScreen.verificationId = verificationId;
                            //       Navigator.pushNamed(context, 'verify')
                            //           .then((v) {
                            //         setState(() {
                            //           isLoading = false;
                            //         });
                            //       });
                            //     },
                            //     codeAutoRetrievalTimeout:
                            //         (String verificationId) {},
                            //   );
                            // } catch (e) {
                            //   setState(() {
                            //     isLoading = false;
                            //   });
                            //   ScaffoldMessenger.of(context).showSnackBar(
                            //     const SnackBar(
                            //       content: Text(
                            //           "Please enter correct phone number!"),
                            //     ),
                            //   );
                            // }
                          }
                        }, "Send OTP"),
                ),
                // const Expanded(child: SizedBox()),
                // SizedBox(height: MediaQuery.of(context).size.height * 0.28),
                // Align(
                //   alignment: Alignment.bottomCenter,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Text(
                //         "Experiencing an issue? ",
                //         style: primaryTextStyle(context,),
                //       ),
                //       InkWell(
                //         onTap: () {

                //         },
                //         child: Text(
                //           "Help Center",
                //           style: primaryTextStyle(context, color: primaryColor),
                //         ),
                //       ),
                //       // RichText(
                //       //   textAlign: TextAlign.center,
                //       //   text: TextSpan(
                //       //     text: 'Having trouble logging in? ',
                //       //     style: primaryTextStyle(),
                //       //     children: <TextSpan>[
                //       //       TextSpan(
                //       //           text: 'Help Center',
                //       //           style: primaryTextStyle(color: primaryColor)),
                //       //     ],
                //       //   ),
                //       // ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
