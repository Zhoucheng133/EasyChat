import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class Dialogs {

  void showCancelOk(BuildContext context, String title, String content, Function func){
    showDialog(
      context: context, 
      builder: (context)=>AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: ()=>Navigator.pop(context), 
            child: const Text('取消')
          ),
          ElevatedButton(
            onPressed: (){
              func();
              Navigator.pop(context);
            }, 
            child: const Text('继续')
          )
        ],
      )
    );
  }

  void showErr(BuildContext context, String title, String content){
    showDialog(
      context: context, 
      builder: (context)=>AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          ElevatedButton(
            onPressed: ()=>Navigator.pop(context), 
            child: const Text('好的')
          )
        ],
      )
    );
  }
  
  Future<void> showAbout(BuildContext context) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if(context.mounted){
      showDialog(
        context: context, 
        builder: (context)=>AlertDialog(
          title: const Text('关于'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icon.png',
                width: 100,
              ),
              const SizedBox(height: 10,),
              Text(
                'EasyChat',
                style: GoogleFonts.notoSansSc(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 3,),
              Text(
                'v${packageInfo.version}',
                style: GoogleFonts.notoSansSc(
                  fontSize: 13,
                  color: Colors.grey[400]
                ),
              ),
              const SizedBox(height: 20,),
              GestureDetector(
                onTap: (){
                  final url=Uri.parse('https://github.com/Zhoucheng133/EasyChat');
                  launchUrl(url);
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.github,
                        size: 15,
                      ),
                      const SizedBox(width: 5,),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Text(
                          '本项目地址',
                          style: GoogleFonts.notoSansSc(
                            fontSize: 13,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: ()=>showLicensePage(context: context),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.certificate,
                        size: 15,
                      ),
                      const SizedBox(width: 5,),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Text(
                          '许可证',
                          style: GoogleFonts.notoSansSc(
                            fontSize: 13,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(onPressed: ()=>Navigator.pop(context), child: const Text('好的'))
          ],
        )
      );
    }
  }
}