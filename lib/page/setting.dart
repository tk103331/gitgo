import 'package:flutter/material.dart';
import '../common/config.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("设置"),
        ),
        drawer: MainDrawer,
        body: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.brush),
              title: Text("主题"),
              onTap: (){},
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("起始页"),
              onTap: (){},
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.language),
              title: Text("语言"),
              onTap: (){},
            ),
            Divider(),
          ],
        ));
  }
}
