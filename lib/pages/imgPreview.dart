import 'package:flutter/material.dart';

class _ImgPreview extends StatelessWidget {
  String url;

  _ImgPreview(this.url) : super();

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(),
      body: new Center(
        child: new FlatButton(
          // onPressed: ()=>Navigator.of(context).pop(),
          child: Image.network(
            url,
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}

void openImgPreview(BuildContext context, String url) {
  Navigator.push(context, new MaterialPageRoute(builder: (context) {
    return new _ImgPreview(url);
  }));
}
