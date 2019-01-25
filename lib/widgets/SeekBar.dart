import 'package:flutter/material.dart';

/// SeekBar build on two [SizedBox] .
class SeekBar extends StatefulWidget {
  /// The width of the SeekBar. @required
  final double width;

  /// The height of the SeekBar. @required
  final double height;

  /// The minimum value of the SeekBar.
  ///
  /// Defaults to 0.0 .
  final int min;

  /// The maximum value of the SeekBar.
  ///
  /// Defaults to 10.0 .
  final int max;

  /// The step by which the SeekBar's value is incremented.
  ///
  /// Defaults to 1.0 .
//  final double step;

  /// The initial value of the SeekBar.
  ///
  /// Defaults to [min] - [step].
  int value;

  /// The initial value of the seek radius.
  ///
  /// Defaults to Math.min(width ,height) ].
  final double radius;

  /// The sensitivity of the SeekBar's edges in pixels.
  ///
  /// A value of 5.0 means that when the SeekBar is less than 5 pixels away
  /// from the top or bottom, it will snap to it. Defaults to 0.0 .
//  final double accuracy;

  /// The child [Widget] of the fixed [SizedBox].
  ///
  /// Use this to change the appearance of the SeekBar. Defaults to h a grey [Container].
  final Widget bar;

  /// The child [Widget] of the fixed [SizedBox].
  ///
  /// Use this to change the appearance of the SeekBar. Defaults to h a red [Container].
  final Widget progress;

  /// The child [Widget] of the moving [SizedBox].
  ///
  /// Use this to change the appearance of the SeekBar. Defaults to a
  /// [SizedBox] with a red [ClipOval].
  final Widget seek;

  /// The function called when the value of the SeekBar changes.
  /// Passes the new value as a parameter.
  final void Function(double) onValueChanged;

  SeekBar({
    Key key,
    @required this.height,
    @required this.width,
    this.onValueChanged,
    this.max: 100,
    this.min: 0,
    this.radius,
//    this.step,
//    this.accuracy,
    this.value: 0,
    this.bar,
    this.progress,
    this.seek,
  }) : super(key: key);

  _SeekBarState createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  double _length;
  double radius;
  Widget seek;
  Widget bar;
  bool isHorizontal = true;

  initState() {
    super.initState();
    isHorizontal = widget.width > widget.height;

    radius = widget.radius ?? (isHorizontal ? widget.height : widget.width);

    _length = isHorizontal ? widget.width : widget.height;
  }

  double _convertLength(int value) {
    return (widget.value - widget.min) * _length / (widget.max - widget.min) -
        radius;
  }

  double _convertValue(double current) {
    return (current + radius) * (widget.max - widget.min) / _length +
        widget.min;
  }

  void updateValue(double delta) {
    setState(() {
      var _current = _convertLength(widget.value);
      var now = _current + delta;
      if (now > _length - radius) {
        now = _length - radius;
      }
      if (now < -radius) {
        now = -radius;
      }
      if (_current != now) {
        var newVlaue = _convertValue(now).floor();
        widget.value = newVlaue;
        print("newVlaue:" + newVlaue.toString());
        widget.onValueChanged ?? (newVlaue);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
//      onTapUp: _onTapUp,
      onHorizontalDragUpdate: (dragDetails) {
        if (!isHorizontal) {
          return;
        }
        updateValue(dragDetails.delta.dx);
      },
      onVerticalDragUpdate: (dragDetails) {
        if (isHorizontal) {
          return;
        }
        updateValue(dragDetails.delta.dy);
      },
      child: Stack(
        alignment: isHorizontal
            ? AlignmentDirectional.centerStart
            : AlignmentDirectional.topCenter,
        children: <Widget>[
          _buildBar(),
          _buildProgress(),
          new Transform.translate(
            offset: Offset(isHorizontal ? _convertLength(widget.value) : 0,
                isHorizontal ? 0 : _convertLength(widget.value)),
            child: _buildSeek(),
          ),
        ],
      ),
    );
  }

  _buildSeek() {
    return widget.seek ??
        new SizedBox(
          width: 2 * radius,
          height: 2 * radius,
          child: new ClipOval(
            child: new Container(
              color: Colors.red,
            ),
          ),
        );
  }

  _buildBar() {
    return new SizedBox(
      width: widget.width,
      height: widget.height,
      child: widget.bar ??
          new Container(
            color: Colors.grey,
          ),
    );
  }

  _buildProgress() {
    return new SizedBox(
      width:
          isHorizontal ? _convertLength(widget.value) + radius : widget.width,
      height:
          isHorizontal ? widget.height : _convertLength(widget.value) + radius,
      child: widget.progress ??
          new Container(
            color: Colors.red,
          ),
    );
  }
}
