// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:dhurandhar/models/core/user_data.dart';
import 'package:dhurandhar/models/repository/request_helper.dart';
import 'package:dhurandhar/providers/profile_provider.dart';
import 'package:dhurandhar/utils/Constants.dart';
import 'package:dhurandhar/utils/custom_logger.dart';
import 'package:dhurandhar/views/authenication/verify.dart';
import 'package:dhurandhar/views/main_screen/main_screen.dart';
import 'package:dhurandhar/views/main_screen/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';

// import '../model/repository/request_helper.dart';
import '../utils/widgets/Common.dart';
import '../views/authenication/auth_screen.dart';

class MobileAuthenicationProvider extends ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;

  UserData? _currentUser;

  UserData? get currentUser => _currentUser;

  set currentUser(UserData? value) {
    _currentUser = value;
    notifyListeners();
  }

  bool isLoading = false;
  var phoneNumber = "";

  // Login with phone number
  Future<void> loginWithPhone(BuildContext context, String _phoneNumber) async {
    isLoading = true;
    phoneNumber = _phoneNumber;
    notifyListeners();
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91 $_phoneNumber',
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          toast("something went wrong");
          showScafoldSnackBar(context, e.toString());
          isLoading = false;
          notifyListeners();
        },
        codeSent: (String verificationId, int? resendToken) {
          AuthScreen.verificationId = verificationId;
          Navigator.pushNamed(context, AuthScreenVerify.routeName);
          isLoading = false;
          notifyListeners();
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      notifyListeners();
      toast("something went wrong");
      showScafoldSnackBar(context, e.toString());
    }
  }

  // Resending phone otp
  Future<void> resendOTP(BuildContext context) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91 $phoneNumber',
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          isLoading = false;
          notifyListeners();
          showScafoldSnackBar(context, e.toString());
        },
        codeSent: (String verificationId, int? resendToken) {
          AuthScreen.verificationId = verificationId;
          // Navigator.pushNamed(context, AuthScreenVerify.routeName).then((v) {
          //   isLoading = false;
          //   notifyListeners();
          // });
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      notifyListeners();
      toast("something went wrong");
      showScafoldSnackBar(context, e.toString());
    }
  }

  // verifing phone otp
  Future<void> verifyOTP(
    BuildContext context,
    String code,
  ) async {
    isLoading = true;
    notifyListeners();
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: AuthScreen.verificationId, smsCode: code);

      await auth.signInWithCredential(credential);
      // final User? user = auth.currentUser;

      bool isSuccess = await getCurrentUserData(context);
      isLoading = false;
      notifyListeners();

      if (isSuccess) {
        Navigator.pushNamedAndRemoveUntil(
            context, MainScreen.routeName, ((route) => false));
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, AuthScreen.routeName, ((route) => false));
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      CustomLogger.instance.error("error: $e");
      showScafoldSnackBar(context,
          "Incorrect OTP entered. Please recheck and enter the correct OTP.");
    }
  }

  Future<void> logOut(BuildContext context) async {
    try {
      await auth.signOut();
      launchScreen(context, const SplashScreen(),
          isNewTask: true, pageRouteAnimation: PageRouteAnimation.Slide);
      // Navigator.pushNamedAndRemoveUntil(
      //     context, SplashScreen.routeName, ((route) => false));
    } catch (e) {
      showScafoldSnackBar(context, "Something went wrong!");
    }
  }

  // getting current user data from server
  Future<bool> getCurrentUserData(BuildContext context) async {
    String apiUrl = "${mBaseUrl}api/create_user/";
    var requestResponse =
        await RequestHelper.getApiRequest(apiUrl, hasHeader: true);
    String responseData = requestResponse.body; //json
    var decodeResponseData = jsonDecode(responseData);

    if (requestResponse.statusCode == 200) {
      // toast(decodeResponseData['message']);
      currentUser = UserData.fromMap(decodeResponseData['user']);
      notifyListeners();
      Provider.of<ProfileScreenProvider>(context, listen: false)
          .setCurrentUserData(currentUser);
      // ProfileScreenProvider().setCurrentUserData(currentUser);
      return true;
    } else {
      toast(decodeResponseData['error']);
      return false;
    }
  }
}
