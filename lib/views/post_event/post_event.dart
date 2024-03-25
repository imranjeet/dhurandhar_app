// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:dhurandhar/providers/post_event_provider.dart';
import 'package:dhurandhar/utils/Colors.dart';
import 'package:dhurandhar/utils/constants/sizes.dart';
import 'package:dhurandhar/utils/datetime_converter.dart';
import 'package:dhurandhar/utils/widgets/Common.dart';
import 'package:dhurandhar/utils/widgets/app_textfield.dart';
import 'package:dhurandhar/views/post_event/location_picker_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class PostEventScreen extends StatefulWidget {
  const PostEventScreen({super.key});

  @override
  State<PostEventScreen> createState() => _PostEventScreenState();
}

class _PostEventScreenState extends State<PostEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final PostEventProvider _postEventProvider = PostEventProvider();
  TextEditingController nameController = TextEditingController();
  TextEditingController desController = TextEditingController();
  File? _imageFile;
  final picker = ImagePicker();
  String? selectedDateTime;
  String? formattedDateTime;
  bool isLoading = false;

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
    });
  }

  //  Submiting user data form to server
  _submitForm(PostEventProvider provider) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        isLoading = true;
      });
      await _postEventProvider
          .postEventDataWithFile(
              context,
              nameController.text,
              desController.text,
              formattedDateTime!,
              provider.address!,
              provider.addressLatitude!,
              provider.addressLongitude!,
              _imageFile!)
          .whenComplete(() {
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<PostEventProvider>(builder: (context, value, child) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            "Post Event",
            style: boldTextStyle(context, size: 22),
          ),
        ),
        body: Form(
          key: _formKey,
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
                    padding: EdgeInsets.only(top: size.height * 0.02),
                    child: SingleChildScrollView(
                      child: SizedBox(
                        height: size.height * 0.78,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _getFromGallery();
                              },
                              child: Center(
                                child: SizedBox(
                                  height: size.height * 0.2,
                                  width: size.width * 0.8,
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: _imageFile == null
                                            ? const Icon(Iconsax.gallery_add,
                                                size: 80)
                                            : Container(
                                                width: size.width * 0.6,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            TSizes.md)),
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            TSizes.md),
                                                    child: Image(
                                                        image: FileImage(
                                                            _imageFile!),
                                                        fit: BoxFit.fill)),
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.03,
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
                                errorThisFieldRequired: "This Field Required.",
                                hintText: "Title",
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            SizedBox(
                              // height: size.height * 0.09,
                              child: AppTextField(
                                controller: desController,
                                textFieldType: TextFieldType.NAME,
                                isValidationRequired: true,
                                textStyle: primaryTextStyle(
                                  context,
                                ),
                                errorThisFieldRequired: "This Field Required.",
                                hintText: "Description",
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            GestureDetector(
                              onTap: () {
                                SystemChannels.textInput
                                    .invokeMethod('TextInput.hide');

                                selectDateAndTime(context, size);
                              },
                              child: Container(
                                height: size.height * 0.065,
                                // width: 70,
                                decoration: BoxDecoration(
                                  color: greyScaleColor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, right: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        formattedDateTime ?? "Event DateTime",
                                        style: formattedDateTime == null
                                            ? primaryTextStyle(context,
                                                color: lightBlackColor)
                                            : primaryTextStyle(
                                                context,
                                              ),
                                      ),
                                      Icon(
                                        Icons.calendar_month,
                                        color: lightBlackColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.04,
                            ),
                            Center(
                              child: Column(
                                children: [
                                  RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      text: "Selected Location: ",
                                      style: primaryTextStyle(context,
                                          weight: FontWeight.w400,
                                          size: 18,
                                          color: const Color(0XFF000000)),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: value.address ?? '',
                                            style: primaryTextStyle(context,
                                                color: primaryColor,
                                                weight: FontWeight.w700,
                                                size: 18)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: size.height * 0.02,
                                  ),
                                  SizedBox(
                                      height: size.height * 0.08,
                                      width: size.width * 0.5,
                                      child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: bottomCustomButton(context,
                                              () {
                                            launchScreen(context,
                                                const LocationPickerScreen(),
                                                pageRouteAnimation:
                                                    PageRouteAnimation.Slide);
                                          }, "Choose Location",
                                              color: secondaryColor))),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  isLoading
                      ? circleProgressLoader()
                      : bottomCustomButton(context, () {
                          if (formattedDateTime == "") {
                            showScafoldSnackBar(
                                context, "Please select your event Data!");
                          } else if (value.address == null) {
                            showScafoldSnackBar(
                                context, "Please select event location!");
                          } else if (_imageFile == null) {
                            showScafoldSnackBar(
                                context, "Please select a image!");
                          } else {
                            _submitForm(value);
                          }
                        }, "Post"),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  // Select date and time
  selectDateAndTime(BuildContext context, Size size) {
    // Show date picker
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2101),
    ).then((selectedDate) {
      if (selectedDate != null) {
        // Show time picker after selecting date
        showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        ).then((selectedTime) {
          if (selectedTime != null) {
            // Handle selected date and time
            DateTime selDateTime = DateTime(
              selectedDate.year,
              selectedDate.month,
              selectedDate.day,
              selectedTime.hour,
              selectedTime.minute,
            );
            selectedDateTime = selDateTime.toIso8601String();
            formattedDateTime = dateTimeConverter(selDateTime);
            setState(() {});
          }
        });
      }
    });
  }
}
