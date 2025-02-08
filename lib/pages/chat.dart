import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_chat/variables/chat_var.dart';
import 'package:easy_chat/variables/page_var.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  bool hasFocus=false;

  String? selectedModel;

  @override
  void initState() {
    super.initState();
    input.addListener((){
      setState(() {
        hasFocus=input.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    input.dispose();
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
                      }
                    },
                  )
                ),
              ),
            ) : Container()
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
                  color: hasFocus ? Colors.amber[300]! : Colors.grey[300]!,
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
                      ),
                    ),
                    IconButton(
                      onPressed: c.noModel() ? null : (){
                        // TODO Send!
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