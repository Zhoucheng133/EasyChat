import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsVar extends GetxController{

  Future<void> init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final length=prefs.getString("contextLength");
    if(length!=null){
      contextLength.value=length;
    }
  }

  RxString contextLength="50".obs;
  List contextItems=[
    '10', '20', '30', '40', '50'
  ];
  RxBool saveChats=true.obs;
}