import 'package:flutter/material.dart';
import 'package:github/server.dart' as github;

import '../api/base.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<github.Notification> _notifications = new List();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() {
    defaultClient.activity.listNotifications().listen((n) {
      setState(() {
        _notifications.add(n);
      });
    });
  }

  Widget _createItem(BuildContext context, int index) {
    var n = _notifications[index];
    return ListTile(title: Text(n.subject?.title ?? "AAA"));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: ListView.builder(
          itemCount: _notifications.length, itemBuilder: _createItem),
    );
  }
}
