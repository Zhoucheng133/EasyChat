import 'dart:convert';

import 'package:easy_chat/variables/user_var.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ChatMessage{
  late String role;
  late String content;
  ChatMessage(this.role, this.content);

  Map toMap(){
    return {
      "role": role,
      "content": content,
    };
  }
}

class ChatItem{
  late String id;
  late String? name;
  late String? model;
  late List<ChatMessage> messages;
  ChatItem(this.id, this.name, this.model, this.messages);

  List<Map> toMap(){
    List<Map> ls=[];
    for (var element in messages) {
      ls.add(element.toMap());
    }
    return ls;
  }

  Future<void> doChat(String content) async {
    if(model==null){
      return;
    }
    final UserVar u=Get.find();
    messages.add(ChatMessage("user", content));
    // print('${u.url.value}/v1/chat/completions');
    final request = http.Request('POST', Uri.parse('${u.url.value}/v1/chat/completions'));
    final requestBody={
      "model": model,
      "messages": toMap(),
      "temperature": 0.7, 
      "max_tokens": -1,
      "stream": true
    };
    // print(requestBody);
    request.headers.addAll({
      "Content-Type": "application/json",
    });
    request.body = jsonEncode(requestBody);
    final response = await http.Client().send(request);
    response.stream
    .transform(utf8.decoder)
    .transform(const LineSplitter())
    .listen((line) {
      // print(line);
      try {
        Map data=jsonDecode(line.substring(5));
        // print(data['choices']['delta']['content']);
        print(data['choices'][0]['delta']['content']);
      } catch (_) {}
    }, onDone: () {
      // TODO 结束
    }, onError: (error) {});
  }
}