import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appnewoen/main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_appnewoen/Cons/Constants.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ChatUI.dart';
import 'Home.dart';
import 'Login.dart';

class feedback extends StatefulWidget {
  @override
  _feedbackState createState() => _feedbackState();
}

class _feedbackState extends State<feedback> {
  TextEditingController _controller = TextEditingController();
  late ProgressDialog pr;
  bool check = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getuser();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context);
    pr.style(
        message: 'Please Waiting...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.chat),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatUi()),
          );
        },
      ),
      appBar: AppBar(
        title: Text('Feedback'),
        backgroundColor: Colors.blueGrey.shade900,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.pop(context);
              }),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Feedback',
              style: TextStyle(color: Colors.grey, fontSize: 25),
            ),
            Text(
              'Please give your honest Feedback about AMAN Exercise 2021',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            SizedBox(
              height: 20,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Container(
                color: Colors.black12,
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  style: TextStyle(),
                  decoration: InputDecoration(
                    hintText: 'Text input',
                    fillColor: Colors.black12,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RaisedButton(
                  onPressed: () {
                    pr.show();
                    sendmessage(_controller.text.toString());
                  },
                  child: Text('Submit'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> sendmessage(String message) async {
    _controller.text = '';
    String getid;
    final ore = await SharedPreferences.getInstance();
    getid = ore.getString('id')!;
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Basic ' + ore.getString('counter')!,
    };
    var params = {"userid": getid, "feedback1": message};
    Uri uri = Uri.parse(Base_url + "feedbacks");

    var response = await http.post(uri,
        headers: requestHeaders, body: json.encode(params));

    if (response.statusCode == 401) {
      print('error');
    } else if (response.statusCode == 201) {
      print('201');
      Navigator.pop(context);
      Alert(
        context: context,
        title: "Feedback",
        desc: "Thank you! We have received your feebdback",
        alertAnimation: FadeAlertAnimation,
      ).show();
    }
  }

  Widget FadeAlertAnimation(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return Align(
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }

  void getuser() async {
    final ore = await SharedPreferences.getInstance();
    if (ore.getString('counter') == null) {
      Future.delayed(Duration(seconds: 1));
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginSevenPage()),
      );
    }
  }
}
