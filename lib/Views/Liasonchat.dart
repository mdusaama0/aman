import 'dart:async';
import 'dart:convert';

/**
 * Author: Damodar Lohani
 * profile: https://github.com/lohanidamodar
 */
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_appnewoen/Cons/Constants.dart';
import 'package:flutter_appnewoen/Views/Liaison.dart';
import 'package:flutter_appnewoen/model/LiasonModelchat.dart';
import 'package:flutter_appnewoen/model/chatsdialogmodel.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'ChatUI.dart';
import 'Home.dart';
import 'Login.dart';

class Liasonchat extends StatefulWidget {
  var get = '';
  Liasonchat(this.get);
  static final String path = "lib/src/pages/misc/chat2.dart";
  @override
  _ChatTwoPageState createState() => _ChatTwoPageState(get);
}

//asdadasdasd
class _ChatTwoPageState extends State<Liasonchat> {
  var get = '';
  _ChatTwoPageState(this.get);

  List<liasonmodelchat> getchatslist = [];
  List<liasonmodelchat> reversedList = [];
  var getid = '';
  var getemail = '';
  var check = true;
  String text = '';
  TextEditingController _controller = TextEditingController();
  final List<Message> messages = [
    Message(0, "But I may not go if the weather is bad."),
    Message(0, "I suppose I am."),
    Message(1, "Are you going to market today?"),
    Message(0, "I am good too"),
    Message(1, "I am fine, thank you. How are you?"),
    Message(1, "Hi,"),
    Message(0, "How are you today?"),
    Message(0, "Hello,"),
  ];
  final rand = Random();
  late Timer timer;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 30), (Timer t) => getchats());
    getchats();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // const fiveSeconds = const Duration(seconds: 10);
    // // _fetchData() is your function to fetch data
    // Timer.periodic(fiveSeconds, (Timer t) => getchats());
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => ChatUi()),
        // );
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text("Liaison Chat Room"),
            backgroundColor: Colors.blueGrey.shade900,
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.home),
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return MyApp();
                    }), (route) => false);
                  }),
            ],
          ),
          body: Stack(
            children: <Widget>[
              Image.asset(
                "assets/images/backgroundchat.jpg",
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fill,
              ),
              check
                  ? Center(
                      child: SpinKitSquareCircle(
                        color: Colors.blueGrey.shade900,
                        size: 50.0,
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          child: ListView.separated(
                            reverse: true,
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            separatorBuilder: (context, index) {
                              return const SizedBox(height: 10.0);
                            },
                            itemCount: reversedList.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (reversedList[index].email == getemail)
                                return _buildMessageRow(index, current: true);
                              return _buildMessageRow(index, current: false);
                              //masla kya aa raha ha??
                            },
                          ),
                        ),
                        _buildBottomBar(context),
                      ],
                    ),
            ],
          )),
    );
  }

  Container _buildBottomBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 16.0,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30.0),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 20.0,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              textInputAction: TextInputAction.send,
              controller: _controller,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 20.0,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  hintText: "Type a message"),
              onEditingComplete: _save,
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            color: Colors.blueGrey.shade900,
            onPressed: _save,
          )
        ],
      ),
    );
  }

  _save() async {
    if (_controller.text.isEmpty) return;
    FocusScope.of(context).requestFocus(FocusNode());
    sendmessage(_controller.text.toString());
  }

  Row _buildMessageRow(int count, {required bool current}) {
    return Row(
      mainAxisAlignment:
          current ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment:
          current ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: current ? 30.0 : 20.0),
        if (!current) ...[
          const SizedBox(width: 5.0),
        ],
        Flexible(
          child: Column(
            mainAxisAlignment:
                current ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment:
                current ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                decoration: BoxDecoration(
                    color: current ? Colors.blueGrey.shade900 : Colors.white,
                    borderRadius: BorderRadius.circular(10.0)),
                child: Column(
                  children: [
                    Text(
                      reversedList[count].message,
                      style: TextStyle(
                          color: current ? Colors.white : Colors.black,
                          fontSize: 18.0),
                    ),
                  ],
                ),
              ),
              Container(
                width: 250,
                padding: const EdgeInsets.symmetric(
                  vertical: 5.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black.withOpacity(0.5),
                ),
                child: Center(
                  child: Text(
                    reversedList[count].email +
                        ' | ' +
                        reversedList[count].fromName +
                        ' | ' +
                        reversedList[count].country,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (current) ...[
          const SizedBox(width: 5.0),
        ],
        SizedBox(width: current ? 20.0 : 30.0),
      ],
    );
  }

  void getchats() async {
    final ore = await SharedPreferences.getInstance();
    if (ore.getString('counter') == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) {
        return LoginSevenPage();
      }), (route) => false);
    } else {
      getid = ore.getString('id')!;
      getemail = ore.getString('useremail')!;
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Basic ' + ore.getString('counter')!,
      };

      Uri uri = Uri.parse(Base_url + "liaisonmessage");

      var response = await http.get(uri, headers: requestHeaders);

      if (response.statusCode == 401) {
        print('error');
      } else if (response.statusCode == 200) {
        var responseJson = json.decode(response.body);
        for (var u in responseJson) {
          if (u['message'].toString() != "null") {
            liasonmodelchat post = liasonmodelchat(
                u['id'].toString(),
                u['fromName'].toString(),
                u['rank'].toString(),
                u['email'].toString(),
                u['country'].toString(),
                u['message'].toString(),
                u['level'].toString(),
                u['level'].toString());
            getchatslist.add(post);
          }
        }
        reversedList = new List.from(getchatslist.reversed);
        setState(() {
          check = false;
        });
      }
    }
  }

  Future<void> sendmessage(String message) async {
    final ore = await SharedPreferences.getInstance();
    getid = ore.getString('id')!;
    reversedList.insert(
        0,
        liasonmodelchat(
            getid,
            ore.getString('username')!,
            ore.getString('rank')!,
            ore.getString('useremail')!,
            ore.getString('country')!,
            message,
            ore.getString('level')!,
            'null'));
    _controller.text = '';

    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Basic ' + ore.getString('counter')!,
    };
    var params = {
      "fromName": ore.getString('username'),
      "rank": ore.getString('rank'),
      "email": ore.getString('useremail'),
      "country": ore.getString('country'),
      "message": message,
      "level": ore.getString('level'),
      "time": null,
    };
    Uri uri = Uri.parse(Base_url + "liaisonmessage");

    var response = await http.post(uri,
        headers: requestHeaders, body: json.encode(params));

    if (response.statusCode == 401) {
      print('error');
    } else if (response.statusCode == 201) {
      print('201');
    }
  }

  callmethod() {
    Navigator.pop(context);
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => ChatUi()),
    // );
  }
}

class Message {
  final int user;
  final String description;

  Message(this.user, this.description);
}
