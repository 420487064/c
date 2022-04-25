import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../componts/calc_list.dart';

class calc_history extends StatefulWidget {
  calc_history({Key? key}) : super(key: key);

  @override
  State<calc_history> createState() => _calc_historyState();
}

class _calc_historyState extends State<calc_history> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView3(),
    );
  }
}
