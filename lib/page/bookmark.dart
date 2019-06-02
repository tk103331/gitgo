import 'package:flutter/material.dart';

import '../common/config.dart';

class BookmarkPage extends StatefulWidget {
  @override
  _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("书签"),
      ),
      drawer: MainDrawer,
      body: Container(
        child: Center(
          child: Text("书签"),
        ),
      ),
    );
  }
}
