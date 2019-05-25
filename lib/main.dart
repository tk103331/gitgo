import 'package:flutter/material.dart';
import 'api/auth.dart';
import 'api/base.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _username = "";
  String _password = "";

  String _avatarUrl = "";
  String _statusText = "";

  void _login() async {
    var success = login(_username, _password);

    if (success) {
      var currentUser = await defaultClient.users.getCurrentUser();
      setState(() {
        _avatarUrl = currentUser.avatarUrl;
        _statusText = "login success";
      });
    } else {
      setState(() {
        _statusText = "login failed";
      });
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
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                  onPressed: _login,
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
