import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_chat/funcs/requests.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatMessage{
  late String role;
  late String content;
  ChatMessage(this.role, this.content);
}

class ChatItem{
  late String id;
  late String name;
  late String model;
  late List<ChatMessage> messages;
  ChatItem(this.id, this.name, this.model, this.messages);
}

class ChatVar extends GetxController{
  // RxList<ChatList> chatList=<ChatList>[].obs;
  RxList<ChatItem> chatList=<ChatItem>[].obs;

  Future<void> addChat(BuildContext context) async {
    final data=await Requests().getModels();
    // print(data);
    String selected=data[0].id;

    if(context.mounted){
      showDialog(
        context: context, 
        builder: (context)=>AlertDialog(
          title: const Text('添加聊天'),
          content: StatefulBuilder(
            builder: (context, setState) => DropdownButtonHideUnderline(
              child: DropdownButton2(
                isExpanded: true,
                hint: Text(
                  '选择模型',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).hintColor,
                  )
                ),
                items: data.map((item) => DropdownMenuItem(
                    value: item.id,
                    child: Text(
                      item.id,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  )
                ).toList(),
                value: selected,
                onChanged: (value){
                  if(value!=null){
                    setState((){
                      selected=value;
                    });
                  }
                },
              )
            )
          ),
          actions: [
            TextButton(
              onPressed: ()=>Navigator.pop(context), 
              child: const Text('取消')
            ),
            ElevatedButton(
              onPressed: (){

              }, 
              child: const Text('添加')
            )
          ],
        )
      );
    }
  }
}