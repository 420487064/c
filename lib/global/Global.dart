import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Global {
  static late Global _instance;
  late Dio dio;
  late String token;
  late Map user;

  static Global getInstance() {
    if (_instance == null) _instance = Global();
    return _instance;
  }

  Global() {
    dio = new Dio();
    dio.options = BaseOptions(
      baseUrl: "https://119.3.138.217:3000/",
      // baseUrl: "http://localhost:8080/",
      connectTimeout: 5000,
      sendTimeout: 5000,
      receiveTimeout: 5000,
      contentType: Headers.formUrlEncodedContentType,
      responseType: ResponseType.json,
    );
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        //   EasyLoading.show(status: "Loading...");
        return handler.next(options); //continue
      },
      onResponse: (response, handler) {
        //    EasyLoading.dismiss();
        return handler.next(response); // continue
      },
      onError: (DioError e, handler) {
        print(e.toString());
        //    EasyLoading.dismiss();
        String msg = "";
        if (e.type == DioErrorType.connectTimeout) {
          msg = "连接超时错误";
        } else {
          msg = "接口错误！";
        }
        //    EasyLoading.showError(msg);
      },
    ));
  }
}
