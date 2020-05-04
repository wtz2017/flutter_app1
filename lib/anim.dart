import 'package:flutter/material.dart';

class Anim extends StatefulWidget {
  Anim({Key key, this.title}) : super(key: key);
  final String title;

  @override
  AnimState createState() => new AnimState();
}

class AnimState extends State<Anim> with TickerProviderStateMixin {
  AnimationController controller;
  CurvedAnimation curve;
  bool isForward = false;

  @override
  void initState() {
    controller = new AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    /// [CurvedAnimation] is useful when you want to apply a non-linear [Curve] to
    /// an animation object, especially if you want different curves when the
    /// animation is going forward vs when it is going backward.
    curve = new CurvedAnimation(parent: controller, curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
          child: new Container(
              child: new FadeTransition(
                  opacity: curve,
                  // The animation that controls the opacity of the child.
                  child: new FlutterLogo(
                    size: 100.0,
                  )))),
      floatingActionButton: new FloatingActionButton(
        tooltip: 'Fade',
        child: new Icon(Icons.brush),
        onPressed: () {
          isForward = !isForward;
          if (isForward) {
            controller.forward();
          } else {
            controller.reverse();
          }
        },
      ),
    );
  }
}
