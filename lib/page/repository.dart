import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
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

class RepoDetailPage extends StatefulWidget {
  String _title = "";

  @override
  _RepoDetailPageState createState() => _RepoDetailPageState();
}

class _RepoDetailPageState extends State<RepoDetailPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  github.Repository _repo;
  List<github.GitHubFile> _files = List();
  String _readme;
  String _path = "";

  _RepoDetailPageState() {
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void didChangeDependencies() {
    _repo = ModalRoute.of(context).settings.arguments as github.Repository;
    _getReadme();
    _listFiles();
    super.didChangeDependencies();
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
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  Widget _createFileItem(BuildContext context, int index) {
    var file = _files[index];
    return GestureDetector(
      onTap: (){
        if (file.type == "dir") {
          if(file.name == "..") {
            _path = _path.contains("/") ? _path.substring(0, _path.lastIndexOf("/")) : "";
          } else {
            _path += "/" + file.name;
          }
          _listFiles();
        } else {

        }
      },
      child: Container(
          padding: EdgeInsets.only(left: 15),
          height: 40,
          child: Row(
            children: <Widget>[
              file.type == "dir"
                  ? Icon(Icons.folder)
                  : Icon(Icons.insert_drive_file),
              Text(file.name)
            ],
          )),
    );
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
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 137,
              child: Markdown(
                data: _readme ?? "",
              ),
            )
          ],
        ),
        Center(
          child: ListView.builder(
            itemCount: _files.length,
            itemBuilder: _createFileItem,
          ),
        ),
        Center(
          child: Text("提交"),
        ),
        Center(
          child: Text("活动"),
        ),
      ]),
    );
  }
}
