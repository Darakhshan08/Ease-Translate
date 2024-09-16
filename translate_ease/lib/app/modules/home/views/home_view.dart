import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);



  void closeAppUsingExit() {
    exit(0);
  }

  @override
  Widget build(BuildContext context) {
    controller.setTimer();
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          // Show an alert dialog when the user presses the back button
          bool exit = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Exit App?'),
              content: Text('Are you sure you want to exit the app?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
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
            body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/layer1.png',
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
              ),
              Spacer(),
              Image.asset(
                'assets/background.png',
                height: 100,
                width: 70,
              ),
              // const Text(
              //   "Translate Ease",
              //   style: TextStyle(
              //     fontSize: 24,
              //     color: Colors.blue,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              Spacer(),
              const Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: SizedBox(
                  width: 70,
                  child: LoadingIndicator(
                    indicatorType: Indicator.ballPulse,
                    colors: [Colors.blue],
                    strokeWidth: 2,
                    backgroundColor: Colors.transparent,
                    pathBackgroundColor: Colors.black,
                  ),
                ),
              )
            ],
          ),
        )),
      ),
    );
  }
}
