import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:beauty/widgets/SeekBar.dart';
///auther:gengqiquan
///date:2019/1/25
///description:MusicDetailUI

class MusicDetailUI extends StatefulWidget {
  final Map info;

  MusicDetailUI({@required this.info});

  @override
  State<StatefulWidget> createState() => new _MusicDetailUIState(info);
}

class _MusicDetailUIState extends State<MusicDetailUI> {
  final Map info;

  _MusicDetailUIState(this.info);

  AudioPlayer audioPlayer = new AudioPlayer();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: const Text(""),
      ),
      body: new SeekBar(height: 500, width: 20,fixedBox: new Container(width: 40,height: 20,color: Colors.green,),),
    );
  }
}
