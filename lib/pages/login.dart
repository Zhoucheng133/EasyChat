import 'package:easy_chat/variables/user_var.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final UserVar u=Get.find();

  bool hoverIn=false;

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
            Positioned(
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: (){
                  // TODO
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