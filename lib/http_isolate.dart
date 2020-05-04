import 'dart:isolate';
import 'dart:convert'; // for json

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HttpIsolate extends StatefulWidget {
  HttpIsolate({Key key}) : super(key: key);

  @override
  _HttpIsolateState createState() => new _HttpIsolateState();
}

class _HttpIsolateState extends State<HttpIsolate> {
  List widgets = [];

  @override
  void initState() {
    super.initState();

    loadData();
  }

  shouldShowLoading() {
    if (widgets.length == 0) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("HttpAppPage"),
        ),
        body: getBody());
  }

  getBody() {
    if (shouldShowLoading()) {
      return getProgressDialog();
    } else {
      return getListView();
    }
  }

  getProgressDialog() {
    return new Center(child: new CircularProgressIndicator());
  }

  ListView getListView() => new ListView.builder(
      itemCount: widgets.length,
      itemBuilder: (BuildContext context, int position) {
        return getRow(position);
      });

  Widget getRow(int i) {
    return new Padding(
        padding: new EdgeInsets.all(10.0),
        child: new Text("Row ${widgets[i]["title"]}"));
  }

  loadData() async {
    ReceivePort receiveOncePort = new ReceivePort();
    // 通过 spawn 新建一个 Isolate，并绑定静态回调方法和传递通信 port
    await Isolate.spawn(dataLoader, receiveOncePort.sendPort);

    // The 'echo' isolate sends it's SendPort as the first message
    // 'first' method: Stops listening to this stream after the first element has been received.
    // Internally the method cancels its subscription after the first element.
    // 获取到 Isolate 线程中的 SendPort
    SendPort dataLoaderSendPort = await receiveOncePort.first;

    List msg = await sendReceive(
        dataLoaderSendPort, "https://jsonplaceholder.typicode.com/posts");

    setState(() {
      widgets = msg;
    });
  }

  // the entry point for the isolate
  static dataLoader(SendPort externalSendPort) async {
    // Open the ReceivePort for incoming messages.
    // TODO ReceivePort 只能本地接收用，线程隔离把 SendPort 发给别人用来发消息给自己
    ReceivePort localReceivePort = new ReceivePort();

    // Notify any other isolates what port this isolate listens to.
    // 我的理解，SendPort 就像是一个监听器，send 方法就是 callback 方法；
    // 通过 SendPort.send(...) 来回调外部的 ReceivePort
    // 下边一句就是把本地监听发给外部监听，两边相互监听
    externalSendPort.send(localReceivePort.sendPort);

    // 等待外部通过 localReceivePort.sendPort 发消息过来
    await for (var msg in localReceivePort) {
      SendPort responseSendPort = msg[0];
      String dataURL = msg[1];

      http.Response response = await http.get(dataURL);
      // Lots of JSON to parse
      // TODO 目前 externalSendPort 把本地接收端口发给外边后，使命就结束了，外边使用的是 first
      // TODO 为何要新用一个 responseSendPort 回调数据？复用 externalSendPort 不行吗？
      responseSendPort.send(json.decode(response.body));
    }
  }

  // 创建一个通用的发送和接收方法
  Future sendReceive(SendPort sendPort, msg) {
    print("sendReceive msg-->" + msg);
    ReceivePort response = new ReceivePort();
    sendPort.send([response.sendPort, msg]);
    return response.first;
  }
}
