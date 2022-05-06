import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class switchchange extends StatefulWidget {
  switchchange({Key? key}) : super(key: key);

  @override
  State<switchchange> createState() => _switchchangeState();
}

class _switchchangeState extends State<switchchange> {
  late String? user;
  late bool _switchSelected = true;
  @override
  void initState() {
    init();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Switch(
      activeColor: Colors.white,
      value: _switchSelected, //当前状态
      onChanged: (value) async {
        //重新构建页面
        await isshowed(value);
        setState(() {
          _switchSelected = value;
        });
      },
    );
  }

  isshowed(bool value) async {
    int number = value == true ? 1 : 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user = prefs.getString("user");
    var respon = await Dio().get("http://119.3.138.217:3000/api/calc/f",
        queryParameters: {"user": user, "isshow": number});
    print(respon);
  }

  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user = prefs.getString("user");
    var response = await Dio().get("http://119.3.138.217:3000/api/calc/g",
        queryParameters: {"user": user});
    var data = jsonDecode(response.toString());
    _switchSelected = data["data"][0]["isshow"] == 1 ? true : false;
    print(_switchSelected);
    setState(() {
      _switchSelected;
    });
  }
}
