import 'package:flutter/material.dart';
import 'package:gitgo/page/home.dart';
import 'package:gitgo/page/start.dart';
import 'page/login.dart';
import 'common/config.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _start = true;
  bool _logined = false;
  Widget _body = StartPage();

  void _onLogin() {
    setState(() {
      _logined = true;
      _body = HomePage();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_start) {
      Future.delayed(Duration(seconds: 3)).then((a) {
        setState(() {
          _start = false;
          if (_logined) {
            _body = HomePage();
          } else {
            _body = LoginPage(_onLogin);
          }
        });
      });
    }
    return _body;
  }
}
