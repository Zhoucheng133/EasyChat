import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserVar extends GetxController{
  RxString url="".obs;
  RxBool loading=true.obs;

  Future<void> init(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? getUrl = prefs.getString('url');
    if(getUrl!=null){
      if(context.mounted){
        login(getUrl, context);
      }
    }else{
      loading.value=false;
    }
  }

  void login(String urlInput, BuildContext context){
    if(urlInput.isEmpty){
      showDialog(
        context: context, 
        builder: (context)=>AlertDialog(
          title: const Text('登录失败'),
          content: const Text('URL地址不能为空'),
          actions: [
            FilledButton(
              onPressed: ()=>Navigator.pop(context), 
              child: const Text('好的')
            )
          ],
        )
      );
    }else if(!(urlInput.startsWith('http://') || urlInput.startsWith('https://'))){
      showDialog(
        context: context, 
        builder: (context)=>AlertDialog(
          title: const Text('登录失败'),
          content: const Text('URL地址不合法'),
          actions: [
            ElevatedButton(
              onPressed: ()=>Navigator.pop(context), 
              child: const Text('好的')
            )
          ],
        )
      );
    }else{
      
    }
  }
}