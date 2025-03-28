import 'dart:async';
import 'dart:convert';

import 'package:easy_chat/variables/settings_var.dart';
import 'package:easy_chat/variables/user_var.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

enum RoleEnum{
  user,
  assistant,
}

class ChatMessage{
  late RoleEnum role;
  late String content;
  ChatMessage(this.role, this.content);

  Map toMap(){
    return {
      "role": role.name,
      "content": content,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> data){
    return ChatMessage(
      data['role']=="user"?RoleEnum.user : RoleEnum.assistant,
      data['content'] as String,
    );
  }
}

class ChatItem{
  late String id;
  late String? name;
  late String? model;
  late List<ChatMessage> messages;
  ChatItem(this.id, this.name, this.model, this.messages);

  StreamSubscription<String>? subscription;
  
  final SettingsVar s=Get.find();

  List<Map> sendMsg(){
    if (messages.length > int.parse(s.contextLength.value)) {
      return messages.map((item)=>item.toMap()).toList().sublist(messages.length - int.parse(s.contextLength.value));
    }
    return messages.map((item)=>item.toMap()).toList();
  }

  Map toMap(){
    return {
      "id": id,
      "name": name??"",
      "model": model??"",
      "messages": messages.map((item)=>item.toMap()).toList()
    };
  }

  factory ChatItem.fromString(Map<String, dynamic> json){

    return ChatItem(
      json['id'] as String, 
      json['name'] as String?, 
      json['model'] as String?, 
      (json['messages'] as List).map((msgItem)=>ChatMessage.fromMap(msgItem as Map<String, dynamic>)).toList()
    );
  }

  void abort(Function abortOk){
    try {
      subscription?.cancel();
      abortOk();
    } catch (_) {}
  }

  Future<void> doChat(String content, Function updateCallback, Function updateOk) async {
    if(model==null){
      return;
    }
    final UserVar u=Get.find();
    messages.add(ChatMessage(RoleEnum.user, content));
    updateCallback();
    final request = http.Request('POST', Uri.parse('${u.url.value}/v1/chat/completions'));
    final requestBody={
      "model": model,
      "messages": sendMsg(),
      "temperature": 0.7, 
      "max_tokens": -1,
      "stream": true
    };
    request.headers.addAll({
      "Content-Type": "application/json",
    });
    request.body = jsonEncode(requestBody);
    final response = await http.Client().send(request);
    subscription=response.stream
    .transform(utf8.decoder)
    .transform(const LineSplitter())
    .listen((line) {
      try {
        Map data=jsonDecode(line.substring(5));
        if(data['choices'][0]['delta']['content']!=null){
          String text=data['choices'][0]['delta']['content'];
          if(messages.last.role==RoleEnum.user){
            messages.add(ChatMessage(RoleEnum.assistant, text));
          }else{
            messages[messages.length-1].content=messages[messages.length-1].content+text;
          }
          updateCallback();
        }
      } catch (_) {}
    }, onDone: () {
      updateOk();
    }, onError: (error) {});
  }
}