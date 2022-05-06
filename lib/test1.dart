import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study/utils/eventbus.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SharedPreferences.setMockInitialValues({});
  WidgetsFlutterBinding.ensureInitialized();
  runApp(EventBusTest());
}

class EventBusTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RaisedButton',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'RaisedButton'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // 获取事件总线

  int index = 1;
  String text = '';

  @override
  void initState() {
    super.initState();
    // 添加监听，模仿不同页面添加事件监听
    bus.on("key0", (parmas) {
      text = parmas.toString();
      print("key0");
    });
    bus.on("key1", (parmas) {
      text = parmas.toString();
      print("key1");
    });
    bus.on("key2", (parmas) {
      text = parmas.toString();
      print("key2");
    });
  }

  @override
  void dispose() {
    super.dispose();
    //widget关闭时 删除监听
    bus.off("key0");
    bus.off("key1");
    bus.off("key2");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //导航栏
        title: Text("App Name"),
        actions: <Widget>[
          //导航栏右侧菜单
          IconButton(icon: Icon(Icons.share), onPressed: () {}),
        ],
      ),
      body: Center(
        child: Text(text),
      ),
      floatingActionButton: FloatingActionButton(
        //悬浮按钮
        child: Text("emit"),
        onPressed: _onAdd, // 点击调用方法
      ),
    );
  }

  void _onAdd() {
    index++;
    setState(() {
      // 发送事件
      bus.emit(getNameByIndex(index), 2);
    });
  }

  String? getNameByIndex(index) {
    if (index % 3 == 0) {
      return 'key0';
    }
    if (index % 3 == 1) {
      return 'key1';
    }
    if (index % 3 == 2) {
      return 'key2';
    }
  }
}
