import 'dart:async';

import 'package:flutter/services.dart';

class ObsHw {
  static const MethodChannel _channel =
      const MethodChannel('obs_hw');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> upImage(String bety) async {
    if(bety?.length!=0) {
      Map data = {};
      data['ak'] = "QU2IWSMAGGOSGCMRFL3N";
      data['sk'] = "7XVFSsKc5o18eP5sOSsSumrFKdPwubiFw2ZPZgun";
      data['endPoint'] = "https://obs.cn-east-3.myhuaweicloud.com";
      data['bucketName'] = "sijie";
      data['bucketDomain'] = "sijie.obs.cn-east-3.myhuaweicloud.com";
      data['data'] = bety;
      data['key'] = "key";
      final String url = await _channel.invokeMethod('upImage', data);
      return url;
    }else{
      return "对象不能为空";
    }
  }

  static Future<List<String>> upImageList(List betyList) async {
    Iterable<Future<String>> upList = [];
    List<Future<String>> list = [];
    for (String bety in betyList) {
      list.add(upImage(bety));
    }
    upList = list;
    List<String> lists = await Future.wait(upList);
    return lists;
  }
}
