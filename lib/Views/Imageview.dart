import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class Imageview extends StatelessWidget {
  String image;
  Imageview(this.image);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Image'),
        actions: <Widget>[

          IconButton(icon: Icon(Icons.home), onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) {
              return MyApp();
            }), (route) => false);
          }),
        ],
        leading: IconButton(icon:Icon(Icons.arrow_back,color: Colors.white,),
          onPressed:() => Navigator.pop(context, false),
        ),
        backgroundColor: Colors.blueGrey.shade900,
      ),
      body: new Image.network(
        image,
        fit: BoxFit.fitWidth,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      ),
    );
  }
}
