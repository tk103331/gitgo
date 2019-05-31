import 'package:flutter/material.dart';
import 'package:gitgo/widget/activity_item.dart';
import 'package:gitgo/widget/repo_item.dart';
import 'package:github/server.dart';

import '../common/config.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User _user;
  List<Event> _events = List();
  List<Repository> _repos = List();

  @override
  void didChangeDependencies() {
    _user = ModalRoute.of(context).settings.arguments as User;
//    defaultClient.activity
//        .listEventsPerformedByUser(_user.login)
//        .listen((event) {
//        _events.add(event);
//    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("个人主页"),
      ),
      drawer: MainDrawer,
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              decoration:
                  BoxDecoration(color: Theme.of(context).primaryColorLight),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Image.network(
                      _user?.avatarUrl ?? "",
                      width: 64,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(_user?.login ?? ""),
                      Text(_user?.location ?? ""),
                      Text("创建于 " + _user?.createdAt?.toString() ?? "")
                    ],
                  )
                ],
              ),
            ),
            DefaultTabController(
              length: 3,
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorLight),
                    child: TabBar(
                      tabs: <Widget>[
                        Tab(
                          child: Text("信息"),
                        ),
                        Tab(
                          child: Text("活动"),
                        ),
                        Tab(
                          child: Text("星标"),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                        child: TabBarView(
                      children: <Widget>[
                        Center(
                          child: Text("个人信息"),
                        ),
                        ListView.builder(
                          itemCount: _events.length,
                          itemBuilder: _createActivityItem,
                        ),
                        ListView.builder(itemCount: _repos.length,itemBuilder: _createRepoItem,)
                      ],
                    )),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _createActivityItem(BuildContext context, int index) {
    var event = _events[index];
    return ActivityListItem(event);
  }

  Widget _createRepoItem(BuildContext context, int index) {
    var repo = _repos[index];
    return RepoListItem(repo);
  }
}
