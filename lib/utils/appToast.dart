import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/rendering.dart';

void showAppToast(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Color.fromRGBO(0, 0, 0, 0.6),
    textColor: Color.fromRGBO(255, 255, 255, 1),
  );
}
