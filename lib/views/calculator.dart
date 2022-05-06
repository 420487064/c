import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/calculator/main.dart';

class CalcButton extends StatefulWidget {
  CalcButton(
      {Key? key, required this.id, required this.express, required this.res})
      : super(key: key);
  int id;
  dynamic res;
  String express;
  @override
  _CalcButtonState createState() =>
      _CalcButtonState(this.id, this.express, this.res);
}

class _CalcButtonState extends State<CalcButton> {
  late dynamic _currentValue = 0;
  late String user;
  late String _expression = "0";
  int id;

  _CalcButtonState(this.id, this._expression, this._currentValue);

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    var calc = SimpleCalculator(
      value: _currentValue!,
      hideExpression: false,
      hideSurroundingBorder: true,
      expression: _expression,
      autofocus: true,
      onChanged: (key, value, expression) async {
        setState(() {
          _currentValue = value ?? 0;
          _expression = expression ?? "";
        });
        if (kDebugMode) {
          print('$key\t$value\t$expression');
          // if ('$key' == '=') _in('$expression\t$key\t$value\n');
          if ('$key' == '=') {
            var response = await Dio()
                .get("http://119.3.138.217:3000/api/calc/a", queryParameters: {
              "express": '${expression}',
              "res": '${value}',
              "zh": '${user}'
            });
            print(response);
          }
        }
      },
      onTappedDisplay: (value, details) {
        if (kDebugMode) {
          print('$value\t${details.globalPosition}');
        }
      },
      theme: const CalculatorThemeData(
        borderColor: Color.fromARGB(255, 255, 255, 255),
        borderWidth: 2,
        displayColor: Colors.black,
        displayStyle: TextStyle(fontSize: 80, color: Colors.yellow),
        expressionColor: Colors.indigo,
        expressionStyle: TextStyle(fontSize: 20, color: Colors.white),
        operatorColor: Color.fromARGB(255, 30, 233, 148),
        operatorStyle: TextStyle(fontSize: 30, color: Colors.white),
        commandColor: Colors.orange,
        commandStyle: TextStyle(fontSize: 30, color: Colors.white),
        numColor: Color.fromARGB(255, 192, 11, 11),
        numStyle: TextStyle(fontSize: 50, color: Colors.white),
      ),
    );
    return Scaffold(
        appBar: AppBar(
            title: const Text("计算器"),
            leading: Builder(builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed("myhome");
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            }),
            actions: <Widget>[
              //导航栏右侧菜单
              IconButton(
                  icon: const Icon(Icons.settings),
                  //单击
                  onPressed: () {
                    Navigator.of(context).pushNamed("calc_history");
                  })
            ]),
        body: SizedBox(
            height: MediaQuery.of(context).size.height * 1, child: calc));
  }

  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user = await prefs.getString('user') ?? "";
    setState(() {
      user;
    });
    print(user);
  }
}
