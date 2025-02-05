import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserVar extends GetxController{
  RxString url="".obs;
  RxBool loading=true.obs;

  Future<void> init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? getUrl = prefs.getString('url');
    if(getUrl!=null){
      // TODO 登录
    }else{
      loading.value=false;
    }
  }
}