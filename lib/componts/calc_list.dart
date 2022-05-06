import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study/utils/calculator/calculator.dart';
import 'package:flutter_study/utils/eventbus.dart';
import 'package:flutter_study/viewmodel/calc_history.dart';
import 'package:flutter_study/views/calculator.dart';
import 'package:provider/provider.dart';

class ListView3 extends StatefulWidget {
  ListView3({Key? key}) : super(key: key);

  @override
  State<ListView3> createState() => _ListView3State();
}

class _ListView3State extends State<ListView3> {
  var len = 0;
  var express = <String>[];
  var res = <dynamic>[];
  var bool = <String>[];
  var id = <int>[];
  List list = [];

  @override
  void initState() {
    // TODO: implement initState
    bus.on(1, (parmas) {
      context.read<calc_historyViewmodel>().sets(parmas.toString());
      print("key0");
      print(context.read<calc_historyViewmodel>().gets);
    });
    init();
    super.initState();
  }

  void init() async {
    //list = context.read<calc_historyViewmodel>().getList;

    var expresss = <String>[];
    var ids = <int>[];
    var bools = <String>[];
    var ress = <dynamic>[];
    var response = await Dio().get("http://119.3.138.217:3000/api/calc/e",
        queryParameters: {"zh": context.read<calc_historyViewmodel>().gets});
    var dat = jsonDecode(response.toString());
    var result = dat['data'];
    print("list");
    print(dat);
    var lens = result.length;
    for (var i = 0; i < result.length; i++) {
      expresss.add(result[i]['expression'].toString());
      ids.add(result[i]['id']);
      ress.add(result[i]['res']);
      bools.add(result[i]['bool'].toString());
    }

    setState(() {
      list;
      express = expresss;
      res = ress;
      bool = bools;
      len = lens;
      id = ids;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    bus.off(1);
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
        index += 0;
        String s = express[index] + "=" + res[index].toString();
        return GestureDetector(
            child: ListTile(title: Text(s)),
            onTap: () {
              print(id[index]);
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => CalcButton(
                        id: id[index],
                        express: express[index],
                        res: res[index] + 0.0,
                      )));
            });
      },
      //分割器构造器
      separatorBuilder: (BuildContext context, int index) {
        return index % 2 == 0 ? divider1 : divider2;
      },
    );
    ;
  }
}
