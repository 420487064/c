import 'package:flutter/material.dart';
import 'package:flutter_study/views/calc_history.dart';
import 'package:flutter_study/views/calculator.dart';
import 'package:flutter_study/views/login_view.dart';
import 'package:flutter_study/views/myhomepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SharedPreferences.setMockInitialValues({});
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

//程序运行入口
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      //主题页面
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //跳转路由
      routes: {
        "login": (context) => const LoginView(),
        "myhome": (context) => const MyHomePage(),
        //   "caculator": (context) => CalcButton(),
        "calc_history": (context) => calc_history()
      },
      //主页面
      home: MyHomePage(),
    );
  }
}
