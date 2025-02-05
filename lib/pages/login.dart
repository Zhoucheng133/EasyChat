import 'package:easy_chat/variables/user_var.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final UserVar u=Get.find();
  bool hoverIn=false;
  final TextEditingController urlInput=TextEditingController();
  var onFocus=FocusNode();
  bool isFocus=false;

  void onFocusChange(){
    if(onFocus.hasFocus){
      setState(() {
        isFocus=true;
      });
    }else{
      setState(() {
        isFocus=false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    onFocus.addListener(onFocusChange);
  }
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 400,
        height: 300,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 253, 253, 253),
          borderRadius: BorderRadius.circular(10),
           boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(150, 200, 200, 200),
              offset: Offset(0, 0),
              blurRadius: 10.0,
              spreadRadius: 1.0,
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  const SizedBox(height: 15,),
                  const Row(
                    children: [
                      SizedBox(width: 10,),
                      Icon(
                        // FluentIcons.chevron_right_med,
                        Icons.chevron_right_rounded,
                        size: 20,
                      ),
                      SizedBox(width: 10,),
                      Text(
                        '连接到服务',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          width: 280,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: isFocus ? Colors.grey.withOpacity(0.2) : Colors.grey.withOpacity(0),
                                spreadRadius: 1,
                                blurRadius: 5,
                              ),
                            ]
                          ),
                          duration: const Duration(milliseconds: 200),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "URL地址",
                                  style: GoogleFonts.notoSansSc(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.public_rounded,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 5,),
                                    Expanded(
                                      child: TextField(
                                        focusNode: onFocus,
                                        controller: urlInput,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          isCollapsed: true,
                                          contentPadding: const EdgeInsets.only(top: 10, bottom: 10, left: 0, right: 10),
                                          hintText: 'http(s)://',
                                          hintStyle: TextStyle(
                                            color: Colors.grey[400],
                                          )
                                        ),
                                        onEditingComplete: () => u.login(urlInput.text, context),
                                        autocorrect: false,
                                        enableSuggestions: false,
                                        style: GoogleFonts.notoSansSc(
                                          fontSize: 14
                                        ),
                                      )
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
                        )
                      ],
                    )
                  ),
                  const SizedBox(height: 40,)
                ],
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: (){
                  u.login(urlInput.text, context);
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onEnter: (_){
                    setState(() {
                      hoverIn=true;
                    });
                  },
                  onExit: (_){
                    setState(() {
                      hoverIn=false;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: hoverIn ? Colors.yellow[700] : Colors.yellow[600],
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(10)
                      )
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white
                      ),
                    )
                  ),
                ),
              )
            )
          ],
        ),
      )
    );
  }
}