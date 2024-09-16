import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:speech_to_text/speech_to_text.dart';
import 'app/routes/app_pages.dart';
import 'package:sqflite/sqflite.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();
  initSpeechToText();
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}

//handle permissions for android for speech to text and camera
void initSpeechToText() {
  SpeechToText speechToText = SpeechToText();
  speechToText.initialize();
  
}


