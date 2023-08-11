import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:notes_app/screens/Notes_screen/notes.dart';

class NotificationServices{

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true
    );
    if(settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    }
    else if(settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    }
    else{
      print('USer denied permission');
    }
  }

  void initLocalNotifications(RemoteMessage message) async {
    var androidInitializationSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettings = InitializationSettings(
        android: androidInitializationSettings
    );

    await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (payLoad) {
          handleMessage( message);
        });
  }


  void firebaseInit(){

    FirebaseMessaging.onMessage.listen((message) {

      print(message.notification!.title.toString());
      print(message.notification!.body.toString());
      print(message.data.toString());
      print(message.data['type']);
      print(message.data['id']);

      initLocalNotifications(message);
      showNotification(message);
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(100000).toString(),
      'High Importance Notification',
      importance: Importance.max,
    );

    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: 'Your Channel description',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails
    );

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails);
    });
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  void isTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      print('refresh token');
    });
  }


  Future<void> setupInteractMessage() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    //when app is terminated
    if(initialMessage != null){
      handleMessage(initialMessage);
    }

    //when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(event);
    });
  }


  void handleMessage(RemoteMessage message) {
    if(message.data['type'] == 'msg'){
      Get.to(const NotesScreen());
        //id: message.data['id'],

      // Navigator.push(
      //   context,
      //     MaterialPageRoute(builder: (context) => MessageScreen(
      //       id: message.data['id'],
      //     )));
    }
  }



}