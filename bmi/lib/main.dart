import 'dart:async';
import 'dart:math';

import 'package:bmi/result_screen.dart';
import 'package:bmi/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(MyApp());
}

Color secondGirlColor = Color.fromRGBO(195, 124, 192, 1);
Color maleColor =Color.fromRGBO(96, 167, 197, 1);
Color mainGirlsColor =Colors.blue;// Color.fromRGBO(250, 120, 190, 1);
bool isMale=false;
bool isBlack=false;
double height = 140;
double weight = 40;

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class CirclePainterTop extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();
    paint.color = isMale?maleColor.withOpacity(0.4):secondGirlColor.withOpacity(0.4);
    canvas.drawCircle(Offset(size.width * 0.02, size.height * 0.03), 80, paint);
    paint.color = isMale?maleColor.withOpacity(0.4):secondGirlColor.withOpacity(0.4);
    canvas.drawCircle(Offset(size.width * 0.3, size.height * 0.01), 60, paint);
    paint.color = isMale?maleColor.withOpacity(0.4):secondGirlColor.withOpacity(0.4);
    canvas.drawCircle(Offset(size.width * 0.55, size.height * 0.4), 70, paint);
    paint.color = isMale?maleColor.withOpacity(0.4):secondGirlColor.withOpacity(0.3);
    canvas.drawCircle(Offset(size.width * 0.75, size.height * 0), 55, paint);
    paint.color = isMale?maleColor.withOpacity(0.1):secondGirlColor.withOpacity(0.1);
    canvas.drawCircle(Offset(size.width * 1, size.height * 0.2), 60, paint);


  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class CirclePainterBottom extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();
    paint.color = isMale?maleColor.withOpacity(0.4):secondGirlColor.withOpacity(0.4);
    canvas.drawCircle(Offset(size.width * 0.02, size.height * 0.03), 100, paint);
    paint.color = isMale?maleColor.withOpacity(0.4):secondGirlColor.withOpacity(0.4);
    canvas.drawCircle(Offset(size.width * 0.9, size.height * 3), 90, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class AgeInput extends StatefulWidget {
  @override
  _AgeInputState createState() => _AgeInputState();
}

class _AgeInputState extends State<AgeInput> {
  int age = 18;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Age',
          style: TextStyle(
            color: isMale?maleColor:secondGirlColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 10),
        FloatingActionButton(
          heroTag: '1',
          backgroundColor: isMale ? maleColor : secondGirlColor,
          mini: true,
          child: Icon(Icons.remove, color: Colors.white),
          onPressed: () {
            setState(() {
              if (age > 1) age--;
            });
          },
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '$age',
            style: TextStyle(
                color: isMale?maleColor:secondGirlColor, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        FloatingActionButton(
          heroTag: 'uniqueTag1',
          backgroundColor: isMale ? maleColor : secondGirlColor,
          mini: true,
          child: Icon(Icons.add, color: Colors.white),
          onPressed: () {
            setState(() {
              age++;
            });
          },
        ),
      ],
    );
  }
}

class HeightWeightInput extends StatefulWidget {
  @override
  _HeightWeightInputState createState() => _HeightWeightInputState();
}

class _HeightWeightInputState extends State<HeightWeightInput> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
           mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Height (CM)  ',
              style: TextStyle(
                color: isMale ? maleColor : secondGirlColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${height.round()} cm', // Display current height
              style: TextStyle(
                color: isMale ? maleColor : secondGirlColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Slider(
          inactiveColor: Colors.white,
          activeColor: isMale ? maleColor : secondGirlColor,
          value: height,
          min: 50,
          max: 250,
          divisions: 200,
          label: height.round().toString(),
          onChanged: (double value) {
            setState(() {
              height = value;
            });
          },
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Weight (KG)  ',
              style: TextStyle(
                color: isMale ? maleColor : secondGirlColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${weight.round()} kg', // Display current weight
              style: TextStyle(
                color: isMale ? maleColor : secondGirlColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Slider(
          inactiveColor: Colors.white,
          activeColor: isMale ? maleColor : secondGirlColor,
          value: weight,
          min: 1,
          max: 200,
          divisions: 199,
          label: weight.round().toString(),
          onChanged: (double value) {
            setState(() {
              weight = value;
            });
          },
        ),
      ],
    );
  }
}

class ResultButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        double height_m=height/100.0;
        double bmi=weight/pow(height_m, 2);
        String clasi='';
        print(bmi);
        double roundedValue = double.parse(bmi.toStringAsFixed(1));
        print(roundedValue);
        if(roundedValue < 18.5){
          clasi="Underweight";
        }
        else if(roundedValue>=18.5 && roundedValue<=24.9){
          clasi="Normal";
        }
        else if(roundedValue>=25.0 && roundedValue<=29.9){
          clasi='Overweight';
        }
        else {
          clasi="Obese";
        }
        print(clasi);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=>  ResultScreen(res: roundedValue,isDark: isBlack,clasi:clasi,isMale: isMale,)),

        );
        },
      style: ElevatedButton.styleFrom(
        backgroundColor: isMale?maleColor:secondGirlColor.withOpacity(1),
      ),
      child: Text(
        'Result',
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
      ),
    );
  }
}
