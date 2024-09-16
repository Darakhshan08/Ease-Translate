import 'dart:async';

import 'package:get/get.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final count = 0.obs;


  @override
  void onInit() {
    super.onInit();

  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
  // Cancel the timer when closing the controller
    super.onClose();
  }

  void setTimer() {
   Timer(Duration(seconds: 5), () {
      Get.toNamed('/main-screen');
    
    });
  }
}
