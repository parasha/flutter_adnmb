import 'package:flutter/material.dart';

import 'package:adnmb/pages/home.dart';
// import 'package:adnmb/pages/file.dart';

class App extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return new MaterialApp(
      home: new Home(),
      routes: {
        // 'file': (context)=>new FileOperationRoute()
      },
    );
  }
}

void main(List<String> args) async{
  runApp(new App());
}