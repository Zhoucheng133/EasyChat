import 'dart:io';

import 'package:easy_chat/pages/login.dart';
import 'package:easy_chat/variables/user_var.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:window_manager/window_manager.dart';

class MainWindow extends StatefulWidget {
  const MainWindow({super.key});

  @override
  State<MainWindow> createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow> with WindowListener {
  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    u.init();
  }

  bool isMax=false;
  final UserVar u=Get.put(UserVar());

  @override
  void onWindowMaximize() {
    setState(() {
      isMax=true;
    });
    super.onWindowMaximize();
  }

  @override
  void onWindowUnmaximize() {
    setState(() {
      isMax=false;
    });
    super.onWindowUnmaximize();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 30,
          color: Colors.transparent,
          child: Row(
            children: [
              Expanded(child: DragToMoveArea(child: Container())),
              Platform.isWindows ? Row(
                children: [
                  WindowCaptionButton.minimize(onPressed: () => windowManager.minimize(),),
                  isMax ? WindowCaptionButton.unmaximize(onPressed:() => windowManager.unmaximize(),) :
                  WindowCaptionButton.maximize(onPressed: () => windowManager.maximize(),),
                  WindowCaptionButton.close(onPressed: () => windowManager.close(),)
                ],
              ) : Container()
            ],
          ),
        ),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Obx(()=>
              u.loading.value ? Center(
                child: LoadingAnimationWidget.beat(
                  color: Colors.yellow[700]!, 
                  size: 30
                ),
              ) : u.url.value.isEmpty ? const Login() : Container()
            ),
          )
        )
      ],
    );
  }
}