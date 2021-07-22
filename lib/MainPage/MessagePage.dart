import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:outfit2/Database/Constants.dart';
import 'package:outfit2/Database/Firebase.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:outfit2/ChatRoom.dart';

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final ScrollController listScrollController = ScrollController();

  Stream getMessageStream;
  DatabaseMethods databaseMethods = new DatabaseMethods();
  int limit = 20;
  int limitIncrement = 20;

  @override
  void initState() {
    getUsersList();
    super.initState();
  }

  void registerNotification() {
    //調出權限通知供iOS用戶確認
    firebaseMessaging.requestNotificationPermissions();

    //onMessage：當App正在執行中且手機畫面就是目前的App時觸發
    //onLaunch：當App完全被關閉(也不在背景執行)時觸發
    //onResume：當App正在背景執行時觸發
    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print('onMessage: $message');
      Platform.isAndroid
          ? showNotification(message['notification'])
          : showNotification(message['aps']['alert']);
      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume:$message');
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');
      return;
    });

    //判斷用戶正在聊天對象，token為對象id，接受其他訊息則通知(token對象除外)
    //若在主頁面，token對象為null，則接受所有訊息通知
    firebaseMessaging.getToken().then((token) {
      print('token: $token');
      FirebaseFirestore.instance
          .collection('Users')
          .doc(Constants.userId)
          .update({'pushToken': token});
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.message.toString());
    });
  }

  void configLocalNotification() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();
    final MacOSInitializationSettings initializationSettingsMacOS =
        MacOSInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: initializationSettingsMacOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  Future selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
    // );
  }

  void showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid ? 'com.example.outfit2' : '',
      'Clothes & Closer',
      'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var macOSPlatformChannelSpecifics = new MacOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
        macOS: macOSPlatformChannelSpecifics);

    print(message);
//    print(message['body'].toString());
//    print(json.encode(message));

    await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
        message['body'].toString(), platformChannelSpecifics,
        payload: json.encode(message));

//    await flutterLocalNotificationsPlugin.show(
//        0, 'plain title', 'plain body', platformChannelSpecifics,
//        payload: 'item x');
  }

  void scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        limit += limitIncrement;
      });
    }
  }

  getUsersList() async {
    databaseMethods.getUsersData(limit).then((result) {
      setState(() {
        getMessageStream = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '訊息',
          style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontFamily: '思源宋體',
              fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_outlined),
        ),
      ),
      body: StreamBuilder(
        stream: getMessageStream,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            default:
              if (snapshot.hasError)
                return Text('Error:${snapshot.error}');
              else
                return createListView(context, snapshot);
          }
        },
      ),
    );
  }

  Widget createListView(context, snapshot) {
    return ListView.builder(
      padding: EdgeInsets.all(5.0),
      controller: null,
      itemCount: snapshot.data.documents.length,
      itemBuilder: (context, index) {
        if (snapshot.data.documents[index].data()['id'] == Constants.userId) {
          return Container();
        } else {
          return Container(
            child: MaterialButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (content) => ChatRoom()));
              },
              child: Row(
                children: [
                  Material(
                    child: snapshot.data.documents[index].data()['photoUrl'] !=
                            null
                        ? CircleAvatar(
                            radius: 25.0,
                            child: Image.network(
                              snapshot.data()['photoUrl'],
                              fit: BoxFit.cover,
                            ),
                          )
                        : Icon(
                            Icons.account_circle,
                            size: 50.0,
                            color: Colors.white,
                          ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Container(
                          child: Text(
                            snapshot.data.documents[index].data()['userName'],
                            style: TextStyle(
                              fontSize: 25.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            '',
                            style: TextStyle(
                              fontSize: 25.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
