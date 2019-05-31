import 'package:flutter/material.dart';
import '../common/config.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("搜索"),
      ),
      drawer: MainDrawer,
      body: Container(
        child: Center(
          child: Text("搜索"),
        ),
      ),
    );
  }
}
