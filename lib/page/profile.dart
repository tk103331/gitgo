import 'package:flutter/material.dart';
import 'package:github/server.dart';

import '../api/base.dart';
import '../common/config.dart';
import '../widget/activity_item.dart';
import '../widget/repo_item.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User _user = null;
  List<Event> _events = List();
  List<Repository> _repos = List();

  @override
  void didChangeDependencies() {
    _user = ModalRoute.of(context).settings.arguments as User;
    defaultClient.activity
        .listEventsPerformedByUser(_user.login)
        .listen((event) {
      setState(() {
        _events.add(event);
      });
    });
    defaultClient.repositories.listRepositories().listen((repo) {
      setState(() {
        _repos.add(repo);
      });
    });
    super.didChangeDependencies();
  }

  Widget _createCountButton(String name, String count) {
    return FlatButton(
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[Text(count), Text(name)],
        ),

      ),
      onPressed: () {},
    );
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
              height: 100,
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
                  Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(_user?.login ?? ""),
                          Text(_user?.location ?? ""),
                          Text("创建于 " + _user?.createdAt?.toString() ?? "")
                        ],
                      ))
                ],
              ),
            ),
            Container(
                height: (MediaQuery.of(context).size.height - 189),
                child: DefaultTabController(
                  length: 3,
                  child: Column(
                    children: <Widget>[
                      Container(
                        color: Theme.of(context).primaryColorLight,
                        height: 40,
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
                        child: TabBarView(children: <Widget>[
                          Container(
                            child: Container(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      _user?.name ?? "",
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        _createCountButton("关注我的",
                                            _user.followersCount.toString()),
                                        _createCountButton("我关注的",
                                            _user.followingCount.toString()),
                                        _createCountButton("公开仓库",
                                            _user.publicReposCount.toString()),
                                        _createCountButton("公开Gist",
                                            _user.publicGistsCount.toString()),
                                      ],
                                    )
                                  ],
                                )),
                          ),
                          ListView.builder(
                              itemCount: _events.length * 2 - 1,
                              itemBuilder: _createActivityItem),
                          ListView.builder(
                              itemCount: _repos.length * 2 - 1,
                              itemBuilder: _createRepoItem),
                        ]),
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget _createActivityItem(BuildContext context, int index) {
    if (index % 2 == 1) {
      return Divider();
    }
    var event = _events[index ~/ 2];
    return ActivityListItem(event);
  }

  Widget _createRepoItem(BuildContext context, int index) {
    if (index % 2 == 1) {
      return Divider();
    }
    var repo = _repos[index ~/ 2];
    return RepoListItem(repo);
  }
}
