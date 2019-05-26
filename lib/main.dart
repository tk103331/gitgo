import 'package:flutter/material.dart';
import 'package:gitgo/widget/drawer.dart';
import 'page/login.dart';
import 'common/config.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      home: LoginPage(),
    );
  }
}
