import 'package:flutter/material.dart';
import 'package:flutter_study/componts/mydrawer.dart';
import 'package:flutter_study/viewmodel/calc_history.dart';
import 'package:flutter_study/views/calc_history.dart';
import 'package:flutter_study/views/calculator.dart';
import 'package:flutter_study/views/login_view.dart';
import 'package:flutter_study/views/myhomepage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  SharedPreferences sp = await SharedPreferences.getInstance();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => calc_historyViewmodel()),
  ], child: MyApp()));
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
        "caculator": (context) => CalcButton(
              id: 0,
              res: 0.0,
              express: '0',
            ),
        "calc_history": (context) => calc_history(),
        "mydrawer": (context) => MyDrawer()
      },
      //主页面
      home: MyHomePage(),
    );
  }
}
