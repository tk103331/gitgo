import 'package:flutter/material.dart';
import '../api/base.dart';
import 'package:github/server.dart' as github;

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<github.Notification> _notifications = new List();

  initState() {
    _loadMoreData();
  }

  _loadMoreData() {
    defaultClient.activity.listNotifications().listen((n) {
      setState(() {
        _notifications.add(n);
      });
    });
  }

  Widget _createItem(BuildContext context, int index) {
    if (index < _notifications.length) {
      var n = _notifications[index];
      return ListTile(title: Text(n.subject?.title ?? "AAA"));
    } else {
      _loadMoreData();
    }
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
