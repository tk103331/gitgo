import 'package:flutter/material.dart';
import 'package:gitgo/common/route.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/auth.dart';
import '../common/config.dart';
import '../common/emums.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _username = "";
  String _password = "";

  String _avatarUrl = "";
  String _statusText = "";

  void _login(BuildContext context) async {
    var success = await login(_username, _password);

    if (success) {
      var refs = await SharedPreferences.getInstance();
      refs.setString("username", _username);
      refs.setString("password", _password);

      routeToFirstPage(context);
    }
  }

  Widget avatarImage() {
    if (_avatarUrl == "") {
      return Image.asset("assets/images/octocat.png");
    } else {
      return Image.network(_avatarUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                avatarImage(),
                TextField(
                  decoration: InputDecoration(labelText: "用户名"),
                  onChanged: (String val) {
                    setState(() {
                      _username = val;
                    });
                  },
                ),
                TextField(
                  decoration: InputDecoration(labelText: "密码"),
                  obscureText: true,
                  onChanged: (String val) {
                    setState(() {
                      _password = val;
                    });
                  },
                ),
                ButtonBar(
                  children: <Widget>[
                    RaisedButton(
                      child: Text("登陆"),
                      onPressed: () {
                        _login(context);
                      },
                    )
                  ],
                ),
                Text(_statusText)
              ],
            ),
          ),
        ));
  }
}
