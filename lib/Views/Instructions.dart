import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_appnewoen/Cons/Constants.dart';
import 'package:flutter_appnewoen/model/getlink.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'Login.dart';

class HorizontalAndVerticalListView extends StatefulWidget {
  @override
  _HorizontalAndVerticalListViewState createState() =>
      _HorizontalAndVerticalListViewState();
}

class _HorizontalAndVerticalListViewState
    extends State<HorizontalAndVerticalListView>
    with SingleTickerProviderStateMixin {
  List<getlink> doslist = [];
  List<getlink> dontslist = [];

  bool hasData = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getdata();
    getdata2();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Instructions'),
        backgroundColor: Colors.blueGrey.shade900,
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
          : doslist.length == null && dontslist.length == null
              ? Center(
                  child: Text('No Data found'),
                )
              : CustomScrollView(
                  slivers: <Widget>[
                    SliverFixedExtentList(
                      itemExtent: 50,
                      delegate: SliverChildListDelegate([
                        Container(
                            child: Row(
                          children: [
                            IconButton(
                                // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                                icon: FaIcon(
                                  FontAwesomeIcons.ban,
                                ),
                                color: Colors.redAccent,
                                onPressed: () {}),
                            Text(
                              'Things Not To Do',
                              style: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                          ],
                        )),
                        _listItem(),
                        Container(
                            child: Row(
                          children: [
                            IconButton(
                                // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                                icon: FaIcon(
                                  FontAwesomeIcons.check,
                                ),
                                color: Colors.green,
                                onPressed: () {}),
                            Text(
                              'Things To Do',
                              style: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                          ],
                        )),
                        _listItem2(),

                        // _listItem2(),

                        ///add more as you wish
                      ]),
                    )
                  ],
                ),
    );
  }

  _listItem() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Text(
            doslist[index].value!,
            style: TextStyle(fontSize: 18),
          );
        },
        itemCount: doslist.length,
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
        Uri.parse(Base_url + 'dos'),
        headers: requestHeaders,
      );
      if (response.statusCode == 200) {
        var responseJson = json.decode(response.body);
        for (var u in responseJson) {
          doslist.add(getlink(u['id'].toString(), u['message'].toString()));
        }
      }

      //EasyLoading.showSuccess("Logged in");

      //  EasyLoading.dismiss();
    }
  }

  Future<void> getdata2() async {
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
        Uri.parse(Base_url + 'donts'),
        headers: requestHeaders,
      );
      if (response.statusCode == 200) {
        var responseJson = json.decode(response.body);
        for (var u in responseJson) {
          dontslist.add(getlink(u['id'].toString(), u['message'].toString()));
        }
      }

      //EasyLoading.showSuccess("Logged in");

      //  EasyLoading.dismiss();
    }
    setState(() {
      hasData = false;
    });
  }

  _listItem2() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Text(
            dontslist[index].value!,
            style: TextStyle(fontSize: 18),
          );
        },
        itemCount: dontslist.length,
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  String path = "images/svgs/yts_logo.svg";
  int ratings = 2;
  //MovieCard({@required this.path});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      child: Column(
        children: <Widget>[
//          Card(
//            shape: RoundedRectangleBorder(
//              borderRadius: BorderRadius.circular(10),
//            ),
//            elevation: 12,
//            child: SvgPicture.asset(path,fit: BoxFit.fill,width: 100,height: 100,),
//          ),
          //title

          Text("title",
              style: TextStyle(
                  fontFamily: 'open_sans',
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.normal)),
          IconTheme(
            data: IconThemeData(
              color: Colors.amber,
              size: 20,
            ),
            child: _provideRatingBar(3),
          )
          //ratings
        ],
      ),
    );
  }

  _provideRatingBar(int rating) {
    return Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(5, (index) {
          return Icon(
            index < rating ? Icons.star : Icons.star_border,
          );
        }));
  }
}
