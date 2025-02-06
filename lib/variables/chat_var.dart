import 'package:get/get.dart';

class ChatMessage{
  late String role;
  late String content;
  ChatMessage(this.role, this.content);
}

class ChatList{
  late String id;
  late List<ChatMessage> messages;
  ChatList(this.id, this.messages);
}

class ChatVar extends GetxController{
  RxList<ChatList> chatList=<ChatList>[].obs;
}