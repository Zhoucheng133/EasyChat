import 'dart:io';

import 'package:flutter/material.dart';
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
  }

  bool isMax=false;

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
              Platform.isMacOS ? Row(
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
        Expanded(child: Container())
      ],
    );
  }
}