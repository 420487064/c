// ignore_for_file: unnecessary_new, deprecated_member_use

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study/componts/listcard.dart';

class AnimatedListRoute extends StatefulWidget {
  const AnimatedListRoute({Key? key}) : super(key: key);

  @override
  _AnimatedListRouteState createState() => _AnimatedListRouteState();
}

class _AnimatedListRouteState extends State<AnimatedListRoute> {
  var data = <String>[];
  var id = <String>[];
  var content = <String>[];

  final globalKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
      children: [
        //UI异步函数
        FutureBuilder<String>(
          //待回调的函数
          future: mockNetworkData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            // 请求已结束
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                // 请求失败，显示错误
                return Text("Error: ${snapshot.error}");
              } else {
                // 请求成功，显示数据 
                //列表循环生成器
                return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final item = id[index];
                      final char = data[index];
                      String cid = id[index];
                      String ccontent = content[index];
                      return Dismissible(
                        key: Key(item),
                        confirmDismiss: d,
                        onDismissed: (direction) {
                          //id.removeAt(index);
                          if (direction == direction) {
                            Scaffold.of(context).showSnackBar(new SnackBar(
                                content: new Text("$direction 被删除了")));
                          }
                        },
                        // background: Container(
                        //   color: Colors.red,
                        // ),
                        // secondaryBackground: Container(
                        //   color: Colors.green,
                        // ),
                        child: listcard(
                          key: Key(cid.toString()),
                          ccontent: ccontent,
                          char: char,
                          cid: cid,
                        ),
                      );
                    });
                // AnimatedList(
                //   key: Key(UniqueKey().toString()),
                //   initialItemCount: data.length,
                //   itemBuilder: (
                //     BuildContext context,
                //     int index,
                //     Animation<double> animation,
                //   ) {
                //     //每行的数据
                //     String char = data[index];
                //     String cid = id[index];
                //     String ccontent = content[index];
                //     //添加列表项时会执行渐显动画
                //     return FadeTransition(
                //       key: Key(cid.toString()),
                //       opacity: animation,
                //       //每个列表项
                //       child: slidelistcard(
                //         key: Key(cid.toString()),
                //         ccontent: ccontent,
                //         char: char,
                //         cid: cid,
                //       ),
                //     );
                //   },
                // );
              }
            } else {
              // 请求未结束，显示loading
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ],
    ));
  }

  Future<bool?> d(_direction) {
    bool _value = false;
    return showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Row(children: <Widget>[
                Icon(Icons.settings),
                SizedBox(width: 8),
                Text(_direction == DismissDirection.endToStart
                    ? 'Delete'
                    : 'Edit')
              ]),
              content: Icon(
                  _direction == DismissDirection.endToStart
                      ? Icons.delete_forever
                      : Icons.edit,
                  color: _direction == DismissDirection.endToStart
                      ? Colors.red
                      : Colors.green),
              actions: <Widget>[
                FlatButton(
                    child: const Text('No'),
                    onPressed: () {
                      Navigator.pop(context, true);
                      _value = false;
                    }),
                FlatButton(
                    child: const Text('Yes'),
                    onPressed: () {
                      Navigator.pop(context, true);
                      _value = true;
                    })
              ]);
        }).then((val) {
      val = _value;
      return val;
    });
  }

  //请求数据
  Future<String> mockNetworkData() async {
    var response;
    var datas = <String>[];
    var ids = <String>[];
    var contents = <String>[];
    response =
        await Dio().get("http://47.112.108.20:3000/api/blogs/getRecentBlog");

    var dat = jsonDecode(response.toString()); //3
    var result = dat['blogs'];
    //  print(dat['blogs'].length);
    // print(dat['blogs'][0]['title']);

    for (var i = 0; i < result.length; i++) {
      datas.add(dat['blogs'][i]['title'].toString());
      ids.add(dat['blogs'][i]['id'].toString());
      contents.add(dat['blogs'][i]['content'].toString());
    }

    return "11";
  }

  //初始化
  void loadData() async {
    var datas = <String>[];
    var ids = <String>[];
    var contents = <String>[];
    var response =
        await Dio().get("http://47.112.108.20:3000/api/blogs/getRecentBlog");

    var dat = jsonDecode(response.toString()); //3
    var result = dat['blogs'];

    print(result);
    for (var i = 0; i < result.length; i++) {
      datas.add(dat['blogs'][i]['title'].toString());
      ids.add(dat['blogs'][i]['id'].toString());
      contents.add(dat['blogs'][i]['content'].toString());
    }
    setState(() {
      data = datas;
      id = ids;
      content = contents;
    });
    //print(data);
  }
}
