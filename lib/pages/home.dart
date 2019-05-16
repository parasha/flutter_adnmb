import 'package:flutter/material.dart';
import 'package:adnmb/utils/http.dart';

import 'package:adnmb/pages/chan.dart';
import 'package:adnmb/pages/imgPreview.dart';

import 'package:adnmb/utils/htmlEscape.dart';

class Home extends StatefulWidget {
  HomeState createState() => new HomeState();
}

class HomeState extends State {
  List forumList;
  List postList;

  String forumindex = '4';
  String pageIndex = '1';

  String pageTitle = '综合版';

  bool loadingSwitch = false;

  void initState() {
    getForumList();
    getPostById(forumindex, pageIndex);
  }

  // 滚动加载
  void loadNextPage() async {
    if (loadingSwitch) {
      return;
    } else {
      loadingSwitch = true;
      pageIndex = (int.parse(pageIndex) + 1).toString();
      await getPostById(forumindex, pageIndex);
      loadingSwitch = false;
    }
  }

  // 页面刷新
  void refreshData() async {
    setState(() {
      postList = null;
    });
    pageIndex = '1';
    getPostById(forumindex, pageIndex);
  }

  // 跳转详情页
  void jumpChanPage(String chanId) {
    Navigator.push(context, new MaterialPageRoute(builder: (context) {
      return new ChanPage(chanId);
    }));
  }

  // 切换 板块
  void selectForum(String id, String title) async {
    if (id == forumindex) {
      return;
    }
    forumindex = id;
    pageIndex = '1';
    Navigator.of(context).pop();
    setState(() {
      postList = null;
      pageTitle = title;
    });
    await getPostById(forumindex, pageIndex);
  }

  // 接口请求
  void getForumList() async {
    var fl = await http.get('nmb.fastmirror.org/Api/getForumList');
    setState(() {
      forumList = fl;
    });
  }

  void getPostById(String id, String page) async {
    Map<String, String> data = {'id': id, 'page': page};
    var pl = await http.get('nmb.fastmirror.org/Api/showf', data: data);
    setState(
      () {
        try {
          postList == null ? postList = pl : postList.addAll(pl);
        } catch (e) {
          postList = null;
        }
      },
    );
  }

  // 数据渲染
  List forumInit(List forumList) {
    List<Widget> r = [
      Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.blueGrey))),
        child: ListTile(
          title: Row(
            children: <Widget>[
              Icon(Icons.settings),
              Container(
                child: Text('设置'),
                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
              )
            ],
          ),
          // contentPadding: EdgeInsets.fromLTRB(40, 0, 0, 0),
          onTap: () {
            Navigator.pushNamed(context, 'SETTING');
          },
        ),
      ),
      Container(
        child: Text(
          '板块列表',
          style: TextStyle(color: Colors.blueAccent),
        ),
        padding: EdgeInsets.fromLTRB(15, 5, 0, 5),
        decoration: BoxDecoration(color: Color.fromRGBO(180, 180, 180, 0.5)),
      )
    ];
    if (forumList != null) {
      for (var area in forumList) {
        ListTile tile = new ListTile(
          title: new Text(
            area['name'],
            style: new TextStyle(
                // color: Colors.green,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        );
        r.add(tile);
        for (var item in area['forums']) {
          ListTile forum = new ListTile(
            title: new Text(item['name']),
            contentPadding: EdgeInsets.fromLTRB(40, 0, 0, 0),
            onTap: () {
              selectForum(item['id'], item['name']);
            },
          );
          r.add(forum);
        }
      }
    }
    return r;
  }

  Widget postListInit(Map item) {
    Widget tile = new Container(
        margin: EdgeInsets.only(bottom: 15),
        padding: EdgeInsets.only(bottom: 15),
        decoration: new BoxDecoration(
            border: new Border(bottom: BorderSide(color: Colors.blueAccent))),
        child: listTileInit(item));
    return tile;
  }

  Widget listTileInit(Map item) {
    return new ListTile(
      onTap: () => jumpChanPage(item['id']),
      title: new Container(
        child: new Row(
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
      ),
      subtitle: new Container(
        margin: EdgeInsets.only(top: 10),
        child: item['img'] == ''
            ? new Text(
                htmlEscape(item['content']),
              )
            : new Row(
                children: <Widget>[
                  new FlatButton(
                    onPressed: () {
                      openImgPreview(
                          context,
                          'https://nmbimg.fastmirror.org/image/' +
                              item['img'] +
                              item['ext']);
                    },
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
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(pageTitle),
      ),
      body: postList == null
          ? new Center(child: new Text('Loading...少女祈祷中'))
          : new Scrollbar(
              child: new NotificationListener(
                  onNotification: (ScrollNotification sn) {
                    if (sn.metrics.extentAfter < 200) {
                      loadNextPage();
                    }
                  },
                  child: ListView.builder(
                    itemCount: postList == null ? 0 : postList.length,
                    itemBuilder: (BuildContext context, int index) {
                      var item = postList[index];
                      return postListInit(item);
                    },
                  )),
            ),
      floatingActionButton: new FloatingActionButton(
          onPressed: refreshData, child: new Icon(Icons.refresh)),
      drawer: new Drawer(
        child: new Scaffold(
          appBar: new AppBar(
            // title: new Text('板块列表'),
            automaticallyImplyLeading: false,
            centerTitle: false,
          ),
          body: ListView(children: forumInit(forumList)),
        ),
      ),
    );
  }
}
