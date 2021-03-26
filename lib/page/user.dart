import 'package:flutter/material.dart';
import 'package:gitgo/api/base.dart';
import 'package:gitgo/api/service.dart';
import 'package:gitgo/common/emums.dart';
import 'package:gitgo/widget/appbar.dart';
import 'package:gitgo/widget/indicator.dart';
import 'package:github/server.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  Users _type;

  String _title = "";
  String _subtitle = "";
  List<User> _users = [];
  RepositorySlug _repoSlug;
  String _userName;
  bool _loaded = false;

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
    List<User> list = [];
    switch (_type) {
      case Users.Follower:
        setState(() {
          _title = "跟随者";
          _subtitle = _userName;
        });
        list = await defaultClient.users.listUserFollowers(_userName).toList();
        break;
      case Users.Following:
        setState(() {
          _title = "跟随";
          _subtitle = _userName;
        });
        list = await listUserFollowing(_userName).toList();
        break;
      case Users.Stargazer:
        setState(() {
          _title = "星标";
          _subtitle = _repoSlug.fullName;
        });
        list = await defaultClient.activity.listStargazers(_repoSlug).toList();
        break;
      case Users.Watcher:
        setState(() {
          _title = "关注者";
          _subtitle = _repoSlug.fullName;
        });
        list = await defaultClient.activity.listWatchers(_repoSlug).toList();
        break;
    }
    if (mounted) {
      setState(() {
        _users.clear();
        _users.addAll(list);
        _loaded = true;
      });
    }
  }

  Widget _createUserItem(BuildContext context, int index) {
    var user = _users[index];
    return Card(
      child: ListTile(
        leading: Image.network(user.avatarUrl),
        title: Text(user.login),
        onTap: () {
          Navigator.of(context)
              .pushNamed(Pages.Profile.toString(), arguments: user.login);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: AppBarTitle(
            title: _title,
            subtitle: _subtitle,
          ),
        ),
        body: IndicatorContainer(
          showChild: _loaded,
          child: ListView.builder(
              itemCount: _users.length, itemBuilder: _createUserItem),
        ));
  }
}
