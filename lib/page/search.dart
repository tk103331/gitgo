import 'package:flutter/material.dart';
import 'package:github/server.dart';
import '../api/base.dart';
import '../common/config.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Repository> _repos = List();
  List<User> _users = List();
  TextEditingController _textEditingController = TextEditingController();
  bool _showActions = false;

  void _search(String key) {
    _repos.clear();
    _users.clear();
    setState(() {});
    if (key != "") {
      defaultClient.search.repositories(key).listen((repo) {
        setState(() {
          _repos.add(repo);
        });
      });
      defaultClient.search.users(key).listen((user) {
        setState(() {
          _users.add(user);
        });
      });
    }
  }

  Widget _createUserItem(BuildContext context, int index) {
    if (index % 2 == 0) {
      return Divider();
    }
    var user = _users[index ~/ 2];
    print(user);
    return Container(
      child: ListTile(
        leading: Image.network(user.avatarUrl),
        title: Text(user.login),
      ),
    );
  }

  Widget _createRepoItem(BuildContext context, int index) {
    if (index % 2 == 0) {
      return Divider();
    }
    var repo = _repos[index ~/ 2];
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

  List<Widget> _createActions() {
    if (_showActions) {
      return <Widget>[
        FlatButton(
          child: Icon(Icons.close),
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
      ),
      drawer: MainDrawer,
      body: Container(
          child: DefaultTabController(
        length: 2,
        child: Column(
          children: <Widget>[
            Container(
                height: 40,
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
                child: TabBar(
                  indicatorColor: Colors.black54,
                  tabs: <Widget>[
                    Tab(
                      text: "仓库",
                    ),
                    Tab(
                      text: "用户",
                    ),
                  ],
                )),
            Expanded(
              child: Container(
                child: TabBarView(
                  children: <Widget>[
                    ListView.builder(
                      itemCount: _repos.length * 2,
                      itemBuilder: _createRepoItem,
                    ),
                    ListView.builder(
                      itemCount: _users.length * 2,
                      itemBuilder: _createUserItem,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
