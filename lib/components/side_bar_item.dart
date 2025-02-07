import 'package:easy_chat/variables/chat_var.dart';
import 'package:easy_chat/variables/page_var.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SideBarHeader extends StatefulWidget {
  const SideBarHeader({super.key});

  @override
  State<SideBarHeader> createState() => _SideBarHeaderState();
}

class _SideBarHeaderState extends State<SideBarHeader> {

  bool onHover=false;
  final ChatVar c=Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  '列表',
                  style: TextStyle(
                    fontSize: 13
                  ),
                ),
              ),
            ),
            Tooltip(
              message: '添加',
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                onEnter: (_){
                  setState(() {
                    onHover=true;
                  });
                },
                onExit: (_){
                  setState(() {
                    onHover=false;
                  });
                },
                child: GestureDetector(
                  onTap: ()=>c.addChat(context),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: onHover ? const Color.fromRGBO(255, 236, 179, 0.4) : const Color.fromRGBO(255, 236, 179, 0),
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.add_rounded,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 5,),
        Container(
          color: Colors.amber[100],
          height: 2,
        )
      ],
    );
  }
}

class SideBarItem extends StatefulWidget {

  final int index;

  const SideBarItem({super.key, required this.index});

  @override
  State<SideBarItem> createState() => _SideBarItemState();
}

class _SideBarItemState extends State<SideBarItem> {

  final ChatVar c=Get.find();
  final PageVar p=Get.find();
  bool onHover=false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        p.page.value=PageItem(c.chatList[widget.index].id, PageType.chat);
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_){
          setState(() {
            onHover=true;
          });
        },
        onExit: (_){
          setState(() {
            onHover=false;
          });
        },
        child: Obx(()=>
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 35,
            decoration: BoxDecoration(
              color: p.page.value.id==c.chatList[widget.index].id ? const Color.fromRGBO(255, 236, 179, 1) : onHover ? const Color.fromRGBO(255, 236, 179, 0.4) : const Color.fromRGBO(255, 236, 179, 0),
              borderRadius: BorderRadius.circular(5)
            ),
            child: Obx(()=>
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    c.chatList[widget.index].name,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13
                    ),
                  ),
                ),
              )
            ),
          ),
        )
      ),
    );
  }
}