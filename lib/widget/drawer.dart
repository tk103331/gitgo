import 'package:flutter/material.dart';
import 'package:gitgo/common/emums.dart';

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
        ListTile(
          leading: Icon(Icons.account_circle),
          title: Text("主页"),
          onTap: () {
            _navTo(Pages.Profile);
          },
        ),
        ListTile(
          leading: Icon(Icons.camera),
          title: Text("动态"),
          onTap: () {
            _navTo(Pages.Activity);
          },
        ),
        ListTile(
          leading: Icon(Icons.add_alert),
          title: Text("通知"),
          onTap: () {
            _navTo(Pages.Notification);
          },
        ),
        ListTile(
          leading: Icon(Icons.live_help),
          title: Text("问题"),
          onTap: () {
            _navTo(Pages.Issue);
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.book),
          title: Text("我的版本库"),
          onTap: () {
            _navTo(Pages.MineRepo);
          },
        ),
        ListTile(
          leading: Icon(Icons.star),
          title: Text("星标版本库"),
          onTap: () {
            _navTo(Pages.StarredRepo);
          },
        ),
        ListTile(
          leading: Icon(Icons.bookmark),
          title: Text("书签"),
          onTap: () {
            _navTo(Pages.Bookmark);
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.search),
          title: Text("搜索"),
          onTap: () {
            _navTo(Pages.Search);
          },
        ),
      ],
    ));
  }
}
