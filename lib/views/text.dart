// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../utils/fluttertoast.dart';
import 'myhomepage.dart';

GlobalKey globalKey = GlobalKey();

class text extends StatefulWidget {
  text({Key? key, required this.id, required this.content}) : super(key: key);
  final String content;
  final String id;
  @override
  State<text> createState() => _textState(this.id, this.content);
}

class _textState extends State<text> {
  TextEditingController _controller = TextEditingController();
  String id;
  String content;
  _textState(this.id, this.content);
  bool flag = false;

  @override
  void initState() {
    // TODO: implement initState
    //  loadData();
    _controller.text = content;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //头部
      appBar: AppBar(
        leading: GestureDetector(
          child: Icon(Icons.keyboard_backspace),
          onTap: () {
            if (flag) {
              showDialog(
                  context: context,
                  builder: (context) =>
                      AlertDialog(title: Text('你未保存要退出吗？'), actions: <Widget>[
                        RaisedButton(
                            child: Text('退出'),
                            onPressed: () => Navigator.of(context)
                                .pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => MyHomePage()),
                                    (route) => route == null)),
                        RaisedButton(
                            child: Text('取消'),
                            onPressed: () => Navigator.of(context).pop(false)),
                      ]));
            } else {
              Navigator.of(context).pop(true);
            }
          },
        ),
        title: const Text("context", textAlign: TextAlign.center),
        actions: <Widget>[
          IconButton(
              icon: Icon(flag == false
                  ? Icons.check_circle_outline
                  : Icons.check_box_outline_blank),
              onPressed: () async {
                await zt();
                if (!flag) {
                  Fluttertoast.showToast(
                      backgroundColor: Color.fromARGB(255, 32, 122, 224),
                      msg: "保存成功",
                      textColor: Color.fromARGB(255, 229, 232, 236));
                } else {
                  Fluttertoast.showToast(
                      backgroundColor: Color.fromARGB(255, 32, 122, 224),
                      msg: "修改",
                      textColor: Color.fromARGB(255, 229, 232, 236));
                }
                changge();
              }),
        ],
      ),

      body: TextField(
        //获取表单的值
        controller: _controller,
        minLines: 40,
        enabled: flag,
        maxLines: 50,
      ),
      bottomNavigationBar:
          BottomNavigationBar(items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "favorite"),
        BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border), label: "favorite boder")
      ]),
    );
  }

  //初始化
  void loadData() async {
    var datas = <String>[];
    var ids = <String>[];
    var contents = <String>[];
    var response = await Dio().get("http://47.112.108.20:3000/api/selectid",
        queryParameters: {"id": '${id}'});

    var dat = jsonDecode(response.toString()); //3
    // print(dat);
    var result = dat['blogs'][0]['content'].toString();

    setState(() {
      _controller.text = result;
    });
    //print(data);
  }

  void changge() {
    //print('${content}');
    Dio().get("http://47.112.108.20:3000/api/textupdate",
        queryParameters: {"content": '${_controller.text}', "id": '${id}'});
  }

  zt() {
    setState(() {
      flag = !flag;
    });
  }
}
