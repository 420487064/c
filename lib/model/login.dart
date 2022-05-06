import 'package:flutter_study/global/Global.dart';

Future loginModel(String user, String pwd) async {
  return await Global.getInstance().dio.post(
    "/zxw/user",
    queryParameters: {
      "username": user,
      "password": pwd,
    },
  );
}

Future tokenLoginModel() async {
  return await Global.getInstance().dio.get("/zxw/user");
}
