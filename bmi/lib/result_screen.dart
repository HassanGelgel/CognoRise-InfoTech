import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget {
  final double res;
  final bool isMale;
  final String clasi;
  final bool isDark;
  ResultScreen({required this.res, required this.clasi, required this.isMale, required this.isDark});

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late bool isDark;
  late String adv;
  late Color tm;

  final String normal =
      'Great job on maintaining a healthy weight! A BMI within the normal range is a positive indicator of overall health.';
  final String under = ''' -While I can provide general advice, it's essential to consult with a healthcare professional for personalized guidance.
-Focus on Nutrition (Increase calorie intake, Choose nutrient-dense foods ,Regular meals ,Healthy fats , Protein-rich foods, Complex carbohydrates,Strength training ,Resistance training ,Consult a trainer)
-Lifestyle Factors (Quality sleep , Manage stress , Regular check-ups )
-Important Considerations (Gradual weight gain , Balance ,Hydration , Consult a healthcare provider)
Remember: It's crucial to find the root cause of your underweight condition. Underlying health issues might be contributing to your weight. A healthcare professional can help you determine the best approach. ''';
  final String over = ''' Understanding that seeing your BMI in the overweight range can be tough, but remember, it's a starting point, not a judgment.
Losing weight gradually and healthily is key. Here are some tips:
( Consult a healthcare professional, Focus on a balanced diet, Regular exercise , Hydration , Manage stress , Sufficient sleep , Seek support , Celebrate small victories )
Remember, sustainable weight loss is about lifestyle changes, not quick fixes. It's important to be patient and kind to yourself throughout the process. ''';
  final String obs = ''' Understanding that being obese can be challenging, but it's important to take steps towards a healthier you.
Losing weight gradually and sustainably is key. Here are some tips:
Consult a healthcare professional , Focus on a balanced diet , Portion control is crucial , Regular physical activity, Hydration , Manage stress , Sufficient sleep , Seek support , Celebrate small victories
Remember, sustainable weight loss is a journey, not a race. Be patient with yourself and focus on making gradual, healthy changes. ''';
  final Color gray = Color.fromRGBO(30, 32, 33, 1);
  final Color secondGirlColor = Color.fromRGBO(195, 124, 192, 1).withOpacity(0.4);
  final Color mailColor = Color.fromRGBO(96, 167, 197, 1).withOpacity(0.4);

  @override
  void initState() {
    super.initState();
    isDark = widget.isDark;
    setAdviceAndTheme();
  }

  void setAdviceAndTheme() {
    if (widget.clasi == "Normal") adv = normal;
    else if (widget.clasi == "Overweight") adv = over;
    else if (widget.clasi == "Underweight") adv = under;
    else adv = obs;

    if (!isDark && widget.isMale) tm = mailColor;
    if (!isDark && !widget.isMale) tm = secondGirlColor;
    if(isDark==true)tm=Colors.black;
  }

  void toggleDarkMode(bool value) {
    setState(() {
      isDark = value;
      setAdviceAndTheme();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: Column(
        children: [
          SizedBox(height: 23),
          Container(
            width: double.infinity,
            height: 53,
            decoration: BoxDecoration(
                color: isDark ? gray : tm,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Row(
              children: [
                SizedBox(width: 50),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Result',
                      style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ),
                Switch(
                  value: isDark,
                  onChanged: toggleDarkMode,
                  activeColor: tm.withOpacity(0.5),
                  inactiveTrackColor: tm.withOpacity(1),
                  inactiveThumbColor: Colors.white,

                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'YOUR BMI ',
                style: TextStyle(
                    color: isDark ? Colors.grey : Colors.black26,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
              Text(
                ' ${widget.res}',
                style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
            ],
          ),
          if (widget.clasi == "Normal" && isDark) Image.asset('images/dn.jpeg')
          else if (widget.clasi == "Overweight" && isDark) Image.asset('images/do.jpeg')
          else if (widget.clasi == "Underweight" && isDark) Image.asset('images/du.jpeg')
            else if (widget.clasi == "Obese" && isDark) Image.asset('images/dobs.jpeg')
              else if (widget.clasi == "Normal" && !isDark) Image.asset('images/ln.jpeg')
                else if (widget.clasi == "Overweight" && !isDark) Image.asset('images/lo.jpeg')
                  else if (widget.clasi == "Underweight" && !isDark) Image.asset('images/lu.jpeg')
                    else if (widget.clasi == "Obese" && !isDark) Image.asset('images/lobs.jpeg'),
          Text(
            widget.clasi,
            style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 30),
          ),
          SizedBox(height: 8),
          Expanded(
            child: Container(
              child: Column(
                children: [
                  Container(
                    height: 258,
                    decoration: BoxDecoration(
                        color: isDark ? gray : tm,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20))),
                    width: double.infinity,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding:
                            const EdgeInsets.only(top: 10, left: 10, right: 10),
                            child: Text(
                              adv,
                              style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black,
                                  fontFamily: 'Imprima',
                                  fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: isDark?Colors.black:tm.withOpacity(0.7),
                    child: Row(
                      children: [
                        Text(
                          'Follow For More ...',
                          style: TextStyle(
                              fontSize: 35,
                              fontFamily: 'Italianno',
                              color: isDark ? Colors.white : Colors.black),
                        ),
                        SizedBox(width: 25),
                        Icon(
                          Icons.facebook_sharp,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        SizedBox(width: 10),
                        Icon(
                          Icons.telegram,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
