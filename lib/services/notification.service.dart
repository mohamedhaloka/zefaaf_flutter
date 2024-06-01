import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:zeffaf/pages/chat.details/view.dart';
import 'package:zeffaf/pages/notifications/notifications.view.dart';
import 'package:zeffaf/pages/user_details/user_details.view.dart';
import 'package:zeffaf/services/socketService.dart';

class NotificationsService extends GetxService {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late String messageTittle, messageBody, messageType, currentPageType;
  String userName = '';
  String? userId;
  String pushToken = "";
  late int activeTypeNumber;
  String lastNotificationId = '';
  RxBool isRecievedNotify = RxBool(false);

  Future<NotificationsService> init() async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {},
    );
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: onSelectNotification,
    );

    _flutterLocalNotificationsPlugin.cancelAll();

    setupNotifications();
    return this;
  }

  Future setupNotifications() async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      log('User granted provisional permission');
    } else {
      log('User declined or has not accepted permission');
    }
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      await Future.delayed(const Duration(seconds: 1));
      var message = initialMessage.data;
      Map<String, dynamic> messageContent;
      messageTittle = initialMessage.notification!.title ?? '';
      messageBody = initialMessage.notification!.body ?? '';
      messageContent = message;

      Map allDetailsAboutNotification = {
        'messageType': returnMessageType(messageContent).toString(),
        'activeIndex': returnActiveType(messageContent).toString(),
        'currentPage': returnCurrentPage(messageContent).toString(),
        'userId': returnUserId(messageContent).toString(),
        'chatId': returnChatIdPage(messageContent).toString(),
        'userNameChat': returnUserNameForChat(messageContent).toString(),
        'userIdChat': returnUserIdForChat(messageContent).toString()
      };

      String payload = json.encode(allDetailsAboutNotification);

      onSelectNotification(payload);
    }

    FirebaseMessaging.onMessage.listen((event) async {
      final socket = Get.find<SocketService>();

      isRecievedNotify.value = !isRecievedNotify.value;

      var message = event.data;
      Map<String, dynamic> messageContent;
      messageTittle = event.notification!.title ?? '';
      messageBody = event.notification!.body ?? '';
      messageContent = message;

      if (lastNotificationId == messageContent['uniqueId']) {
        //Duplicate notification
        return;
      } else {
        lastNotificationId = messageContent['uniqueId'];
      }

      Map allDetailsAboutNotification = {
        'messageType': returnMessageType(messageContent).toString(),
        'activeIndex': returnActiveType(messageContent).toString(),
        'currentPage': returnCurrentPage(messageContent).toString(),
        'userId': returnUserId(messageContent).toString(),
        'chatId': returnChatIdPage(messageContent).toString(),
        'userNameChat': returnUserNameForChat(messageContent).toString(),
        'userIdChat': returnUserIdForChat(messageContent).toString()
      };

// {body: Test Notification mash, smallIcon: res://notification_icon.png, google.c.a.e: 1, sound: sound.mp3, gcm.message_id: 1617085106513107, google.c.sender.id: 483285088195,
// privateData: {"type":"0"}, title: Hello Tamer, icon: fcm_push_icon, click_action: FLUTTER_NOTIFICATION_CLICK, aps: {content-available: 1, alert: {title: Hello Tamer, body: Test Notification mash}, category: FLUTTER_NOTIFICATION_CLICK, sound: sound.wav}, largeIcon: fcm_push_icon, android_channel_id: noti_push_app_1, vibrate: 1}
// {notification: {title: Hello Tamer, body: Test Notification mash},
// data: {smallIcon: res://notification_icon.png, android_channel_id: noti_push_app_1,
// body: Test Notification mash, icon: fcm_push_icon, sound: sound.mp3, title: Hello Tamer,
// click_action: FLUTTER_NOTIFICATION_CLICK, vibrate: 1, largeIcon: fcm_push_icon, privateData: {"type":"1","id":"483"}}}

      String payload = json.encode(allDetailsAboutNotification);

      if (socket.roomName.value != userName &&
          allDetailsAboutNotification['messageType'] == '6') {
        showNotification(messageTittle, messageBody, payload);
        return;
      }

      if (allDetailsAboutNotification['messageType'] != '6') {
        showNotification(messageTittle, messageBody, payload);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      var message = event.data;
      Map<String, dynamic> messageContent;
      messageTittle = event.notification!.title ?? '';
      messageBody = event.notification!.body ?? '';
      messageContent = message;

      Map allDetailsAboutNotification = {
        'messageType': returnMessageType(messageContent).toString(),
        'activeIndex': returnActiveType(messageContent).toString(),
        'currentPage': returnCurrentPage(messageContent).toString(),
        'userId': returnUserId(messageContent).toString(),
        'chatId': returnChatIdPage(messageContent).toString(),
        'userNameChat': returnUserNameForChat(messageContent).toString(),
        'userIdChat': returnUserIdForChat(messageContent).toString()
      };

      String payload = json.encode(allDetailsAboutNotification);

      onSelectNotification(payload);
    });
  }

  int returnActiveType(message) {
    messageType = json.decode(message['privateData'])['type'];
    activeTypeNumber = activeType(messageType);
    return activeTypeNumber;
  }

  returnUserId(message) {
    String? userIdIndex = json.decode(message['privateData'])['id'];
    if (userIdIndex != null) {
      userId = userIdIndex;
      return userId;
    } else {
      return "0";
    }
  }

  returnCurrentPage(message) {
    messageType = json.decode(message['privateData'])['type'];
    currentPageType = currentPage(messageType);
    return currentPageType;
  }

  returnChatIdPage(message) {
    String? chatIdIndex = json.decode(message['privateData'])['id'];
    if (chatIdIndex != null) {
      userId = chatIdIndex;
      return userId;
    } else {
      return "0";
    }
  }

  returnUserNameForChat(message) {
    String? chatUser = json.decode(message['privateData'])['chatUser'];
    if (chatUser != null) {
      userName = chatUser;
      return chatUser;
    } else {
      return "0";
    }
  }

  returnUserIdForChat(message) {
    userId = json.decode(message['privateData'])['userId'];
    if (userId != null) {
      return userId;
    } else {
      return "0";
    }
  }

  returnMessageType(message) {
    messageType = json.decode(message['privateData'])['type'];
    return messageType;
  }

  activeType(messageType) {
    switch (messageType) {
      case "0":
        return 1;
      case "2":
        return 3;
      case "3":
        return 5;
      case "5":
        return 7;
      default:
        return 0;
    }
  }

  currentPage(messageType) {
    switch (messageType) {
      case "0":
        return "-";
      case "2":
        return "1";
      case "3":
        return "3";
      case "5":
        return "5";
      default:
        return "0";
    }
  }

  showNotification(tittle, message, filterData) async {
    var android = const AndroidNotificationDetails(
        'noti_push_app_1', 'noti_push_app_1',
        channelDescription: 'Deafult Notifications',
        priority: Priority.high,
        importance: Importance.max,
        sound: RawResourceAndroidNotificationSound('sound'));
    const iOS = IOSNotificationDetails(sound: 'sound.caf');
    var platform = NotificationDetails(android: android, iOS: iOS);
    await _flutterLocalNotificationsPlugin
        .show(0, '$tittle', '$message', platform, payload: filterData);
  }

  Future onSelectNotification(String? payload) async {
    if (payload != null) {
      String messageType = json.decode(payload)['messageType'];
      String activeType = json.decode(payload)['activeIndex'];
      String currentPage = json.decode(payload)['currentPage'];
      String userId = json.decode(payload)['userId'];
      String userIdChat = json.decode(payload)['userIdChat'];
      if (messageType == "1" ||
          messageType == "2" ||
          messageType == "3" ||
          messageType == "4" ||
          messageType == "5" ||
          messageType == "7" ||
          messageType == "8" ||
          messageType == "9") {
        Get.to(() => UserDetails(
              isFavourite: false,
              userId: int.parse(userId),
            ));
      }
      // else if (messageType == "3" ||
      //     messageType == "4" ||
      //     messageType == "5")
      else if (messageType == "0") {
        Get.to(() => Notifications(
              notInTab: true,
              notification: currentPage,
              activeIndex: int.parse(activeType),
            ));
      } else if (messageType == "6") {
        Get.to(() => ChatDetails(
              isBackToChatList: false,
              otherId: int.parse(userIdChat),
            ));
      } else if (messageType == "12") {
        Get.toNamed('/AppMessageView');
      } else {
        Get.to(() => const Notifications(
              notInTab: true,
              notification: '0',
              activeIndex: 1,
            ));
      }
    }
  }
}
