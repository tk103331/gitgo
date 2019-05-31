import 'package:flutter/material.dart';
import 'package:github/server.dart' as github;

import '../api/base.dart';
import '../common/config.dart';
import '../common/emums.dart';

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
    return ListTile(
      leading: CircleAvatar(
        child: Image.network(repo.owner.avatarUrl),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[Text(repo.name), Text(repo.language ?? "")],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(repo.description?.trim() ?? "", softWrap: true),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(Icons.star, size: 14),
              Expanded(
                child: Text(repo.stargazersCount?.toString() ?? "0"),
              ),
              Icon(Icons.call_split, size: 14),
              Expanded(
                child: Text(repo.forksCount?.toString() ?? "0"),
              ),
              Icon(Icons.account_circle, size: 14),
              Text(repo.owner?.login ?? "")
            ],
          )
        ],
      ),
      onTap: () {},
    );
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
