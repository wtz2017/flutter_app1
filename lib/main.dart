import 'package:flutter/material.dart';

import 'random_words.dart';
import 'http_isolate.dart';
import 'lifecycle_watcher.dart';
import 'route_args.dart';
import 'anim.dart';
import 'signature.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomePage(), // becomes the route named '/'
      routes: {
        RoutePages.ROUTE_ARGS: (context) => RouteArgs(),
        RoutePages.RANDOM_WORDS: (context) => RandomWords(),
        RoutePages.HTTP_ISOLATE: (context) => HttpIsolate(),
        RoutePages.LIFECYCLE_WATCHER: (context) => LifecycleWatcher(),
        RoutePages.ANIM: (context) => Anim(title: "Anim"),
        RoutePages.SIGNATURE: (context) => Signature(),
      },
    );
  }
}

class RoutePages {
  static const String ROUTE_ARGS = '/route_args_page';
  static const String RANDOM_WORDS = '/random_words_page';
  static const String HTTP_ISOLATE = '/http_isolate_page';
  static const String LIFECYCLE_WATCHER = '/lifecycle_watcher_page';
  static const String ANIM = '/anim_page';
  static const String SIGNATURE = '/signature_page';
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HomePage"),
      ),
      body: Center(
          child: Column(
        // row: 横向线性布局 Column: 纵向线性布局
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RouteButton(
              RoutePages.ROUTE_ARGS, RoutePages.ROUTE_ARGS, {'k1': 'v1'}),
          RouteButton(RoutePages.RANDOM_WORDS, RoutePages.RANDOM_WORDS, null),
          RouteButton(RoutePages.HTTP_ISOLATE, RoutePages.HTTP_ISOLATE, null),
          RouteButton(
              RoutePages.LIFECYCLE_WATCHER, RoutePages.LIFECYCLE_WATCHER, null),
          RouteButton(RoutePages.ANIM, RoutePages.ANIM, null),
          RouteButton(RoutePages.SIGNATURE, RoutePages.SIGNATURE, null),
        ],
      )),
    );
  }
}

class RouteButton extends StatelessWidget {
  String routeName;
  String showName;
  Map<String, String> args;

  RouteButton(this.routeName, this.showName, this.args);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // match parent to width
      child: RaisedButton(
        onPressed: () {
          _push(context);
        },
        child: Text(showName),
      ),
    );
  }

  void _push(BuildContext context) async {
    String popValues =
        await Navigator.pushNamed<dynamic>(context, routeName, arguments: args);
    if (popValues == null) {
      popValues = "null";
    }
    print("RouteButton get popValues-->" + popValues);
  }
}
