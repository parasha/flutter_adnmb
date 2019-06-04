import 'package:flutter/material.dart';

import 'package:adnmb/utils/appToast.dart';
import 'package:adnmb/utils/http.dart';

class Repply extends StatelessWidget {
  String chanId;
  String repplyString;

  Repply(this.chanId);

  void sendRepply() {
    print(repplyString);
    if (repplyString == null || repplyString == '') {
      showAppToast('回复不能为空');
      return;
    }
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.send),
            onPressed: sendRepply,
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: TextField(
          onChanged: (String value) {
            repplyString = value;
          },
          decoration: InputDecoration(
              hintText: "Input your opinion",
              hintStyle: TextStyle(color: Colors.white30),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(new Radius.circular(5.0))),
              labelStyle: TextStyle(color: Colors.white)),
          maxLines: 20,
        ),
      ),
    );
  }
}
