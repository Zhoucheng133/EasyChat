import 'package:get/get.dart';

enum PageType{
  none,
  chat,
  settings
}

class Page{
  late String id;
  late PageType type;
  Page(this.id, this.type);
}

class PageVar extends GetxController{
  Rx<Page> page=Page("", PageType.none).obs;
}