import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class flutterpdf extends StatefulWidget {
  String geturl = '';
  flutterpdf(this.geturl);
  @override
  _MyAppState createState() => new _MyAppState(geturl);
}

class _MyAppState extends State<flutterpdf> {
  String pathPDF = "";
  String geturl = '';
  _MyAppState(this.geturl);

  @override
  void initState() {
    super.initState();
    print(geturl);
    createFileOfPdfUrl().then((f) {
      setState(() {
        pathPDF = f.path;
        print(pathPDF);
      });
    });
  }

  Future<File> createFileOfPdfUrl() async {
    final url = geturl;
    final filename = url.substring(url.lastIndexOf("/") + 1);
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pdf View')),
      body: Center(
        child: RaisedButton(
          child: Text("Open PDF"),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PDFScreen(pathPDF)),
          ),
        ),
      ),
    );
  }
}

class PDFScreen extends StatelessWidget {
  String pathPDF = "";
  PDFScreen(this.pathPDF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text("Document"),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.share),
          onPressed: () {},
        ),
      ],
    ));
    // path: pathPDF);
  }
}
