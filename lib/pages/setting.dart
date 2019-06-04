import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:adnmb/utils/appToast.dart';

import 'package:adnmb/utils/simple_store.dart' show store;

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
  //     store.saveCookie(cookie);
  //     showAppToast('保存饼干');
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
    store.saveCookie(qr['cookie']);
    sharedPreferences.setString('cookie', qr['cookie']);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('设置'),
        ),
        body: Container(
          padding: EdgeInsets.fromLTRB(30, 20, 10, 10),
          child: Column(
            children: <Widget>[

              FlatButton(
                onPressed: readQrcode,
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 10.0),
                      child: Icon(Icons.photo_camera),
                    ),
                    
                    Text('扫描二维码添加饼干')
                  ],
                ),
              )
              // Text(qrcodeInfo == null ? 'loading...' : qrcodeInfo),
              // IconButton(
              //   icon: Icon(Icons.camera_alt),
              //   onPressed: () {
              //     readQrcode();
              //   },
              // ),
            ],
          ),
        ));
  }
}
