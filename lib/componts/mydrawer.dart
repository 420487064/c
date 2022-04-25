import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../views/calculator.dart';

class MyDrawer extends StatefulWidget {
  MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String? user = "账号未登入";

  @override
  void initState() {
    // TODO: implement initState
    init();
    setState(() {
      user;
    });
    super.initState();
  }

  void init() async {
    final prefs = await SharedPreferences.getInstance();
    user = prefs.getString('user') ?? "账号未登入";
  }

  Future<String> mockNetworkData() async {
    return Future.delayed(Duration(seconds: 1), () => "我是从互联网上获取的数据");
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
                  FutureBuilder<String>(
                    future: mockNetworkData(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      // 请求已结束
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          // 请求失败，显示错误
                          return Text("Error: ${snapshot.error}");
                        } else {
                          // 请求成功，显示数据
                          return Text(
                            user!,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          );
                        }
                      } else {
                        // 请求未结束，显示loading
                        return CircularProgressIndicator();
                      }
                    },
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
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
                      //    Navigator.pushNamed(context, "caculator",
                      //      arguments: {"id": 1});

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CalcButton(id: 1)));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class $ {}

// class MyDrawer extends StatelessWidget {
//   const MyDrawer({
//     Key? key,
//   }) : super(key: key);
 
  
// }
