import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:beauty/main.dart';
import 'package:beauty/Video.dart';

import 'dart:ui';

class JokeUI extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _JokeUItate();
}

class _JokeUItate extends State<JokeUI> {
  var width = MediaQueryData.fromWindow(window).size.width;
  List list = new List();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: const Text('图片详情'),
          iconTheme: new IconThemeData(color: Colors.white),
        ),
        body: getImg(1));
  }

  PageController controller;
  var pageOffset = 0.0;
  var forward = true;

  @override
  void initState() {
    super.initState();
    getHttp();
    controller = new PageController();
//    lastOffset = controller.offset;
    controller.addListener(() {
      setState(() {});
    });
  }

  Offset offset = Offset.zero;
  double x = 0.0;
  GlobalKey _key = GlobalKey();
  Offset lastOffset;
  double lastScale = 1.0;

  Widget getImg(int index) {
    return new GestureDetector(
        onScaleStart: (scale) {
          lastOffset = scale.focalPoint;
        },
        onScaleUpdate: (scaleUpdate) {
          print(scaleUpdate.scale.toString());
          setState(() {
            lastScale = (lastScale*scaleUpdate.scale).clamp(0.5, 5.0);
            offset = Offset(
                offset.dx + scaleUpdate.focalPoint.dx - lastOffset.dx,
                offset.dy + scaleUpdate.focalPoint.dy - lastOffset.dy);
          });
          lastOffset = scaleUpdate.focalPoint;
        },
        onScaleEnd: (scaleEnd){
          setState(() {
//            lastScale = scaleEnd.scale;
          });
        },
//        onTapDown: (dragDown) {
//          lastOffset = dragDown.globalPosition;
//        },
////        onTapCancel: () {
////          lastOffset = null;
////        },
//        onPanUpdate: (dragUpdate) {
//          RenderBox box = _key.currentContext.findRenderObject();
////          Offset offset = box.localToGlobal(Offset.zero);
//          print(dragUpdate.delta.dx.toString() +
//              ":" +
//              dragUpdate.globalPosition.dx.toString());
//
//          setState(() {
//            offset = Offset(
//                offset.dx + dragUpdate.globalPosition.dx - lastOffset.dx,
//                offset.dy + dragUpdate.globalPosition.dy - lastOffset.dy);
//          });
//          lastOffset = dragUpdate.globalPosition;
//        },
        child: new Center(
          child: new Container(
              margin: EdgeInsets.all(30),
              width: double.infinity,
              height: double.infinity,
              child: new Transform(
                  transform: Matrix4.identity()
                    ..translate(offset.dx, offset.dy)
                    ..scale(lastScale),
                  child: new Card(
                    key: _key,
                    child: new Text(
                        "ListView官网目前只介绍了一个下拉刷新功能，但上拉加载更多貌似没有甚至监听都没找到，相信以后会有大侠陆续给出自己的方案的，就像Android一样如雨后春笋，势不可挡。"),
                  ))),
        ));
//    var currentLeftPageIndex = pageOffset.floor();
//    var currentPageOffsetPercent = pageOffset - currentLeftPageIndex;
//
//    return Transform.translate(
//        offset: Offset(0, (pageOffset - position) * width),
//        child: Transform.scale(
//            scale: currentLeftPageIndex == position
//                ? 1 - currentPageOffsetPercent
//                : currentPageOffsetPercent,
//            child: new Container(
//              color: Color(0xff66ff99),
//              width: 200,
//              height: 200,
//              child: new Center(
//                child: Text(
//                    "fsajfhajsafhjskfkjsafjksafjkbasfjksjkbfsjkbfsjkbfsjabfksjfbsjabfsakjbfsjkabfkjabsfjbasjfbjk"),
//              ),
//            )));
//    return new Image.network(
//      url,
//      fit: BoxFit.scaleDown,
//    );
  }

  Future<Null> getHttp() async {
    try {
      Response<Map<String, Object>> response;
      response = await Dio().get("https://api.apiopen.top/recommendPoetry");
      if (response.statusCode != 200) {
        return print("response.statusCode" + response.statusCode.toString());
      }
      var data = response.data;
      print(data["code"]);
      if (data["code"] == 200) {
        setState(() {
          list.add(data["result"]);
          print(list);
        });
      }
    } catch (e) {
      return print(e);
    }
  }
}
