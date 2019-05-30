import 'package:flutter/material.dart';
import '../page/notification.dart';
import '../page/activity.dart';
import '../page/issue.dart';
import '../page/repository.dart';
import '../common/config.dart';

class NavDrawer extends StatelessWidget {
  final Function _navTo;
  NavDrawer(this._navTo);
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      children: <Widget>[
        UserAccountsDrawerHeader(
            accountName: Text(currentUser.name ?? ""),
            accountEmail: Text(currentUser.email ?? ""),
            currentAccountPicture: Image.network(currentUser.avatarUrl)),
        FlatButton(
          child: Text("动态"),
          onPressed: () {
            _navTo(ActivityPage());
          },
        ),
        FlatButton(
          child: Text("通知"),
          onPressed: () {
            _navTo(NotificationPage());
          },
        ),
        FlatButton(
          child: Text("问题"),
          onPressed: () {
            _navTo(IssuePage());
          },
        ),
        Divider(),
        FlatButton(
          child: Text("我的版本库"),
          onPressed: () {
            _navTo(RepositoryPage());
          },
        ),
        FlatButton(
          child: Text("星标版本库"),
          onPressed: () {
            _navTo(RepositoryPage());
          },
        ),
      ],
    ));
  }
}
