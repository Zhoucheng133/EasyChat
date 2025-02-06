import 'package:get/get.dart';

class ChatMessage{
  late String role;
  late String content;
  ChatMessage(this.role, this.content);
}

class ChatItem{
  late String id;
  late String name;
  late List<ChatMessage> messages;
  ChatItem(this.id, this.name, this.messages);
}

class ChatVar extends GetxController{
  // RxList<ChatList> chatList=<ChatList>[].obs;
  RxList<ChatItem> chatList=<ChatItem>[
    ChatItem("123", "测试一个非常长的标题测试一个非常长的标题", []),
    ChatItem("124", "测试1", []),
    ChatItem("125", "测试1", []),
    ChatItem("126", "测试1", []),
    ChatItem("127", "测试1", []),
  ].obs;
}