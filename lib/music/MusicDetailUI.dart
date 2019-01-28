import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:beauty/widgets/SeekBar.dart';
import 'dart:ui';

///auther:gengqiquan
///date:2019/1/25
///description:MusicDetailUI

class MusicDetailUI extends StatefulWidget {
  final Map info;

  MusicDetailUI({@required this.info});

  @override
  State<StatefulWidget> createState() => new _MusicDetailUIState(info);
}

class _MusicDetailUIState extends State<MusicDetailUI>
    with TickerProviderStateMixin {
  final Map info;

  _MusicDetailUIState(this.info);

  AudioPlayer audioPlayer;

  var value = 0;
  AnimationController rotateController;
  CurvedAnimation rotateCurved;
  AnimationController swingController;
  CurvedAnimation swingCurved;

  @override
  void initState() {
    super.initState();

    AudioPlayer.logEnabled = true;
    audioPlayer = new AudioPlayer();

//    audioPlayer.durationHandler = (duration) {
//      print("total"+duration.inSeconds.toString());
//    };
//    audioPlayer.positionHandler = (duration) {
//      setState(() {
//        value = duration.inSeconds;
//        angle += 25 / 360.0;
//        print(value.toString());
//      });
//    };
    rotateController = new AnimationController(
        vsync: this,
        duration: const Duration(seconds: 15),
        animationBehavior: AnimationBehavior.preserve);
    rotateCurved =
        new CurvedAnimation(parent: rotateController, curve: Curves.linear);

    swingController = new AnimationController(
        lowerBound: 0.1,
        upperBound: 0.2,
        vsync: this,
        duration: const Duration(milliseconds: 500),
        animationBehavior: AnimationBehavior.preserve);
    swingCurved =
        new CurvedAnimation(parent: swingController, curve: Curves.linear);

    audioPlayer.play(info["url"],position: Duration(milliseconds: 50));
    swingController.forward();
    rotateController.repeat();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    audioPlayer.stop();
  }

  var isPlaying = true;
  var angle = 0.0;

  void replay() {
    setState(() {
      isPlaying = true;
      swingController.forward();
      rotateController.repeat();
      audioPlayer.resume();
    });
  }

  void pause() {
    setState(() {
      isPlaying = false;
      swingController.reverse();
      rotateController.stop();
      audioPlayer.pause();
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(info["name"]),
        ),
        body: new Stack(
          children: <Widget>[
            new Image.network(
              info["pic"],
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            BackdropFilter(
              filter: new ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: new Container(
                color: Colors.white.withOpacity(0.5),
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            new Column(
              children: <Widget>[
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
                                    child: new ClipOval(
                                        child: new Container(
                                      padding: EdgeInsets.all(40),
                                      color: Colors.black,
                                      child: new Stack(
                                        children: <Widget>[
                                          new ClipOval(
                                            child:
                                                new Image.network(info["pic"]),
                                          )
                                        ],
                                      ),
                                    )))),
                          ),
                        ),
                        new Positioned(
                            right: 0,
                            child: new RotationTransition(
                              turns: swingController,
                              alignment: Alignment.topLeft,
                              child: new Container(
                                width: 200,
                                height: 20,
                                color: Colors.white,
                              ),
                            ))
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(2.0))),
                      ),
                      progress: new Container(
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius:
                                BorderRadius.all(Radius.circular(2.0))),
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
                          audioPlayer.seek(new Duration(seconds: index.floor()));
                        });

//                    audioPlayer.play(info["url"],
//                        position: Duration(seconds: index.floor()));
                      },
                      onValueChangedStart: () {
//                        audioPlayer.stop();
                      },
                      onValueChangedEnd: () {
//                    audioPlayer.resume();
//                        audioPlayer.play(info["url"],
//                            position: Duration(seconds: value.floor()));
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
                      onTap: () {},
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
                      onTap: () {},
                    ),
                  ],
                ),
                new Container(
                  height: 15,
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
          ],
        ));
  }
}
