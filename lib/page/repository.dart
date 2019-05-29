import 'package:flutter/material.dart';
import 'package:github/server.dart' as github;
import '../api/base.dart';
import '../common/config.dart';

class RepositoryPage extends StatefulWidget {
  @override
  _RepositoryPageState createState() => _RepositoryPageState();
}

class _RepositoryPageState extends State<RepositoryPage> {
  List<github.Repository> _repositories = new List();

  @override
  initState() async {
    return _loadMoreData();
  }

  _loadMoreData() {
    defaultClient.repositories
        .listUserRepositories(currentUser.login)
        .listen((n) {
      setState(() {
        _repositories.add(n);
      });
    });
  }

  Widget _createItem(BuildContext context, int index) {
    if (index < _repositories.length) {
      var repo = _repositories[index];
      return ListTile(title: Text(repo.name));
    } else {
      _loadMoreData();
    }
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
