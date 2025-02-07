import 'dart:async';
import 'dart:convert';

import 'package:easy_chat/variables/user_var.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ModelItem {
  final String id;
  final String object;
  final String ownedBy;

  ModelItem({
    required this.id,
    required this.object,
    required this.ownedBy,
  });

  // 通过工厂构造函数从 Map 创建 ModelItem
  factory ModelItem.fromMap(Map<String, dynamic> map) {
    return ModelItem(
      id: map['id'] ?? '',
      object: map['object'] ?? '',
      ownedBy: map['owned_by'] ?? '',
    );
  }
}

class Requests {

  Future<Map<String, dynamic>> httpRequest(String url, {int timeoutInSeconds = 3}) async {
    try {
      final response = await http.get(Uri.parse(url)).timeout(Duration(seconds: timeoutInSeconds));

      if (response.statusCode == 200) {
        String responseBody = utf8.decode(response.bodyBytes);
        Map<String, dynamic> data = json.decode(responseBody);
        return data;
      } else {
        Map<String, dynamic> data = {};
        throw Exception(data);
      }
    } on TimeoutException {
      // 请求超时处理逻辑
      Map<String, dynamic> data = {};
      return data;
    } catch (error) {
      // 其他错误处理逻辑
      Map<String, dynamic> data = {};
      return data;
    }
  }

  Future<bool> checkUrl(String url) async {
    try {
      await http.get(Uri.parse("$url/v1/models"));
    } catch (_) {
      return false;
    }
    return true;
  }
  

  Future<List<ModelItem>> getModels() async {
  final UserVar u = Get.find();
  Map response = await httpRequest("${u.url.value}/v1/models");
  if (response.isNotEmpty) {
    try {
      var data = response['data'];
      if (data is List) {
        // 将每个元素转换为 ModelItem 实例
        List<ModelItem> modelItems = data
        .map((item) => ModelItem.fromMap(item as Map<String, dynamic>))
        .toList();
        return modelItems;
      }
    } catch (_) {}
  }
  return [];
}
}