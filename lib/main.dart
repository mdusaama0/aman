// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.


import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Views/NotificationsManager.dart';
import 'Views/Page1.dart';
import 'Views/page2.dart';

void main() {
  runApp(Splash());
}

class Splash extends StatefulWidget{

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash>  with WidgetsBindingObserver {
  late AppLifecycleState _lastLifecycleState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }
  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    print('dispose');
    super.dispose();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _lastLifecycleState = state;
    doit();
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen.navigate(
          name: 'assets/images/Aman.flr',
          next: (_) => MyApp(),
          until: () => Future.delayed(Duration(milliseconds: 0)),
          startAnimation: 'Untitled',
          fit: BoxFit.fill,
        ));
  }

  void doit() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }


}

class MyApp extends StatefulWidget {
  Mainpage createState() => Mainpage();
}
class Mainpage extends State<MyApp> {

  NotificationsManager notificationsManager = NotificationsManager();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  PageController _pageController = PageController();
  double currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                        Colors.blueGrey.shade900.withOpacity(0.5), BlendMode.color),
                    image: AssetImage('assets/images/backgroundnewone.jpg'),
                    fit: BoxFit.cover)),
          ),
      Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.blueGrey.shade900.withOpacity(0.5), BlendMode.color),
                image: AssetImage('assets/images/realone.PNG'),
                fit: BoxFit.fitWidth)),

      ),
          Container(

            constraints: BoxConstraints.expand(),
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  Container(
                    color: Colors.black54,
                    child: ListTile(
                      leading: Image.asset('assets/images/realone.PNG'),
                      title: Text(
                        'EXERCISE AMAN 2021',
                        style: TextStyle(color: Colors.white, letterSpacing: .5,fontWeight: FontWeight.bold,fontSize: 20),
                      ),
                      subtitle: Text('Together for Peace',style: TextStyle(color: Colors.white),),
                    ),
                  ),

                  Expanded(
                    child: PageIndicatorContainer(
                      align: IndicatorAlign.bottom,
                      length: 1,
                      indicatorSpace: 10.0,
                      child: PageView(
                        controller: _pageController,
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          page1(),
                          page2(),

                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )

        ],
      ),
    );
  }

  void _showNotification(Map<String, dynamic> message) {

    notificationsManager.showNotifications(message);
  }

  @override
  void initState() {
    super.initState();
    notificationsManager.initializeNotifications(context);

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        _showNotification(message);
        print("onMessage:$message");
        print("yeh mera:"+message['notification']['title']);

        //_showItemDialog(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
       // _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      //  _navigateToItemDetail(message);
      },
    );

    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
      //  _homeScreenText = "Push Messaging token: $token";
      });
     // print(_homeScreenText);
    });
    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page!;
      });
    });

  }
}
//
//Container(height:double.infinity,child: Image.asset('assets/images/background.jpeg',fit: BoxFit.cover)),
//child: Column(
//children: <Widget>[
//PageIndicatorContainer(
//align: IndicatorAlign.bottom,
//length: 4,
//indicatorSpace: 10.0,
//child: PageView(
//controller: _pageController,
//scrollDirection: Axis.horizontal,
//children: <Widget>[
//page1(),
//page1(),
//page1(),
//page1(),
//],
//),
//)
//],
//),
