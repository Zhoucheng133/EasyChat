import 'package:easy_chat/funcs/requests.dart';
import 'package:easy_chat/variables/chat_item.dart';
import 'package:easy_chat/variables/page_var.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';


class ChatVar extends GetxController{
  RxList<ChatItem> chatList=<ChatItem>[].obs;
  RxList<ModelItem> models=<ModelItem>[].obs;

  var uuid = const Uuid();

  bool noModel(){
    final PageVar p=Get.find();
    return chatList[p.page.value.index??0].model==null;
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