import 'package:flutter/material.dart';
import 'package:gitgo/widget/appbar.dart';
import 'package:github/server.dart' as github;

import '../api/base.dart';
import '../common/config.dart';
import '../common/emums.dart';
import '../widget/indicator.dart';
import '../widget/repo_item.dart';

class RepositoryPage extends StatefulWidget {
  final Repos _repos;

  RepositoryPage(this._repos);

  @override
  _RepositoryPageState createState() => _RepositoryPageState(_repos);
}

class _RepositoryPageState extends State<RepositoryPage> {
  List<github.Repository> _repositories = [];
  Repos _repos = Repos.Mine;
  Widget _title = Text("我的仓库");
  bool _loaded = false;
  String _topic = "";
  String _user = "";

  _RepositoryPageState(this._repos);

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var params =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    if (params != null) {
      _topic = params['topic'] as String;
      _user = params['user'] as String;
    }
    _loadData();
  }

  _loadData() async {
    switch (_repos) {
      case Repos.User:
        if (mounted) {
          setState(() {
            _title = AppBarTitle(
              title: "公共仓库",
              subtitle: _user ?? "",
            );
          });
        }
        var list = await defaultClient.repositories
            .listUserRepositories(_user)
            .toList();
        if (mounted) {
          setState(() {
            _repositories.addAll(list);
            _loaded = true;
          });
        }
        break;
      case Repos.Mine:
        if (mounted) {
          setState(() {
            _title = Text("我的仓库");
          });
        }
        var list = await defaultClient.repositories
            .listUserRepositories(currentUser.login)
            .toList();
        if (mounted) {
          setState(() {
            _repositories.addAll(list);
            _loaded = true;
          });
        }
        break;
      case Repos.Starred:
        if (mounted) {
          setState(() {
            _title = Text("星标仓库");
          });
        }
        // var list =
        //     await listStarredRepositoriesByUser(currentUser.login).toList();
        var list = await defaultClient.activity
            .listStarredByUser(currentUser.login)
            .toList();
        if (mounted) {
          setState(() {
            _repositories.addAll(list);
            _loaded = true;
            _title = Text("星标仓库");
          });
        }
        break;
      case Repos.Topic:
        if (mounted) {
          setState(() {
            _title = Text("主题 " + _topic);
          });
        }
        var list =
            await defaultClient.search.repositories("topic:" + _topic).toList();
        setState(() {
          _repositories.addAll(list);
          _loaded = true;
        });
        break;
    }
  }

  Widget _createItem(BuildContext context, int index) {
    var repo = _repositories[index];
    return RepoListItem(repo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: _title,
        ),
        drawer: MainDrawer,
        body: IndicatorContainer(
          showChild: _loaded,
          child: ListView.builder(
              itemCount: _repositories.length, itemBuilder: _createItem),
        ));
  }
}
