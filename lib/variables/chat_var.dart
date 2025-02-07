import 'package:dropdown_button2/dropdown_button2.dart';
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
  late String model;
  late List<ChatMessage> messages;
  ChatItem(this.id, this.name, this.model, this.messages);
}

class ChatVar extends GetxController{
  RxList<ChatItem> chatList=<ChatItem>[].obs;

  var uuid = const Uuid();

  Future<void> addChat(BuildContext context) async {
    final data=await Requests().getModels();
    // print(data);
    String? selected;
    if(context.mounted && data.isNotEmpty){
      showDialog(
        context: context, 
        builder: (context)=>AlertDialog(
          title: const Text('添加对话'),
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
                if(selected==null){
                  showDialog(
                    context: context, 
                    builder: (context)=>AlertDialog(
                      title: const Text('无法添加对话'),
                      content: const Text('没有选择模型'),
                      actions: [
                        ElevatedButton(
                          onPressed: ()=>Navigator.pop(context), 
                          child: const Text('好的')
                        )
                      ],
                    )
                  );
                }else if(selected!=null){
                  final id=uuid.v4();
                  chatList.add(ChatItem(id, null, selected!, []));
                  final PageVar p=Get.find();
                  p.page.value=PageItem(id, PageType.chat);
                  Navigator.pop(context);
                }
              }, 
              child: const Text('添加')
            )
          ],
        )
      );
    }else if(context.mounted && data.isEmpty){
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
    }
  }
}