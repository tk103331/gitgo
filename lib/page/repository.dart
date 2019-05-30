import 'package:flutter/material.dart';
import '../common/emums.dart';
import 'package:github/server.dart' as github;
import '../api/base.dart';
import '../common/config.dart';

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
    if (_repos == Repos.Mine) {
      defaultClient.repositories
          .listUserRepositories(currentUser.login)
          .listen((n) {
        setState(() {
          _repositories.add(n);
        });
      });
    } else {
      // TODO starred repos
    }
  }

  Widget _createItem(BuildContext context, int index) {
    var repo = _repositories[index];
    return ListTile(title: Text(repo.name));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: ListView.builder(
          itemCount: _repositories.length, itemBuilder: _createItem),
    );
  }
}
