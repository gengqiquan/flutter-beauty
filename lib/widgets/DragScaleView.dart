import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'dart:ui';

class DragScaleView extends StatefulWidget {
  const DragScaleView(
      {Key key,
      @required this.child,
      this.lowerLimit = 1,
      this.upperLimit = 3,
      this.delayLevel = 10.0})
      : assert(child != null),
        super(key: key);
  final Widget child;

  ///最小缩小限制
  final num lowerLimit;

  ///最大放大限制
  final num upperLimit;

  ///  动作维度拉长系数，值越大，放大缩小的动作越慢
  final double delayLevel;

  @override
  State<StatefulWidget> createState() =>
      new _DragScaleState(child, lowerLimit, upperLimit, delayLevel);
}

class _DragScaleState extends State<DragScaleView>
    with SingleTickerProviderStateMixin {
  Offset offset = Offset.zero;
  double x = 0.0;
  Offset lastOffset;
  double lastScale = 1.0;
  final Widget child;
  final num lowerLimit;
  final num upperLimit;
  final double delayLevel;
  AnimationController controller;
  Animation<Offset> animation;
  double minFlingVelocity = 600.0;

  _DragScaleState(
      this.child, this.lowerLimit, this.upperLimit, this.delayLevel);

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this);
    controller.addListener(() {
      setState(() {
        offset = animation.value;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  Offset _clampOffset(Offset offset) {
    final Size size = context.size;
    // widget的屏幕宽度
    final Offset minOffset =
        Offset(size.width, size.height) * (1.0 - lastScale);
    // 限制他的最小尺寸
    return Offset(
        offset.dx.clamp(minOffset.dx, 0.0), offset.dy.clamp(minOffset.dy, 0.0));
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
        onScaleStart: (scaleStart) {
          setState(() {
            lastOffset = (scaleStart.focalPoint - offset) / lastScale;
            // 计算图片放大后的位置
            controller.stop();
          });
        },
        onScaleUpdate: (scaleUpdate) {
          setState(() {
            //动作维度拉长，caleUpdate.scale 的值是按两指移动距离计算的，值变动跨度太大。这里做系数缩放
            var delayScale = scaleUpdate.scale;
            if (delayScale > 1) {
              //正向缩小系数
              delayScale = 0.1 * delayScale / delayLevel + 1;
            } else {
              delayScale = 1 - (1 - delayScale) / delayLevel; //取差缩小系数
            }
            // 限制放大倍数
            lastScale = (lastScale * delayScale).clamp(lowerLimit, upperLimit);
            //调整位置,保证中心点不变
            offset =
                _clampOffset(scaleUpdate.focalPoint - lastOffset * lastScale);
          });
        },
        onScaleEnd: (scaleEnd) {
          final double magnitude = scaleEnd.velocity.pixelsPerSecond.distance;
          if (magnitude < minFlingVelocity) return;
          final Offset direction =
              scaleEnd.velocity.pixelsPerSecond / magnitude;
          // 计算当前的方向
          final double distance = (Offset.zero & context.size).shortestSide;
          // 计算放大倍数，并相应的放大宽和高，宽和高是同时变化的
          animation = controller.drive(Tween<Offset>(
              begin: offset, end: _clampOffset(offset + direction * distance)));
          controller
            ..value = 0.0
            ..fling(velocity: magnitude / 1000.0);
        },
        child: new Transform(
          transform: Matrix4.identity()
            ..translate(offset.dx, offset.dy)
            ..scale(lastScale),
          child: child,
        ));
  }
}
