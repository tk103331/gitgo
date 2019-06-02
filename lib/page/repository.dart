import 'package:flutter/material.dart';
import 'package:gitgo/widget/indicator.dart';
import 'package:github/server.dart' as github;

import '../api/base.dart';
import '../common/config.dart';
import '../common/emums.dart';
import '../widget/repo_item.dart';

class RepositoryPage extends StatefulWidget {
  final Repos _repos;

  RepositoryPage(this._repos);

  @override
  _RepositoryPageState createState() => _RepositoryPageState(_repos);
}

class _RepositoryPageState extends State<RepositoryPage> {
  List<github.Repository> _repositories = new List();
  Repos _repos = Repos.Mine;
  String _title = "我的仓库";
  bool _loaded = false;

  _RepositoryPageState(this._repos);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    switch (_repos) {
      case Repos.Mine:
        var list = await defaultClient.repositories
            .listUserRepositories(currentUser.login)
            .toList();

        setState(() {
          _repositories.addAll(list);
          _loaded = true;
          _title = "我的仓库";
        });
        break;
      case Repos.Starred:
        //TODO starred
        var list = await defaultClient.repositories
            .listRepositories(type: "private")
            .toList();

        setState(() {
          _repositories.addAll(list);
          _loaded = true;
          _title = "星标仓库";
        });
        break;
      case Repos.Trending:
        //TODO trending
        var list = await defaultClient.repositories
            .listRepositories(type: "public")
            .toList();
        setState(() {
          _repositories.addAll(list);
          _loaded = true;
          _title = "趋势仓库";
        });

        break;
    }
  }

  Widget _createItem(BuildContext context, int index) {
    if (index % 2 == 1) {
      return Divider();
    }
    var repo = _repositories[index ~/ 2];
    return RepoListItem(repo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_title),
        ),
        drawer: MainDrawer,
        body: IndicatorContainer(
          showChild: _loaded,
          child: ListView.builder(
              itemCount: _repositories.length * 2 - 1,
              itemBuilder: _createItem),
        ));
  }
}
