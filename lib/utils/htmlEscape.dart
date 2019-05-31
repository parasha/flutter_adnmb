import 'package:flutter/widgets.dart';

// Widget RichText(String text){

// }

String htmlEscape(String text){
  // 去除换行 <br>
  text = text.replaceAll('<br />', '');
  text = text.replaceAll('<br>', '');
  text = text.replaceAll('&gt;', '>');
  text = text.replaceAll('&lt;', '<');

  return text;
}