import 'package:flutter/material.dart';
import '../common/config.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("个人主页"),
      ),
      drawer: MainDrawer,
      body: Container(
        child: Center(
          child: Text("个人主页"),
        ),
      ),
    );
  }
}
