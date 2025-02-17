import 'dart:async';
import 'dart:convert';

import 'package:easy_chat/variables/settings_var.dart';
import 'package:easy_chat/variables/user_var.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

enum RoleEnum{
  user,
  bot,
}

class ChatMessage{
  late RoleEnum role;
  late String content;
  ChatMessage(this.role, this.content);

  Map toMap(){
    return {
      "role": role==RoleEnum.bot?"assistant":"user",
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

  StreamSubscription<String>? subscription;
  
  final SettingsVar s=Get.put(SettingsVar());

  List<Map> toMap(){
    List<Map> ls=[];
    for (var element in messages) {
      ls.add(element.toMap());
    }
    if (ls.length > int.parse(s.contextLength.value)) {
      return ls.sublist(ls.length - int.parse(s.contextLength.value));
    }
    return ls;
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
      "messages": toMap(),
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
            messages.add(ChatMessage(RoleEnum.bot, text));
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