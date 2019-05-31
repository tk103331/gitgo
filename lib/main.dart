import 'package:flutter/material.dart';
import 'package:gitgo/page/login.dart';
import 'common/emums.dart';
import 'common/route.dart';
import 'page/start.dart';

import 'common/config.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      home: MainPage(),
      routes: Routes,
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Widget _body = StartPage();
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3)).then((a) {
      print(Pages.Login.toString());

      setState(() {
        _body = LoginPage();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _body;
  }
}
