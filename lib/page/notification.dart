import 'package:flutter/material.dart';
import 'package:github/server.dart' as github;

import '../api/base.dart';
import '../common/config.dart';
import '../widget/indicator.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<github.Notification> _notifications = [];
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    var list = await defaultClient.activity.listNotifications().toList();
    setState(() {
      _notifications.addAll(list);
      _loaded = true;
    });
  }

  Widget _createItem(BuildContext context, int index) {
    var n = _notifications[index];
    return Card(child: ListTile(title: Text(n.subject?.title ?? "")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("通知"),
      ),
      drawer: MainDrawer,
      body: IndicatorContainer(
        showChild: _loaded,
        child: ListView.builder(
            itemCount: _notifications.length, itemBuilder: _createItem),
      ),
    );
  }
}
