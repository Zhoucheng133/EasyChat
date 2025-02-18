import 'dart:io';

import 'package:easy_chat/funcs/dialogs.dart';
import 'package:easy_chat/pages/home.dart';
import 'package:easy_chat/pages/login.dart';
import 'package:easy_chat/variables/chat_var.dart';
import 'package:easy_chat/variables/page_var.dart';
import 'package:easy_chat/variables/settings_var.dart';
import 'package:easy_chat/variables/user_var.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      u.init(context);
      c.init();
    });
  }

  bool isMax=false;
  final UserVar u=Get.put(UserVar());
  final ChatVar c=Get.put(ChatVar());
  final PageVar p=Get.put(PageVar());
  final SettingsVar s=Get.put(SettingsVar());
  final Dialogs dialogs=Dialogs();

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
          child: Obx(()=>
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: u.loading.value ? Center(
                key: const Key("loading"),
                child: LoadingAnimationWidget.beat(
                  color: Colors.yellow[700]!, 
                  size: 30
                ),
              ) : u.url.value.isEmpty ? const Login(key: Key("login"),) : const Home(key: Key("main"),)
            )
          )
        ),
        Platform.isMacOS ? Obx(()=>
          PlatformMenuBar(
            menus: [
              PlatformMenu(
                label: 'EasyChat', 
                menus: [
                  PlatformMenuItemGroup(
                    members: [
                      PlatformMenuItem(
                        label: "关于 EasyChat",
                        onSelected: (){
                          dialogs.showAbout(context);
                        }
                      ),
                      PlatformMenuItemGroup(
                        members: [
                          PlatformMenuItem(
                            label: "设置...",
                            shortcut: const SingleActivator(
                              LogicalKeyboardKey.comma,
                              meta: true,
                            ),
                            onSelected: u.url.value.isNotEmpty ? (){
                              p.page.value=PageItem(null, PageType.settings);
                            } : null,
                          ),
                        ]
                      ),
                      const PlatformMenuItemGroup(
                        members: [
                          PlatformProvidedMenuItem(
                            enabled: true,
                            type: PlatformProvidedMenuItemType.hide,
                          ),
                          PlatformProvidedMenuItem(
                            enabled: true,
                            type: PlatformProvidedMenuItemType.quit,
                          ),
                        ]
                      )
                    ]
                  ),
                ]
              ),
              PlatformMenu(
                label: '编辑', 
                menus: [
                  PlatformMenuItem(
                    label: "复制",
                    shortcut: const SingleActivator(
                      LogicalKeyboardKey.keyC,
                      meta: true
                    ),
                    onSelected: (){

                    }
                  ),
                  PlatformMenuItem(
                    label: "粘贴",
                    shortcut: const SingleActivator(
                      LogicalKeyboardKey.keyV,
                      meta: true
                    ),
                    onSelected: (){

                    }
                  ),
                  PlatformMenuItem(
                    label: "全选",
                    shortcut: const SingleActivator(
                      LogicalKeyboardKey.keyA,
                      meta: true
                    ),
                    onSelected: (){

                    }
                  ),
                ]
              ),
              const PlatformMenu(
                label: "窗口", 
                menus: [
                  PlatformMenuItemGroup(
                    members: [
                      PlatformProvidedMenuItem(
                        enabled: true,
                        type: PlatformProvidedMenuItemType.minimizeWindow,
                      ),
                      PlatformProvidedMenuItem(
                        enabled: true,
                        type: PlatformProvidedMenuItemType.toggleFullScreen,
                      )
                    ]
                  )
                ]
              )
            ]
          )
        ) : Container()
      ],
    );
  }
}