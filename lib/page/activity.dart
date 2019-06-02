import 'package:flutter/material.dart';
import 'package:gitgo/widget/indicator.dart';
import 'package:github/server.dart';

import '../api/base.dart';
import '../common/config.dart';
import '../widget/activity_item.dart';

class ActivityPage extends StatefulWidget {
  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  bool _loaded = false;
  List<Event> _events = new List();

  @override
  void initState() {
    super.initState();
    _loadMoreData();
  }

  _loadMoreData() async {
    var list = await defaultClient.activity
        .listEventsPerformedByUser(currentUser.login)
        .toList();


    setState(() {
      _events.addAll(list);
      _loaded = true;
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
        body: IndicatorContainer(
          showChild: _loaded,
          child: ListView.builder(
              itemCount: _events.length * 2 - 1, itemBuilder: _createItem),
        ));
  }
}
