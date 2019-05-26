import 'package:flutter/material.dart';
import '../common/config.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        UserAccountsDrawerHeader(
            accountName: Text(currentUser.name ?? ""),
            accountEmail: Text(currentUser.email ?? ""),
            currentAccountPicture: Image.network(currentUser.avatarUrl)),
        Divider(),
        FlatButton(
          child: Text("Activity"),
          onPressed: () {},
        )
      ],
    );
  }
}
