import 'package:flutter/material.dart';

import '../common/config.dart';
import '../common/emums.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer();

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
          title: Text("个人主页"),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(Pages.Profile.toString(),
                arguments: currentUser);
          },
        ),
        ListTile(
          leading: Icon(Icons.camera),
          title: Text("活动"),
          onTap: () {
            Navigator.of(context)
                .pushReplacementNamed(Pages.Activity.toString());
          },
        ),
        ListTile(
          leading: Icon(Icons.add_alert),
          title: Text("通知"),
          onTap: () {
            Navigator.of(context)
                .pushReplacementNamed(Pages.Notification.toString());
          },
        ),
        ListTile(
          leading: Icon(Icons.live_help),
          title: Text("问题"),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(Pages.Issue.toString());
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.book),
          title: Text("我的版本库"),
          onTap: () {
            Navigator.of(context)
                .pushReplacementNamed(Pages.MineRepo.toString());
          },
        ),
        ListTile(
          leading: Icon(Icons.star),
          title: Text("星标版本库"),
          onTap: () {
            Navigator.of(context)
                .pushReplacementNamed(Pages.StarredRepo.toString());
          },
        ),
        ListTile(
          leading: Icon(Icons.bookmark),
          title: Text("书签"),
          onTap: () {
            Navigator.of(context)
                .pushReplacementNamed(Pages.Bookmark.toString());
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.search),
          title: Text("搜索"),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(Pages.Search.toString());
          },
        ),
        ListTile(
          leading: Icon(Icons.apps),
          title: Text("精选主题"),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(Pages.Topic.toString());
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text("设置"),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(Pages.Setting.toString());
          },
        ),
      ],
    ));
  }
}
