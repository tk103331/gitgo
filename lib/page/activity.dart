import 'package:flutter/material.dart';
import 'package:github/server.dart';

import '../api/base.dart';
import '../common/config.dart';

class ActivityPage extends StatefulWidget {
  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  List<Event> _events = new List();
  int pages = 0;

  _ActivityPageState() {
    _loadMoreData();
  }

  _loadMoreData() {
    pages++;
    defaultClient.activity
        .listPublicEventsPerformedByUser(currentUser.login)
        .listen((e) {
      setState(() {
        print(e);
        _events.add(e);
      });
    });
  }

  Widget _createItem(BuildContext context, int i) {
    if (i >= _events.length - 1) {
      _loadMoreData();
    }
    var e = _events[i];
    return Container(
        decoration: BoxDecoration(
            color: Colors.white70,
            border: Border(top: BorderSide(color: Colors.white, width: 3.0))),
        padding: EdgeInsets.all(2),
        child: ListTile(
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.network(e.actor?.avatarUrl ?? "", width: 32, height: 32),
              Text(e.actor.login ?? ""),
              Text(e.createdAt?.toLocal().toString() ?? "")
            ],
          ),
          subtitle: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(e.type ?? ""), Text(e.repo.name ?? "")],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _events.length, itemBuilder: _createItem);
  }
}
