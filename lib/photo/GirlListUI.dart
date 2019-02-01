import 'dart:convert';

import 'package:beauty/main.dart';
import 'package:beauty/photo/PhotoDetailUI.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class GirlListUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new DefaultTabController(
        length: choices.length,
        child: new Scaffold(
          appBar: new AppBar(
            title: const Text('福利'),
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
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: '全部'),
  const Choice(title: '小清新'),
  const Choice(title: '写真'),
  const Choice(title: '气质'),
  const Choice(title: '嫩萝莉'),
  const Choice(title: '清纯'),
  const Choice(title: '长发'),
  const Choice(title: '可爱'),
  const Choice(title: '素颜'),
  const Choice(title: '甜素纯'),
  const Choice(title: '不忍直视'),
  const Choice(title: '宅男女神'),
  const Choice(title: '诱惑'),
  const Choice(title: '诱人'),
  const Choice(title: '性感蕾丝'),
  const Choice(title: '日本'),
  const Choice(title: '日韩'),
  const Choice(title: '唯美'),
  const Choice(title: '长腿'),
  const Choice(title: '清凉'),
  const Choice(title: '夏装'),
  const Choice(title: '性感'),
  const Choice(title: '大胸'),
  const Choice(title: '爆乳'),
  const Choice(title: '短裙'),
  const Choice(title: '丰满'),
  const Choice(title: '内衣'),
];

class ChoiceCard extends StatefulWidget {
  const ChoiceCard({Key key, this.choice}) : super(key: key);

  final Choice choice;

//  @override
//  Widget build(BuildContext context) {
//    final TextStyle textStyle = Theme.of(context).textTheme.display1;
//    return new Card(
//      color: Colors.white,
//      child: new Center(
//        child: new Column(
//          mainAxisSize: MainAxisSize.min,
//          crossAxisAlignment: CrossAxisAlignment.center,
//          children: <Widget>[
//            new Icon(choice.icon, size: 128.0, color: textStyle.color),
//            new Text(choice.title, style: textStyle),
//          ],
//        ),
//      ),
//    );
//  }

  @override
  State<StatefulWidget> createState() => new _CounterState(choice);
}

class _CounterState extends State<ChoiceCard> {
  _CounterState(this.choice);

  Dio dio = new Dio();
  List<String> imgs = new List();
  int count = 20;
  final Choice choice;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new RefreshIndicator(
        onRefresh: () => getHttp(),
        child: new StaggeredGridView.countBuilder(
          controller: _scrollController,
//          gridDelegate:
//              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          crossAxisCount: 4,
          shrinkWrap: true,
          itemCount: imgs.length + 1,
          itemBuilder: (BuildContext context, int index) =>
              index == imgs.length ? buildFoot() : buidlItem(context, index),
          staggeredTileBuilder: (int index) =>
              new StaggeredTile.count(2, index.isEven ? 2 : 3),
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          addAutomaticKeepAlives: false,
        ));
  }

  buildFoot() {
    return new Container(
        alignment: Alignment.center, child: new CupertinoActivityIndicator());
  }

  buidlItem(BuildContext context, int index) {
    return new GestureDetector(
        child: new Hero(
            tag: imgs[index],
            child: Image.network(
              imgs[index],
              fit: BoxFit.fitWidth,
            )),
        onTap: () {
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (context) => new PhotoDetailUI(
                    urls: imgs,
                    index: index,
                  )));
        });
  }

  var page = 0;

  Future<Null> getHttp({bool refresh: true}) async {
    if (refresh) {
      imgs.clear();
      page = 0;
    }
    try {
      print(page.toString());
      Response response;
      response = await Dio().get(
          "http://image.baidu.com/channel/listjson?pn=${page}&rn=${count}&tag1=美女&tag2=${choice.title}&ie=utf8&hd=1");
      if (response.statusCode != 200) {
        return print("response.statusCode" + response.statusCode.toString());
      }
      Map data = JsonCodec().decode(response.data);
//      print(data);
      List list = data["data"];
      print(list);
      page += count;
      setState(() {
        for (var value in list) {
//        Map img = JsonCodec().decode(value);
          String url = value["image_url"];
          if (url != null) {
            imgs.add(value["image_url"]);
          }
        }
      });

//      print(imgs);
    } catch (e) {
      return print(e);
    }
  }

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print("more");
        getHttp(refresh: false);
      }
    });
    getHttp();
    super.initState();
  }

  @override
  void deactivate() {}
}
