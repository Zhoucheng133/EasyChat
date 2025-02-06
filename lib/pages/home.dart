import 'package:easy_chat/components/side_bar.dart';
import 'package:easy_chat/pages/chat.dart';
import 'package:easy_chat/pages/settings.dart';
import 'package:easy_chat/variables/page_var.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final p=Get.put(PageVar());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Row(
        children: [
          const SizedBox(
            width: 150,
            child: SideBar(),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Obx(()=>
                p.page.value.type==PageType.none ? Container() : 
                p.page.value.type==PageType.settings ? const Settings() :
                const Chat()
              ),
            )
          )
        ],
      ),
    );
  }
}