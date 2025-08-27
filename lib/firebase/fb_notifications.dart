
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../firebase_options.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage remoteMessage) async {
  // BACKGROUND NOTIFICATIONS - IOS & Android
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('📱 Background Message: ${remoteMessage.messageId}');
  print('📱 Title: ${remoteMessage.notification?.title}');
  print('📱 Body: ${remoteMessage.notification?.body}');
}

// GLOBAL
late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin localNotificationsPlugin;

mixin FbNotifications {
  // CALLED IN main function between ensureInitialized <-> runApp(widget);
  static Future<void> initNotifications() async {
    print('🔔 بدء تشغيل الإشعارات...');

    // ربط الدالة مع الإشعارات في الخلفية
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // إعداد Android
    if (Platform.isAndroid) {
      await _setupAndroidNotifications();
    }

    // إعداد iOS
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    print('✅ تم تشغيل الإشعارات بنجاح');
  }

  static Future<void> _setupAndroidNotifications() async {
    channel = const AndroidNotificationChannel(
      'elancer_flutter_channel',
      'إشعارات التطبيق',
      description: 'قناة الإشعارات الرئيسية للتطبيق',
      importance: Importance.high,
      enableLights: true,
      enableVibration: true,
      ledColor: Colors.orange,
      showBadge: true,
      playSound: true,
    );

    localNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // إعداد Android
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await localNotificationsPlugin.initialize(initializationSettings);

    // إنشاء القناة
    await localNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    print('📱 تم إعداد Android بنجاح');
  }

  // طلب الأذونات لـ iOS
  Future<void> requestNotificationPermissions() async {
    if (Platform.isIOS) {
      print('🍎 طلب أذونات iOS...');
      NotificationSettings notificationSettings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        carPlay: false,
        announcement: false,
        provisional: false,
      );

      if (notificationSettings.authorizationStatus == AuthorizationStatus.authorized) {
        print('✅ تم منح الأذونات لـ iOS');
      } else if (notificationSettings.authorizationStatus == AuthorizationStatus.denied) {
        print('❌ تم رفض الأذونات لـ iOS');
      }
    } else {
      print('🤖 Android - لا حاجة لطلب أذونات');
    }

    // طباعة FCM Token
    String? token = await FirebaseMessaging.instance.getToken();
    print('🔑 FCM Token: $token');
  }

  // ANDROID - الإشعارات المقدمة
  void initializeForegroundNotificationForAndroid() {
    print('📱 تفعيل الإشعارات المقدمة...');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📨 تم استلام رسالة: ${message.messageId}');
      print('📨 العنوان: ${message.notification?.title}');
      print('📨 المحتوى: ${message.notification?.body}');

      RemoteNotification? notification = message.notification;
      AndroidNotification? androidNotification = notification?.android;

      if (notification != null) {
        if (Platform.isAndroid && androidNotification != null) {
          _showAndroidNotification(notification);
        }
      }
    });
  }

  void _showAndroidNotification(RemoteNotification notification) {
    localNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: '@mipmap/ic_launcher',
          importance: Importance.high,
          priority: Priority.high,
          enableLights: true,
          enableVibration: true,
          playSound: true,
        ),
      ),
    );
  }

  // التعامل مع النقر على الإشعارات
  void manageNotificationAction() {
    print('🖱️ تفعيل التعامل مع النقر على الإشعارات...');

    // عند فتح التطبيق من إشعار
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('🖱️ تم فتح التطبيق من إشعار: ${message.messageId}');
      _controllerNotificationNavigation(message.data);
    });

    // التحقق من وجود إشعار عند بدء التطبيق
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        print('🚀 التطبيق تم فتحه من إشعار: ${message.messageId}');
        _controllerNotificationNavigation(message.data);
      }
    });
  }

  void _controllerNotificationNavigation(Map<String, dynamic> data) {
    print('📊 بيانات الإشعار: $data');

    if (data['page'] != null) {
      switch (data['page']) {
        case 'products':
          var productId = data['id'];
          print('🛍️ الانتقال للمنتج: $productId');
          break;
        case 'settings':
          print('⚙️ الانتقال للإعدادات');
          break;
        case 'profile':
          print('👤 الانتقال للملف الشخصي');
          break;
        case 'notifications':
          print('🔔 الانتقال للإشعارات');
          break;
        default:
          print('🏠 الانتقال للرئيسية');
          break;
      }
    }
  }

  // دالة للحصول على FCM Token
  Future<String?> getFcmToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      print('🔑 FCM Token الجديد: $token');
      return token;
    } catch (e) {
      print('❌ خطأ في الحصول على Token: $e');
      return null;
    }
  }
}

