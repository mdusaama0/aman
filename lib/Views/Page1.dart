import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appnewoen/Views/Liaison.dart';
import 'package:flutter_appnewoen/model/getlink.dart';

import '../main.dart';
import 'Adminlogin.dart';
import 'ChatUI.dart';
import 'Contactus.dart';
import 'Exercise.dart';
import 'Feedback.dart';
import 'Gallerypreview.dart';
import 'Griditem.dart';
import 'Home.dart';

import 'Instructions.dart';
import 'Leaders.dart';
import 'Login.dart';
import 'Participants.dart';
import 'Webvie.dart';
import 'Webviewlogin.dart';
import 'organizers.dart';

class page1 extends StatefulWidget {
  page1states createState() => page1states();
}

class page1states extends State<page1> {
  List<getlink> gettitlelist = [];
  @override
  void initState() {
    gettitlelist.add(getlink.a1(Icon(Icons.home, size: 35, color: Colors.white),
        'Introduction', ExpansionTileSample()));
    gettitlelist.add(getlink.a1(
        Icon(Icons.explicit, size: 35, color: Colors.white),
        'Exercise',
        Exercise('0')));
    gettitlelist.add(getlink.a1(
        Icon(Icons.security, size: 35, color: Colors.white),
        'Service & Support',
        Exercise('1')));
    gettitlelist.add(getlink.a1(
        Icon(Icons.people_outline, size: 35, color: Colors.white),
        'Participants',
        Participants()));
    gettitlelist.add(getlink.a1(
        Icon(Icons.assignment_ind, size: 35, color: Colors.white),
        'Organizers',
        organizers()));
    gettitlelist.add(getlink.a1(
        Icon(Icons.verified_user, size: 35, color: Colors.white),
        'Misc',
        Exercise('6')));
    gettitlelist.add(getlink.a1(
        Icon(Icons.image, size: 35, color: Colors.white),
        'Gallery',
        Gallerypreview()));
    gettitlelist.add(getlink.a1(
        Icon(Icons.contacts, size: 35, color: Colors.white),
        'Contact us',
        contactus()));
    gettitlelist.add(getlink.a1(
        Icon(Icons.exit_to_app, size: 35, color: Colors.white),
        'Login/Logout',
        LoginSevenPage()));
    gettitlelist.add(getlink.a1(
        Icon(Icons.chat, size: 35, color: Colors.white), 'Chat', ChatUi()));
    gettitlelist.add(getlink.a1(
        Icon(Icons.verified_user, size: 35, color: Colors.white),
        'Admin Login',
        WikipediaExplorer()));
    gettitlelist.add(getlink.a1(
        Icon(Icons.feedback, size: 35, color: Colors.white),
        'Feedback',
        feedback()));

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
}
