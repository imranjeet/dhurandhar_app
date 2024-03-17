import 'dart:async';

import 'package:dhurandhar/utils/Colors.dart';
import 'package:dhurandhar/utils/widgets/Common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../providers/mobile_auth_provider.dart';
import './editable_otp_field.dart';

class AuthScreenVerify extends StatefulWidget {
  static const routeName = "AuthScreenVerify";
  const AuthScreenVerify({Key? key}) : super(key: key);

  @override
  State<AuthScreenVerify> createState() => _AuthScreenVerifyState();
}

class _AuthScreenVerifyState extends State<AuthScreenVerify> {
  var code = "";
  int secondsRemaining = 30;
  bool enableResend = false;
  late Timer timer;

  @override
  initState() {
    super.initState();

    startOtpTimer();
  }

  // Starting timer for OTP resend
  startOtpTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          enableResend = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Consumer<MobileAuthenicationProvider>(
        builder: (context, value, child) {
      return Scaffold(
        // extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(
            "Verify Your Phone Number",
            style: boldTextStyle(context, size: 20),
          ),
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              // color: Colors.black,
            ),
          ),
          elevation: 0,
        ),
        body: Container(
          margin: const EdgeInsets.only(left: 25, right: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // SizedBox(
              //   height: MediaQuery.of(context).size.height * 0.25,
              // ),

              SizedBox(
                height: size.height * 0.06,
              ),
              Column(
                children: [
                  Text(
                    "OTP has been sent to +91 ${value.phoneNumber}",
                    style: primaryTextStyle(context,
                        size: 18,
                        color: darkBlackColor,
                        weight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                  EditableOtpField(
                      length: 6,
                      onChanged: (otp) {
                        // Handle OTP changes here
                        code = otp;
                      }),
                  // Pinput(
                  //   length: 6,
                  //   enabled: true,
                  //   // autofocus: true,
                  //   defaultPinTheme: defaultPinTheme,
                  //   focusedPinTheme: focusedPinTheme,
                  //   onChanged: ((value) {
                  //     code = value;
                  //   }),
                  //   androidSmsAutofillMethod:
                  //       AndroidSmsAutofillMethod.smsRetrieverApi,
                  //   showCursor: true,
                  //   onCompleted: (pin) {
                  //     SystemChannels.textInput.invokeMethod('TextInput.hide');
                  //     // verifyOTP();
                  //   },
                  // ),

                  SizedBox(height: size.height * 0.065),
                  // ElevatedButton(
                  //   onPressed: enableResend
                  //       ? () {
                  //           setState(() {
                  //             secondsRemaining = 30;
                  //             enableResend = false;
                  //           });
                  //           startOtpTimer();
                  //           Provider.of<PhoneAuthenicationProvider>(context,
                  //                   listen: false)
                  //               .resendOTP(context);
                  //         }
                  //       : null,
                  //   child: const Text('Resend Code'),
                  // ),
                  enableResend
                      ? SizedBox(
                          width: size.width * 0.5,
                          height: size.height * 0.045,
                          child: bottomCustomButton(
                              context,
                              enableResend
                                  ? () {
                                      setState(() {
                                        secondsRemaining = 30;
                                        enableResend = false;
                                      });
                                      startOtpTimer();
                                      value.resendOTP(context);
                                    }
                                  : () {},
                              "Resend OTP"),
                        )
                      // ElevatedButton(
                      //     onPressed: () {
                      //       setState(() {
                      //         secondsRemaining = 30;
                      //         enableResend = false;
                      //       });
                      //       startOtpTimer();
                      //       Provider.of<PhoneAuthenicationProvider>(context,
                      //               listen: false)
                      //           .resendOTP(context);
                      //     },
                      //     child: Text(
                      //       'Resend OTP',
                      //       style: primaryTextStyle(),
                      //     ),
                      //   )

                      : RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'Resend otp in ',
                            style: primaryTextStyle(
                              context,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                  text: '$secondsRemaining',
                                  style: primaryTextStyle(context,
                                      color: primaryColor)),
                              TextSpan(
                                  text: ' seconds',
                                  style: primaryTextStyle(
                                    context,
                                  )),
                            ],
                          ),
                        ),
                ],
              ),
              value.isLoading
                  ? Padding(
                      padding: EdgeInsets.only(bottom: size.height * 0.05),
                      child: circleProgressLoader(),
                    )
                  : Padding(
                      padding: EdgeInsets.only(bottom: size.height * 0.05),
                      child: bottomCustomButton(context, () {
                        SystemChannels.textInput.invokeMethod('TextInput.hide');
                        value.verifyOTP(context, code);
                      }, "Verify One Time Password"),
                    ),
              // SizedBox(
              //   width: double.infinity,
              //   height: 45,
              //   child: ElevatedButton(
              //       style: ElevatedButton.styleFrom(
              //           primary: Colors.black,
              //           shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(10))),
              //       onPressed: () {
              //         verifyOTP();
              //       },
              //       child: const Text("Verify Phone Number")),
              // ),
              // Row(
              //   children: [
              //     TextButton(
              //         onPressed: () {
              //           Navigator.pushNamedAndRemoveUntil(
              //             context,
              //             'phone',
              //             (route) => false,
              //           );
              //         },
              //         child: const Text(
              //           "Edit Phone Number ?",
              //           style: TextStyle(color: Colors.black),
              //         ))
              //   ],
              // )
            ],
          ),
        ),
      );
    });
  }
}
