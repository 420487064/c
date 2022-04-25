import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study/views/text.dart';

class listcard extends StatefulWidget {
  listcard({
    Key? key,
    required this.char,
    required this.cid,
    required this.ccontent,
  }) : super(key: key);
  final String char;
  final String cid;
  final String ccontent;
  @override
  State<listcard> createState() => _listcardState(char, cid, ccontent);
}

class _listcardState extends State<listcard> {
  String char;
  String cid;
  String ccontent;
  _listcardState(this.char, this.cid, this.ccontent);

  //删除框显示
  bool flag = true;

  //删除后隐藏
  bool delete = false;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: delete,
      //手势函数
      child: GestureDetector(
        child: Container(
          margin: const EdgeInsets.only(top: 5),
          padding: const EdgeInsets.only(bottom: 0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color.fromARGB(255, 22, 226, 226).withOpacity(0.4)
              // gradient: LinearGradient(
              //     begin: Alignment.topLeft,
              //     end: Alignment.bottomRight,
              //     colors: [
              //       const Color.fromARGB(255, 55, 163, 235).withOpacity(0.4),
              //       const Color.fromARGB(255, 22, 226, 226).withOpacity(0.4)
              //     ]),
              ),
          child: ListTile(
              title: Text(char),
              trailing: Offstage(
                offstage: flag,
                child: IconButton(
                  icon: const Icon(Icons.delete),
                  // 点击时删除
                  onPressed: () => {dele()},
                ),
              )),
        ),
        //长按处理
        onLongPress: () {
          rubish();
        },
        //单击处理
        onTap: () {
          //跳转到text
          Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => new text(
                  id: cid,
                  content: ccontent,
                ),
              ));
        },
      ),
    );
  }

  //删除栏的显示和自动关闭
  void rubish() {
    setState(() {
      flag = false;
      //定时器
      var timer = Timer.periodic(Duration(milliseconds: 2000), (timer) {
        setState(() {
          flag = true;
        });
        timer.cancel(); //取消定时器
      });
    });
  }

  //删除后的处理
  void dele() async {
    await Dio().get("http://47.112.108.20:3000/api/textdelete",
        queryParameters: {"id": '${cid}'});
    setState(() {
      delete = true;
    });
  }
}
