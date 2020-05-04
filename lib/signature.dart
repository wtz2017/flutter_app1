import 'package:flutter/material.dart';

class Signature extends StatefulWidget {
  SignatureState createState() => new SignatureState();
}

/// TODO 现在有问题：setState 时不回调 paint() 方法
class SignatureState extends State<Signature> {
  List<Offset> _points = <Offset>[];

  Widget build(BuildContext context) {
    print("SignatureState build"); //TODO TEST
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Signature"),
        ),
//        body: getBody1());//TODO TEST
        body: getBody2());
  }

  getBody1() {
    return new GestureDetector(
      onTap: () {
        print("onTap");
      },
      onPanUpdate: (DragUpdateDetails details) {
        print("onPanUpdate");
        setState(() {
          RenderBox referenceBox = context.findRenderObject();
          Offset localPosition =
              referenceBox.globalToLocal(details.globalPosition);
          _points = new List.from(_points)..add(localPosition);
        });
      },
      onPanEnd: (DragEndDetails details) {
        print("onPanEnd");
        _points.add(null);
      },
//      child: new CustomPaint(painter: new SignaturePainter(_points)),
      child: new CustomPaint(
          size: Size.infinite, painter: new SignaturePainter(_points)),
    );
  }

  getBody2() {
    print("SignatureState getBody2");
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            print("onTap");
          },
          onPanUpdate: (DragUpdateDetails details) {
            print("onPanUpdate");
            setState(() {
              RenderBox referenceBox = context.findRenderObject();
              Offset localPosition =
                  referenceBox.globalToLocal(details.globalPosition);
              _points = new List.from(_points)..add(localPosition);
            });
          },
          onPanEnd: (DragEndDetails details) {
            print("onPanEnd");
            _points.add(null);
          },
        ),
        CustomPaint(painter: SignaturePainter(_points)),
      ],
    );
  }
}

class SignaturePainter extends CustomPainter {
  final List<Offset> points;

  SignaturePainter(this.points);

  //  bool shouldRepaint(SignaturePainter other) => other.points != points;
  bool shouldRepaint(SignaturePainter other) => true; // TODO TSET

  void paint(Canvas canvas, Size size) {
    print("SignaturePainter on paint...points length=" +
        (points != null ? points.length : "0"));
    var paint = new Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null)
        canvas.drawLine(points[i], points[i + 1], paint);
    }
  }
}
