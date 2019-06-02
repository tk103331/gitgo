import 'package:flutter/material.dart';
import 'package:github/server.dart';

import '../api/base.dart';
import '../common/config.dart';
import '../widget/activity_item.dart';

class ActivityPage extends StatefulWidget {
  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  List<Event> _events = new List();
  int pages = 0;

  @override
  void initState() {
    super.initState();
    _loadMoreData();
  }

  _loadMoreData() {
    pages++;
    defaultClient.activity
        .listEventsPerformedByUser(currentUser.login)
        .listen((e) {
      setState(() {
        _events.add(e);
      });
    });
  }

  Widget _createItem(BuildContext context, int i) {
    if (i % 2 == 1) {
      return Divider();
    }
    int index = i ~/ 2;
    var e = _events[index];
    return ActivityListItem(e);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("活动"),
      ),
      drawer: MainDrawer,
      body: ListView.builder(
          itemCount: _events.length * 2 - 1, itemBuilder: _createItem),
    );
  }
}
