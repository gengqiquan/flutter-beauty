import 'package:beauty/funny/FunnyListUI.dart';
import 'package:beauty/photo/GirlListUI.dart';
import 'package:beauty/news/NewsListUI.dart';
import 'package:flutter/material.dart';

class HomeBuilder {
  static Widget homeDrawer(BuildContext context) {
    return new ListView(padding: const EdgeInsets.only(), children: <Widget>[
      _drawerHeader(),
      new ClipRect(
        child: new ListTile(
          leading: new CircleAvatar(child: new Icon(Icons.book)),
          title: new Text('新闻'),
          onTap: () {
            Navigator.of(context).push(
                new MaterialPageRoute(builder: (context) => new NewsListUI()));
          },
        ),
      ),   new ClipRect(
        child: new ListTile(
          leading: new CircleAvatar(child: new Icon(Icons.photo)),
          title: new Text('福利'),
          onTap: () {
            Navigator.of(context).push(
                new MaterialPageRoute(builder: (context) => new GirlListUI()));
          },
        ),
      ),
      new ListTile(
        leading: new CircleAvatar(child: new Icon(Icons.link)),
        title: new Text('内涵段子'),
        onTap: () {
          Navigator.of(context).push(
              new MaterialPageRoute(builder: (context) => new FunnyListUI()));
        },
      ),
      new AboutListTile(
        icon: new CircleAvatar(child: new Icon(Icons.person)),
        child: new Text("关于"),
        applicationName: "Beauty",
        applicationVersion: "1.0",
        applicationIcon: new Image.asset(
          "assets/ic_girl_header.jpeg",
          width: 64.0,
          height: 64.0,
        ),
        applicationLegalese: "gengqiquan",
//        aboutBoxChildren: <Widget>[
//          new Text("BoxChildren"),
//          new Text("box child 2")
//        ],
      ),
    ]);
  }

  static Widget _drawerHeader() {
    return new UserAccountsDrawerHeader(
//      margin: EdgeInsets.zero,
      accountName: new Text(
        "gengqiquan",
//        style: HStyle.titleNav(),
      ),
      accountEmail: new Text(
        "gengqiquan@foxmail.com",
//        style: HStyle.bodyWhite(),
      ),
      currentAccountPicture: new CircleAvatar(
        backgroundImage: new AssetImage("assets/ic_girl_header.jpeg"),
      ),
      onDetailsPressed: () {},
    );
  }
}

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Beauty',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new GirlListUI(),
    );
  }
}
