import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study/views/text.dart';
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
  late String _expression = "0";
  int id;

  _CalcButtonState(this.id, this._expression, this._currentValue);

  @override
  void initState() {
    super.initState();
    // init();
    // print(_currentValue);
    // print(_expression);
  }

  // void init() async {
  //   print("id:");
  //   print(id);
  //   var response = await Dio().get("http://47.112.108.20:3000/api/calc/c",
  //       queryParameters: {"id": id});
  //   var dat = jsonDecode(response.toString());
  //   var result = dat['data'];
  //   print("result");
  //   print(dat);
  //   print("express");
  //   print(result[0]['expression']);
  //   setState(() {
  //     _currentValue = result[0]['res'] as double?;
  //     _expression = result[0]['expression'].toString();
  //   });
  // }

  // Future<String> _in(String s) async {
  //   final SharedPreferences prefs = await _prefs;
  //   String counter = prefs.getString('counter') ?? "";
  //   counter = counter + s;
  //   // print("result:" + counter);
  //   ccontent = counter;
  //   setState(() {
  //     _counter = prefs.setString('counter', counter).then((bool success) {
  //       return counter;
  //     });
  //   });
  //   return "error";
  // }

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
                .get("http://47.112.108.20:3000/api/calc/a", queryParameters: {
              "express": '${expression}',
              "res": '${value}'
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
        appBar: AppBar(title: const Text("计算器"), actions: <Widget>[
          //导航栏右侧菜单
          IconButton(
              icon: const Icon(Icons.settings),
              //单击
              onPressed: () {
                //        print("content");
                //          print(ccontent);
                Navigator.pushNamed(context, "calc_history");
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) =>
                //        text(
                //         id: "计算器",
                //         content: "${ccontent}",
                //       ),
                //     ));
                // Navigator.of(context).pushNamed("text",
                //     arguments: {"id": "计算器", "content": "${_counter}"});
              })
        ]),
        body: SizedBox(
            height: MediaQuery.of(context).size.height * 1, child: calc)
        // FutureBuilder<String>(
        //   future: mockNetworkData(),
        //   builder: (BuildContext context, AsyncSnapshot snapshot) {
        //     // 请求已结束
        //     if (snapshot.connectionState == ConnectionState.done) {
        //       if (snapshot.hasError) {
        //         // 请求失败，显示错误
        //         return Text("Error: ${snapshot.error}");
        //       } else {
        //         // 请求成功，显示数据
        //         return SizedBox(
        //             height: MediaQuery.of(context).size.height * 1,
        //             child: calc);
        //       }
        //     } else {
        //       // 请求未结束，显示loading
        //       return Center(child: CircularProgressIndicator());
        //     }
        //   },
        // )
        );
  }
}
