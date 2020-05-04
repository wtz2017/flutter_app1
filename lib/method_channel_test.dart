import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MethodChannelTest extends StatefulWidget {
  MethodChannelTestState createState() => MethodChannelTestState();
}

class MethodChannelTestState extends State<MethodChannelTest> {
  static const PLATFORM_CHANNEL = const MethodChannel('com.test.flutter_app1/battery');
  static const PLATFORM_METHOD_NAME = "getBatteryLevel";

  String _batteryLevel = 'Unknown battery level.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MethodChannelTest'),
      ),
      body: _getBody(),
    );
  }

  _getBody() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          RaisedButton(
            child: Text('Get Battery Level'),
            onPressed: _getBatteryLevel,
          ),
          Text(_batteryLevel),
        ],
      ),
    );
  }

  Future<Null> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await PLATFORM_CHANNEL.invokeMethod(PLATFORM_METHOD_NAME);
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }
}
