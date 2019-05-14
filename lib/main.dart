import 'package:flutter/material.dart';

import 'package:adnmb/pages/home.dart';
import 'package:adnmb/pages/setting.dart';


class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      routes: {
        'SETTING': (context)=> SettingPage()
      },
    );
  }
}

void main(List<String> args) async {
  runApp(App());
}
