
import 'dart:async';

import 'package:bmi/home_screen.dart';
import 'package:bmi/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 3),
            ()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,),
       body: Center(
         child: Image.asset('images/splash.png',fit: BoxFit.contain,height: double.infinity,width: double.infinity,alignment: Alignment.center,),
       ),
    );
  }
}
