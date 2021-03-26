import 'package:flutter/material.dart';
import 'package:gitgo/common/emums.dart';
import 'package:gitgo/widget/tabbar.dart';
import 'package:github/server.dart' as github;

import '../api/service.dart';
import '../common/config.dart';
import '../widget/indicator.dart';

class IssuePage extends StatefulWidget {
  @override
  _IssuePageState createState() => _IssuePageState();
}

class _IssuePageState extends State<IssuePage>
    with SingleTickerProviderStateMixin {
  List<github.Issue> _openedIssues = [];
  List<github.Issue> _closedIssues = [];
  bool _openedLoaded = false;
  bool _closedLoaded = false;
  TabController _tabController;

  _IssuePageState() {
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void initState() {
    super.initState();
    _loadOpenedIssues();
    _loadClosedIssues();
  }

  _loadOpenedIssues() async {
    var list = await listOpenedIssues().toList();
    setState(() {
      _openedIssues.addAll(list);
      _openedLoaded = true;
    });
  }

  _loadClosedIssues() async {
    var list = await listClosedIssues().toList();
    setState(() {
      _closedIssues.addAll(list);
      _closedLoaded = true;
    });
  }

  Widget _createItem(github.Issue issue) {
    return Card(
        child: ListTile(
      leading: Image.network(issue?.user?.avatarUrl ?? ""),
      title: Text(issue?.title),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[Text(issue?.createdAt?.toString() ?? "")],
      ),
      onTap: () {
        Navigator.of(context)
            .pushNamed(Pages.IssueDetail.toString(), arguments: issue);
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("问题"),
          bottom: SizedTabBar(controller: _tabController, tabs: <Widget>[
            SizedTab(
              child: Text("开放的"),
            ),
            SizedTab(
              child: Text("关闭的"),
            ),
          ]),
        ),
        drawer: MainDrawer,
        body: TabBarView(controller: _tabController, children: [
          IndicatorContainer(
              showChild: _openedLoaded,
              child: ListView.builder(
                  itemCount: _openedIssues.length,
                  itemBuilder: (context, i) {
                    return _createItem(_openedIssues[i]);
                  })),
          IndicatorContainer(
            showChild: _closedLoaded,
            child: ListView.builder(
                itemCount: _closedIssues.length,
                itemBuilder: (context, i) {
                  return _createItem(_closedIssues[i]);
                }),
          )
        ]));
  }
}
