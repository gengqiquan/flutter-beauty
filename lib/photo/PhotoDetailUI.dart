import 'package:flutter/material.dart';

class PhotoDetailUI extends StatelessWidget {
  String url;

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
//        theme: new ThemeData.dark(),
        home: new Scaffold(
          appBar: new AppBar(
            title: const Text('Tabbed AppBar'),
          ),
          body: new Hero(
              tag: url,
              child: new Image.network(
                url,
                fit: BoxFit.scaleDown,
              )),
        ));
  }

  PhotoDetailUI({Key key, @required this.url}) : super(key: key);
}
