import 'package:flutter/material.dart';
import 'package:gitgo/page/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api/auth.dart';
import 'common/config.dart';
import 'common/emums.dart';
import 'common/route.dart';
import 'page/start.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      home: MainPage(),
      routes: mainRoutes,
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

    Future.delayed(Duration(seconds: 1)).then((a) async {
      var refs = await SharedPreferences.getInstance();
      var user = refs.getString("username");
      var pswd = refs.getString("password");
      if (user != null && user.isNotEmpty && pswd != null && pswd.isNotEmpty) {
        var success = await login(user, pswd);
        if (success) {
          Navigator.of(context).pushReplacementNamed(Pages.Activity.toString());
          return;
        }
      }
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
