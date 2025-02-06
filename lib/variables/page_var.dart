import 'package:get/get.dart';

enum PageType{
  none,
  chat,
  settings
}

class PageItem{
  late String id;
  late PageType type;
  PageItem(this.id, this.type);
}

class PageVar extends GetxController{
  Rx<PageItem> page=PageItem("", PageType.none).obs;
}