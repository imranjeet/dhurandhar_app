// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:dhurandhar/models/core/user_data.dart';
import 'package:dhurandhar/providers/profile_provider.dart';
import 'package:dhurandhar/utils/Colors.dart';
import 'package:dhurandhar/utils/Constants.dart';
import 'package:dhurandhar/utils/widgets/Common.dart';
import 'package:dhurandhar/utils/widgets/app_textfield.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';


class UploadUserData extends StatefulWidget {
  bool? fromProfile;
  UploadUserData({
    Key? key,
    this.fromProfile = false,
  }) : super(key: key);

  @override
  State<UploadUserData> createState() => _UploadUserDataState();
}

class _UploadUserDataState extends State<UploadUserData> {
  final ProfileScreenProvider _profileScreenProvider = ProfileScreenProvider();
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  File? _imageFile;
  final picker = ImagePicker();
  bool isLoading = false;
  String? birthDateInString;
  DateTime? birthDate;
  bool isDateSelected = false;
  var gendersList = ['Gender', "male", "female", "other"];
  String selectedGender = "Gender";
  bool isWhatsapp = false;
  String? currentUserPic;
  UserData? currentUser;

  @override
  void initState() {
    super.initState();
    initOldUserData();
  }

  initOldUserData() {
    currentUser =
        Provider.of<ProfileScreenProvider>(context, listen: false).currentUser;

    nameController = TextEditingController(text: currentUser!.name);
    cityController = TextEditingController(text: currentUser!.address);

    currentUserPic = currentUser!.profileImage;
  }