// *** V1 ***

// import 'dart:io';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import '../firebase_options.dart';
//
// Future<void> firebaseMessagingBackgroundHandler(
//     RemoteMessage remoteMessage) async {
//   // BACKGROUND NOTIFICATIONS - IOS & Android
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   print('Message: ${remoteMessage.messageId}');
// }
//
// // GLOBAL
// late AndroidNotificationChannel channel;
// late FlutterLocalNotificationsPlugin localNotificationsPlugin;
//
// mixin FbNotifications {
//   // CALLED IN main function between ensureInitialized <-> runApp(widget);
//
//   static Future<void> initNotifications() async {
//     //Connect the previous created function with onBackgroundMessage to enable
//     //receiving notification when app in Background.
//     FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
//     //Channel
//     if (Platform.isAndroid) {
//       //if (!kIsWeb) {
//       channel = const AndroidNotificationChannel(
//         'elancer_flutter_channel',
//         'flutter Android Notifications Channel',
//         description: 'This channel will receive notifications specific to flutter-app',
//         importance: Importance.high,
//         enableLights: true,
//         enableVibration: true,
//         ledColor: Colors.orange,
//         showBadge: true,
//         playSound: true,
//       );
//       //Flutter Local Notifications Plugin
//       localNotificationsPlugin = FlutterLocalNotificationsPlugin();
//       await localNotificationsPlugin.resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//           ?.createNotificationChannel(channel);
//     }
//
//     //ios Notification SetUp
//     await FirebaseMessaging.instance
//     .setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//   }
//
//   //Ios Notification Permission
//   Future<void>requestNotificationPermissions()async{
//
//     if(Platform.isIOS){
//       NotificationSettings notificationSettings = await FirebaseMessaging.instance.requestPermission(
//         alert: true,
//         badge: true,
//         sound: true,
//         carPlay: false,
//         announcement: false,
//         provisional: false,
//       );
//       if (notificationSettings.authorizationStatus == AuthorizationStatus.authorized){
//         print('GRANT Permission');
//       }else if(notificationSettings.authorizationStatus == AuthorizationStatus.denied){
//         print('Permission Denied');
//
//       }
//     }
//
//   }
//
//   // ANDROID
//   void initializeForegroundNotificationForAndroid() {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print('Message Received: ${message.messageId}');
//
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? androidNotification = notification?.android;
//
//       if (notification != null && androidNotification != null) {
//         localNotificationsPlugin.show(
//           notification.hashCode,
//           notification.title,
//           notification.body,
//           NotificationDetails(
//             android: AndroidNotificationDetails(
//               channel.id,
//               channel.name,
//               channelDescription: channel.description,
//               icon: 'launch_background',
//               //  icon: androidNotification.smallIcon,
//             ),
//           ),
//         );
//       }
//     });
//   }
//   //General (android-ios)
//   void manageNotificationAction(){
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message){
//       _controllerNotificationNavigation(message.data);
//     });
//   }
//
//   void _controllerNotificationNavigation(Map<String, dynamic> data) {
//     print('Data: $data');
//     if (data['page'] != null) {
//       switch (data['page']) {
//         case 'products':
//           var productId = data['id'];
//           print('Product Id: $productId');
//           break;
//         case 'settings':
//           print('Navigate to settings');
//           break;
//
//         case 'profile':
//           print('Navigate to profile');
//           break;
//       }
//     }
//   }
// }