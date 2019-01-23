import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:beauty/main.dart';
import 'package:beauty/Video.dart';

class FunnyDetailUI extends StatelessWidget {
  Map item;

  FunnyDetailUI({Key key, @required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: const Text('内涵段子'),
//        bottom: new TabBar(
//          isScrollable: true,
//          tabs: choices.map((Choice choice) {
//            return new Tab(
//              text: choice.title,
//            );
//          }).toList(),
//        ),
        ),
        body: new SingleChildScrollView(
            child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              padding: EdgeInsets.all(15),
              child: new Row(
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
                  new Text(
                    item["username"],
                    style: new TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            new Container(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
              child: new Text(
                item["text"],
                textAlign: TextAlign.start,
              ),
            ),
            new Container(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                child: buildContent(item)),
            new Comment(
              uid: item["uid"],
            )
          ],
        ))
//      ]),
        );
  }

  Widget buildContent(item) {
    print(item);
    switch (item["type"]) {
      case "video":
        var controller = VideoPlayerController.network(
          item["video"].toString().replaceAll("http", "https"),
        );
        controller.addListener(() {
          if (controller.value.hasError) {
            print(controller.value.errorDescription);
          }
        });
        controller.initialize();
        controller.setLooping(false);
        controller.play();
        return new SizedBox(
            width: double.infinity,
            child: new AspectRatio(
                aspectRatio: 3 / 2, child: VideoPlayer(controller)));
//        } else {
//          return new SizedBox(
//              width: double.infinity,
//              child: new AspectRatio(
//                  aspectRatio: 3 / 2,
//                  child: Stack(children: <Widget>[
//                    new Image.network(
//                      item["thumbnail"],
//                      width: double.infinity,
//                      fit: BoxFit.fill,
//                    ),
//                    new InkWell(
//                      child: new Center(
//                        child: new Image.asset("assets/ic_player.png"),
//                      ),
//                      onTap: () {
////                        if (lastController != null) {
////                          lastController.dispose();
////                        }
//                        controller.play();
////                        lastController = controller;
//                      },
//                    ),
//                  ])));
//        }

        break;
      case "image":
        return image(item["image"]);
        break;
      case "gif":
        return image(item["gif"]);
        break;
      case "text":
        break;
    }
  }

  Widget image(String text) {
    return new SizedBox(
        width: double.infinity,
        child: new AspectRatio(
          aspectRatio: 1,
          child: new Image.network(
            text,
            fit: BoxFit.fitWidth,
          ),
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
        padding: EdgeInsets.all(15),
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
                ],
              ),
            ),
            new Container(
                padding: EdgeInsets.fromLTRB(30, 0, 15, 15),
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
              color: Colors.grey,
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
      color: Colors.black12,
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(8),
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
            replay = "回复";
          }

          return new Row(children: <Widget>[
            new Text(
              user["username"],
              style: TextStyle(color: Colors.blue),
            ),
            new Text(
              replay,
//                  style: TextStyle(color: Colors.blue),
            ),
            new Text(
              to_user_name,
              style: TextStyle(color: Colors.blue),
            ),
            new Text(
              ":" + child["content"],
//                  style: TextStyle(color: Colors.blue),
            ),
          ]);
        },
        addAutomaticKeepAlives: false,
      ),
    );
  }

  void getHttp() async {
    try {
      Response<Map<String, Object>> response;
      response = await Dio()
          .get("https://www.apiopen.top/satinCommentApi?id=27610708&page=1");
      if (response.statusCode != 200) {
        return print("response.statusCode" + response.statusCode.toString());
      }
      var data = response.data;
      print(data["code"]);
      if (data["code"] == 200) {
        setState(() {
          Map map = data["data"];
          Map normal = map["normal"];
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
