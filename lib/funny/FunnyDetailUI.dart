import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:beauty/Video.dart';
import 'dart:ui';
import 'package:beauty/photo/PhotoPreviewUI.dart';

class FunnyDetailUI extends StatelessWidget {
  Map item;

  FunnyDetailUI({Key key, @required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
//        appBar: new AppBar(
//          title: const Text('内涵段子'),
////        bottom: new TabBar(
////          isScrollable: true,
////          tabs: choices.map((Choice choice) {
////            return new Tab(
////              text: choice.title,
////            );
////          }).toList(),
////        ),
//        ),
        body: new Stack(
      children: <Widget>[
        new Container(
            color: Colors.black,
            child: new SingleChildScrollView(
                child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(
                  margin: EdgeInsets.only(
                      top: MediaQueryData.fromWindow(window).padding.top),
                  height: 48,
                  width: double.infinity,
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new SizedBox(
                        width: 30,
                        height: 30,
                        child: new ClipOval(
                          child: Image.network(item["header"]),
                        ),
                      ),
                      new Container(
                        width: 15,
                      ),
                      new SizedBox(
                          width: 100,
                          child: new Text(
                            item["username"],
                            overflow: TextOverflow.ellipsis,
                            style: new TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          )),
                    ],
                  ),
                ),
                new Container(
                    margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
                    child: new Stack(
                      children: <Widget>[
                        new AspectRatio(aspectRatio: 3 / 2),
                        buildContent(context, item)
                      ],
                    )),
                new Container(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                  child: new Text(
                    item["text"],
                    textAlign: TextAlign.start,
                    style: new TextStyle(color: Colors.white),
                  ),
                ),
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      width: 15,
                    ),
                    new Icon(Icons.sentiment_satisfied,
                        color: Colors.white, size: 20.0),
                    new Text(
                      " " + item["up"].toString(),
                      style: new TextStyle(color: Colors.white),
                    ),
                    new Container(
                      width: 15,
                    ),
                    new Icon(Icons.sentiment_dissatisfied,
                        color: Colors.white, size: 20.0),
                    new Text(
                      " " + item["down"].toString(),
                      style: new TextStyle(color: Colors.white),
                    ),
                    new Flexible(
                      child: Container(),
                      flex: 1,
                    ),
                    new Icon(Icons.sms, color: Colors.white, size: 20.0),
                    new Text(
                      " " + item["comment"].toString(),
                      style: new TextStyle(color: Colors.white),
                    ),
                    new Container(
                      width: 15,
                    ),
                    new Icon(Icons.share, color: Colors.white, size: 20.0),
                    new Text(
                      " " + item["forward"].toString(),
                      style: new TextStyle(color: Colors.white),
                    ),
                    new Container(
                      width: 15,
                    ),
                  ],
                ),
                new Container(
                  height: 15,
                ),
                new Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0))),
                  child: new Comment(
                    uid: item["soureid"].toString(),
                  ),
                )
              ],
            ))
//      ]),
            ),
        new InkWell(
          child: new Container(
            margin: EdgeInsets.fromLTRB(
                15, MediaQueryData.fromWindow(window).padding.top, 0, 0),
            height: 48,
            width: 48,
            child: new Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        )
      ],
    ));
  }

  Widget buildContent(BuildContext context, item) {
    print(item);
    switch (item["type"]) {
      case "video":
        return new SizedBox(
            width: double.infinity,
            child: NetworkPlayerLifeCycle(
              item["video"].toString().replaceAll("http", "https"),
              true,
              (BuildContext context, VideoPlayerController controller) =>
                  AspectRatioVideo(controller),
            )); //        } else {


        break;
      case "image":
        return image(context, item["image"]);
        break;
      case "gif":
        return image(context, item["gif"]);
        break;
      case "text":
        break;
    }
  }

  Widget image(BuildContext context, String url) {
    return new GestureDetector(
        onTap: () {
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (context) => new PhotoPreviewUI(
                    url: url,
                  )));
        },
        child: new Image.network(
          url,
          width: double.infinity,
          fit: BoxFit.fitWidth,
        ));
  }
}

