import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:adnmb/pages/home.dart';
import 'package:adnmb/pages/setting.dart';

import 'package:adnmb/utils/simple_store.dart' show store;

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      routes: {'SETTING': (context) => SettingPage()},
    );
  }
}

void main(List<String> args) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String cookie = sharedPreferences.getString('cookie');
  store.saveCookie(cookie);
  print(store.toStirng());
  runApp(App());
}
