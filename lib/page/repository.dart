import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gitgo/widget/activity_item.dart';
import 'package:github/server.dart' as github;

import '../api/base.dart';
import '../api/service.dart';
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
  List<github.Repository> _repositories = new List();
  Repos _repos = Repos.Mine;
  String _title = "我的仓库";
  bool _loaded = false;
  String _topic = "";

  _RepositoryPageState(this._repos);

  @override
  void initState() {
    super.initState();

  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var params = ModalRoute
        .of(context)
        .settings
        .arguments as Map<String, dynamic>;
    if(params != null) {
      _topic = params['topic'] as String;
    }
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
        var list =
            await listStarredRepositoriesByUser(currentUser.login).toList();

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
      case Repos.Topic:
        var list =
            await defaultClient.search.repositories("topic:" + _topic).toList();
        setState(() {
          _repositories.addAll(list);
          _loaded = true;
          _title = "主题 " + _topic;
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

class RepoDetailPage extends StatefulWidget {
  @override
  _RepoDetailPageState createState() => _RepoDetailPageState();
}

class _RepoDetailPageState extends State<RepoDetailPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  github.Repository _repo;
  List<github.GitHubFile> _files = List();
  List<github.Event> _events = List();
  List<github.RepositoryCommit> _commits = List();
  String _readme;
  String _path = "";
  bool _fileLoaded = false;
  bool _eventLoaded = false;
  bool _commitLoaded = false;

  _RepoDetailPageState() {
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _repo = ModalRoute.of(context).settings.arguments as github.Repository;
    _getReadme();
    _listFiles();
    _listEvents();
    _listCommits();
  }

  void _getReadme() async {
    try {
      var file = await defaultClient.repositories.getReadme(_repo.slug());
      var str = file.text;
      setState(() {
        _readme = str;
      });
    } catch (e) {
      print(e);
    }
  }

  void _listFiles() async {
    setState(() {
      _fileLoaded = false;
      _files.clear();
    });
    try {
      var contents =
          await defaultClient.repositories.getContents(_repo.slug(), _path);

      if (contents.isFile) {
        _files.add(contents.file);
      } else if (contents.isDirectory) {
        _files.addAll(contents.tree);
      }
      if (_files.length > 0) {
        var parent = github.GitHubFile()
          ..name = ".."
          ..type = "dir";
        _files.insert(0, parent);
      }
      setState(() {
        _fileLoaded = true;
      });
    } catch (e) {
      print(e);
    }
  }

  void _listCommits() async {
    try {
      var commits =
          await defaultClient.repositories.listCommits(_repo.slug()).toList();
      _commits.addAll(commits);
      setState(() {
        _commitLoaded = true;
      });
    } catch (e) {}
  }

  void _listEvents() async {
    try {
      var events = await defaultClient.activity
          .listRepositoryEvents(_repo.slug())
          .toList();
      _events.addAll(events);
      setState(() {
        _eventLoaded = true;
      });
    } catch (e) {}
  }

  Widget _createFileItem(BuildContext context, int index) {
    var file = _files[index];
    file.sourceRepository = _repo.slug();
    return ListTile(
      title: Row(
        children: <Widget>[
          file.type == "dir"
              ? Icon(Icons.folder)
              : Icon(Icons.insert_drive_file),
          Text(file.name)
        ],
      ),
      onTap: () {
        if (file.type == "dir") {
          if (file.name == "..") {
            _path = _path.contains("/")
                ? _path.substring(0, _path.lastIndexOf("/"))
                : "";
          } else {
            _path += "/" + file.name;
          }
          _listFiles();
        } else {
          Navigator.of(context)
              .pushNamed(Pages.CodeView.toString(), arguments: file);
        }
      },
    );
  }

  Widget _createCommitItem(BuildContext context, int index) {
    var commit = _commits[index];
    return ListTile(
        leading: Image.network(commit.committer.avatarUrl),
        title: Text(commit.committer.login),
        subtitle: Text(commit.commit.message));
  }

  Widget _createActivityItem(BuildContext context, int index) {
    var event = _events[0];
    return ActivityListItem(event);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_repo.name),
        actions: <Widget>[
          FlatButton(
            child: Icon(Icons.star),
            onPressed: () {},
          ),
          FlatButton(
            child: Icon(Icons.call_split),
            onPressed: () {},
          )
        ],
        bottom: TabBar(controller: _tabController, tabs: [
          Tab(
            child: Text("信息"),
          ),
          Tab(
            child: Text("文件"),
          ),
          Tab(
            child: Text("提交"),
          ),
          Tab(
            child: Text("活动"),
          ),
        ]),
      ),
      body: TabBarView(controller: _tabController, children: <Widget>[
        Column(
          children: <Widget>[
            Container(
                height: 30,
                child: Text(
                  "README",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 167,
              child: Markdown(
                data: _readme ?? "",
              ),
            )
          ],
        ),
        IndicatorContainer(
          showChild: _fileLoaded,
          child: ListView.builder(
            itemCount: _files.length,
            itemBuilder: _createFileItem,
          ),
        ),
        IndicatorContainer(
          showChild: _commitLoaded,
          child: ListView.builder(
            itemCount: _commits.length,
            itemBuilder: _createCommitItem,
          ),
        ),
        IndicatorContainer(
          showChild: _eventLoaded,
          child: ListView.builder(
            itemCount: _events.length,
            itemBuilder: _createActivityItem,
          ),
        )
      ]),
    );
  }
}
