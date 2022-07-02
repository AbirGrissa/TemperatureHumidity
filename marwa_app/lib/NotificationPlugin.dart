import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'dart:io' show File, Platform;

class NotificationPlugin {
  late FlutterLocalNotificationsPlugin notif;
  final BehaviorSubject<ReceivedNotification>
      didReceivedLocalNotificationSubject =
      BehaviorSubject<ReceivedNotification>();
  var initializationSettings;

  NotificationPlugin._() {
    init();
  }
  init() async {
    notif = FlutterLocalNotificationsPlugin();
    if (Platform.isIOS) {
      _requestIOSPermission();
    }
    initializePlatformSpecifics();
  }

  initializePlatformSpecifics() {
    var initSettingsAndroid = AndroidInitializationSettings("defaultIcon");
    var initSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestSoundPermission: true,
      requestBadgePermission: false,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        ReceivedNotification receivedNotification = ReceivedNotification(
            id: id,
            body: body is String ? body : '',
            payload: payload is String ? payload : '',
            title: title is String ? title : '');
        didReceivedLocalNotificationSubject.add(receivedNotification);
      },
    );
    initializationSettings = InitializationSettings(
        iOS: initSettingsIOS, android: initSettingsAndroid);
  }

  _requestIOSPermission() {
    notif
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: false,
          badge: true,
          sound: true,
        );
  }

  setListennerForLowerVersions(Function onNotificationInLowerVersion) {
    didReceivedLocalNotificationSubject.listen((receivedNotification) {
      onNotificationInLowerVersion(receivedNotification);
    });
  }

  setOnNotificationClick(Function onNotificationClick) async {
    await notif.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      onNotificationClick(payload);
    });
  }

  Future<void> showNotification() async {
    var androidChannelSpecifics = AndroidNotificationDetails(
        'channelId', 'channelName',
        importance: Importance.max, priority: Priority.high);
    var IOSChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidChannelSpecifics, iOS: IOSChannelSpecifics);
    await notif.show(0, 'test title', 'test Body', platformChannelSpecifics,
        payload: 'test payload');
  }
}

NotificationPlugin notifPlugin = NotificationPlugin._();

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;
  ReceivedNotification(
      {required this.id,
      required this.body,
      required this.payload,
      required this.title});
}
