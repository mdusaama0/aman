import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_appnewoen/Cons/Constants.dart';
import 'package:flutter_appnewoen/main.dart';
import 'package:flutter_appnewoen/model/liasonmodel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'ChatUI.dart';
import 'Home.dart';
import 'Login.dart';

class liaison extends StatefulWidget {
  @override
  _liaisonState createState() => _liaisonState();
}

class _liaisonState extends State<liaison> with SingleTickerProviderStateMixin {
  List<liasonmodel> getalluserlist = [];
  bool hasData = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: Colors.blueGrey.shade900,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.pop(context);
              }),
        ],
      ),
      body: hasData
          ? Center(
              child: SpinKitSquareCircle(
                color: Colors.white,
                size: 50.0,
                controller: AnimationController(
                    vsync: this, duration: const Duration(milliseconds: 1200)),
              ),
            )
          : getalluserlist.length == 0
              ? Center(child: Text('No data found'))
              : Stack(
                  children: <Widget>[
                    Container(
                      height: 100.0,
                      decoration: new BoxDecoration(
                        color: Color(0xff074880).withOpacity(0.9),
                        boxShadow: [new BoxShadow(blurRadius: 40.0)],
                        borderRadius: new BorderRadius.vertical(
                            bottom: new Radius.elliptical(
                                MediaQuery.of(context).size.width, 100.0)),
                      ),
                      child: Center(
                          child: Text(
                        'Liaison Officers',
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      )),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 200),
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 6,
                            margin: EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Colors.blueGrey.shade900, width: 1),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 6,
                                ),
                                ListTile(
                                  title: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.person,
                                            size: 20,
                                            color: Colors.blueGrey.shade900,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            getalluserlist[index].username,
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          Spacer(),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(Icons.pin_drop,
                                              size: 20,
                                              color: Colors.blueGrey.shade900),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            getalluserlist[index].country,
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Spacer(),
                                          Icon(
                                            Icons.phone,
                                            size: 20,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            getalluserlist[index].contactno,
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        color: Colors.blueGrey.shade900,
                                      )
                                    ],
                                  ),
                                  subtitle: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                            color: Colors.blueGrey.shade900)),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.stars,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              getalluserlist[index].rank,
                                              style: TextStyle(fontSize: 12),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.info),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .6,
                                              child: Text(
                                                getalluserlist[index]
                                                    .liasonwith,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 5,
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                              ],
                            ),
                          );
                        },
                        itemCount: getalluserlist.length,
                      ),
                    ),
                  ],
                ),
    );
  }

  Future<void> getdata() async {
    final ore = await SharedPreferences.getInstance();
    if (ore.getString('counter') == null) {
      Future.delayed(Duration(seconds: 1));
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginSevenPage()),
      );
    } else {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Basic ' + ore.getString('counter')!,
      };
      final response = await http.get(
        Uri.parse(Base_url + 'liasons'),
        headers: requestHeaders,
      );
      if (response.statusCode == 200) {
        var responseJson = json.decode(response.body);
        for (var u in responseJson) {
          getalluserlist.add(liasonmodel(
              u['id'].toString(),
              u['rank'].toString(),
              u['name'].toString(),
              u['contactNo'].toString(),
              u['liasonWith'].toString(),
              u['country'].toString()));
        }
      }

      setState(() {
        hasData = false;
      });

      //EasyLoading.showSuccess("Logged in");

      //  EasyLoading.dismiss();
    }
  }
}
