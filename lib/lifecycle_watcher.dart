import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LifecycleWatcher extends StatefulWidget {
  @override
  _LifecycleWatcherState createState() => new _LifecycleWatcherState();
}

class _LifecycleWatcherState extends State<LifecycleWatcher>
    with WidgetsBindingObserver {
  AppLifecycleState _lastLifecyleState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _lastLifecyleState = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("LifecycleWatcher"),
        ),
        body: _getBody());
  }

  _getBody() {
    if (_lastLifecyleState == null)
      return MyText('This widget has not observed any lifecycle changes.');
    return new MyText(
        'The most recent lifecycle state this widget observed was: $_lastLifecyleState.');
  }
}

class MyText extends StatelessWidget {
  String _msg;

  MyText(this._msg);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
            _msg,
            textAlign: TextAlign.left,
            maxLines: 6,
            overflow: TextOverflow.ellipsis,
            // 显示不完，就在后面显示点点
            style: TextStyle(
              fontSize: 20.0, // 文字大小
              color: Colors.pink, // 文字颜色
            ),
            textDirection: TextDirection.ltr));
  }
}
