import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:beauty/main.dart';
import 'package:beauty/news/NewsDetailUI.dart';

class NewsListUI extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _NewsListState();
}

class _NewsListState extends State<NewsListUI> {
  _NewsListState();

  List<Choice> choices = <Choice>[
    Choice('头条', "toutiao"),
    Choice('科技', "tech"),
    Choice('汽车', "auto"),
    Choice('财经', "money"),
    Choice('体育', "sports"),
    Choice('军事', "war"),
    Choice('娱乐', "ent"),
    Choice('个性推荐', "dy"),
  ];

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new DefaultTabController(
        length: choices.length,
        child: new Scaffold(
          appBar: new AppBar(
            title: const Text('新闻'),
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

  void getHttp() async {
    try {
      Response<Map<String, Object>> response;
      response = await Dio().get("https://www.apiopen.top/journalismApi");
      if (response.statusCode != 200) {
        return print("response.statusCode" + response.statusCode.toString());
      }
      var data = response.data;
      print(data["code"]);
      if (data["code"] == 200) {
        Map map = data["data"];
        setState(() {
          for (var value in choices) {
            value.list = map[value.type];
            value.list.removeWhere((item) => item["title"] == null);
            print(value.list);
          }
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
}

class Choice {
  Choice(this.title, this.type);

  final String title;
  final String type;
  List list = new List();
}

class ChoiceCard extends StatefulWidget {
  const ChoiceCard({Key key, this.choice}) : super(key: key);

  final Choice choice;

  @override
  State<StatefulWidget> createState() => new _CounterState(choice);
}

class _CounterState extends State<ChoiceCard> {
  _CounterState(this.choice);

  Dio dio = new Dio();
  final Choice choice;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new ListView.builder(
      shrinkWrap: true,
      itemCount: choice.list.length,
      itemBuilder: (BuildContext context, int index) {
        Map item=choice.list[index];
        return new GestureDetector(
            child: buildItem(item),
            onTap: () {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (context) => new NewsWebPage()));
            });
      },
      addAutomaticKeepAlives: false,
    );
  }

  Widget buildItem(item) {
    return new Card(
        child: new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Container(
          padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: new Text(
            item["title"],
            textAlign: TextAlign.start,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87),
          ),
        ),
        new Container(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: buildContent(item)),
        new Container(
          padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: new Row(
            children: <Widget>[
              new Offstage(
                offstage: item["isTop"] == null,
                child: new Container(
                    padding: EdgeInsets.only(right: 10),
                    child: new Text(
                      "热点",
                      style: new TextStyle(color: Colors.red),
                    )),
              ),
              new Text(
                item["source"] != null ? item["source"] : "",
                style: new TextStyle(color: Colors.grey),
              ),
              new Container(
                width: 15,
              ),
              new Text(
                item["tcount"].toString() + " 浏览",
                style: new TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    ));
  }

  Widget buildContent(item) {
    print(item);
    int imgsrc3gtype = item["imgsrc3gtype"];
//    if(imgsrc3gtype==1){
    List pic = item["picInfo"];
    if (pic != null && pic.isNotEmpty) {
      Map first = pic.firstWhere((item) => item["url"] != null);
      if (first != null) {
        return image(first["url"]);
      }
    }
//    }
    return new Container(
        padding: EdgeInsets.only(top: 15, bottom: 15),
        child: new Text(
          item["digest"] + "...",
          style: new TextStyle(color: Colors.black87),
        ));
  }

  Widget image(String text) {
    return new SizedBox(
        width: double.infinity,
        child: new AspectRatio(
          aspectRatio: 3 / 2,
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

  @override
  void deactivate() {}
}
