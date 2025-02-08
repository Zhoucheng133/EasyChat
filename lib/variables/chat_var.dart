import 'package:easy_chat/funcs/requests.dart';
import 'package:easy_chat/variables/page_var.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class ChatMessage{
  late String role;
  late String content;
  ChatMessage(this.role, this.content);
}

class ChatItem{
  late String id;
  late String? name;
  late String? model;
  late List<ChatMessage> messages;
  ChatItem(this.id, this.name, this.model, this.messages);
}

class ChatVar extends GetxController{
  RxList<ChatItem> chatList=<ChatItem>[].obs;
  RxList<ModelItem> models=<ModelItem>[].obs;

  var uuid = const Uuid();

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