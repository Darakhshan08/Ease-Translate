import 'dart:developer';
import 'dart:io';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:circle_flags/circle_flags.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translate_ease/app/Theme/ColorTheme.dart';
import 'package:translate_ease/app/widgets/Appbars.dart';
import 'package:translate_ease/app/widgets/Drawers.dart';
import '../controllers/main_screen_controller.dart';
import 'package:gradient_borders/gradient_borders.dart';

class MainScreenView extends GetView<MainScreenController> {
  const MainScreenView({Key? key}) : super(key: key);

  void closeAppUsingExit() {
    exit(0);
  }

  @override
  Widget build(BuildContext context) {
    controller.TranslationRecord();

    controller.TranslationFavRecord();

    controller.getLanguageList();

    final SpeechToText speechToText = SpeechToText();
    final isInitailized = false.obs;

    final isInitailizedTarget = false.obs;

    final List _tabs = [
// Chat (conversation) popup box  //
      Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          // Show text message
          RefreshIndicator(
              onRefresh: () async {
                controller
                    .TranslationRecord(); // Refresh the data when pulling the list down
              },
              child: Obx(
                () => controller.TranslationRecords.isEmpty
                    ? Center(
                        child: Image.asset(
                          'assets/norecord1.png',
                          width: Get.mediaQuery.size.width / 1.4,
                        ),
                      )
                    : ListView.builder(
                        reverse: true,
                        scrollDirection: Axis.vertical,
                        physics: AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.only(bottom: 80),
                        itemCount: controller.TranslationRecords.length,
                        itemBuilder: (context, index) {
                          final snapshot = controller.TranslationRecords;

                          return Padding(
                            padding: EdgeInsets.all(10),
                            child: FractionallySizedBox(
                              widthFactor: 0.5,
                              alignment: snapshot[index].side == 'left'
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                              child: GestureDetector(
                                onLongPress: () => {
                                  Get.dialog(AlertDialog(
                                      content: const Text(
                                          "Are you sure you want to delete?",
                                          textAlign: TextAlign.center),
                                      title: const Text("Delete Confirmation",
                                          textAlign: TextAlign.center),
                                      actions: [
                                        TextButton(
                                          child: Text("Yes"),
                                          onPressed: () async {
                                            await controller
                                                .deleteTranslationRecord(
                                                    snapshot[index].id);
                                            Get.back();
                                          },
                                        ),
                                        TextButton(
                                          child: Text("No"),
                                          onPressed: () => Get.back(),
                                        ),
                                      ]))
                                },

                                // Chat (conversation) ke page ka div ka color or text color //
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(
                                      colors: [
                                        purple2Color, // First color
                                        purple2Color, // Second color
                                        pink2Color, // Third color
                                      ],
                                      stops: const [
                                        0.0, // 0% for the first color (purple2Color)
                                        0.62, // 50% for the second color (purple2Color)
                                        3.7, // 100% for the third color (pink2Color)
                                      ],
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.topRight,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot[index].message,
                                        style: TextStyle(
                                          color: secondaryColor,
                                        ),
                                      ),
                                      Divider(color: Colors.grey[300]),
                                      Text(
                                        snapshot[index].translation,
                                        style: TextStyle(
                                          color: secondaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              )),

          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: 70,
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0),
                    blurRadius: 6.0,
                    spreadRadius: 0.0,
                  ),
                ],
                borderRadius: BorderRadius.circular(40),
                color: blackColor,
                border: GradientBoxBorder(
                  gradient: LinearGradient(
                      colors: [blueColor, pinkColor, purpleColor]),
                  width: 3,
                ),
              ),
              child: Row(
                children: [
                  Obx(
                    () => AvatarGlow(
                      animate: isInitailized.value,
                      glowColor: primaryColor,
                      duration: const Duration(milliseconds: 2000),
                      repeatPauseDuration: const Duration(milliseconds: 100),
                      repeat: true,
                      endRadius: 35.0,
                      child: GestureDetector(
                        onTapDown: (details) {
                          isInitailized.value = true;
                          controller.Chatting(
                              speechToText,
                              controller.selectedLanguage.value["code"]
                                  .toString(),
                              controller.selectedLanguagetoConvert.value["code"]
                                  .toString(),
                              "left");
                        },
                        onTapUp: (details) {
                          isInitailized.value = false;
                          speechToText.stop();
                        },

                        //Tranlation page div and Icon color //

                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            // gradient: LinearGradient(
                            //   colors: [blueColor, pinkColor, purpleColor],
                            //   begin: Alignment.topLeft,
                            //   end: Alignment.bottomLeft,
                            // ),
                            color: blackColor,
                          ),
                          child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                isInitailized.value
                                    ? Icons.mic
                                    : Icons.mic_none,
                                color: Colors.white,
                              )),
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => GestureDetector(
                      onTap: () {
                        Get.dialog(
                            barrierDismissible: false,
                            SelectedLanguageDialog());
                      },
                      child: Text(
                        '${controller.selectedLanguage.value["name"].toString()}',
                        style: TextStyle(
                          fontSize: 18,
                          color: secondaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  IconButton(
                      onPressed: () {
                        controller.swapLanguages();
                      },
                      icon: Icon(
                        Icons.compare_arrows_outlined,
                        color: secondaryColor,
                      )),
                  Spacer(),
                  Obx(
                    () => GestureDetector(
                      onTap: () {
                        Get.dialog(
                            barrierDismissible: false,
                            SelectedTargetLanguageDialog());
                      },
                      child: Text(
                        '${controller.selectedLanguagetoConvert.value["name"].toString()}',
                        style: TextStyle(
                          fontSize: 18,
                          color: secondaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => AvatarGlow(
                      animate: isInitailizedTarget.value,
                      glowColor: primaryColor,
                      duration: const Duration(milliseconds: 2000),
                      repeatPauseDuration: const Duration(milliseconds: 100),
                      repeat: true,
                      endRadius: 35.0,
                      child: GestureDetector(
                        onTapDown: (details) {
                          isInitailizedTarget.value = true;
                          controller.Chatting(
                              speechToText,
                              controller.selectedLanguagetoConvert.value["code"]
                                  .toString(),
                              controller.selectedLanguage.value["code"]
                                  .toString(),
                              "right");
                        },
                        onTapUp: (details) {
                          isInitailizedTarget.value = false;
                          speechToText.stop();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            // gradient: LinearGradient(
                            //   colors: [blueColor, pinkColor, purpleColor],
                            //   begin: Alignment.topLeft,
                            //   end: Alignment.bottomLeft,
                            // )),
                            color: blackColor,
                          ),
                          child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                isInitailizedTarget.value
                                    ? Icons.mic
                                    : Icons.mic_none,
                                color: Colors.white,
                              )),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          // Show text message
          RefreshIndicator(
              onRefresh: () async {
                controller
                    .TranslationFavRecord(); // Refresh the data when pulling the list down
              },
              child: Obx(
                () => controller.TranslationFavoriteRecords.isEmpty
                    ? Center(
                        child: Image.asset(
                          'assets/norecord1.png',
                          width: Get.mediaQuery.size.width / 1.4,
                        ),
                      )
                    : ListView.builder(
                        itemCount: controller.TranslationFavoriteRecords.length,
                        itemBuilder: (context, index) {
                          final snapshot =
                              controller.TranslationFavoriteRecords;
                          return Padding(
                            padding: EdgeInsets.all(20),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    purple2Color, // First color
                                    purple2Color, // Second color
                                    pink2Color, // Third color
                                  ],
                                  stops: [
                                    0.0, // 0% for the first color (purple2Color)
                                    0.62, // 50% for the second color (purple2Color)
                                    3.7, // 100% for the third color (pink2Color)
                                  ],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                      alignment: Alignment.topRight,
                                      child: IconButton(
                                        onPressed: () {
                                          controller.Favorite(
                                              snapshot[index].id, 0);
                                        },
                                        icon: Icon(
                                          Icons.star_rate_rounded,
                                          color: Colors.amber,
                                        ),
                                      )),
                                  Text(
                                    snapshot[index].message_language,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  Text(snapshot[index].message,
                                      style: TextStyle(color: Colors.white)),
                                  Divider(color: Colors.grey[300]),
                                  Text(
                                    snapshot[index].translation_language,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    snapshot[index].translation,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              )),
        ],
      ),
      Translate(),
      Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          // Show text message
          RefreshIndicator(
              onRefresh: () async {
                controller
                    .TranslationRecord(); // Refresh the data when pulling the list down
              },
              child: Obx(
                () => controller.TranslationRecords.isEmpty
                    ? Center(
                        child: Image.asset(
                          'assets/norecord1.png',
                          width: Get.mediaQuery.size.width / 1.4,
                        ),
                      )
                    : ListView.builder(
                        reverse: true,
                        padding: EdgeInsets.only(bottom: 50),
                        itemCount: controller.TranslationRecords.length,
                        itemBuilder: (context, index) {
                          final snapshot = controller.TranslationRecords;
                          return Padding(
                            padding: EdgeInsets.all(15),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    purple2Color, // First color
                                    purple2Color, // Second color
                                    pink2Color, // Third color
                                  ],
                                  stops: [
                                    0.0, // 0% for the first color (purple2Color)
                                    0.62, // 50% for the second color (purple2Color)
                                    3.7, // 100% for the third color (pink2Color)
                                  ],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                      alignment: Alignment.topRight,
                                      child: IconButton(
                                        onPressed: () {
                                          if (snapshot[index].isFavorite == 0) {
                                            controller.Favorite(
                                                snapshot[index].id, 1);
                                          } else {
                                            controller.Favorite(
                                                snapshot[index].id, 0);
                                          }
                                        },
                                        icon: Icon(
                                          snapshot[index].isFavorite == 0
                                              ? Icons.star_border_rounded
                                              : Icons.star_rate_rounded,
                                          color: Colors.amber,
                                        ),
                                      )),
                                  Text(
                                    snapshot[index].message_language,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(snapshot[index].message,
                                      style: TextStyle(color: Colors.white)),
                                  Divider(color: Colors.grey[300]),
                                  Text(
                                    snapshot[index].translation_language,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    snapshot[index].translation,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              )),

          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [blueColor, pinkColor, purpleColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius:
                    BorderRadius.circular(30), // Similar to StadiumBorder
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  backgroundColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal:
                          30), // Button background transparent so gradient is visible
                  shadowColor:
                      Colors.transparent, // Remove the shadow for clean look
                ),
                onPressed: () {
                  Get.dialog(AlertDialog(
                      content: const Text(
                          "Are you sure you want to delete all history?",
                          textAlign: TextAlign.center),
                      title: const Text("Delete Confirmation",
                          textAlign: TextAlign.center),
                      actions: [
                        TextButton(
                          child: Text("Yes"),
                          onPressed: () async {
                            await controller.deleteTranslationAllRecord();
                            Get.back();
                          },
                        ),
                        TextButton(
                          child: Text("No"),
                          onPressed: () => Get.back(),
                        ),
                      ]));
                },
                child: Text(
                  'Clear History',
                  style: TextStyle(color: secondaryColor),
                ),
              ),
            ),
          ),
        ],
      ),
      Container(
        child: Column(
          children: <Widget>[
            SizedBox(height: Get.mediaQuery.size.height / 5),
            Center(
              child: Image.asset(
                'assets/camera.png',
                height: 200,
              ),
            ),
            Text(
              "When scanner is open,\nplease tap on screen to scan",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: secondaryColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [blueColor, pinkColor, purpleColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius:
                      BorderRadius.circular(30), // Similar to StadiumBorder
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    backgroundColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal:
                            50), // Button background transparent so gradient is visible
                    shadowColor:
                        Colors.transparent, // Remove the shadow for clean look
                  ),
                  onPressed: () {
                    controller.openCamera();
                  },
                  child: Text(
                    'Scan',
                    style: TextStyle(color: secondaryColor),
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    ];

    return Obx(
      () => SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            // Show an alert dialog when the user presses the back button
            bool exit = await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Exit App?'),
                content: const Text('Are you sure you want to exit the app?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      //close complete app
                      closeAppUsingExit();
                    },
                    child: Text('Exit'),
                  ),
                ],
              ),
            );
            return exit ?? false;
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
              width: Get.mediaQuery.size.width,
              height: Get.mediaQuery.size.height,
              decoration: BoxDecoration(
                color: blackColor,
              ),
              child: _tabs.elementAt(controller.count.value),
            ),
            appBar: controller.count.value == 0 || controller.count.value == 3
                ? SearchableAppBar()
                : PreferredSize(
                    preferredSize: Size.fromHeight(kToolbarHeight),
                    child: BasicAppBar()),
            drawer: basicDrawer(),
         bottomNavigationBar: BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                const BottomNavigationBarItem(
                  icon: Column(
                    children: [Icon(Icons.mic), Text('Chat')],
                  ),
                  label: '',
                ),
                const BottomNavigationBarItem(
                  icon: Column(
                    children: [Icon(Icons.star), Text('Favorite')],
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        color: bottomCenterBtn,
                        height: 50,
                        width: 50,
                        child: Icon(Icons.translate, color: Colors.white),
                      )),
                  label: '',
                ),
                const BottomNavigationBarItem(
                  icon: Column(
                    children: [Icon(Icons.history), Text('History')],
                  ),
                  label: '',
                ),
                const BottomNavigationBarItem(
                  icon: Column(
                    children: [Icon(Icons.camera_alt_rounded), Text('Camera')],
                  ),
                  label: '',
                ),
              ],
              currentIndex: controller.count.value,
              selectedItemColor:
                  Get.isDarkMode ? Colors.blueAccent : primaryColor,
              unselectedItemColor:
                  Get.isDarkMode ? Colors.blueAccent : Colors.grey,
              onTap: (index) {
                // Update the current index
                controller.onItemTapped(index);

                // if (index == 4) {
                //   controller.openCamera();
                // }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget Translate() {
    final SpeechToText speechToText = SpeechToText();
    final isInitailized = false.obs;

    final isInitailizedTarget = false.obs;

    return SingleChildScrollView(
      child: Container(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              width: Get.mediaQuery.size.width,
              height: 70,
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), // Offset of the shadow
                    blurRadius: 6.0, // Blur radius of the shadow
                    spreadRadius: 0.0, // Spread radius of the shadow
                  ),
                ],
                borderRadius: BorderRadius.circular(40),
                color: blackColor,
                border: GradientBoxBorder(
                  gradient: LinearGradient(
                      colors: [blueColor, pinkColor, purpleColor]),
                  width: 3,
                ),
              ),
              child: Row(children: [
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Obx(
                      () => CircleFlag(
                          '${controller.selectedLanguage.value["flag"].toString()}'),
                    )),
                GestureDetector(
                  onTap: () {
                    Get.dialog(
                        barrierDismissible: false, SelectedLanguageDialog());
                  },
                  child: Obx(
                    () => Text(
                      '${controller.selectedLanguage.value["name"].toString()}',
                      style: TextStyle(
                        fontSize: 18,
                        color: secondaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Spacer(),
                IconButton(
                    onPressed: () {
                      //swip between selectedlanguage and targetselectedlanaguage
                      controller.swapLanguages();
                    },
                    icon: Icon(
                      Icons.compare_arrows_outlined,
                      color: secondaryColor,
                    )),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    Get.dialog(
                        barrierDismissible: false,
                        SelectedTargetLanguageDialog());
                  },
                  child: Obx(
                    () => Text(
                      '${controller.selectedLanguagetoConvert.value["name"].toString()}',
                      style: TextStyle(
                        fontSize: 18,
                        color: secondaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Obx(
                      () => CircleFlag(
                          '${controller.selectedLanguagetoConvert.value["flag"].toString()}'),
                    )),
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Container(
              width: Get.mediaQuery.size.width,
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), // Offset of the shadow
                    blurRadius: 6.0, // Blur radius of the shadow
                    spreadRadius: 0.0, // Spread radius of the shadow
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
                color: purple2Color,
              ),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(children: [
                  Row(
                    children: [
                      Obx(
                        () => Text(
                          '${controller.selectedLanguage.value["name"].toString()}',
                          style: TextStyle(
                            fontSize: 18,
                            color: secondaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () => controller.playText(
                                controller.textEditor.text,
                                controller.selectedLanguage.value["code"]
                                    .toString(),
                              ),
                          icon: Icon(
                            Icons.volume_up,
                            color: secondaryColor,
                          )),
                      IconButton(
                          onPressed: () {
                            if (controller.textEditor.text.isNotEmpty) {
                              Clipboard.setData(ClipboardData(
                                  text: controller.textEditor.text));
                              Get.snackbar('Copied', 'Text Copied',
                                  snackPosition: SnackPosition.TOP,
                                  backgroundColor: pink2Color,
                                  colorText: Colors.white);
                            } else {
                              Get.snackbar('Error', 'Nothing to copy',
                                  snackPosition: SnackPosition.TOP,
                                  backgroundColor:
                                      const Color.fromARGB(255, 244, 16, 0),
                                  colorText: Colors.white);
                            }
                          },
                          icon: Icon(
                            Icons.copy,
                            color: secondaryColor,
                          )),
                      Spacer(),
                      GestureDetector(
                          onTap: () {
                            controller.textEditor.clear();
                          },
                          child: Icon(
                            Icons.close,
                            color: secondaryColor,
                          )),
                    ],
                  ),
                  Form(
                      child: Column(
                    children: [
                      TextFormField(
                        style: TextStyle(color: secondaryColor),
                        maxLines: 4,
                        controller: controller.textEditor,
                        decoration: const InputDecoration(
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: 'Enter text here',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.multiline,
                      )
                    ],
                  )),
                  Row(
                    children: [
                      Obx(
                        () => AvatarGlow(
                          animate: isInitailized.value,
                          glowColor: primaryColor,
                          duration: const Duration(milliseconds: 2000),
                          repeatPauseDuration:
                              const Duration(milliseconds: 100),
                          repeat: true,
                          endRadius: 35.0,
                          child: GestureDetector(
                            onTapDown: (details) {
                              isInitailized.value = true;
                              controller.ConvertSpeechToText(
                                  speechToText,
                                  controller.selectedLanguage.value["code"]
                                      .toString(),
                                  controller.textEditor);
                            },
                            onTapUp: (details) {
                              isInitailized.value = false;
                              speechToText.stop();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  // gradient: LinearGradient(
                                  //   colors: [blueColor, pinkColor, purpleColor],
                                  //   begin: Alignment.topLeft,
                                  //   end: Alignment.bottomLeft,
                                  // )),
                                  color: blackColor),
                              child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Icon(
                                    isInitailized.value
                                        ? Icons.mic
                                        : Icons.mic_none,
                                    color: Colors.white,
                                  )),
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [blueColor, pinkColor, purpleColor],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(
                              30), // Similar to StadiumBorder
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const StadiumBorder(),
                            backgroundColor: Colors.transparent,
                            padding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal:
                                    30), // Button background transparent so gradient is visible
                            shadowColor: Colors
                                .transparent, // Remove the shadow for clean look
                          ),
                          onPressed: () {
                            controller.ConvertSelectedTextToTargetText(
                                controller.textEditor.text,
                                controller.selectedLanguage.value["code"]
                                    .toString(),
                                controller
                                    .selectedLanguagetoConvert.value["code"]
                                    .toString());
                          },
                          child: Text(
                            'Translate',
                            style: TextStyle(
                                color: Colors.white), // Text color for contrast
                          ),
                        ),
                      ),
                    ],
                  )
                ]),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 4, left: 25, right: 25, bottom: 20),
            child: Container(
              width: Get.mediaQuery.size.width,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), // Offset of the shadow
                    blurRadius: 6.0, // Blur radius of the shadow
                    spreadRadius: 0.0, // Spread radius of the shadow
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  colors: [
                    purple2Color, // First color
                    purple2Color, // Second color
                    pink2Color, // Third color
                  ],
                  stops: [
                    0.0, // 0% for the first color (purple2Color)
                    0.62, // 50% for the second color (purple2Color)
                    3.7, // 100% for the third color (pink2Color)
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(children: [
                  Row(
                    children: [
                      Obx(
                        () => Text(
                          '${controller.selectedLanguagetoConvert.value["name"].toString()}',
                          style: TextStyle(
                            fontSize: 18,
                            color: secondaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () => controller.playText(
                                controller.targettextEditor.text,
                                controller
                                    .selectedLanguagetoConvert.value["code"]
                                    .toString(),
                              ),
                          icon: Icon(
                            Icons.volume_up,
                            color: secondaryColor,
                          )),
                      IconButton(
                          onPressed: () {
                            if (controller.targettextEditor.text.isNotEmpty) {
                              Clipboard.setData(ClipboardData(
                                  text: controller.targettextEditor.text));
                              Get.snackbar('Copied', 'Text Copied',
                                  snackPosition: SnackPosition.TOP,
                                  backgroundColor: pink2Color,
                                  colorText: Colors.white);
                            } else {
                              Get.snackbar('Error', 'Nothing to copy',
                                  snackPosition: SnackPosition.TOP,
                                  backgroundColor:const Color.fromARGB(255, 244, 16, 0),
                                  colorText: Colors.white);
                            }
                          },
                          icon: Icon(
                            Icons.copy,
                            color: secondaryColor,
                          )),
                      Spacer(),
                      GestureDetector(
                          onTap: () {
                            controller.targettextEditor.clear();
                          },
                          child: Icon(
                            Icons.close,
                            color: secondaryColor,
                          )),
                    ],
                  ),
                  Form(
                      child: Column(
                    children: [
                      TextFormField(
                        style: TextStyle(color: secondaryColor),
                        maxLines: 4,
                        controller: controller.targettextEditor,
                        decoration: InputDecoration(
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: 'Enter text here',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.multiline,
                      )
                    ],
                  )),
                  Row(
                    children: [
                      Obx(
                        () => AvatarGlow(
                          animate: isInitailizedTarget.value,
                          glowColor: primaryColor,
                          duration: const Duration(milliseconds: 2000),
                          repeatPauseDuration:
                              const Duration(milliseconds: 100),
                          repeat: true,
                          endRadius: 35.0,
                          child: GestureDetector(
                            onTapDown: (details) {
                              isInitailizedTarget.value = true;
                              controller.ConvertSpeechToText(
                                  speechToText,
                                  controller
                                      .selectedLanguagetoConvert.value["code"]
                                      .toString(),
                                  controller.targettextEditor);
                            },
                            onTapUp: (details) {
                              isInitailizedTarget.value = false;
                              speechToText.stop();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  // gradient: LinearGradient(
                                  //   colors: [blueColor, pinkColor, purpleColor],
                                  //   begin: Alignment.topLeft,
                                  //   end: Alignment.bottomLeft,
                                  // )),
                                  color: blackColor),
                              child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Icon(
                                    isInitailized.value
                                        ? Icons.mic
                                        : Icons.mic_none,
                                    color: Colors.white,
                                  )),
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [blueColor, pinkColor, purpleColor],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(
                              30), // Similar to StadiumBorder
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const StadiumBorder(),
                            backgroundColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal:
                                    30), // Button background transparent so gradient is visible
                            shadowColor: Colors.transparent, // Remove the shadow for clean look
                          ),
                          onPressed: () {
                            controller.ConvertSelectedTextToTargetText(
                                controller.textEditor.text,
                                controller.selectedLanguage.value["code"]
                                    .toString(),
                                controller
                                    .selectedLanguagetoConvert.value["code"]
                                    .toString());
                          },
                          child: const Text(
                            'Translate',
                            style: TextStyle(
                                color: Colors.white), // Text color for contrast
                          ),
                        ),
                      ),
                    ],
                  )
                ]),
              ),
            ),
          )
        ]),
      ),
    );
  }

  Widget SelectedTargetLanguageDialog() {
    return AlertDialog(
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text('Close'),
        ),
      ],
      title: Text('Target Language'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: controller.languageList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    var value = controller.languageList[index];
                    if (value is Map<String, dynamic>) {
                      // Ensure that the required fields are of String type
                      String name = value['name'] ?? '';
                      String code = value['code'] ?? '';
                      String flag = value['flag'] ?? '';

                      // Create a new Map<String, String> with the correct type
                      Map<String, String> selectedLanguageMap = {
                        'name': name,
                        'code': code,
                        'flag': flag,
                      };

                      // Update selectedLanguage with the new map
                      controller.selectedLanguagetoConvert.value =
                          selectedLanguageMap;
                      Get.back();
                    }
                  },
                  tileColor:
                      controller.selectedLanguagetoConvert.value['code'] ==
                              controller.languageList[index]['code']
                          ? Colors.blue[100]
                          : Colors.white,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //Radio check

                      CircleFlag(controller.languageList[index]["flag"]),
                      SizedBox(width: 10),
                      Text(controller.languageList[index]["name"],
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget SelectedLanguageDialog() {
    return AlertDialog(
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text('Close'),
        ),
      ],
      title: Text('Select Language'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: controller.languageList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  tileColor: controller.selectedLanguage.value['code'] ==
                          controller.languageList[index]['code']
                      ? Colors.blue[100]
                      : Colors.white,
                  onTap: () {
                    var value = controller.languageList[index];
                    if (value is Map<String, dynamic>) {
                      // Ensure that the required fields are of String type
                      String name = value['name'] ?? '';
                      String code = value['code'] ?? '';
                      String flag = value['flag'] ?? '';

                      // Create a new Map<String, String> with the correct type
                      Map<String, String> selectedLanguageMap = {
                        'name': name,
                        'code': code,
                        'flag': flag,
                      };

                      // Update selectedLanguage with the new map
                      controller.selectedLanguage.value = selectedLanguageMap;
                      Get.back();
                    }
                  },
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //Radio check

                      CircleFlag(controller.languageList[index]["flag"]),
                      SizedBox(width: 10),
                      Text(controller.languageList[index]["name"],
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
