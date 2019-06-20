import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:github/server.dart' as github;
import 'package:oktoast/oktoast.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

import '../api/base.dart';
import '../common/emums.dart';
import '../widget/activity_item.dart';
import '../widget/indicator.dart';

class RepoDetailPage extends StatefulWidget {
  @override
  _RepoDetailPageState createState() => _RepoDetailPageState();
}

class _RepoDetailPageState extends State<RepoDetailPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  github.RepositorySlug _repoSlug;
  github.Repository _repo;
  List<github.GitHubFile> _files = List();
  List<github.Event> _events = List();
  List<github.RepositoryCommit> _commits = List();
  String _readme;
  String _path = "";
  bool _fileLoaded = false;
  bool _eventLoaded = false;
  bool _commitLoaded = false;
  bool _isStarred = false;

  _RepoDetailPageState() {
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _repoSlug =
        ModalRoute.of(context).settings.arguments as github.RepositorySlug;
    _loadData();
  }

  void _loadData() async {
    var repo = await defaultClient.repositories.getRepository(_repoSlug);
    if(mounted) {
      setState(() {
        _repo = repo;
      });
      _getReadme();
      _listFiles();
      _listEvents();
      _listCommits();
      _loadIsStarred();
    }


  }

  void _loadIsStarred() async {
    var isStarred = await defaultClient.activity.isStarred(_repo.slug());
    if (mounted) {
      setState(() {
        _isStarred = isStarred;
      });
    }
  }

  void _getReadme() async {
    try {
      var file = await defaultClient.repositories.getReadme(_repo.slug());
      var str = file.text;
      if (mounted) {
        setState(() {
          _readme = str;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void _listFiles() async {
    if (mounted) {
      setState(() {
        _fileLoaded = false;
        _files.clear();
      });
    }
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
      if (mounted) {
        setState(() {
          _fileLoaded = true;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void _listCommits() async {
    try {
      var commits =
          await defaultClient.repositories.listCommits(_repo.slug()).toList();
      _commits.addAll(commits);
      if (mounted) {
        setState(() {
          _commitLoaded = true;
        });
      }
    } catch (e) {}
  }

  void _listEvents() async {
    try {
      var events = await defaultClient.activity
          .listRepositoryEvents(_repo.slug())
          .toList();
      _events.addAll(events);
      if (mounted) {
        setState(() {
          _eventLoaded = true;
        });
      }
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

  void _handleClickStar() async {
    if (_isStarred) {
      await defaultClient.activity.unstar(_repo.slug());
      showToast("取消星标成功",
          position: ToastPosition(align: Alignment.bottomCenter));
    } else {
      await defaultClient.activity.star(_repo.slug());
      showToast("星标成功", position: ToastPosition(align: Alignment.bottomCenter));
    }
    _loadIsStarred();
  }

  void _handleTabLink(String href) async {
    var handled = false;
    if (href != null && href.length > 20) {
      var pos = href.indexOf("github.com/");
      if ( pos > -1) {
        var name = href.substring(pos + 11);
        if (name.split("/").length == 2) {
          var slug = github.RepositorySlug.full(name);
          Navigator.of(context)
              .pushNamed(Pages.RepoDetail.toString(), arguments: slug);
          handled = true;
        }
      }
    }

    if (!handled) {
      Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
        return WebviewScaffold(
          appBar: AppBar(
            title: Text(href),
            actions: <Widget>[
              FlatButton(child: Icon(Icons.open_in_browser), onPressed: () {
                _launchUrl(href);
              },)
            ],
          ),
          url: href,
          initialChild: Center(
            child: CircularProgressIndicator(),
          ),

        );
      }));
    }
  }

  void _launchUrl(String url) async {
    var can = await url_launcher.canLaunch(url);
    if(can) {
      await url_launcher.launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_repoSlug?.name ?? ""),
        actions: <Widget>[
          FlatButton(
            clipBehavior: Clip.hardEdge,
            child: Icon(
              _isStarred ? Icons.star : Icons.star_border,
              color: Colors.white70,
            ),
            onPressed: _handleClickStar,
          ),
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
                onTapLink: (href) {
                  _handleTabLink(href);
                },
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
