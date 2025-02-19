import 'dart:convert';

import 'package:easy_chat/funcs/dialogs.dart';
import 'package:easy_chat/funcs/requests.dart';
import 'package:easy_chat/variables/chat_item.dart';
import 'package:easy_chat/variables/page_var.dart';
import 'package:easy_chat/variables/settings_var.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';


class ChatVar extends GetxController{
  RxList<ChatItem> chatList=<ChatItem>[].obs;
  RxList<ModelItem> models=<ModelItem>[].obs;
  RxBool loading=false.obs;
  late SharedPreferences prefs;
  final SettingsVar s=Get.put(SettingsVar());
  final dialogs=Dialogs();

  Future<void> init() async {
    prefs=await SharedPreferences.getInstance();
    String? chat=prefs.getString("chat");
    if(chat!=null){
      chatList.value=List<ChatItem>.from(
        (jsonDecode(chat) as List).map((item) => ChatItem.fromString(item)),
      );
    }
  }

  void clearSave(){
    prefs.remove("chat");
  }

  void clearChatsHandler(){
    chatList.value=[];
    clearSave();
  }

  void clearChats(BuildContext context){
    dialogs.showCancelOk(context, "删除所有的对话", "这个操作不能撤销", ()=>clearChatsHandler());
  }

  void saveChats(){
    if(!s.saveChats.value){
      return;
    }
    String jsonString=jsonEncode(
      chatList.map((item)=>item.toMap()).toList()
    );
    prefs.setString("chat", jsonString);
  }

  var uuid = const Uuid();

  bool noModel(){
    return chatList[nowIndex()].model==null;
  }

  int nowIndex(){
    final PageVar p=Get.find();
    return p.page.value.index??0;
  }

  void abort(){
    if(loading.value){
      chatList[nowIndex()].abort((){
        loading.value=false;
        chatList.refresh();
      });
    }
  }

  void doChat(String content){
    if(chatList[nowIndex()].name==null){
      chatList[nowIndex()].name= content.length<20 ? content : content.substring(0, 20);
      chatList.refresh();
    }
    chatList[nowIndex()].doChat(content, (){
      chatList.refresh();
      if(!loading.value){
        loading.value=true;
      }
    }, (){
      saveChats();
      loading.value=false;
    });
  }

  Future<void> addChat(BuildContext context) async {
    models.value=await Requests().getModels();
    if(context.mounted && models.isEmpty){
      showDialog(
        context: context, 
        builder: (context)=>AlertDialog(
          title: const Text('无法添加对话'),
          content: const Text('没有可用的模型'),
          actions: [
            ElevatedButton(
              onPressed: ()=>Navigator.pop(context), 
              child: const Text('好的')
            )
          ],
        )
      );
    }else{
      final PageVar p=Get.find();
      final id=uuid.v4();
      chatList.insert(0, ChatItem(id, null, null, []));
      p.page.value=PageItem(0, PageType.chat);
    }
  }
}