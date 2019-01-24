import 'package:flutter/material.dart';
import 'package:beauty/widgets/DragScaleView.dart';
import 'dart:ui';

class PhotoPreviewUI extends StatelessWidget {
  PhotoPreviewUI({Key key, @required this.url}) : super(key: key);
  final String url;

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        new Center(
          child: new DragScaleView(
              upperLimit: 3,
              child: new Hero(
                tag: url,
                child: Image.network(
                  url,
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                ),
              )),
        ),
        new SizedBox(
            height: 60,
            child: new AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              iconTheme: new IconThemeData(color: Colors.white),
            )),
      ],
    );
  }
}
