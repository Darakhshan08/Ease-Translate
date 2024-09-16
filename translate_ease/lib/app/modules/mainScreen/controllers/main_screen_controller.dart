import 'dart:async';
import 'dart:convert';

import 'package:emailjs/emailjs.dart' as EmailJS;
import 'package:emailjs/emailjs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobile_vision_2/flutter_mobile_vision_2.dart';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:translate_ease/app/Theme/ColorTheme.dart';
import 'package:translate_ease/app/api/Apikey.dart';
import 'package:translate_ease/app/modules/mainScreen/history_model.dart';
import 'package:translate_ease/app/modules/mainScreen/providers/history_provider.dart';
import 'package:translator/translator.dart';

import 'package:speech_to_text/speech_to_text.dart';

class MainScreenController extends GetxController {
  //TODO: Implement MainScreenController
  final historyDB = HistoryProvider();

  final count = 0.obs;
  late RxBool isInitialized = false.obs;
  late TextEditingController textEditor = new TextEditingController();
  //form key
  final formKey = GlobalKey<FormState>();

  late TextEditingController targettextEditor = new TextEditingController();

  late TextEditingController feedbackController = new TextEditingController();

  final isListening = false.obs;

  late RxList<History> TranslationRecords = <History>[].obs;

  late RxList<History> TranslationFavoriteRecords = <History>[].obs;

  //selectedLanguage
  late RxMap selectedLanguage =
      {"name": "English", "code": "en", "flag": "us"}.obs;
  late List<OcrText> texts;
  late RxMap selectedLanguagetoConvert =
      {"name": "Urdu", "code": "ur", "flag": "pk"}.obs;

  late RxList<dynamic> languageList = [].obs;

  void getLanguageList() async {
    String jsonString = await rootBundle.loadString('assets/language.json');
    List<dynamic> list = json.decode(jsonString)['schema'];
    languageList.assignAll(List<Map<String, dynamic>>.from(list));
    update();
  }

  final text = "".obs;

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
    super.onClose();
  }

  void onItemTapped(int index) {
    count.value = index;
  }

  swapLanguages() {
    Map temp = selectedLanguage.value;
    selectedLanguage.value = selectedLanguagetoConvert.value;
    selectedLanguagetoConvert.value = temp;
  }

  ConvertSpeechToText(SpeechToText speechToText, String code,
      TextEditingController textEditor) async {
    try {
      var available = await SpeechToText().initialize(
        onStatus: (status) {
          print(status);
        },
        onError: (errorNotification) {
          print(errorNotification);
        },
      );

      if (available) {
        isListening.value = true;
        speechToText.listen(
          onResult: (result) {
            textEditor.text = result.recognizedWords;
          },
          localeId: code, // Provide the language code here
        );
      }
    } catch (e) {
      print(e);
    }
  }

  ConvertSelectedTextToTargetText(
      String text, String from_lang_code, String to_lang_code) {
    text
        .translate(
      from: from_lang_code,
      to: to_lang_code,
    )
        .then((value) {
      // Update TranslationRecords and trigger UI update
      targettextEditor.text = value.toString();
    }).catchError((error) {
      print(error);
    });
  }

  ConvertTargetTextToSelectedText(
      String text, String from_lang_code, String to_lang_code) {
    text
        .translate(
      from: from_lang_code,
      to: to_lang_code,
    )
        .then((value) {
      // Update TranslationRecords and trigger UI update
      textEditor.text = value.toString();
    }).catchError((error) {
      print(error);
    });
  }

