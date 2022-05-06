import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../views/calculator.dart';

class MyDrawer extends StatefulWidget {
  MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  late String user = "未登入";

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: MediaQuery.removePadding(
        context: context,
        //移除抽屉菜单顶部默认留白
        removeTop: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 38.0),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ClipOval(
                      child: Image.asset(
                        "images/1.jpg",
                        width: 80,
                      ),
                    ),
                  ),
                  Text(
                    user,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  if (user == "未登入")
                    ListTile(
                        leading: const Icon(Icons.add),
                        title: const Text('账号登入'),
                        onTap: () {
                          Navigator.pushNamed(context, "login");
                        }),
                  ListTile(
                    leading: const Icon(Icons.add),
                    title: const Text('计算器'),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CalcButton(
                                id: 1,
                                express: '0',
                                res: 0.0,
                              )));
                    },
                  ),
                  if (user != "未登入")
                    ListTile(
                        leading: const Icon(Icons.add),
                        title: const Text('账号退出'),
                        onTap: () {
                          pop();
                          Navigator.pushNamed(context, "myhome");
                        }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user = await prefs.getString('user') ?? "未登入";
    if (prefs.getString('user') == Null) prefs.setString('user', "未登入");
    setState(() {
      user;
    });
    print(user);
  }

  void pop() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("user", "未登入");
  }
}
