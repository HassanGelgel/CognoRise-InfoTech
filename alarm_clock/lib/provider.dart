import 'Model/Model.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class alarmprovider extends ChangeNotifier {
  late SharedPreferences preferences;
  List<Model> modelist = [];
  List<String> listofstring = [];
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  late BuildContext context;

  Future<void> SetAlaram(String label, String dateTime, bool check, String repeat, int id, int milliseconds) async {
    modelist.add(Model(label: label, dateTime: dateTime, check: check, when: repeat, id: id, milliseconds: milliseconds));
    await SetData();
    notifyListeners();
  }

  Future<void> RemoveAlarm(int index) async {
    modelist.removeAt(index);
    await SetData();
    notifyListeners();
  }


  SecduleNotification(DateTime datetim,int Randomnumber) async {

    int newtime= datetim.millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch;
    print(datetim.millisecondsSinceEpoch);
    print(DateTime.now().millisecondsSinceEpoch);
    print(newtime);
    await flutterLocalNotificationsPlugin!.zonedSchedule(
        Randomnumber,
        '${modelist[modelist.length-1].label}',
        "${DateFormat().format(DateTime.now())}",
        tz.TZDateTime.now(tz.local).add( Duration(milliseconds: newtime)),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name',
                channelDescription: 'your channel description',

                sound: RawResourceAndroidNotificationSound("alarm"),
                autoCancel: false,
                playSound: true,
                priority: Priority.max


            )),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
  }

  void EditSwitch(int index, bool check) {
    modelist[index].check = check;
    notifyListeners();
  }

  CancelNotification(int notificationid)async{
    await flutterLocalNotificationsPlugin!.cancel(notificationid);
  }
  Future<void> GetData() async {
    preferences = await SharedPreferences.getInstance();
    List<String>? cominglist = await preferences.getStringList("data");

    if (cominglist != null) {
      modelist = cominglist.map((e) => Model.fromJson(json.decode(e))).toList();
    } else {
      modelist = [];
    }
    notifyListeners();
  }

  Future<void> SetData() async {
    listofstring = modelist.map((e) => json.encode(e.toJson())).toList();
    await preferences.setStringList("data", listofstring);
  }

  Future<void> Inituilize(BuildContext con) async {
    context = con;
    var androidInitilize = AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSinitilize = DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(android: androidInitilize, iOS: iOSinitilize);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin!.initialize(initializationSettings);
    await GetData();
  }
}
