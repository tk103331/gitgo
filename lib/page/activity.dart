import 'package:flutter/material.dart';
import '../api/base.dart';
import '../common/config.dart';

class ActivityPage extends StatefulWidget {
  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  _createItems() {
    var events = defaultClient.activity.listPublicEvents(pages: 1);

    var items = new List<Widget>();
    events.forEach((e) {
      items.add(ListTile(
        title: Row(children: [
          Image.network(e.actor?.avatarUrl ?? ""),
          Text(e.actor.name ?? ""),
          Text(e.createdAt?.toString() ?? "")
        ]),
        subtitle: Row(
          children: [
            Text(e.type ?? ""),
            Text(e.payload?.toString() ?? ""),
            Text(e.json?.toString() ?? "")
          ],
        ),
      ));
    });
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: _createItems());
  }
}
