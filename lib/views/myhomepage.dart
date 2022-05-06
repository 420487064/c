import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study/componts/list.dart';
import '../componts/mydrawer.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //文本内容监听器
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //组件
    return Scaffold(
      //头部
      appBar: AppBar(
        //头部文字
        title: const Text("主页"),
        //+按钮
        actions: <Widget>[
          //导航栏右侧菜单
          IconButton(
              icon: const Icon(Icons.add),
              //单击
              onPressed: () {
                changeLanguage();
              }),
        ],
      ),
      //主题/*  */
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: [
            //背景图
            Image.asset(
              'images/1.jpg',
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              scale: 1,
            ),
            //列表
            AnimatedListRoute()
          ],
        ),
      ),
      //抽屉
      drawer: MyDrawer(),
      //底部
      // bottomNavigationBar: BottomNavigationBar(
      //     backgroundColor: Colors.blue,
      //     selectedItemColor: Colors.white,
      //     items: const <BottomNavigationBarItem>[
      //       BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      //       BottomNavigationBarItem(
      //           icon: Icon(Icons.settings), label: "setting")
      //     ]),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.blueAccent,
        height: 60,
        items: <Widget>[
          Icon(Icons.add, size: 30),
          Icon(Icons.list, size: 30),
          Icon(Icons.compare_arrows, size: 30),
        ],
        onTap: (index) {
          //Handle button tap
        },
      ),
    );
  }

  //添加的对话框
  Future<void> changeLanguage() async {
    await showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('文本名称'),
            children: <Widget>[
              SimpleDialogOption(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(hintText: "输入文本"),
                    minLines: 1,
                    enabled: true,
                    maxLines: 5,
                  ),
                ),
              ),
              Row(
                children: [
                  const Padding(padding: EdgeInsets.only(left: 150)),
                  TextButton(
                    child: const Text("取消"),
                    onPressed: () => Navigator.of(context).pop(), //关闭对话框
                  ),
                  TextButton(
                    child: const Text("创建"),
                    onPressed: () async {
                      await Dio().get("http://119.3.138.217:3000/api/textadd",
                          queryParameters: {
                            "title": '${_nameController.text}'
                          });
                      Navigator.pushNamed(context, "myhome");
                    },
                  ),
                ],
              )
            ],
          );
        });
  }
}
