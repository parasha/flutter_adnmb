import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:adnmb/utils/appToast.dart';

class SettingPage extends StatefulWidget {
  SettingPageState createState() => new SettingPageState();
}

class SettingPageState extends State {
  String qrcodeInfo;

  // Future readQrcode() async {
  //   try {
  //     String barcode = await BarcodeScanner.scan();
  //     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //     String cookie = json.decode(barcode)['cookie'];
  //     sharedPreferences.setString('COOKIE', cookie);
  //     showAppToast('记录饼干：$cookie');
  //   }catch(e){
  //     showAppToast('扫码失败');
  //   }
  // }

  void readQrcode() async {
    Map qr = json.decode(
        '{"cookie":"Wh%D5%CA%B2GT%CC%92%98%0B%F3%E1%E2%93%C4%8D%13%FB%FD%AA%A7%C2%2A"}');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      qrcodeInfo = qr['cookie'];
    });
    sharedPreferences.setString('cookie', qr['cookie']);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('设置'),
      ),
      body: Column(
        children: <Widget>[
          Text(qrcodeInfo == null ? 'loading...' : qrcodeInfo),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () {
              readQrcode();
            },
          ),
        ],
      ),
    );
  }
}