  // Taking image from camera for user profile pic and storing it to on server
  _getFromGallery() async {
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 500,
        maxWidth: 500,
        imageQuality: 50);
    if (pickedFile == null) return;
    File imageFile = File(pickedFile.path);
    setState(() {
      _imageFile = imageFile;
      currentUserPic = null;
    });
  }

  //  Submiting user data form to server
  _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        isLoading = true;
      });

      await _profileScreenProvider
          .updateUserDataWithFile(
              context, nameController.text, cityController.text, _imageFile)
          .whenComplete(() {
        setState(() {
          isLoading = false;
        });
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // CustomLogger.instance.singleLine('currentUser: ${currentUser!.name}');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.fromProfile == true ? "Edit Profile" : "Complete Your Profile",
          style: boldTextStyle(context, size: 22),
        ),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Container(
          margin: const EdgeInsets.only(
            left: 25,
            right: 25,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: size.height * 0.05),
                  child: SingleChildScrollView(
                    child: SizedBox(
                      height: size.height * 0.75,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Profile photo
                          GestureDetector(
                            onTap: () {
                              /// Get profile image
                              _getFromGallery();
                            },
                            child: Center(
                              child: SizedBox(
                                height: size.height * 0.14,
                                width: size.height * 0.14,
                                child: Stack(
                                  children: [
                                    Center(
                                      child: currentUserPic != null
                                          ? CircleAvatar(
                                              radius: size.height * 0.07,
                                              backgroundColor: greyScaleColor,
                                              backgroundImage:
                                                  NetworkImage(currentUserPic!),
                                            )
                                          : _imageFile == null
                                              ? CircleAvatar(
                                                  radius: size.height * 0.07,
                                                  // backgroundColor:
                                                  //     greyScaleColor,
                                                  backgroundImage: const AssetImage(
                                                      "assets/profile_image.png"),
                                                )
                                              : CircleAvatar(
                                                  radius: size.height * 0.07,
                                                  backgroundImage:
                                                      FileImage(_imageFile!),
                                                ),
                                    ),
                                    Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                            height: size.height * 0.033,
                                            width: size.height * 0.033,
                                            decoration: BoxDecoration(
                                                color: primaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: const Center(
                                              child: Icon(
                                                Icons.camera_alt_rounded,
                                                size: 20,
                                                color: Colors.white,
                                              ),
                                            )))
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.05,
                          ),
                          SizedBox(
                            // height: size.height * 0.067,
                            child: AppTextField(
                              controller: nameController,
                              textFieldType: TextFieldType.NAME,
                              isValidationRequired: true,
                              textStyle: primaryTextStyle(
                                context,
                              ),
                              errorThisFieldRequired: "Name is invalid.",
                              hintText: "Full name",
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.03,
                          ),

                          SizedBox(
                            // height: size.height * 0.067,
                            child: AppTextField(
                              controller: cityController,
                              textFieldType: TextFieldType.NAME,
                              isValidationRequired: true,
                              textStyle: primaryTextStyle(
                                context,
                              ),
                              errorThisFieldRequired: errorThisFieldRequired,
                              hintText: "Address",
                            ),
                          ),

                          // GestureDetector(
                          //   onTap: () {
                          //     SystemChannels.textInput
                          //         .invokeMethod('TextInput.hide');
                          //     pickUserDOB();
                          //   },
                          //   child: Container(
                          //     height: size.height * 0.065,
                          //     // width: 70,
                          //     decoration: BoxDecoration(
                          //       color: greyScaleColor,
                          //       borderRadius: BorderRadius.circular(15),
                          //     ),
                          //     child: Padding(
                          //       padding: const EdgeInsets.only(
                          //           left: 20.0, right: 10),
                          //       child: Row(
                          //         mainAxisAlignment:
                          //             MainAxisAlignment.spaceBetween,
                          //         children: [
                          //           Text(
                          //             birthDateInString ?? "Date of Birth",
                          //             style: birthDateInString == null
                          //                 ? primaryTextStyle(context,
                          //                     color: lightBlackColor)
                          //                 : primaryTextStyle(context,),
                          //           ),
                          //           Icon(
                          //             Icons.calendar_month,
                          //             color: lightBlackColor,
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // SizedBox(
                          //   height: size.height * 0.02,
                          // ),
                          // AppTextField(
                          //   controller: emailController,
                          //   textFieldType: TextFieldType.EMAIL,
                          //   errorThisFieldRequired: "Email is invalid.",
                          //   isValidationRequired: true,
                          //   suffix: Icon(
                          //     Icons.email_outlined,
                          //     color: lightBlackColor,
                          //   ),
                          //   textStyle: primaryTextStyle(context,),
                          //   hintText: "Email",
                          // ),
                          // const SizedBox(
                          //   height: 20,
                          // ),
                          // AppTextField(
                          //   controller: cityController,
                          //   textFieldType: TextFieldType.ADDRESS,
                          //   isValidationRequired: true,
                          //   textStyle: primaryTextStyle(),
                          //   decoration: const InputDecoration(
                          //     border: InputBorder.none,
                          //     hintText: "City",
                          //   ),
                          // ),
                          //  SizedBox(
                          //   height: size.height * 0.01,
                          // ),

                          // Row(
                          //   children: [
                          //     Text("Would you like to receive updates over WhatsApp?", style: primaryTextStyle()),
                          //     const Expanded(child: SizedBox()),
                          //     Switch(
                          //       value: isWhatsapp,
                          //       activeColor: primaryColor,
                          //       onChanged: (val) {
                          //         setState(() {
                          //           isWhatsapp = val;
                          //         });
                          //       },
                          //     ),
                          //   ],
                          // ),
                          // SizedBox(
                          //   height: size.height * 0.02,
                          // ),

                          // Container(
                          //   height: size.height * 0.065,
                          //   decoration: BoxDecoration(
                          //     color: greyScaleColor,
                          //     borderRadius: BorderRadius.circular(15),
                          //   ),
                          //   child: Padding(
                          //     padding:
                          //         const EdgeInsets.only(left: 20.0, right: 10),
                          //     child: Center(
                          //       child: DropdownButton(
                          //         elevation: 0,
                          //         underline: const SizedBox(),
                          //         value: selectedGender,
                          //         iconEnabledColor: lightBlackColor,
                          //         iconDisabledColor: lightBlackColor,
                          //         // dropdownColor: lightBlackColor,
                          //         isExpanded: true,
                          //         icon: const Icon(Icons.arrow_drop_down),
                          //         items: gendersList.map((String items) {
                          //           return DropdownMenuItem(
                          //             value: items,
                          //             child: Text(
                          //               "${items[0].toUpperCase()}${items.substring(1).toLowerCase()}",
                          //               style: primaryTextStyle(context,
                          //                   color: lightBlackColor),
                          //             ),
                          //           );
                          //         }).toList(),
                          //         onChanged: (String? newValue) {
                          //           setState(() {
                          //             selectedGender = newValue!;
                          //           });
                          //         },
                          //       ),
                          //     ),
                          //   ),
                          // ),

                          // SizedBox(
                          //   height: size.height * 0.03,
                          // ),
                          // InkWell(
                          //   onTap: () {
                          //     setState(() {
                          //       isWhatsapp = isWhatsapp ? false : true;
                          //     });
                          //   },
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //     children: [
                          //       Container(
                          //         height: size.height * 0.03,
                          //         width: size.height * 0.03,
                          //         decoration: BoxDecoration(
                          //           // shape: BoxShape.rectangle,
                          //           borderRadius: BorderRadius.circular(5),
                          //           border: Border.all(
                          //               color: primaryColor, width: 3),
                          //         ),
                          //         child: isWhatsapp
                          //             ? Icon(Icons.check,
                          //                 color: primaryColor, size: 14)
                          //             : const SizedBox.shrink(),
                          //       ),
                          //       SizedBox(
                          //         height: size.height * 0.04,
                          //         width: size.width * 0.77,
                          //         child: Center(
                          //           child: Text(
                          //             "Would you like to receive updates over WhatsApp?",
                          //             textAlign: TextAlign.left,
                          //             style: primaryTextStyle(context,
                          //                 size: 14,
                          //                 weight: FontWeight.w600,
                          //                 color: darkBlackColor),
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),

                          SizedBox(
                            height: size.height * 0.1,
                          ),
                          // RichText(
                          //   textAlign: TextAlign.center,
                          //   text: TextSpan(
                          //     text:
                          //         "*By registering an account with us, you agree to be bound by our ",
                          //     style: primaryTextStyle(context,
                          //         weight: FontWeight.w400,
                          //         size: 14,
                          //         color: const Color(0XFF000000)),
                          //     children: <TextSpan>[
                          //       TextSpan(
                          //           text: 'Terms of Service',
                          //           style: primaryTextStyle(context,
                          //               color: primaryColor,
                          //               weight: FontWeight.w700,
                          //               size: 14)),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
                isLoading
                    ? circleProgressLoader()
                    : bottomCustomButton(context, () {
                        // CustomLogger.instance.singleLine(
                        //     "${currentUser?.name == nameController.text} ${currentUser?.address == cityController.text}");
                        if (currentUser?.name == nameController.text &&
                            currentUser?.address == cityController.text &&
                            _imageFile == null) {
                          Navigator.pop(context);
                        } else {
                          // CustomLogger.instance
                          //     .singleLine("[ProfileScreen] Validate User Info");
                          _submitForm();
                        }
                        // _submitForm();
                        // if (birthDateInString == "") {
                        //   showScafoldSnackBar(
                        //       context, "Please select your Data of Birth !");
                        // } else if (selectedGender == "Gender") {
                        //   showScafoldSnackBar(context,
                        //       "Gender is required and must be must be either male or female or others.");
                        // } else {
                        //   _submitForm();
                        // }
                      }, "Update"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void pickUserDOB() async {
    final datePick = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));
    if (datePick != null && datePick != birthDate) {
      setState(() {
        birthDate = datePick;
        isDateSelected = true;

        // put it here
        var monthStr = birthDate!.month > 9
            ? "${birthDate!.month}"
            : "0${birthDate!.month}";
        var dayStr =
            birthDate!.day > 9 ? "${birthDate!.day}" : "0${birthDate!.day}";

        birthDateInString =
            "${birthDate!.year}-$monthStr-$dayStr"; // 08/14/2019
      });
      // updatedProfileData["dob"] =
      //     birthDateInString;
    }
  }
}

// class GenderButton extends StatelessWidget {
//   String? text;
//   IconData? icon;
//   final Color color;
//   final Color backgroundColor;
//   double height;
//   double width;
//   bool? isIcon;
//   GenderButton({
//     Key? key,
//     this.text,
//     this.icon,
//     this.isIcon = false,
//     required this.color,
//     required this.backgroundColor,
//     required this.height,
//     required this.width,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: height,
//       width: width,
//       decoration: BoxDecoration(
//         // border: Border.all(
//         //   color: borderColor,
//         //   width: 1.0,
//         // ),
//         borderRadius: BorderRadius.circular(8),
//         color: backgroundColor,
//       ),
//       child: Center(
//           child: Text(
//         text!,
//         style: primaryTextStyle(
//           context,
//         ),
//         // style: getFontStyle(fontSize: 16, medium: true, color: color),
//       )),
//     );
//   }
// }
