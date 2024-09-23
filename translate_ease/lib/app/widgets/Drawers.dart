import 'dart:io';
import 'package:animated_rating_stars/animated_rating_stars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:translate_ease/app/Theme/ColorTheme.dart';
import 'package:translate_ease/app/modules/mainScreen/controllers/main_screen_controller.dart';
import 'package:yaml/yaml.dart';

Drawer basicDrawer() {
  MainScreenController controller = Get.put(MainScreenController());
  var rate = 5.0;
  return Drawer(
    clipBehavior: Clip.none,
    child: Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        DrawerHeader(
            child: Column(
          children: [
            Image.asset(
              'assets/large.png',
              height: 130,
              width: Get.mediaQuery.size.width,
            ),
          ],
        )),
        ListTile(
          title: const Row(
            children: [
              Icon(
                Icons.star_rate_rounded,
              ),
              SizedBox(width: 20),
              Text(
                'Rate Us',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
          onTap: () {
            Get.dialog(AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Column(
                children: [
                  Image.asset(
                    'assets/star.png',
                    height: 100,
                    width: Get.mediaQuery.size.width,
                  ),
                  const Text(
                    'Did you enjoy our app?',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Please rate your experience so we can improve further',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  AnimatedRatingStars(
                    initialRating: rate,
                    minRating: 0.0,
                    maxRating: 5.0,
                    filledColor: Colors.amber,
                    emptyColor: Colors.grey,
                    filledIcon: Icons.star,
                    halfFilledIcon: Icons.star_half,
                    emptyIcon: Icons.star_border,
                    onChanged: (double rating) {
                      // Handle the rating change here
                      rate = rating;
                    },
                    displayRatingValue: true,
                    interactiveTooltips: true,
                    customFilledIcon: Icons.star,
                    customHalfFilledIcon: Icons.star_half,
                    customEmptyIcon: Icons.star_border,
                    starSize: 30.0,
                    animationDuration: const Duration(milliseconds: 300),
                    animationCurve: Curves.easeInOut,
                    readOnly: false,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            color: Colors.grey, // Set the grey background color
                            borderRadius: BorderRadius.circular(
                                20), // Optional: Match the button shape if needed
                          ),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: greyColor,
                                shape: const StadiumBorder(),
                              ),
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text(
                                'Cancel',
                                style: TextStyle(color: Colors.white),
                              ))),
                      Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [blueColor, pinkColor, purpleColor],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              backgroundColor: Colors.transparent,
                              // Button background transparent so gradient is visible
                              shadowColor: Colors
                                  .transparent, // Remove the shadow for clean look
                            ),
                            onPressed: () {
                              controller.sendRatingEmail(rate);
                              Get.back();
                            },
                            child: Text('Submit',
                                style: TextStyle(color: secondaryColor)),
                          ))
                    ],
                  ),
                ],
              ),
            ));
          },
        ),
        ListTile(
          title: const Row(
            children: [
              Icon(
                Icons.change_circle,
              ),
              SizedBox(width: 20),
              Text(
                'Theme Mode',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
          onTap: () {
            Get.isDarkMode
                ? Get.changeTheme(ThemeData.light())
                : Get.changeTheme(ThemeData.dark());
          },
        ),
        ListTile(
          title: const Row(
            children: [
              Icon(
                Icons.privacy_tip,
              ),
              SizedBox(width: 20),
              Text(
                'Privacy Policy',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
          onTap: () {
            Get.dialog(AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Center(
                child: Text(
                  'Privacy Policy',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              content: Container(
                width: Get.mediaQuery.size.width / 1.5,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/privacy.png",
                        height: 100,
                        width: 100,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'The App may contain links to other sites. If you click on a third-party link, you will be directed to that site. Note that these external sites are not operated by us. Therefore, we strongly advise you to review the Privacy Policy of these websites. We have no control over and assume no responsibility for the content, privacy policies, or practices of any third-party sites or services.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            shape: const StadiumBorder(),
                          ),
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text(
                            'Close',
                            style: TextStyle(color: Colors.white),
                          )),
                    ],
                  ),
                ),
              ),
            ));
          },
        ),
        ListTile(
          title: const Row(
            children: [
              Icon(
                Icons.feedback,
              ),
              SizedBox(width: 20),
              Text(
                'Feedback',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
          onTap: () {
            Get.dialog(AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Center(
                child: Text(
                  'Feedback',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              content: Container(
                width: Get.mediaQuery.size.width / 1.5,
                child: SingleChildScrollView(
                  child: Column(children: [
                    Image.asset(
                      "assets/Feed.png",
                      height: 100,
                      width: 100,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Form(
                      key: controller.formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: controller.feedbackController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            maxLines: 4,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              hintText: 'Enter text here',
                              hintStyle: const TextStyle(color: Colors.grey),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors
                                      .grey, // Set the grey background color
                                  borderRadius: BorderRadius.circular(
                                      20), // Optional: Match the button shape if needed
                                ),
                                child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: greyColor,
                                shape: const StadiumBorder(),
                              ),
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                        blueColor,
                                        pinkColor,
                                        purpleColor
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight),
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: const StadiumBorder(),
                                      backgroundColor: Colors.transparent,
                                      // Button background transparent so gradient is visible
                                      shadowColor: Colors
                                          .transparent, // Remove the shadow for clean look
                                    ),
                                    onPressed: () {
                                      if (controller.formKey.currentState!
                                          .validate()) {
                                        controller.sendFeedbackEmail();
                                        Get.back();
                                      }
                                    },
                                    child: const Text('Submit',
                                        style: TextStyle(color: Colors.white))),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
            ));
          },
        ),
        const SizedBox(
          height: 10,
        ),
        const Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                "Version 1.0.0 ",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        )
      ],
    ),
  );
}
