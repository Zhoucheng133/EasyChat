import 'package:easy_chat/funcs/dialogs.dart';
import 'package:easy_chat/variables/chat_var.dart';
import 'package:easy_chat/variables/page_var.dart';
import 'package:easy_chat/variables/user_var.dart';
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

enum ChatMenuItem{
  del,
  rename
}

class _SideBarItemState extends State<SideBarItem> {

  final ChatVar c=Get.find();
  final PageVar p=Get.find();
  final Dialogs dialogs=Dialogs();
  bool onHover=false;

  void showRenameDialog(BuildContext context, int index){
    final controller=TextEditingController();
    showDialog(
      context: context, 
      builder: (BuildContext context)=>AlertDialog(
        title: const Text('重命名'),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) => SizedBox(
            width: 200,
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                isCollapsed: true,
                contentPadding: const EdgeInsets.all(12),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[300]!, width: 1.0),
                  borderRadius: BorderRadius.circular(10)
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.amber, width: 2.0),
                  borderRadius: BorderRadius.circular(10)
                ),
                hintText: '输入新的对话名称',
                hintStyle: TextStyle(
                  color: Colors.grey[300]
                )
              ),
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: ()=>Navigator.pop(context), 
            child: const Text('取消')
          ),
          ElevatedButton(
            onPressed: (){
              if(controller.text.isNotEmpty){
                c.chatList[index].name=controller.text;
                c.chatList.refresh();
                c.saveChats();
                Navigator.pop(context);
              }else{
                dialogs.showErr(context, '重命名失败', '对话名称不能为空');
              }
            }, 
            child: const Text('完成')
          )
        ]
      ),
    );
  }

  void delChatHandler(int index){
    if(index==p.page.value.index){
      p.page.value=PageItem(null, PageType.none);
    }
    c.chatList.removeAt(index);
    c.saveChats();
  }

  Future<void> showChatMenu(BuildContext context, TapDownDetails details, int index) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final Offset position = overlay.localToGlobal(details.globalPosition);
    final val=await showMenu(
      context: context, 
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx + 50,
        position.dy + 50,
      ), 
      color: Colors.white,
      items: [
        const PopupMenuItem(
          value: ChatMenuItem.rename,
          height: 35,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.edit_rounded,
                size: 18,
              ),
              SizedBox(width: 5,),
              Text("重命名")
            ],
          ),
        ),
        const PopupMenuItem(
          value: ChatMenuItem.del,
          height: 35,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.delete_rounded,
                size: 18,
              ),
              SizedBox(width: 5,),
              Text("删除")
            ],
          ),
        ),
      ],
    );
    if(val==ChatMenuItem.rename){
      if(context.mounted){
        showRenameDialog(context, index);
      }
    }else if(val==ChatMenuItem.del){
      if(context.mounted){
        dialogs.showCancelOk(context, '确定要删除这个对话吗', '这个操作无法撤销', ()=>delChatHandler(index));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        p.page.value=PageItem(widget.index, PageType.chat);
      },
      onSecondaryTapDown: (val)=>showChatMenu(context, val, widget.index),
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
              color: p.page.value.index==widget.index ? const Color.fromRGBO(255, 236, 179, 1) : onHover ? const Color.fromRGBO(255, 236, 179, 0.5) : const Color.fromRGBO(255, 236, 179, 0),
              borderRadius: BorderRadius.circular(5)
            ),
            child: Obx(()=>
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    c.chatList[widget.index].name??"未命名的对话",
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

class SideBarBottom extends StatefulWidget {
  const SideBarBottom({super.key});

  @override
  State<SideBarBottom> createState() => _SideBarBottomState();
}

class _SideBarBottomState extends State<SideBarBottom> {

  bool hoverSettings=false;
  bool hoverExit=false;
  final PageVar p=Get.find();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: (){
              p.page.value=PageItem(null, PageType.settings);
            },
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (_){
                setState(() {
                  hoverSettings=true;
                });
              },
              onExit: (_){
                setState(() {
                  hoverSettings=false;
                });
              },
              child: Obx(()=>
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 35,
                  decoration: BoxDecoration(
                    color: p.page.value.type==PageType.settings ? const Color.fromRGBO(255, 236, 179, 1) : hoverSettings ? const Color.fromRGBO(255, 236, 179, 0.5) : const Color.fromRGBO(255, 236, 179, 0),
                    borderRadius: BorderRadius.circular(5)
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.settings_rounded,
                      size: 16,
                    ),
                  ),
                ),
              )
            ),
          )
        ),
        const SizedBox(width: 10,),
        Expanded(
          child: GestureDetector(
            onTap: (){
              showDialog(
                context: context, 
                builder: (context)=>AlertDialog(
                  title: const Text('退出当前连接'),
                  content: const Text('这会回到初始页面'),
                  actions: [
                    TextButton(onPressed: ()=>Navigator.pop(context), child: const Text('取消')),
                    ElevatedButton(
                      onPressed: (){
                        final UserVar u=Get.find();
                        u.url.value='';
                        Navigator.pop(context);
                      }, 
                      child: const Text('继续')
                    )
                  ],
                )
              );
            },
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (_){
                setState(() {
                  hoverExit=true;
                });
              },
              onExit: (_){
                setState(() {
                  hoverExit=false;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 35,
                decoration: BoxDecoration(
                  color: hoverExit ? const Color.fromRGBO(255, 236, 179, 0.5) : const Color.fromRGBO(255, 236, 179, 0),
                  borderRadius: BorderRadius.circular(5)
                ),
                child: const Center(
                  child: Icon(
                    Icons.logout_rounded,
                    size: 16,
                  ),
                ),
              ),
            ),
          )
        )
      ],
    );
  }
}