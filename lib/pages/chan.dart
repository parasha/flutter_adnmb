import 'package:flutter/material.dart';
import 'package:adnmb/utils/http.dart';
import 'package:adnmb/pages/imgPreview.dart';

class ChanPage extends StatefulWidget {
  String chanId;
  ChanPage(this.chanId) : super();
  ChanPageState createState() => new ChanPageState(chanId);
}

class ChanPageState extends State {
  String chanId;
  String pageIndex = '1';
  List replyList;
  Map chanDetail;
  bool loadSwitch = false;
  bool getBottom = false;

  ChanPageState(this.chanId) : super();

  void initState() {
    getPostList(chanId, pageIndex);
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

  // 主标题
  Widget mainChanInit(Map chanDetail) {
    return new Container(
      margin: EdgeInsets.only(bottom: 20),
      child: new ListTile(
        title: new Row(
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
        subtitle: chanDetail['img'] == ''
            ? new Text(chanDetail['content'])
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
                      chanDetail['content'],
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
    // List<Widget> r = [mainChanInit(chanDetail)];
    // for (var item in replyList) {
    Widget tile = new Container(
        margin: EdgeInsets.only(bottom: 15),
        padding: EdgeInsets.only(bottom: 15),
        decoration: new BoxDecoration(
            border: new Border(top: BorderSide(color: Colors.blueAccent))),
        child: new ListTile(
          title: new Row(
            children: <Widget>[
              new Text(
                item['userid'],
                style: new TextStyle(fontWeight: FontWeight.bold),
              ),
              new Container(
                padding: EdgeInsets.only(left: 20),
                child: new Text(item['now']),
              )
            ],
          ),
          subtitle: item['img'] == ''
              ? new Text(item['content'])
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
                        item['content'],
                        overflow: TextOverflow.clip,
                      ),
                    )
                  ],
                ),
        ));
    // r.add(tile);
    // }
    return tile;
  }

  void getPostList(String chanId, String page) async {
    Map<String, String> data = {'id': chanId, 'page': page};
    var pl = await http.get('nmb.fastmirror.org/Api/thread', data: data);
    setState(() {
      try {
        replyList == null
            ? replyList = pl['replys']
            : replyList.addAll(pl['replys']);
        if (chanDetail == null) {
          chanDetail = pl;
        }
        print(pl['replys'].length);
        print(pl['replys'][0]['title']);

        if (pl['replys'].length == 1 && pl['replys'][0]['title'] == '广告') {
          getBottom = true;
        }
      } catch (e) {
        print(e);
        replyList = null;
        chanDetail = null;
      }
    });
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('No.' + chanId),
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
                      print(replyList.length);
                      if (index == 0) {
                        return mainChanInit(chanDetail);
                      } else {
                        var item = replyList[index - 1];
                        return postListInit(item);
                      }
                    },
                  )
                  // new ListView(children: postListInit(replyList)),
                  ),
            ),
      // floatingActionButton: new FloatingActionButton(
      //   onPressed: () {
      //     Navigator.pushNamed(context, 'file');
      //   },
      //   child: new Icon(Icons.photo),
      // ),
    );
  }
}
