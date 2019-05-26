import 'package:flutter/material.dart';
import 'package:gitgo/page/activity.dart';
import 'package:gitgo/widget/drawer.dart';
import '../common/config.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _bodyName = "activity";

  navTo(Widget body) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return body;
    }));
  }

  _createBody() {
    switch (_bodyName) {
      case "activity":
        return ActivityPage();
    }
    return Center(
      child: Text("Open page from drawer."),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
      ),
      drawer: NavDrawer(),
      body: _createBody(),
    );
  }
}
