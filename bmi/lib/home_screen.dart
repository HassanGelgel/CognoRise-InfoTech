import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:isBlack? Colors.black:Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            CustomPaint(
              painter: CirclePainterTop(),
              child: Container(),
            ),
            SizedBox(height: 10),
            Column(
              children: [
                // SizedBox(height: 44),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(width: 5,),
                    Switch(
                        inactiveThumbColor : (isMale)?Colors.white:Colors.white,
                        inactiveTrackColor: (isMale)? maleColor:secondGirlColor.withOpacity(1),
                        activeTrackColor:(isMale)?maleColor :secondGirlColor,

                        value: isBlack, onChanged: (val){
                      setState(() {
                        isBlack=!isBlack;
                      });
                    }),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundImage:isMale? AssetImage('images/az.png'): AssetImage('images/11.png'),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "BMI Calculator",
                      style: TextStyle(
                        color: isMale?maleColor:secondGirlColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              isMale=false;
                            });
                          },
                          child: CircleAvatar(
                            backgroundImage: AssetImage('images/11.png'),
                            radius: 30,
                          ),
                        ),
                        Text(
                          "Female",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: secondGirlColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 40),
                    Text(
                      "OR",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isMale?maleColor:secondGirlColor,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(width: 40),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              isMale=true;
                            });
                          },
                          child: CircleAvatar(
                            backgroundImage: AssetImage('images/az.png'),
                            radius: 30,
                          ),
                        ),
                        Text(
                          "Male",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: maleColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Wrap the following widgets in a Container with red background
                Container(
                  height: 340,
                  decoration: BoxDecoration(
                    color: isMale?maleColor.withOpacity(0.2):secondGirlColor.withOpacity(0.2),
                    borderRadius: BorderRadius.only( topLeft: Radius.circular(24),topRight:Radius.circular(24) ),
                  ),
                  child: Column(
                    children: [
                      AgeInput(),
                      SizedBox(height: 20),
                      HeightWeightInput(),
                      SizedBox(height: 20),
                      ResultButton(),
                    ],
                  ),
                ),
              ],
            ),
            CustomPaint(
              painter: CirclePainterBottom(),
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
