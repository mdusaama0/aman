import 'dart:convert';

import 'package:flutter/material.dart';

import '../main.dart';


class greeting extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<greeting> {
  late List data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey.shade900,
          title: Text("Greetings"),
          actions: <Widget>[

            IconButton(icon: Icon(Icons.home), onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) {
                return MyApp();
              }), (route) => false);
            }),
          ],
        ),
        body: Container(
          child: Image.asset('assets/images/languages.jpg',height:double.infinity,width: double.infinity,),
          // child: Center(
          //   // Use future builder and DefaultAssetBundle to load the local JSON file
          //   child: FutureBuilder(
          //       future: DefaultAssetBundle.of(context).loadString('assets/images/user.json'),
          //       builder: (context, snapshot) {
          //         // Decode the JSON
          //         var new_data = json.decode(snapshot.data.toString());
          //         return ListView.builder(
          //           // Build the ListView
          //           itemBuilder: (BuildContext conytext, int index) {
          //             return Card(
          //               elevation: 6,
          //               margin: EdgeInsets.all(10),
          //               shape: RoundedRectangleBorder(
          //                 side: BorderSide(color: Colors.white, width: 1),
          //                 borderRadius: BorderRadius.circular(25),
          //               ),
          //               child: Padding(
          //                 padding: EdgeInsets.all(20.0),
          //                 child: Column(
          //                   crossAxisAlignment: CrossAxisAlignment.stretch,
          //                   children: <Widget>[
          //                     Text("Code: " + new_data[index]['code']),
          //                     SizedBox(height: 10,),
          //                     Text("Name: " + new_data[index]['name']),
          //                     SizedBox(height: 10,),
          //                     Text("Greeting: " + new_data[index]['greeting'])
          //                   ],
          //                 ),
          //               ),
          //             );
          //           },
          //           itemCount: new_data == null ? 0 : new_data.length,
          //         );
          //       }),
          // ),
        ));
  }
}
