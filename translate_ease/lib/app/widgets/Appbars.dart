import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:translate_ease/app/Theme/ColorTheme.dart';
import 'package:translate_ease/app/modules/mainScreen/controllers/main_screen_controller.dart';

AppBar BasicAppBar() {
  return AppBar(
    backgroundColor: blackColor,
    elevation: 0,
    title: const Text(
      "Ease Translate ",
      style: TextStyle(
        fontSize: 24,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

class SearchableAppBar extends StatefulWidget implements PreferredSizeWidget {
  SearchableAppBar({Key? key}) : super(key: key);

  @override
  _SearchableAppBarState createState() => _SearchableAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _SearchableAppBarState extends State<SearchableAppBar> {
  bool _isSearching = false;
  bool _isCalender = false;
  final TextEditingController _searchController = TextEditingController();
  MainScreenController controller = Get.put(MainScreenController());

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        controller.DateFilter(selectedDate.toString().substring(0, 10));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: blackColor,
      elevation: 0,
      actions: _isSearching || _isCalender
          ? null
          : [
              IconButton(
                onPressed: () {
                  setState(() {
                    _isCalender = true;
                  });
                  _selectDate(context);
                },
                icon: Icon(Icons.calendar_month, color: secondaryColor),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _isSearching = true;
                  });
                },
                icon: Icon(Icons.search, color: secondaryColor),
              ),
            ],
      title: _isSearching
          ? TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(color: Colors.white),
                border: InputBorder.none,
              ),
              style: const TextStyle(color: Colors.white),
              autofocus: true,
              onChanged: (value) {
                // Implement search logic here
                controller.Search(value);
              },
            )
          : _isCalender
              ? Text(
                  "Calender",
                  style: TextStyle(color: secondaryColor),
                )
              : const Text(
                  "Ease Translate ",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
      leading: _isSearching
          ? IconButton(
              onPressed: () {
                setState(() {
                  _isSearching = false;
                  _searchController.clear();
                });
              },
              icon: Icon(
                Icons.cancel,
                color: secondaryColor,
              ),
            )
          : _isCalender
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _isCalender = false;
                    });
                    controller.TranslationRecord();
                  },
                  icon: Icon(
                    Icons.cancel,
                    color: secondaryColor,
                  ),
                )
              : null,
    );
  }
}
