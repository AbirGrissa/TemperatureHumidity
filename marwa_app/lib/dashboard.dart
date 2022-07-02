//import 'dart:ffi';

//import 'package:flutter/cupertino.dart';
//import 'package:flutter/src/foundation/key.dart';
//import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:marwa_app/CircleProgress.dart';
import 'package:marwa_app/NotificationPlugin.dart';
import 'package:marwa_app/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin notif = FlutterLocalNotificationsPlugin();

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  late AnimationController progressController;
  late Animation<double> tempAnimation;
  late Animation<double> humidityAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //databaseReference.child('ESP32_Device').once().then(DataSnapshot anapshot)
    /*notifPlugin.setListennerForLowerVersions(onNotificationInLowerVersion);
    notifPlugin.setOnNotificationClick(onNotificationClick);*/
    double temp = 7;
    double humidity = 47;
    isLoading = true;

    _DashboardInit(temp, humidity);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification!;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocatNotif.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher', //android/app/src/main/res
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('a new onMessageOpenedApp event was published ');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                  title: Text(notification.title!),
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text(notification.body!)],
                    ),
                  ));
            });
      }
    });
    /*if (temp > 10) {
      notifPlugin.showNotification();
    }*/
  }

  _DashboardInit(double temp, double humid) {
    progressController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 5000));
    tempAnimation =
        Tween<double>(begin: -50, end: temp).animate(progressController)
          ..addListener(() {
            setState(() {});
          });

    humidityAnimation =
        Tween<double>(begin: -50, end: humid).animate(progressController)
          ..addListener(() {
            setState(() {});
          });
    progressController.forward();
  }

  @override
  Widget build(BuildContext context) {
    double temp = 14;

    return Scaffold(
        appBar: AppBar(
            title: Text('EW_B100'),
            centerTitle: true,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.amber.shade300,
            foregroundColor: Colors.black
            /*leading: new IconButton(onPressed: () {}, icon: Icon(Icons.reorder)),*/
            ),
        body: /*DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: new AssetImage("images//background.jpg"),
                fit: BoxFit.cover),
          ),*/
            new Stack(children: <Widget>[
          new Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("images/background2.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          /* child:*/ Center(
            /*decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bulb.jpg"),
            fit: BoxFit.cover,
          ),*/
            child: isLoading
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      CustomPaint(
                        foregroundPainter:
                            CircleProgress(tempAnimation.value, true),
                        child: Container(
                          width: 200,
                          height: 200,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('Temperature'),
                                Text(
                                  '${tempAnimation.value.toInt()}',
                                  style: TextStyle(
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '°C',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      CustomPaint(
                        foregroundPainter:
                            CircleProgress(humidityAnimation.value, false),
                        child: Container(
                          width: 200,
                          height: 200,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('Humidity'),
                                Text(
                                  '${humidityAnimation.value.toInt()}',
                                  style: TextStyle(
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '%',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(
                                    vertical: 25.0, horizontal: 70.0)),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.amber.shade300),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.black),
                            overlayColor:
                                MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.hovered))
                                  return Colors.blue.withOpacity(0.04);
                                if (states.contains(MaterialState.focused) ||
                                    states.contains(MaterialState.pressed))
                                  return Colors.blue.withOpacity(0.12);
                                return null; // Defer to the widget's default.
                              },
                            ),
                          ),
                          //onPressed: () {},
                          onPressed: () => launch('https://www.google.com'),
                          child: Text(
                            'Camera streaming',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          )),
                      /*CoolAlert.show(
                        context: context,
                        type: CoolAlertType.success,
                      )*/

                      /* showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text("Attention !!!!"),
                                  content: Text(
                                      "very low temperature ,check your bees!!"),
                                  actions: [DialogAction(child: Text("ok"))],
                                ))*/
                    ],
                  )
                : Text(
                    'loading',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
          ),
        ]));
  }

  onNotificationInLowerVersion(ReceivedNotification receivedNotification) {}
  onNotificationClick(String payload) {}
}
