import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:beauty/widgets/SeekBar.dart';
import 'dart:ui';

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

  @override
  void initState() {
    super.initState();
    info = _list[_index];
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

    audioPlayer.play(info["url"]);
    swingController.forward();
    rotateController.repeat();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
                    new Center(
                      child: new Container(
                        margin: EdgeInsets.all(40),
                        child: AspectRatio(
                            aspectRatio: 1,
                            child: new RotationTransition(
                              turns: rotateCurved,
                              child: new Stack(
                                children: <Widget>[
                                  new Image.asset("assets/ic_disc.png"),
                                  new Container(
                                      padding: EdgeInsets.all(47),
//                                      color: Colors.black,
                                      child: new ClipOval(
                                        child: new Image.network(info["pic"]),
                                      ))
                                ],
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
                onTap: () {
//                      if (audioPlayer.state == AudioPlayerState.PAUSED) {
//                        audioPlayer.resume();
//                      } else if (audioPlayer.state ==
//                          AudioPlayerState.PLAYING) {
//                        audioPlayer.pause();
//                      }
//                      controller.reverse();
                },
              ),
            ),
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
                new InkWell(
                  child: new Icon(
                    Icons.arrow_left,
                    color: Colors.white,
                    size: 50,
                  ),
                  onTap: () {
                    last();
                  },
                ),
                new InkWell(
                  child: new Icon(
                    !isPlaying ? Icons.play_circle_outline : Icons.pause,
                    color: Colors.white,
                    size: 50,
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
                  child: new Icon(
                    Icons.arrow_right,
                    color: Colors.white,
                    size: 50,
                  ),
                  onTap: () {
                    next();
                  },
                ),
              ],
            ),
            new Container(
              height: 15,
            ),
          ],
        ),
        new Positioned(
            top: MediaQueryData.fromWindow(window).padding.top + 33,
            left: MediaQueryData.fromWindow(window).size.width / 2 - 55,
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
            ))
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
      info = _list[_index];
      audioPlayer.play(info["url"]);
    });
  }

  last() {
    _index = --_index < 0 ? _list.length - 1 : _index;

    setState(() {
      if (audioPlayer.state != AudioPlayerState.COMPLETED) {
        audioPlayer.stop();
        audioPlayer.release();
      }
      info = _list[_index];
      audioPlayer.play(info["url"]);
    });
  }

  seek(double index) async {
    await audioPlayer.seek(new Duration(seconds: index.floor()));
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
