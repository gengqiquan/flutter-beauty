import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:beauty/photo/PhotoPreviewUI.dart';

class PhotoDetailUI extends StatefulWidget {
  PhotoDetailUI({Key key, @required this.urls, this.index: 0})
      : super(key: key);
  final List<String> urls;
  int index;

  @override
  State<StatefulWidget> createState() => new _PhotoDetailUIState(urls, index);
}

class _PhotoDetailUIState extends State<PhotoDetailUI> {
  final List<String> urls;
  final int index;

  _PhotoDetailUIState(this.urls, this.index);

  var width = MediaQueryData.fromWindow(window).size.width;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('图片详情'),
        iconTheme: new IconThemeData(color: Colors.white),
      ),
      body: new Container(
        child: new Hero(
            tag: urls[index],
            child: new PageView(
              controller: controller,
              children: urls.map((url) => getImg(url)).toList(),
            )),
      ),
    );
  }

  PageController controller;
  var pageOffset = 0.0;
  var forward = true;
  var lastOffset = 0.0;

  @override
  void initState() {
    super.initState();
    pageOffset = index * 1.0;
    controller = new PageController(initialPage: index);
    controller.addListener(() {
      setState(() {
        forward = controller.offset > lastOffset;
        pageOffset = controller.offset / width;
      });
    });
  }

  Widget getImg(String url) {
    var currentLeftPageIndex = pageOffset.floor();
    var currentPageOffsetPercent = pageOffset - currentLeftPageIndex;

    var position = urls.indexOf(url);
    return Transform.translate(
      offset: Offset((pageOffset - position) * width, 0),
      child: Transform.scale(
        scale: currentLeftPageIndex == position
            ? 1 - currentPageOffsetPercent
            : currentPageOffsetPercent,
        child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (context) => new PhotoPreviewUI(
                        url: url,
                      )));
            },
            child: Image.network(
              url,
              fit: BoxFit.scaleDown,
            )),
      ),
    );
//    return new Image.network(
//      url,
//      fit: BoxFit.scaleDown,
//    );
  }
}
