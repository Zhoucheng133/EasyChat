import 'package:get/get.dart';

enum PageType{
  none,
  chat,
  settings
}

class PageItem{
  int? index;
  late PageType type;
  PageItem(this.index, this.type);
}

class PageVar extends GetxController{
  Rx<PageItem> page=PageItem(null, PageType.none).obs;
}