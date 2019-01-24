import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:beauty/main.dart';
import 'dart:ui';
import 'package:beauty/funny/FunnyDetailUI.dart';
import 'package:transparent_image/transparent_image.dart';

class FunnyListUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new DefaultTabController(
        length: choices.length,
        child: new Scaffold(
          appBar: new AppBar(
            title: const Text('内涵段子'),
            bottom: new TabBar(
              isScrollable: true,
              tabs: choices.map((Choice choice) {
                return new Tab(
                  text: choice.title,
                );
              }).toList(),
            ),
          ),
          drawer: new Drawer(
            child: HomeBuilder.homeDrawer(context),
          ),
          body: new TabBarView(
            children: choices.map((Choice choice) {
              return new ChoiceCard(choice: choice);
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class Choice {
  const Choice({this.title, this.type});

  final String title;
  final int type;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: '全部', type: 1),
  const Choice(title: '纯文', type: 2),
  const Choice(title: '图片', type: 3),
  const Choice(title: '动图', type: 4),
  const Choice(title: '视频', type: 5),
];

class ChoiceCard extends StatefulWidget {
  const ChoiceCard({Key key, this.choice}) : super(key: key);

  final Choice choice;

  @override
  State<StatefulWidget> createState() => new _CounterState(choice);
}

class _CounterState extends State<ChoiceCard> {
  _CounterState(this.choice);

  Dio dio = new Dio();
  List list = new List();
  final Choice choice;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new RefreshIndicator(
        onRefresh: () => getHttp(),
        child: new ListView.builder(
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
        ));
  }

  Widget buildItem(item, int index) {
    return new Card(
        child: new InkWell(
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
              child: buildContent(item, index)),
          new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Container(
                width: 15,
              ),
              new Icon(Icons.sentiment_satisfied,
                  color: Colors.grey, size: 20.0),
              new Text(
                " " + item["up"].toString(),
                style: new TextStyle(color: Colors.grey),
              ),
              new Container(
                width: 15,
              ),
              new Icon(Icons.sentiment_dissatisfied,
                  color: Colors.grey, size: 20.0),
              new Text(
                " " + item["down"].toString(),
                style: new TextStyle(color: Colors.grey),
              ),
              new Flexible(
                child: Container(),
                flex: 1,
              ),
              new Icon(Icons.sms, color: Colors.grey, size: 20.0),
              new Text(
                " " + item["comment"].toString(),
                style: new TextStyle(color: Colors.grey),
              ),
              new Container(
                width: 15,
              ),
              new Icon(Icons.share, color: Colors.grey, size: 20.0),
              new Text(
                " " + item["forward"].toString(),
                style: new TextStyle(color: Colors.grey),
              ),
              new Container(
                width: 15,
              ),
            ],
          ),
          new Container(
            height: 15,
          ),
          buildHotComment(item)
        ],
      ),
      onTap: () {
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (context) => new FunnyDetailUI(item: item)));
      },
    ));
  }

  Widget buildHotComment(item) {
    if (item["top_commentsName"] != null) {
      return new Container(
          padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: new Text.rich(new TextSpan(children: <TextSpan>[
            new TextSpan(
              text: item["top_commentsName"] + "：",
              style: TextStyle(
                color: Color(0xff999999),
              ),
            ),
            new TextSpan(
              text: item["top_commentsContent"],
              style: TextStyle(color: Colors.black),
            ),
          ])));
    }
    return new Container();
  }

  VideoPlayerController lastController;

  Widget buildContent(item, int index) {
    print(item);
    switch (item["type"]) {
      case "video":
//        if (index == 0) {
//          return new SizedBox(
//              width: double.infinity,
//              child: new AspectRatio(
//                  aspectRatio: 3 / 2,
//                  child: new Stack(children: <Widget>[
//                    new Image.network(
//                      item["thumbnail"],
//                      width: double.infinity,
//                      fit: BoxFit.fill,
//                    ),
//                    NetworkPlayerLifeCycle(
//                      item["video"].toString().replaceAll("http", "https"),
//                      false,
//                      (BuildContext context,
//                              VideoPlayerController controller) =>
//                          AspectRatioVideo(controller),
//                    )
//                  ])));
//        } else {
        return new SizedBox(
            width: double.infinity,
            child: new AspectRatio(
                aspectRatio: 3 / 2,
                child: Stack(children: <Widget>[
                  new Image.network(
                    item["thumbnail"],
                    width: double.infinity,
                    fit: BoxFit.fill,
                  ),
                  BackdropFilter(
                    filter: new ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: new Container(
                      color: Colors.white.withOpacity(0.1),
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  new Image.network(
                    item["thumbnail"],
                    width: double.infinity,
                    fit: BoxFit.scaleDown,
                  ),
                  new InkWell(
                    child: new Center(
                      child: new Image.asset("assets/ic_player.png"),
                    ),
                  ),
                ])));
//        }
        break;
      case "image":
        return image(item["image"]);
        break;
      case "gif":
        return new SizedBox(
            width: double.infinity,
            child: new AspectRatio(
                aspectRatio: 3 / 2,
                child: new Stack(children: <Widget>[
                  new FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: item["thumbnail"],
                    width: double.infinity,
                    fit: BoxFit.fill,
                  ),
                  BackdropFilter(
                    filter: new ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: new Container(
                      color: Colors.white.withOpacity(0.1),
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  new Image.network(
                    item["gif"],
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ])));
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

  Widget maskLabel(String text) {
    return new Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: new Container(
        padding: EdgeInsets.all(15),
        color: Color(0x90000000),
        child: new Text(
          text,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Future<Null> getHttp() async {
    try {
      Response<Map<String, Object>> response;
      response = await Dio().get(
          "https://www.apiopen.top/satinGodApi?type=${choice.type}&page=1");
      if (response.statusCode != 200) {
        return print("response.statusCode" + response.statusCode.toString());
      }
      var data = response.data;
      print(data["code"]);
      if (data["code"] == 200) {
        setState(() {
          list = data["data"];
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
