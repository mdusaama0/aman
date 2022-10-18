import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appnewoen/Views/Liaison.dart';
import 'package:flutter_appnewoen/Views/ShowListItem.dart';
import 'package:flutter_appnewoen/model/getlink.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'Adminlogin.dart';
import 'ChatUI.dart';
import 'Contactus.dart';
import 'Exercise.dart';
import 'Feedback.dart';
import 'Gallerypreview.dart';
import 'Greetings.dart';
import 'Griditem.dart';
import 'Home.dart';

import 'Instructions.dart';
import 'Leaders.dart';
import 'Liasonchat.dart';
import 'Login.dart';
import 'Participants.dart';
import 'Webvie.dart';
import 'Webviewlogin.dart';
import 'organizers.dart';

class page2 extends StatefulWidget {
  page1states createState() => page1states();
}

class page1states extends State<page2> {
  List<getlink> gettitlelist = [];
  @override
  void initState() {
    check();
    gettitlelist.add(getlink.a1(
        Icon(Icons.account_box, size: 35, color: Colors.white),
        'Liaison',
        liaison()));
    gettitlelist.add(getlink.a1(
        Icon(Icons.adjust, size: 35, color: Colors.white),
        'Instructions',
        ShowListItem('Instructions', '18')));

//    gettitlelist.add(getlink.a1(Icon(Icons.adjust,size: 35,color: Colors.white),'Greetings',greeting()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 10 / 10,
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 60),
        itemBuilder: (context, index) => Griditem(gettitlelist[index].icon!,
            gettitlelist[index].key!, gettitlelist[index].test!),
        itemCount: gettitlelist.length,
      ),
    );
  }

  Future<void> check() async {
    final ore = await SharedPreferences.getInstance();
    if (ore.getString('counter') == null ||
        ore.getString('level') != 'Member') {
      gettitlelist.add(getlink.a1(
          Icon(Icons.adjust, size: 35, color: Colors.white),
          'LiasonChat',
          Liasonchat('Instructions')));
    }
  }
}
