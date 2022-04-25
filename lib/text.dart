import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study/utils/fluttertoast.dart';

GlobalKey globalKey = GlobalKey();
void main() => runApp(DemoApp());

class DemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Image Picker Demo',
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello World"),
      ),
      body: Center(
        child: RaisedButton(
          child: Text("Click"),
          onPressed: () {
            Fluttertoast.showToast(
                msg: "Hello world",
                textColor: Color.fromARGB(255, 175, 29, 29));
          },
        ),
      ),
    );
  }
}
