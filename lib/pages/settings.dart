import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_chat/components/settings_item.dart';
import 'package:easy_chat/funcs/dialogs.dart';
import 'package:easy_chat/variables/chat_var.dart';
import 'package:easy_chat/variables/settings_var.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  final dialogs=Dialogs();
  final SettingsVar s=Get.find();
  final ChatVar c=Get.find();

  bool hoverAbout=false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                '设置',
                style: TextStyle(
                  color: Colors.amber[700],
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              )
            ],
          ),
          SettingsItem(
            label: '上下文长度', 
            item: Obx(()=>
              DropdownButton2(
                dropdownStyleData: const DropdownStyleData(
                  decoration: BoxDecoration(
                    color: Colors.white
                  )
                ),
                buttonStyleData: const ButtonStyleData(
                  height: 50,
                  padding: EdgeInsets.only(right: 14),
                ),
                isExpanded: true,
                value: s.contextLength.value,
                items: s.contextItems.map((item)=>DropdownMenuItem(
                  value: item as String,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  )
                )).toList(),
                onChanged: (val) async {
                  if(val!=null){
                    s.contextLength.value=val;
                    SharedPreferences prefs=await SharedPreferences.getInstance();
                    prefs.setString('contextLength', val);
                  }
                },
              )
            )
          ),
          // const SizedBox(height: 10,),
          SettingsItem(
            label: "保存所有对话", 
            item: Align(
              alignment: Alignment.centerLeft,
              child: Obx(()=>
                Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    splashRadius: 0,
                    activeTrackColor: Colors.amber[800],
                    value: s.saveChats.value, 
                    onChanged: (val){
                      s.saveChats.value=val;
                      c.clearSave();
                    }
                  ),
                )
              ),
            )
          ),
          Expanded(child: Container()),
          GestureDetector(
            onTap: ()=>dialogs.showAbout(context),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (_){
                setState(() {
                  hoverAbout=true;
                });
              },
              onExit: (_){
                setState(() {
                  hoverAbout=false;
                });
              },
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: GoogleFonts.notoSansSc(
                  color: hoverAbout ? Colors.amber[700] : Colors.black
                ),
                child: const Text("关于 EasyChat")
              ),
            ),
          ),
          const SizedBox(height: 20,),
        ],
      ),
    );
  }
}