import 'package:flutter/material.dart';
import '../page/notification.dart';
import '../page/activity.dart';
import '../page/issue.dart';
import '../page/repository.dart';
import '../common/config.dart';

class NavDrawer extends StatelessWidget {
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
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return ActivityPage();
            }));
          },
        ),
        FlatButton(
          child: Text("通知"),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return NotificationPage();
            }));
          },
        ),
        FlatButton(
          child: Text("问题"),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return IssuePage();
            }));
          },
        ),
        Divider(),
        FlatButton(
          child: Text("我的版本库"),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return RepositoryPage();
            }));
          },
        ),
        FlatButton(
          child: Text("星标版本库"),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return RepositoryPage();
            }));
          },
        ),
      ],
    ));
  }
}
