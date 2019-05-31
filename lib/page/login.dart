import 'package:flutter/material.dart';
import '../common/emums.dart';
import '../api/auth.dart';
import '../common/config.dart';

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
      Navigator.of(context).pushReplacementNamed(Pages.Profile.toString());
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            avatarImage(),
            TextField(
              decoration: InputDecoration(labelText: "Username"),
              onChanged: (String val) {
                setState(() {
                  _username = val;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: "Password"),
              onChanged: (String val) {
                setState(() {
                  _password = val;
                });
              },
            ),
            ButtonBar(
              children: <Widget>[
                RaisedButton(
                  child: Text("Login"),
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
    );
  }
}
