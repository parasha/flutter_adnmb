import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:adnmb/utils/http.dart';
import 'package:adnmb/pages/imgPreview.dart';
import 'package:adnmb/pages/repply.dart';

import 'package:adnmb/utils/htmlEscape.dart';
import 'package:adnmb/utils/simple_store.dart' show store;
import 'package:adnmb/utils/appToast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChanPage extends StatefulWidget {
  String chanId;
  ChanPage(this.chanId) : super();
  ChanPageState createState() => new ChanPageState(chanId);
}

class ChanPageState extends State {
  String chanId;
  String pageIndex = '1';
  String cookie;
  List replyList;
  Map chanDetail;
  bool loadSwitch = false;
  bool getBottom = false;

  ChanPageState(this.chanId) : super();

  void initState() {
    loadCookie();
    getPostList(chanId, pageIndex);
  }

  Future loadCookie() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    cookie = sharedPreferences.getString('cookie');
  }

  void loadNextPage() async {
    if (loadSwitch || getBottom) {
      return;
    } else {
      loadSwitch = true;
      pageIndex = (int.parse(pageIndex) + 1).toString();
      await getPostList(chanId, pageIndex);
      loadSwitch = false;
    }
  }

  // po
  Widget mainChanInit(Map chanDetail) {
    return new Container(
      margin: EdgeInsets.only(bottom: 20),
      child: new ListTile(
        title: new Container(
          margin: EdgeInsets.only(bottom: 10),
          child: new Row(
            children: <Widget>[
              new Text(
                chanDetail['userid'],
                style: new TextStyle(fontWeight: FontWeight.bold),
              ),
              new Container(
                padding: EdgeInsets.only(left: 20),
                child: new Text(chanDetail['now']),
              )
            ],
          ),
        ),
        subtitle: chanDetail['img'] == ''
            ? new Text(htmlEscape(chanDetail['content']))
            : new Row(
                children: <Widget>[
                  new FlatButton(
                    onPressed: () => openImgPreview(
                        context,
                        'https://nmbimg.fastmirror.org/image/' +
                            chanDetail['img'] +
                            chanDetail['ext']),
                    child: Image.network(
                      'https://nmbimg.fastmirror.org/image/' +
                          chanDetail['img'] +
                          chanDetail['ext'],
                      width: 100.0,
                      height: 100.0,
                    ),
                  ),
                  new Expanded(
                    flex: 1,
                    child: new Text(
                      htmlEscape(chanDetail['content']),
                      overflow: TextOverflow.clip,
                    ),
                  )
                ],
              ),
      ),
    );
  }

  // 串内回复列表
  Widget postListInit(Map item) {
    Widget tile = new Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.only(bottom: 15),
      decoration: new BoxDecoration(
          border: new Border(top: BorderSide(color: Colors.blueAccent))),
      child: new ListTile(
        title: new Container(
          margin: EdgeInsets.only(bottom: 10),
          child: new Row(
            children: <Widget>[
              new Text(
                item['userid'],
                style: item['userid'] == chanDetail['userid']
                    ? new TextStyle(fontWeight: FontWeight.bold)
                    : null,
              ),
              new Container(
                padding: EdgeInsets.only(left: 20),
                child: new Text(item['now']),
              )
            ],
          ),
        ),
        subtitle: item['img'] == ''
            ? new Text(htmlEscape(item['content']))
            : new Row(
                children: <Widget>[
                  new FlatButton(
                    onPressed: () => openImgPreview(
                        context,
                        'https://nmbimg.fastmirror.org/image/' +
                            item['img'] +
                            item['ext']),
                    child: Image.network(
                      'https://nmbimg.fastmirror.org/image/' +
                          item['img'] +
                          item['ext'],
                      width: 100.0,
                      height: 100.0,
                    ),
                  ),
                  new Expanded(
                    flex: 1,
                    child: new Text(
                      htmlEscape(item['content']),
                      overflow: TextOverflow.clip,
                    ),
                  )
                ],
              ),
      ),
    );
    return tile;
  }

  void getPostList(String chanId, String page) async {
    Map<String, String> data = {'id': chanId, 'page': page};
    var pl = await AppHttp.get('/thread', data: data);
    if (pl['replys'].length < 20) {
      getBottom = true;
    }
    if (pl['replys'].length == 1 && pl['replys'][0]['title'] == '广告') {
      return;
    }
    setState(() {
      try {
        replyList == null
            ? replyList = pl['replys']
            : replyList.addAll(pl['replys']);
        if (chanDetail == null) {
          chanDetail = pl;
        }
      } catch (e) {
        replyList = null;
        chanDetail = null;
      }
    });
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('No.' + chanId),
        actions: cookie != null
            ? <Widget>[
                IconButton(
                    icon: Icon(Icons.add_comment),
                    onPressed: () {
                      Navigator.push(context,
                          new MaterialPageRoute(builder: (context) {
                        return Repply(chanId);
                      }));
                    })
              ]
            : null,
      ),
      body: chanDetail == null
          ? new Center(child: new Text('Loading...少女祈祷中'))
          : new Scrollbar(
              child: new NotificationListener(
                onNotification: (ScrollNotification sn) {
                  if (sn.metrics.extentAfter < 200) {
                    loadNextPage();
                  }
                },
                child: ListView.builder(
                  itemCount: replyList == null ? 1 : replyList.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return mainChanInit(chanDetail);
                    } else {
                      var item = replyList[index - 1];
                      return postListInit(item);
                    }
                  },
                ),
              ),
            ),
    );
  }
}
