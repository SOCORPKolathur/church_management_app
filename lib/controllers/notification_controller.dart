import 'dart:async';
import 'dart:developer';
import 'package:church_management_client/models/user_notification_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String? mtoken = " ";

  @override
  void onReady() {
    super.onReady();
    requestPermission();
    listenFCM();
    loadFCM();
    _allclint.bindStream(FirebaseFirestore.instance
        .collection("UserToken")
        .snapshots()
        .map((QuerySnapshot queryy) {
      List<UserNotificationModel> allvideos = [];
      for (var elment in queryy.docs) {
        allvideos.add(UserNotificationModel.formSnap(elment));
      }
      return allvideos;
    }));
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      for (var i = 0; i < clientusers.length; i++) {
        if (clientusers[i].token == token) {
          return;
        }
      }
      mtoken = token!;
      update();
      findusers(token);
      update();
    });
  }

  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              icon: 'launch_background',
            ),
          ),
        );
      }
    });
  }

  void loadFCM() async {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        importance: Importance.high,
        enableVibration: true,
      );
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  final Rx<List<UserNotificationModel>> _allclint = Rx<List<UserNotificationModel>>([]);
  List<UserNotificationModel> get clientusers => _allclint.value;

  Future<void> findusers(String token) async {
    UserNotificationModel usermodel = UserNotificationModel(
      token: token,
    );
    await FirebaseFirestore.instance
        .collection("UserToken")
        .doc()
        .set(usermodel.toJson())
        .catchError((e) {
      log(e.toString());
    });
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {

    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {

    } else {

    }
  }
}
