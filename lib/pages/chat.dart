import 'dart:async';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_chat/variables/chat_item.dart';
import 'package:easy_chat/variables/chat_var.dart';
import 'package:easy_chat/variables/page_var.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gpt_markdown/gpt_markdown.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  final ChatVar c=Get.find();
  final PageVar p=Get.find();
  final FocusNode input=FocusNode();
  final TextEditingController controller=TextEditingController();
  late Worker loadingListener;
  final ScrollController listController=ScrollController();
  bool hasFocus=false;
  late Timer timer;

  String? selectedModel;

  void scrollBottom(){
    try {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        listController.animateTo(listController.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      });
    } catch (_) {}
  }

  @override
  void initState() {
    super.initState();
    input.addListener((){
      setState(() {
        hasFocus=input.hasFocus;
      });
    });
    loadingListener=ever(c.loading, (val){
      if(val){
        scrollBottom();
        timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          scrollBottom();
        });
      }else{
        scrollBottom();
        try {
          timer.cancel();
        } catch (_) {}
      }
    });
  }

  @override
  void dispose() {
    input.dispose();
    loadingListener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Obx(()=>
            c.noModel() ? Center(
              child: SizedBox(
                width: 300,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    dropdownStyleData: const DropdownStyleData(
                      decoration: BoxDecoration(
                        color: Colors.white
                      )
                    ),
                    buttonStyleData: ButtonStyleData(
                      padding: const EdgeInsets.only(right: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.black26,
                        ),
                      ),
                    ),
                    isExpanded: true,
                    hint: Text(
                      '选择模型',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).hintColor,
                      )
                    ),
                    items: c.models.map((item) => DropdownMenuItem(
                        value: item.id,
                        child: Text(
                          item.id,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      )
                    ).toList(),
                    value: selectedModel,
                    onChanged: (value){
                      if(value!=null){
                        setState((){
                          selectedModel=value;
                        });
                        c.chatList[p.page.value.index??0].model=selectedModel;
                        setState(() {
                          selectedModel=null;
                        });
                      }
                    },
                  )
                ),
              ),
            ) : Padding(
              padding: const EdgeInsets.all(10),
              child: Scrollbar(
                controller: listController,
                child: ListView.builder(
                  controller: listController,
                  itemCount: c.chatList[c.nowIndex()].messages.length,
                  itemBuilder: (context, index)=>Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: Container(
                      decoration: BoxDecoration(
                        color: c.chatList[c.nowIndex()].messages[index].role==RoleEnum.user ? Colors.amber[700] : Colors.grey[50],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: SelectionArea(
                          child: GptMarkdown(
                            c.chatList[c.nowIndex()].messages[index].content,
                            style: TextStyle(
                              color: c.chatList[c.nowIndex()].messages[index].role==RoleEnum.user ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          )
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: SizedBox(
            height: 45,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: hasFocus ? Colors.amber : Colors.grey[300]!,
                  width: hasFocus ? 2 : 1
                )
              ),
              child: Obx(()=>
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        focusNode: input,
                        enabled: !c.noModel(),
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(borderSide: BorderSide.none),
                          hintText: c.noModel() ? '没有选择模型' : ''
                        ),
                        autocorrect: false,
                        enableSuggestions: false,
                        style: const TextStyle(
                          fontSize: 14
                        ),
                        onEditingComplete: (){
                          if(controller.text.isNotEmpty && !c.loading.value){
                            c.doChat(controller.text);
                            setState(() {
                              controller.text="";
                            });
                          }
                        },
                      ),
                    ),
                    c.loading.value ? IconButton(
                      onPressed: ()=>c.abort(),
                      icon: const Icon(
                        Icons.stop_rounded,
                        size: 20,
                      )
                    ) : IconButton(
                      onPressed: c.noModel() ? null : (){
                        if(controller.text.isEmpty){
                          return;
                        }
                        c.doChat(controller.text);
                        setState(() {
                          controller.text="";
                        });
                      }, 
                      icon: const Icon(
                        Icons.send_rounded,
                        size: 20,
                      )
                    ),
                    const SizedBox(width: 5,),
                  ],
                ),
              )
            ),
          ),
        )
      ],
    );
  }
}