class Comment extends StatefulWidget {
  const Comment({Key key, this.uid}) : super(key: key);

  final String uid;

  @override
  State<StatefulWidget> createState() => new _CommentState(uid);
}

class _CommentState extends State<Comment> {
  _CommentState(this.uid);

  Dio dio = new Dio();
  List list = new List();
  final String uid;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new ListView.builder(
      shrinkWrap: true,
      itemCount: list.length,
      physics: ClampingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return buildItem(list[index], index);
//        return new GestureDetector(
//            child: new Hero(
//                tag: list[index].hashCode,
//                child: new Card(child: buildItem(context, list[index]))),
//            onTap: () {
//              Navigator.of(context).push(new MaterialPageRoute(
//                  builder: (context) => new PhotoDetailUI(url: list[index])));
//            });
      },
      addAutomaticKeepAlives: false,
    );
  }

  Widget buildItem(item, int index) {
    Map user = item["user"];
    return new Container(
        padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              padding: EdgeInsets.only(right: 15),
              child: new Row(
                children: <Widget>[
                  new SizedBox(
                    width: 30,
                    height: 30,
                    child: new ClipOval(
                      child: Image.network(user["profile_image"]),
                    ),
                  ),
                  new Container(
                    width: 15,
                  ),
                  new Text(
                    user["username"],
                    style: new TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.w600),
                  ),
                  new Flexible(
                    child: Container(),
                    flex: 1,
                  ),
                  new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.thumb_up, color: Colors.grey, size: 15.0),
                      new Text(
                        " " + item["like_count"].toString(),
                        style: new TextStyle(color: Colors.black54),
                      )
                    ],
                  )
                ],
              ),
            ),
            new Container(
                padding: EdgeInsets.fromLTRB(30, 10, 15, 10),
                child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(
                        item["content"],
                        textAlign: TextAlign.start,
                      ),
                      children(item["children"]),
                    ])),
            new Divider(
              color: Color(0xffe0e0e0),
              indent: 30,
              height: 0.5,
            ),
          ],
        ));
  }

  Widget children(List children) {
    print(children);
    if (children == null || children.isEmpty) {
      return new Container(
        padding: EdgeInsets.only(bottom: 10),
      );
    }

    return new Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Color(0xfff2f5f0), borderRadius: BorderRadius.circular(5)),
      child: new ListView.builder(
        shrinkWrap: true,
        itemCount: children.length,
        physics: ClampingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          Map child = children[index];
          Map user = child["user"];
          Map to_user = child["to_user"];
          String to_user_name = "";
          String replay = "";
          if (to_user != null && to_user["username"] != null) {
            to_user_name = to_user["username"];
            replay = " 回复 ";
          }
          String text = user["username"] +
              replay +
              to_user_name +
              " : " +
              child["content"];
          return new Container(
              padding: EdgeInsets.only(bottom: 3),
              child: new Text.rich(new TextSpan(
                  style: TextStyle(height: 1.1),
                  children: <TextSpan>[
                    new TextSpan(
                      text: user["username"],
                      style: TextStyle(color: Colors.blue),
                    ),
                    new TextSpan(
                      text: replay,
                    ),
                    new TextSpan(
                      text: to_user_name,
                      style: TextStyle(color: Colors.blue),
                    ),
                    new TextSpan(
                      text: "：" + child["content"],
                    ),
                  ])));
        },
        addAutomaticKeepAlives: false,
      ),
    );
  }

  void getHttp() async {
    try {
      Response<Map<String, Object>> response;
      response = await Dio()
          .get("https://www.apiopen.top/satinCommentApi?id=${uid}&page=1");
      if (response.statusCode != 200) {
        return print("response.statusCode" + response.statusCode.toString());
      }
      var data = response.data;
      print(data);
      print(data["code"]);
      if (data["code"] == 200) {
        setState(() {
          Map map = data["data"];
          print(map);
          Map normal = map["normal"];
          print(normal);
          list = normal["list"];
          print(list);
        });
      }
    } catch (e) {
      return print(e);
    }
  }

  @override
  void initState() {
    getHttp();
    super.initState();
  }

  @override
  void deactivate() {}
}
