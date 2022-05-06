import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study/utils/fluttertoast.dart';
import 'package:flutter_study/views/myhomepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  @override
  void initState() {
    loadData();
    super.initState();
  }

  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _controller1.text = await prefs.getString("name")!;
    print(_controller1.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("登录"),
        centerTitle: true,
        elevation: 10,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Image.asset("images/1.jpg",
                  width: double.infinity, height: 200, fit: BoxFit.fill),
              const SizedBox(height: 16),
              TextFormField(
                controller: _controller1,
                decoration: const InputDecoration(
                    labelText: "账号",
                    hintText: "请输入账号",
                    prefixIcon: Icon(Icons.padding)),
                validator: (val) =>
                    (val == null || val.isEmpty) ? "账号不能为空" : null,
                autofocus: false,
                textInputAction: TextInputAction.next,
              ),
              TextFormField(
                controller: _controller2,
                decoration: const InputDecoration(
                    labelText: "密码",
                    hintText: "请输入密码",
                    prefixIcon: Icon(Icons.lock)),
                obscureText: true,
                textInputAction: TextInputAction.send,
                validator: (val) =>
                    (val == null || val.isEmpty) ? "密码不能为空" : null,
              ),
              const SizedBox(height: 16),
              GestureDetector(
                child: const SizedBox(
                  width: double.infinity,
                  child: Text(
                    "找回密码",
                    style: TextStyle(color: Colors.blue),
                    textAlign: TextAlign.right,
                  ),
                ),
                onTap: () {
                  // ignore: avoid_print
                  print("找回密码");
                },
              ),
              const SizedBox(height: 16),
              //  GestureDetector(
              ElevatedButton.icon(
                icon: const Icon(Icons.send),
                label: const Text("登录"),
                onPressed: () async {
                  var response = await Dio().get(
                      "http://119.3.138.217:3000/api/user/id",
                      queryParameters: {
                        "user": '${_controller1.text}',
                        "pw": '${_controller2.text}'
                      });
                  var dat = await jsonDecode(response.toString()); //3
                  print("response");
                  print(response);
                  print(dat["success"]);
                  if (dat["success"] == false) {
                    print("false");
                    Fluttertoast.showToast(
                        msg: "账号或者密码错误",
                        backgroundColor: Colors.blue,
                        textColor: Color.fromARGB(255, 255, 255, 255));
                  } else {
                    print("true");
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setString('name', _controller1.text);
                    await prefs.setString('user', _controller1.text);
                    print("prefs");
                    print(prefs.getString("user"));

                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => MyHomePage()),
                        (route) => route == null);
                    Fluttertoast.showToast(
                        msg: "登入成功",
                        backgroundColor: Color.fromARGB(255, 255, 255, 255),
                        gravity: ToastGravity.TOP,
                        textColor: Colors.blue);
                  }
                },
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 30)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
