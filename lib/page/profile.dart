import 'package:flutter/material.dart';
import 'package:gitgo/common/emums.dart';
import 'package:gitgo/model/bookmark.dart';
import 'package:gitgo/widget/tabbar.dart';
import 'package:github/server.dart';

import '../api/base.dart';
import '../api/service.dart';
import '../common/config.dart';
import '../widget/activity_item.dart';
import '../widget/indicator.dart';
import '../widget/repo_item.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  String _userName = "";
  User _user = null;
  List<Event> _events = List();
  bool _eventLoaded = false;
  List<Repository> _repos = List();
  bool _repoLoaded = false;
  bool _userLoaded = false;
  bool _isBookmarked = false;

  _ProfilePageState() {
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void didChangeDependencies() {
    var userName = ModalRoute.of(context).settings.arguments as String;
    setState(() {
      _userName = userName;
    });

    _loadUserData();
    _loadEventData();
    _loadRepoData();
    _loadIsBookmarked();
    super.didChangeDependencies();
  }

  void _loadUserData() async {
    _user = await defaultClient.users.getUser(_userName);
    if (mounted) {
      setState(() {
        _userLoaded = true;
      });
    }
  }

  void _loadEventData() async {
    var list = await defaultClient.activity
        .listEventsPerformedByUser(_userName)
        .toList();
    if (mounted) {
      setState(() {
        _events.addAll(list);
        _eventLoaded = true;
      });
    }
  }

  void _loadRepoData() async {
    var list = await listStarredRepositoriesByUser(_userName).toList();
    if (mounted) {
      setState(() {
        _repos.addAll(list);
        _repoLoaded = true;
      });
    }
  }

  Widget _createCountButton(String name, int count, Function function) {
    return FlatButton(
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[Text(count.toString()), Text(name)],
        ),
      ),
      onPressed: function,
    );
  }

  void _loadIsBookmarked() async {
    int index = bookmarks.indexWhere((bookmark) {
      return bookmark != null &&
          bookmark.type == BookmarkType.User &&
          bookmark.user == _userName;
    });
    setState(() {
      _isBookmarked = index > -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("个人主页"),
          actions: <Widget>[
            IconButton(
              icon:
                  Icon(_isBookmarked ? Icons.bookmark : Icons.bookmark_border),
              onPressed: () {
                var bookmark = Bookmark(BookmarkType.User)..user = _userName;
                if (_isBookmarked) {
                  delBookmark(bookmark);
                } else {
                  addBookmark(bookmark);
                }
                _loadIsBookmarked();
              },
            )
          ],
          bottom: SizedTabBar(
            controller: _tabController,
            tabs: <Widget>[
              SizedTab(
                child: Text("信息"),
              ),
              SizedTab(
                child: Text("活动"),
              ),
              SizedTab(
                child: Text("星标"),
              ),
            ],
          ),
        ),
        drawer: MainDrawer,
        body: TabBarView(controller: _tabController, children: <Widget>[
          Container(
            child: Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Card(
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
                              Text(_user?.createdAt?.toString() ?? "")
                            ],
                          ))
                    ],
                  ),
                ),
                Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        child: Text(
                          _user?.name ?? "",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          _createCountButton("跟随者", _user?.followersCount ?? 0,
                              () {
                            Navigator.of(context)
                                .pushNamed(Pages.User.toString(), arguments: {
                              "type": Users.Follower,
                              "user": _user.login
                            });
                          }),
                          _createCountButton("跟随", _user?.followingCount ?? 0,
                              () {
                            Navigator.of(context)
                                .pushNamed(Pages.User.toString(), arguments: {
                              "type": Users.Following,
                              "user": _user.login
                            });
                          }),
                          _createCountButton(
                              "公开仓库", _user?.publicReposCount ?? 0, () {
                            Navigator.of(context).pushReplacementNamed(
                                Pages.UserRepo.toString(),
                                arguments: {"user": _user.login});
                          }),
                          _createCountButton(
                              "公开Gist", _user?.publicGistsCount ?? 0, () {
                            Navigator.of(context).pushReplacementNamed(
                                Pages.MineGist.toString(),
                                arguments: _user.login);
                          }),
                        ],
                      )
                    ],
                  ),
                )
              ],
            )),
          ),
          IndicatorContainer(
            showChild: _eventLoaded,
            child: ListView.builder(
                itemCount: _events.length, itemBuilder: _createActivityItem),
          ),
          IndicatorContainer(
              showChild: _repoLoaded,
              child: ListView.builder(
                  itemCount: _repos.length, itemBuilder: _createRepoItem))
        ]));
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
