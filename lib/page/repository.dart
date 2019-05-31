import 'package:flutter/material.dart';
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

  _RepositoryPageState(this._repos);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() {
    switch (_repos) {
      case Repos.Mine:
        defaultClient.repositories
            .listUserRepositories(currentUser.login)
            .listen((n) {
          setState(() {
            _repositories.add(n);
          });
        });
        break;
      case Repos.Starred:
        //TODO starred
        defaultClient.repositories
            .listRepositories(type: "private")
            .listen((n) {
          setState(() {
            _repositories.add(n);
          });
        });
        break;
      case Repos.Trending:
        //TODO trending
        defaultClient.repositories.listRepositories(type: "public").listen((n) {
          setState(() {
            _repositories.add(n);
          });
        });
        break;
    }
  }

  Widget _createItem(BuildContext context, int index) {
    if (index % 2 == 0) {
      return Divider();
    }
    var repo = _repositories[index ~/ 2];
    return RepoListItem(repo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("问题"),
      ),
      drawer: MainDrawer,
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: ListView.builder(
            itemCount: _repositories.length * 2, itemBuilder: _createItem),
      ),
    );
  }
}
