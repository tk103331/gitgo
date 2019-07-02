import 'package:flutter/material.dart';
import 'package:gitgo/common/emums.dart';
import 'package:gitgo/widget/tabbar.dart';
import 'package:github/server.dart';

import '../api/base.dart';
import '../common/config.dart';
import '../widget/indicator.dart';
import '../widget/repo_item.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  bool _repoLoaded = true;
  List<Repository> _repos = List();
  bool _userLoaded = true;
  List<User> _users = List();
  TextEditingController _textEditingController = TextEditingController();
  bool _showActions = false;

  _SearchPageState() {
    _tabController = TabController(length: 2, vsync: this);
  }

  void _search(String key) {
    _searchRepo(key);
    _searchUser(key);
  }

  void _searchRepo(String key) async {
    setState(() {
      _repos.clear();
      _repoLoaded = false;
    });
    var list = await defaultClient.search.repositories(key).toList();
    setState(() {
      _repos.addAll(list);
      _repoLoaded = true;
    });
  }

  void _searchUser(String key) async {
    setState(() {
      _users.clear();
      _userLoaded = false;
    });
    var list = await defaultClient.search.users(key).toList();
    setState(() {
      _users.addAll(list);
      _userLoaded = true;
    });
  }

  Widget _createUserItem(BuildContext context, int index) {
    var user = _users[index];
    print(user);
    return Card(
      child: ListTile(
        contentPadding: EdgeInsets.all(10),
        leading: Image.network(user.avatarUrl),
        title: Text(user.login),
        onTap: () {
          Navigator.of(context)
              .pushNamed(Pages.Profile.toString(), arguments: user.login);
        },
      ),
    );
  }

  Widget _createRepoItem(BuildContext context, int index) {
    var repo = _repos[index];
    return RepoListItem(repo);
  }

  List<Widget> _createActions() {
    if (_showActions) {
      return <Widget>[
        IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            _textEditingController.clear();
            setState(() {
              _showActions = false;
            });
          },
        )
      ];
    } else {
      return <Widget>[];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          style: TextStyle(color: Theme.of(context).primaryColorLight),
          controller: _textEditingController,
          autofocus: true,
          onSubmitted: (value) {
            _search(value);
          },
          onChanged: (value) {
            setState(() {
              _showActions = value != "";
            });
          },
        ),
        actions: _createActions(),
        bottom: SizedTabBar(
          size: Size.fromHeight(32),
          controller: _tabController,
          tabs: <Widget>[
            SizedTab(
              size: Size.fromHeight(32),
              text: "仓库",
            ),
            SizedTab(
              size: Size.fromHeight(32),
              text: "用户",
            ),
          ],
        ),
      ),
      drawer: MainDrawer,
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          IndicatorContainer(
            showChild: _repoLoaded,
            child: ListView.builder(
              itemCount: _repos.length,
              itemBuilder: _createRepoItem,
            ),
          ),
          IndicatorContainer(
            showChild: _userLoaded,
            child: ListView.builder(
              itemCount: _users.length,
              itemBuilder: _createUserItem,
            ),
          )
        ],
      ),
    );
  }
}
