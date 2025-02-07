import 'package:easy_chat/components/side_bar_item.dart';
import 'package:easy_chat/variables/chat_var.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {

  final ChatVar c=Get.put(ChatVar());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SideBarHeader(),
          const SizedBox(height: 5,),
          Expanded(
            child: Obx(()=>
              ListView.builder(
                itemCount: c.chatList.length,
                itemBuilder: (context, int index)=>SideBarItem(index: index),
              )
            )
          ),
          const SizedBox(height: 5,),
          const SideBarBottom()
        ],
      ),
    );
  }
}