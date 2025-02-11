import 'package:easy_chat/funcs/dialogs.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  final dialogs=Dialogs();

  bool hoverAbout=false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
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
            style: TextStyle(
              color: hoverAbout ? Colors.amber[700] : Colors.black
            ),
            child: const Text("关于 EasyChat")
          ),
        ),
      ),
    );
  }
}