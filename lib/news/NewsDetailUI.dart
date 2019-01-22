import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsDetailUI extends StatelessWidget {
  String url;

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
//        theme: new ThemeData.dark(),
        home: new Scaffold(
            appBar: new AppBar(
              title: const Text('Tabbed AppBar'),
            ),
            body: new WebView(
              initialUrl: url,
            )));
  }

  NewsDetailUI({Key key, @required this.url}) : super(key: key);
}
