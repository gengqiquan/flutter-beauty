import 'package:beauty/photo/PhotoDetailUI.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'MusicDetailUI.dart';
import 'package:beauty/main.dart';
import 'dart:ui';

class MusicMainUI extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _MusicListState();
}

class _MusicListState extends State<MusicMainUI> {
  Dio dio = new Dio();
  List list = new List();

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
      appBar: new AppBar(
        title: new Text("音乐"),
      ),
//      appBar: new PreferredSize(
//        child: new Container(
//          height: 48,
//          margin: EdgeInsets.only(
//              top: MediaQueryData.fromWindow(window).padding.top),
//          child: searchBar(),
//        ),
//        preferredSize: Size(double.infinity,
//            48 + MediaQueryData.fromWindow(window).padding.top),
//      ),
      drawer: new Drawer(
        child: HomeBuilder.homeDrawer(context),
      ),
      body: musicList(),
    ));
  }

  Widget searchBar() {
    return new TextField(
//      textAlign: TextAlign.center,
      decoration: new InputDecoration(
        prefixIcon: new Icon(Icons.search),
        hintText: "请输入歌名",
//        prefixText: "请输入歌名:",
        prefix: new Icon(Icons.search),
      ),
    );
  }

  Widget musicList() {
    return new RefreshIndicator(
        onRefresh: () => getHttp(),
        child: new ListView.builder(
          shrinkWrap: true,
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index) {
            Map item = list[index];
            return new InkWell(
                child: new Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  margin: EdgeInsets.only(bottom: 15),
                  child: new SizedBox(
                    height: 100,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new AspectRatio(
                            aspectRatio: 1,
                            child: new Hero(
                              tag: item["url"],
                              child: new Image.network(
                                item["pic"],
                                fit: BoxFit.fitWidth,
                              ),
                            )),
                        new Container(
                          width: 15,
                        ),
                        new Flexible(
                          flex: 1,
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
//                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              new Text(
                                item["name"],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18),
                              ),
                              new Container(
                                height: 10,
                              ),
                              new Text(
                                item["singer"],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 15),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) =>
                          new MusicDetailUI(list: list, index: index)));
                });
          },
          addAutomaticKeepAlives: false,
        ));
  }

  var page = 0;

  Future<Null> getHttp({bool refresh: true}) async {
    if (refresh) {
      page = 0;
    }
    try {
      Response response;
      response = await Dio().get(
          "https://api.bzqll.com/music/netease/songList?key=579621905&id=3778678&limit=10&offset=${page}");
      if (response.statusCode != 200) {
        return print("response.statusCode" + response.statusCode.toString());
      }
      Map res = response.data;
      print(res);
      if (res["code"] == 200) {
        Map data = res["data"];
        setState(() {
          list = data["songs"];
        });
      }

      print(list);
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
