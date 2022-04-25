import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study/utils/fluttertoast.dart';
import 'package:flutter_study/views/myhomepage.dart';
import 'package:path/path.dart';
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
    // TODO: implement initState
    super.initState();
    loadData();
  }

  void loadData() async {
    var result =
        await Dio().get("http://47.112.108.20:3000/api/blogs/getRecentBlog");
    print(result);
  }

// Container(
//           //  height: 609,
//           decoration: const BoxDecoration(
//               image: DecorationImage(
//                   image: AssetImage('images/1.jpg'), fit: BoxFit.fill)),

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
                  print('${_controller1.text}');
                  print('${_controller2.text}');
                  var response = await Dio().get(
                      "http://47.112.108.20:3000/api/user/id",
                      queryParameters: {
                        "user": '${_controller1.text}',
                        "pw": '${_controller2.text}'
                      });
                  print(response);
                  var dat = jsonDecode(response.toString()); //3

                  if (response == true) {
                    Fluttertoast.showToast(
                        msg: "账号或者密码错误",
                        textColor: Color.fromARGB(255, 175, 29, 29));
                  }
                  // print(response);

                  //   print(dat['data'][0]['pw']);
                  //  print("111");

                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('user', dat['data'][0]['user']);
                  print("setstring");
                  print(dat['data'][0]['user']);
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => MyHomePage()),
                      (route) => route == null);
                },
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 30)),
              ),
              // onTap: () {
              //   print('${_controller1.text}');
              //   print('${_controller2.text}');
              //   var response = Dio().get(
              //       "http://47.112.108.20:3000/api/user/id",
              //       queryParameters: {
              //         "user": '${_controller1.text}',
              //         "pw": '${_controller2.text}'
              //       });

              //   var dat = jsonDecode(response.toString()); //3
              //   print(dat['data'][0]['pw']);

              //   Navigator.of(context).pushAndRemoveUntil(
              //       MaterialPageRoute(builder: (context) => MyHomePage()),
              //       (route) => route == null);
              // },
              // )
            ],
          ),
        ),
      ),
    );
  }
}
