import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:beauty/widgets/SeekBar.dart';
import 'dart:ui';
import 'package:dio/dio.dart';

///auther:gengqiquan
///date:2019/1/25
///description:MusicDetailUI

class MusicDetailUI extends StatefulWidget {
  final List list;
  final int index;

  MusicDetailUI({@required this.list, this.index});

  @override
  State<StatefulWidget> createState() => new _MusicDetailUIState(list, index);
}

class _MusicDetailUIState extends State<MusicDetailUI>
    with TickerProviderStateMixin {
  Map info;
  final List _list;
  int _index;

  _MusicDetailUIState(this._list, this._index);

  AudioPlayer audioPlayer;

  var value = 0;
  AnimationController rotateController;
  CurvedAnimation rotateCurved;
  AnimationController swingController;
  CurvedAnimation swingCurved;

  var showLrc = false;

  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController();

    AudioPlayer.logEnabled = true;
    audioPlayer = new AudioPlayer();

//    audioPlayer.durationHandler = (duration) {
//      print("total"+duration.inSeconds.toString());
//    };
    audioPlayer.positionHandler = (duration) {
      setState(() {
        value = duration.inSeconds;
        angle += 25 / 360.0;
      });
      scrollLrc(duration);
    };
    rotateController = new AnimationController(
        vsync: this,
        duration: const Duration(seconds: 15),
        animationBehavior: AnimationBehavior.preserve);
    rotateCurved =
        new CurvedAnimation(parent: rotateController, curve: Curves.linear)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              setState(() {
                rotateController.repeat();
              });
            }
            print("Animation" + status.toString());
          });

    swingController = new AnimationController(
        lowerBound: -0.08,
        upperBound: 0.0,
        vsync: this,
        duration: const Duration(milliseconds: 200),
        animationBehavior: AnimationBehavior.preserve);
    swingCurved =
        new CurvedAnimation(parent: swingController, curve: Curves.linear);
    swingController.forward();
    rotateController.repeat();
    play();
  }

  @override
  void deactivate() {
    super.deactivate();
    audioPlayer.stop();
    audioPlayer.release();
  }

  var isPlaying = true;
  var angle = 0.0;

  void replay() {
    setState(() {
      isPlaying = true;
      swingController.forward();
      rotateController.forward();
      audioPlayer.resume();
    });
  }

  void pause() {
    setState(() {
      isPlaying = false;
      swingController.reverse();
      rotateController.stop(canceled: false);
      audioPlayer.pause();
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        body: new Stack(
      children: <Widget>[
        new Image.network(
          info["pic"],
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        BackdropFilter(
          filter: new ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: new Container(
            color: Colors.white.withOpacity(0),
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              height: MediaQueryData.fromWindow(window).padding.top,
            ),
            new Stack(
              fit: StackFit.passthrough,
              alignment: AlignmentDirectional.centerStart,
              children: <Widget>[
                new InkWell(
                  child: new Container(
                    height: 48,
                    width: 48,
                    child: new Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                new Center(
                  child: new Column(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Text(
                        info["name"],
                        style: new TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                      new Text(
                        info["singer"],
                        style: new TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                )
              ],
            ),
            new Divider(
              color: Colors.white,
              height: 0,
            ),
            new Flexible(
              flex: 1,
              child: new InkWell(
                child: new Stack(
                  children: <Widget>[
                    new Offstage(
                      offstage: showLrc,
                      child: new Container(
                        margin: EdgeInsets.fromLTRB(30, 95, 30, 0),
                        child: AspectRatio(
                            aspectRatio: 1,
                            child: new RotationTransition(
                              turns: rotateCurved,
                              child: new Stack(
                                children: <Widget>[
                                  new Container(
                                    margin: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: Colors.white10,
                                      border: Border.all(
                                          color: Colors.white54, width: 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(200)),
                                    ),
                                  ),
                                  new Container(
                                      padding: EdgeInsets.all(10),
//                                      color: Colors.black,
                                      child: new Image.asset(
                                          "assets/ic_disc.png")),
                                  new Container(
                                      padding: EdgeInsets.all(57),
//                                      color: Colors.black,
                                      child: new ClipOval(
                                        child: new Image.network(info["pic"]),
                                      ))
                                ],
                              ),
                            )),
                      ),
                    ),
                    new Container(
                      padding: EdgeInsets.only(bottom: 130),
                      child: new Offstage(
                        offstage: !showLrc,
                        child: buildLic(),
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  setState(() {
                    showLrc = !showLrc;
                  });
                },
              ),
            ),
          ],
        ),
        new Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: new Column(children: <Widget>[
              new Container(
                  margin: EdgeInsets.all(15),
                  child: new SeekBar(
                    height: 4,
                    width: MediaQueryData.fromWindow(window).size.width - 30,
                    max: info["time"],
                    value: value,
                    radius: 10,
                    bar: new Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(2.0))),
                    ),
                    progress: new Container(
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(2.0))),
                    ),
                    seek: new ClipOval(
                      child: Container(
                        color: Colors.white,
                        child: new Center(
                          child: new ClipOval(
                            child: new Container(
                              color: Colors.red,
                              width: 4,
                              height: 4,
                            ),
                          ),
                        ),
                      ),
                    ),
                    onValueChanged: (index) {
                      print(index.toString());
                      setState(() {
                        seek(index);
                      });

//                    audioPlayer.play(info["url"],
//                        position: Duration(seconds: index.floor()));
                    },
                    onValueChangedStart: () {
                      audioPlayer.pause();
                    },
                    onValueChangedEnd: () {
                      audioPlayer.resume();
                    },
                  )),
              new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    width: 50,
                  ),
                  new InkWell(
                    child: new Image.asset(
                      "assets/ic_last.png",
                      color: Colors.white,
                      width: 70,
                      height: 70,
                    ),
                    onTap: () {
                      last();
                    },
                  ),
                  new InkWell(
                    child: new Image.asset(
                      isPlaying ? "assets/ic_pause.png" : "assets/ic_play.png",
                      color: Colors.white,
                      width: 70,
                      height: 70,
                    ),
                    onTap: () {
                      if (isPlaying) {
                        pause();
                      } else {
                        replay();
                      }
                    },
                  ),
                  new InkWell(
                    child: new Image.asset(
                      "assets/ic_next.png",
                      color: Colors.white,
                      width: 70,
                      height: 70,
                    ),
                    onTap: () {
                      next();
                    },
                  ),
                  Container(
                    width: 50,
                  ),
                ],
              )
            ])),
        new Positioned(
            top: MediaQueryData.fromWindow(window).padding.top + 33,
            left: MediaQueryData.fromWindow(window).size.width / 2 - 55,
            child: new Offstage(
                offstage: showLrc,
                child: new ClipRect(
                  clipper: _MyClipper(),
                  child: new RotationTransition(
                    alignment: Alignment(-0.378, -0.83),
                    turns: swingController,
                    child: new Image.asset(
                      "assets/ic_needle.png",
                      width: 170,
                      height: 170,
                    ),
                  ),
                )))
      ],
    ));
  }

  next() {
    _index = (_index + 1) % _list.length;
    setState(() {
      if (audioPlayer.state != AudioPlayerState.COMPLETED) {
        audioPlayer.stop();
        audioPlayer.release();
      }
      play();
    });
  }

  last() {
    _index = --_index < 0 ? _list.length - 1 : _index;

    setState(() {
      if (audioPlayer.state != AudioPlayerState.COMPLETED) {
        audioPlayer.stop();
        audioPlayer.release();
      }
      play();
    });
  }

  play() {
    info = _list[_index];
    audioPlayer.play(info["url"]);
    lrcUrl = info["lrc"];
    lrcs.clear();
    getHttp();
  }

  seek(double index) async {
    await audioPlayer.seek(new Duration(seconds: index.floor()));
  }

  List<Lrc> lrcs = new List<Lrc>();
  String lrcUrl;
  double _offset = 0;
  ScrollController _scrollController;

  final double _LRC_ITEM_HEIGHT = 30;

  Widget buildLic() {
    return SlideTransition(
      child: ListView.builder(
//      padding: EdgeInsets.only(top: baseLine>_offset?baseLine-_offset:0),
          controller: _scrollController,
          itemCount: lrcs.length,
          itemBuilder: (context, index) {
            return new Container(
                height: _LRC_ITEM_HEIGHT,
                child: new Text(
                  lrcs[index].lrc,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: lastLine == index ? Colors.white : Colors.white30,
                  ),
                ));
          }),
    );
  }

  Future<Null> getHttp() async {
    try {
      Response response;
      response = await new Dio()
          .get(lrcUrl, options: new Options(responseType: ResponseType.PLAIN));
      if (response.statusCode != 200) {
        return print("response.statusCode" + response.statusCode.toString());
      }
      String data = response.data;
//      print(response);
      List<String> list = data.split("\n");
      print(list);

      setState(() {
        list.forEach((item) {
          List a = item.toString().split("\]");
          if (a.length == 2 && a[1] != "") {
            print(a);
            List times = a[0].toString().replaceAll("[", "").split(":");

            var s = double.parse(times[1]);
            var d = Duration(
                minutes: int.parse(times[0]),
                seconds: s.floor(),
                milliseconds: ((s % 1) * 1000).floor());
            lrcs.add(new Lrc(a[1], d));
          } else if (a[0].toString().startsWith("[by:")) {
            lrcs.add(new Lrc(
                a[0].toString().replaceAll("[", "").replaceAll("]", ""),
                new Duration()));
          }
        });
//        _scrollController.animateTo(300,
//            duration: new Duration(milliseconds: 300), curve: Curves.ease);
//        print(lrcs);
      });
    } catch (e) {
      return print(e);
    }
  }

  int lastLine = 0;
  var baseLine = MediaQueryData.fromWindow(window).size.height / 3;

  void scrollLrc(Duration duration) {
    int p = duration.inMilliseconds;
    var line = lrcs.lastIndexWhere((lrc) {
      var time = lrc.duration.inMilliseconds;
      return p > time;
    });
    print(p.toString() + ":" + lrcs[line].duration.inMilliseconds.toString());
    if (line != lastLine) {
      setState(() {
        lastLine = line;
        _offset = lastLine * _LRC_ITEM_HEIGHT;

//        if (_offset > baseLine) {
        _scrollController.animateTo(_offset,
            duration: new Duration(milliseconds: 300), curve: Curves.ease);
//        }
      });
    }
  }
}

class Lrc {
  final String lrc;

  Lrc(this.lrc, this.duration);

  final Duration duration;

  @override
  String toString() {
    return 'Lrc{lrc: $lrc}';
  }
}

class _MyClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return new Rect.fromLTRB(0, 15.0, size.width + 20, size.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}
