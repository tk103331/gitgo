import 'package:flutter/material.dart';
import 'package:gitgo/api/base.dart';
import 'package:gitgo/common/emums.dart';
import 'package:github/server.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  Users _type ;
  String _title = "";
  List<User> _users = List();
  RepositorySlug _repoSlug;
  String _userName;

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  void didChangeDependencies() {

    super.didChangeDependencies();
    var params =
    ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    if (params != null) {
      _type = params["type"] as Users;
      _repoSlug = params['slug'] as RepositorySlug;
      _userName = params['user'] as String;
    }
    _loadData();
  }

  void _loadData() async {
    List<User> list = List();
    switch(_type) {
      case Users.Follower:
        setState(() {
          _title = "跟随者";
        });
        list = await defaultClient.users.listCurrentUserFollowers().toList();
        break;
      case Users.Following:
        setState(() {
          _title = "跟随者";
        });

        break;
      case Users.Stargazer:
        setState(() {
          _title = "星标";
        });
        list = await defaultClient.activity.listStargazers(_repoSlug).toList();
        break;
      case Users.Watcher:
        setState(() {
          _title = "关注者";
        });
        list = await defaultClient.activity.listWatchers(_repoSlug).toList();
        break;

    }
    setState(() {
      _users.clear();
      _users.addAll(list);
    });

  }

  Widget _createUserItem(BuildContext context, int index) {
    var user = _users[index];
    return Card(
      child: ListTile(
        leading: Image.network(user.avatarUrl),
        title: Text(user.login),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title ?? ""),
      ),
      body: ListView.builder(
          itemCount: _users.length, itemBuilder: _createUserItem),
    );
  }
}
