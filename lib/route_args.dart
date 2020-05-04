import 'package:flutter/material.dart';

class RouteArgs extends StatelessWidget {
  String receiveArgs;
  BuildContext context;

  @override
  Widget build(BuildContext context) {
    this.context = context;

    // 处理入参
    Map<String, String> args = ModalRoute.of(context).settings.arguments;
    receiveArgs = "receiveArgs-->";
    if (args != null) {
      args.forEach((k, v) {
        print("RouteArgs build get arguments map-->" + k + ":" + v);
        receiveArgs += (k + ":" + v);
      });
    } else {
      print("RouteArgs build get arguments --> null");
      receiveArgs += "null";
    }

    return new WillPopScope(
        child: new Scaffold(
          appBar: new AppBar(
            title: new Text('RouteArgs'),
          ),
          body: _getBody(),
        ),
        onWillPop: _requestPop);
  }

  // 页面即将返回上一页
  Future<bool> _requestPop() {
    print("RouteArgs _requestPop");
    // 返回传参
    Navigator.of(context).pop("RouteArgs poped value1");
    return new Future.value(false);
  }

  _getBody() {
    return Center(
      child: Text(receiveArgs),
    );
  }
}
