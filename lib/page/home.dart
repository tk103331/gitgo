import 'package:flutter/material.dart';

import '../widget/drawer.dart';
import '../common/config.dart';
import '../common/pages.dart';
import 'activity.dart';
import 'issue.dart';
import 'notification.dart';
import 'repository.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Pages _body = Pages.Activity;

  navTo(Pages page) {
    setState(() {
      _body = page;
    });
    Navigator.pop(context);
  }

  _createBody() {
    switch (_body) {
      case Pages.Activity:
        return ActivityPage();
      case Pages.Issue:
        return IssuePage();
      case Pages.Notification:
        return NotificationPage();
      case Pages.Repository:
        return RepositoryPage();
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
      drawer: NavDrawer(navTo),
      body: _createBody(),
    );
  }
}
