import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:obs_hw/obs_hw.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _platformVersion1 = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    String platformVersion1;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await ObsHw.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    try {      
      ByteData data = await rootBundle.load('assets/test.png');
      Image.memory(data.buffer.asUint8List());
      // File file = File.fromRawPath(data.buffer.asUint8List());
      String base = base64Encode(data.buffer.asUint8List());
      platformVersion1 = await ObsHw.upImage(base);
    } on PlatformException {
      platformVersion1 = 'Failed to get platform version.';
    }

    try {      
      ByteData data = await rootBundle.load('assets/test.png');
      Image.memory(data.buffer.asUint8List());
      String base = base64Encode(data.buffer.asUint8List());
      List<String> list = await ObsHw.upImageList([base,base]);
      print('---------------');
      print(list);
      print('---------------');
    } on PlatformException {
      print('上传多张失败');
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      _platformVersion1 = platformVersion1;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: <Widget>[
            Center(
              child:
                  Text('Running on: $_platformVersion\n' + _platformVersion1),
            ),
            
          ],
        ),
      ),
    );
  }
}
