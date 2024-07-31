import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:alaram/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

import 'package:another_flushbar/flushbar.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()!
      .requestNotificationsPermission();

  runApp(ChangeNotifierProvider(
    create: (contex) => alarmprovider(),
    child: const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool value = false;

  @override
  void initState() {
    context.read<alarmprovider>().Inituilize(context);
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });

    super.initState();
    context.read<alarmprovider>().GetData();
  }

  int index = 0;
  List<BottomNavigationBarItem> bar = [
    BottomNavigationBarItem(
        label: 'Alarm', icon: Icon(CupertinoIcons.alarm_fill)),
    BottomNavigationBarItem(
        label: 'Clock', icon: Icon(CupertinoIcons.clock_fill)),
    BottomNavigationBarItem(
        label: 'Stopwatch', icon: Icon(CupertinoIcons.stopwatch_fill)),
    // BottomNavigationBarItem( label: 'clock', icon: Icon(CupertinoIcons.hourglass_bottomhalf_fill)),
  ];
  List<Widget> screens = [
    AlarmsScreen(),
    DateTimeScreen(),
    StopwatchScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: bar,
        currentIndex: index,
        onTap: (cur) {
          setState(() {
            index = cur;
          });
        },
      ),
      backgroundColor: Color(0xFFEEEFF5),
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.menu,
              color: Colors.white,
            ),
          )
        ],
        title: const Text(
          'Alarm Clock ',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: screens[index],
    );
  }
}


class AlarmsScreen extends StatefulWidget {
  const AlarmsScreen({super.key});

  @override
  State<AlarmsScreen> createState() => _AlarmsScreenState();
}

class _AlarmsScreenState extends State<AlarmsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30))),
                height: MediaQuery.of(context).size.height * 0.1,
                child: Center(
                    child: Text(
                      'Alarms List',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white),
                    )),
              ),
              Consumer<alarmprovider>(builder: (context, alarm, child) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child:(alarm.modelist.length>0)? ListView.builder(
                      itemCount: alarm.modelist.length,
                      itemBuilder: (BuildContext, index) {
                        final alarmItem = alarm.modelist[index];
                        return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Dismissible(
                              key: Key(alarmItem.id.toString()),
                              onDismissed: (direction) {
                                // Remove the alarm from the list
                                alarm.RemoveAlarm(index);
                                alarm.CancelNotification(alarmItem.id!);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Alarm Deleted')),
                                );
                              },
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              child: Container(
                                height: MediaQuery.of(context).size.height * 0.1,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.shade300,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                alarmItem.dateTime!,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: Colors.black),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 8.0),
                                                child: Text(" # " + alarmItem.label.toString(),maxLines: 3,overflow: TextOverflow.ellipsis,),
                                              ),
                                            ],
                                          ),
                                          CupertinoSwitch(
                                              activeColor: Colors.deepPurpleAccent,
                                              value: (alarmItem.milliseconds! < DateTime.now().microsecondsSinceEpoch)
                                                  ? false
                                                  : alarmItem.check,
                                              onChanged: (v) {
                                                alarm.EditSwitch(index, v);
                                                alarm.CancelNotification(alarmItem.id!);
                                              }),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ));
                      }):Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.hourglass_empty,size: 90,color: Colors.deepPurple,),
                        SizedBox(height: 15,),
                        Text("No Alaems Yet",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.deepPurple),)
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
          Positioned(
            bottom: 10,
            left: 240,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddAlarm()));
              },
              child: Icon(Icons.add),
              backgroundColor: Colors.deepPurpleAccent,
            ),
          ),
        ],
      ),
    );
  }
}
class DateTimeScreen extends StatefulWidget {
  @override
  _DateTimeScreenState createState() => _DateTimeScreenState();
}

class _DateTimeScreenState extends State<DateTimeScreen> {
  late String _dateTimeString;

  @override
  void initState() {
    super.initState();
    _dateTimeString = _getCurrentDateTime();
    Timer.periodic(Duration(seconds: 1), (Timer t) => _updateDateTime());
  }

  String _getCurrentDateTime() {
    final now = DateTime.now();
    final dayOfWeek = DateFormat('EEEE').format(now); // Get the day of the week
    return "$dayOfWeek \n${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} \n "
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
  }

