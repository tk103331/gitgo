import 'package:flutter/material.dart';

import '../common/config.dart';
import '../common/emums.dart';
import 'activity.dart';
import 'bookmark.dart';
import 'issue.dart';
import 'notification.dart';
import 'profile.dart';
import 'repository.dart';
import 'search.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Pages _body = Pages.Activity;

  navTo(Pages page) {
    setState(() {
      _body = page;
    });
    Navigator.pop(context);
  }

  _createBody() {
    switch (_body) {
      case Pages.Activity:
        return ActivityPage();
      case Pages.Issue:
        return IssuePage();
      case Pages.Notification:
        return NotificationPage();
      case Pages.UserRepo:
        return RepositoryPage(Repos.User);
      case Pages.MineRepo:
        return RepositoryPage(Repos.Mine);
      case Pages.StarredRepo:
        return RepositoryPage(Repos.Starred);
      case Pages.Profile:
        return ProfilePage();
      case Pages.Bookmark:
        return BookmarkPage();
      case Pages.Search:
        return SearchPage();
      default:
        return Center(
          child: Text("Open page from drawer."),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
      ),
      drawer: MainDrawer,
      body: _createBody(),
    );
  }
}
