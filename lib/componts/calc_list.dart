import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study/utils/calculator/calculator.dart';
import 'package:flutter_study/views/calculator.dart';

class ListView3 extends StatefulWidget {
  ListView3({Key? key}) : super(key: key);

  @override
  State<ListView3> createState() => _ListView3State();
}

class _ListView3State extends State<ListView3> {
  var len = 1;
  var express = <String>[];
  var res = <String>[];
  var bool = <String>[];
  var id = <int>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  void init() async {
    var expresss = <String>[];
    var ids = <int>[];
    var bools = <String>[];
    var ress = <String>[];
    var response = await Dio().get("http://47.112.108.20:3000/api/calc/b");
    var dat = jsonDecode(response.toString());
    var result = dat['data'];

    var lens = result.length;
    for (var i = 0; i < result.length; i++) {
      expresss.add(result[i]['expression'].toString());
      ids.add(result[i]['id']);
      ress.add(result[i]['res'].toString());
      bools.add(result[i]['bool'].toString());
    }

    setState(() {
      express = expresss;
      res = ress;
      bool = bools;
      len = lens;
      id = ids;
    });
  }

  @override
  Widget build(BuildContext context) {
    //下划线widget预定义以供复用。
    Widget divider1 = Divider(
      color: Colors.blue,
    );
    Widget divider2 = Divider(color: Colors.green);
    return ListView.separated(
      itemCount: len,
      //列表项构造器
      itemBuilder: (BuildContext context, int index) {
        String s = express[index] + "=" + res[index];
        return GestureDetector(
            child: ListTile(title: Text(s)),
            onTap: () {
              print(id[index]);
              // Navigator.pushNamed(context, "caculator",
              //     arguments: {"id": id[index]});

              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CalcButton(id: id[index])));
            });
      },
      //分割器构造器
      separatorBuilder: (BuildContext context, int index) {
        return index % 2 == 0 ? divider1 : divider2;
      },
    );
  }
}