  void _updateDateTime() {
    setState(() {
      _dateTimeString = _getCurrentDateTime();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            height: MediaQuery.of(context).size.height * 0.1,
            child: Center(
                child: Text(
                  'Date and Time',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                )),
          ),
          SizedBox(height:130 ),
          Column(
            children: [
              Center(
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.deepPurple),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        DateFormat.EEEE().format(DateTime.now()), // Day
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.deepPurple),
                      ),
                      Text(
                        DateFormat.yMMMd().format(DateTime.now()), // Date
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.deepPurple),
                      ),
                      Text(
                        DateFormat.jms().format(DateTime.now()), // Time
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.deepPurple),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ]);
  }
}
class StopwatchScreen extends StatefulWidget {
  @override
  _StopwatchScreenState createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  late Stopwatch _stopwatch;
  late Ticker _ticker;
  late Duration _elapsed;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    _elapsed = Duration.zero;
    _ticker = Ticker((elapsed) {
      setState(() {
        _elapsed = _stopwatch.elapsed;
      });
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.stop();
    super.dispose();
  }

  void _startStopwatch() {
    setState(() {
      _stopwatch.start();
    });
  }

  void _stopStopwatch() {
    setState(() {
      _stopwatch.stop();
    });
  }

  void _resetStopwatch() {
    setState(() {
      _stopwatch.reset();
      _elapsed = Duration.zero;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(

        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            height: MediaQuery.of(context).size.height * 0.1,
            child: Center(
                child: Text(
                  'StopWatch',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                )),
          ),
          SizedBox(height:130 ),
          Center(
            child: Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.deepPurple),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatDuration(_elapsed),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 50,
                        color: Colors.deepPurple),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _stopwatch.isRunning ? null : _startStopwatch,
                        child: Text('Start'),
                      ),
                      ElevatedButton(
                        onPressed: _stopwatch.isRunning ? _stopStopwatch : null,
                        child: Text('Stop'),
                      ),
                      ElevatedButton(
                        onPressed: _resetStopwatch,
                        child: Text('Reset'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String twoDigitMilliseconds =
    (duration.inMilliseconds.remainder(1000) ~/ 10).toString().padLeft(2, '0');
    return "$twoDigitMinutes:$twoDigitSeconds.$twoDigitMilliseconds";
  }
}

class Ticker {
  Ticker(this._onTick);

  final void Function(Duration) _onTick;
  late final _ticker = Stopwatch();
  bool _isTicking = false;

  void start() {
    if (!_isTicking) {
      _isTicking = true;
      _tick();
    }
  }

  void stop() {
    _isTicking = false;
  }

  void _tick() {
    if (_isTicking) {
      _onTick(_ticker.elapsed);
      Future.delayed(Duration(milliseconds: 16), _tick);
    }
  }
}

class AddAlarm extends StatefulWidget {
  const AddAlarm({super.key});

  @override
  State<AddAlarm> createState() => _AddAlaramState();
}

class _AddAlaramState extends State<AddAlarm> {
  late TextEditingController controller;

  String? dateTime;
  bool repeat = false;

  DateTime? notificationtime;

  String? name = "none";
  int ? Milliseconds;

  @override
  void initState() {
    controller = TextEditingController();
    context.read<alarmprovider>().GetData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.check),
          )
        ],
        automaticallyImplyLeading: true,
        title: const Text(
          'Add Alarm',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(

            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width,
            child: Center(
                child: CupertinoDatePicker(
                  showDayOfWeek: true,
                  minimumDate: DateTime.now(),
                  dateOrder: DatePickerDateOrder.dmy,
                  onDateTimeChanged: (va) {
                    dateTime = DateFormat().add_jms().format(va);

                    Milliseconds = va.microsecondsSinceEpoch;

                    notificationtime = va;

                    print(dateTime);
                  },
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(

                width: MediaQuery.of(context).size.width,
                child: CupertinoTextField(
                  placeholder: "Add Label",
                  controller: controller,
                )),
          ),

          ElevatedButton(
              onPressed: () {
                Random random = new Random();
                int randomNumber = random.nextInt(100);

                context.read<alarmprovider>().SetAlaram(
                    controller.text, dateTime!, true, name!, randomNumber,Milliseconds!);
                context.read<alarmprovider>().SetData();

                context
                    .read<alarmprovider>()
                    .SecduleNotification(notificationtime!, randomNumber);

                Navigator.pop(context);
              },
              child: Text("Set Alaram")),
        ],
      ),
    );
  }
}


Model modelFromJson(String str) => Model.fromJson(json.decode(str));

String modelToJson(Model data) => json.encode(data.toJson());

class Model {
  String ? label;
  String ? dateTime;
  bool check;
  String ? when;
  int ? id;
  int ? milliseconds;


  Model({
    required this.label,
    required this.dateTime,
    required this.check,
    required this.when,
    required this.id,
    required this.milliseconds
  });

  factory Model.fromJson(Map<String, dynamic> json) => Model(
    label: json["label"],
    dateTime: json["dateTime"],
    check: json["check"],
    when: json["when"],
    id:json["id"],
    milliseconds:json["milliseconds"],
  );

  Map<String, dynamic> toJson() => {
    "label": label,
    "dateTime": dateTime,
    "check": check,
    "when": when,
    "id":id,
    "milliseconds":milliseconds,
  };
}