//Chatting
  Future<String> conversion(String text, String fromLang, String toLang) async {
    var translatedMessage = await text.translate(
      from: fromLang,
      to: toLang,
    );
    return translatedMessage.toString();
  }

  void sendRatingEmail(rate) async {
    Map<String, dynamic> templateParams = {
      'rate': rate,
    };

    try {
      await EmailJS.send(
        '${ApiKey.emailjs_serviceId}',
        '${ApiKey.emailjs_ratingtemplateId}',
        templateParams,
        const Options(
          publicKey: '${ApiKey.emailjs_publicKey}',
          privateKey: '${ApiKey.emailjs_privateKey}',
        ),
      );
      Get.snackbar("Rating", 'Rating submitted successfully',
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (error) {
      Get.snackbar("Error", error.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  void sendFeedbackEmail() async {
    String feedback = feedbackController.text;
    Map<String, dynamic> templateParams = {
      'feedback': feedback,
    };

    try {
      await EmailJS.send(
        '${ApiKey.emailjs_serviceId}',
        '${ApiKey.emailjs_feedbacktemplateId}',
        templateParams,
        const Options(
          publicKey: '${ApiKey.emailjs_publicKey}',
          privateKey: '${ApiKey.emailjs_privateKey}',
        ),
      );
      Get.snackbar("Feedback", 'Feedback submitted successfully',
          backgroundColor: Colors.green, colorText: Colors.white);

      feedbackController.clear();
    } catch (error) {
      Get.snackbar("Error", error.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> Chatting(
    SpeechToText speechToText,
    String fromLang,
    String toLang,
    String side,
  ) async {
    try {
      var available = await speechToText.initialize(
        onStatus: (status) {
          print(status);
        },
        onError: (errorNotification) {
          print(errorNotification);
        },
      );

      if (available) {
        await speechToText.listen(
          onResult: (result) async {
            var message = result.recognizedWords;

            // Perform the translation only if the speech is fully recognized
            if (!result.finalResult) return;

            var translatedMessage =
                await conversion(result.recognizedWords, fromLang, toLang);
            TranslationRecords.insert(
                0,
                History(
                    id: 0,
                    isFavorite: 0,
                    message_language: fromLang,
                    translation_language: toLang,
                    side: side,
                    message: message,
                    translation: translatedMessage));

            historyDB.insert(
                text: message,
                to_lang: toLang,
                from_lang: fromLang,
                translated_text: translatedMessage,
                isFavorite: 0,
                side: side,
                createdAt: DateTime.now().toIso8601String());

            TranslationRecord();
          },
          localeId: fromLang,
        );
      }
    } catch (e) {
      print(e);
    }
  }

  deleteTranslationRecord(int id) async {
    await historyDB.deleteData(id);
    //delete from array list
    TranslationRecord();
    TranslationRecords.removeWhere((element) => element.id == id);
    Fluttertoast.showToast(
      msg: 'Translation Deleted',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  deleteTranslationAllRecord() async {
    await historyDB.deleteAll();
    //delete from array list
    TranslationRecords.clear();
    Fluttertoast.showToast(
      msg: 'Translation History Deleted',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Favorite(int id, int Favorite) async {
    await historyDB.isFavorite(id, Favorite);
    TranslationRecord();
    TranslationFavRecord();
    Fluttertoast.showToast(
      msg: Favorite == 1 ? 'Added to favorites' : 'Removed from favorites',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  playText(String text, String langCode) {
    FlutterTts flutterTts = FlutterTts();
    flutterTts.setLanguage(langCode);
    flutterTts.setPitch(1.0);
    flutterTts.speak(text);
  }

  openCamera() async {
    texts = [];
    try {
      texts = await FlutterMobileVision.read(
        showText: false,
        waitTap: true,
        forceCloseCameraOnTap: true,
        fps: 2.0,
      );

      // Print recognized text to the console
      Get.dialog(
        AlertDialog(
          title: Row(
            children: [
              Text('Recognized Text'),
              IconButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: texts[0].value));
                  Get.snackbar('Copied', 'Text Copied',
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: buttonColor,
                      colorText: Colors.white);
                },
                icon: Icon(Icons.copy),
              ),
              Spacer(),
              GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(Icons.close))
            ],
          ),
          content: SingleChildScrollView(child: Text(texts[0].value)),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  // Update TranslationRecords and trigger UI update
  void updateTranslationRecords(List<History> records) {
    TranslationRecords.assignAll(records);
    update(); // Trigger UI update
  }

  void updateTranslationFavRecords(List<History> records) {
    TranslationFavoriteRecords.assignAll(records);
    update(); // Trigger UI update
  }

  //dummy record in TranslationRecords
  Future<void> TranslationRecord() async {
    List<History> records = [];
    records = await historyDB.getAll();
    updateTranslationRecords(records);
  }

  Future<void> TranslationFavRecord() async {
    List<History> records = [];
    records = await historyDB.getFavorite();
    updateTranslationFavRecords(records);
  }

  Future<void> Search(String text) async {
    List<History> records = [];
    records = await historyDB.search(text);
    updateTranslationRecords(records);
  }

  //datefilter

  Future<void> DateFilter(String date) async {
    List<History> records = [];
    records = await historyDB.dateFilter(date);
    updateTranslationRecords(records);
  }
}
