import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study/componts/switch.dart';
import 'package:flutter_study/utils/eventbus.dart';
import 'package:flutter_study/viewmodel/calc_history.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../componts/calc_list.dart';

class calc_history extends StatefulWidget {
  calc_history({Key? key}) : super(key: key);

  @override
  State<calc_history> createState() => _calc_historyState();
}

class _calc_historyState extends State<calc_history> {
  List<String> tabs = [];
  List<String> list = [];
  late String? user;
  bool _switchSelected = true;
  @override
  void initState() {
    init();
    super.initState();
  }

  Future<String> mockNetworkData() async {
    return Future.delayed(Duration(microseconds: 1), () => "我是从互联网上获取的数据");
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          appBar: AppBar(
            title: Text("历史记录"),
            leading: Builder(builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            }),
            actions: [switchchange()],
            bottom: TabBar(
              isScrollable: true,
              tabs: tabs
                  .map(
                    (e) => Tab(text: e),
                  )
                  .toList(),
              onTap: (int x) {
                print(tabs[x]);
                context.read<calc_historyViewmodel>().sets(tabs[x]);
                edit(tabs[x]);
                print("s");
                setState(() {
                  // 发送事件
                  bus.emit(1, tabs[x]);
                });
                print(context.read<calc_historyViewmodel>().gets);
              },
            ),
          ),
          body: Center(
            child: FutureBuilder<String>(
              future: mockNetworkData(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                // 请求已结束
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    // 请求失败，显示错误
                    return Text("Error: ${snapshot.error}");
                  } else {
                    // 请求成功，显示数据
                    return ListView3();
                  }
                } else {
                  // 请求未结束，显示loading
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
        ));
  }

  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user = await prefs.getString("user");
    var response = await Dio().get("http://119.3.138.217:3000/api/calc/d",
        queryParameters: {"user": user});
    var data = jsonDecode(response.toString());
    print(data['data']);
    print(data['data'].length);
    tabs.add("未登入");
    for (int i = 0; i < data['data'].length; i++) {
      String s = data['data'][i]['user'].toString();
      if (s == user)
        tabs.insert(0, s);
      else
        tabs.add(s);
    }
    context.read<calc_historyViewmodel>().sets(tabs[0]);
    setState(() {
      tabs;
    });
  }

  edit(String tab) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user = prefs.getString("user");
    var response = await Dio().get("http://119.3.138.217:3000/api/calc/e",
        queryParameters: {"zh": tab, "user": user});
    var data = jsonDecode(response.toString());
    // print(data["data"]);
    int len = data["data"].length;
    for (int i = 0; i < len; i++) {
      String s = data["data"][i]["expression"] +
          "=" +
          data["data"][i]["res"].toString();
      list.add(s);
    }
    context.read<calc_historyViewmodel>().setList(list);
    context.read<calc_historyViewmodel>().setlen(len);
  }
}
