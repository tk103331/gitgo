import 'package:flutter/material.dart';
import 'package:github/server.dart';

import '../api/service.dart';
import '../common/config.dart';
import '../widget/activity_item.dart';
import '../widget/indicator.dart';

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
  }

  @override
  void didChangeDependencies() {
    _loadMoreData();
    super.didChangeDependencies();
  }

  _loadMoreData() async {
    var events =
        await listPublicEventsReceivedByUser(currentUser.login).toList();
    if (mounted) {
      setState(() {
        _events.addAll(events);
        _loaded = true;
      });
    }
  }

  Widget _createItem(BuildContext context, int index) {
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
              itemCount: _events.length, itemBuilder: _createItem),
        ));
  }
}
