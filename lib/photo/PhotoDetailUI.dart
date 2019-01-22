import 'package:flutter/material.dart';

class PhotoDetailUI extends StatelessWidget {
  String url;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('图片详情'),
        iconTheme: new IconThemeData(color: Colors.white),
      ),
      body: new Hero(
          tag: url,
          child: new Image.network(
            url,
            fit: BoxFit.scaleDown,
          )),
    );
  }

  PhotoDetailUI({Key key, @required this.url}) : super(key: key);
}
