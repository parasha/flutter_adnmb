import 'package:flutter/material.dart';

import 'package:adnmb/pages/home.dart';


class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      routes: {
        // 'file': (context)=> FileOperationRoute()
      },
    );
  }
}

void main(List<String> args) async {
  runApp(App());
}
