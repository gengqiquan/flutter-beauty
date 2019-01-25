import 'package:beauty/photo/PhotoDetailUI.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'MusicDetailUI.dart';

class MusicMainUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
        home: new Scaffold(
      appBar: new AppBar(
        title: const Text("音乐"),
      ),
      body: MusicList(),
    ));
  }
}

class MusicList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _MusicListState();
}

class _MusicListState extends State<MusicList> {
  Dio dio = new Dio();
  List list = new List();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new RefreshIndicator(
        onRefresh: () => getHttp(),
        child: new ListView.builder(
          shrinkWrap: true,
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index) {
            Map item = list[index];
            return new GestureDetector(
                child: new Hero(
                    tag: item["url"],
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
                              child: new Image.network(
                                item["pic"],
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            new Column(
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
                                  item["time"].toString(),
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 14),
                                ),
                                new Flexible(
                                  child: new Container(),
                                  flex: 1,
                                ),
                                new Text(
                                  item["singer"],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 15),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    )),
                onTap: () {
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) => new MusicDetailUI(info: item)));
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
