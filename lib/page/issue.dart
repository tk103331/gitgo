import 'package:flutter/material.dart';
import 'package:gitgo/widget/indicator.dart';
import 'package:github/server.dart' as github;

import '../api/base.dart';
import '../common/config.dart';

class IssuePage extends StatefulWidget {
  @override
  _IssuePageState createState() => _IssuePageState();
}

class _IssuePageState extends State<IssuePage> {
  List<github.Issue> _issues = new List();
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    var list = await defaultClient.issues.listAll().toList();

    setState(() {
      _issues.addAll(list);
      _loaded = true;
    });
  }

  Widget _createItem(BuildContext context, int index) {
    var issue = _issues[index];
    return ListTile(title: Text(issue.title));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("问题"),
        ),
        drawer: MainDrawer,
        body: IndicatorContainer(
          showChild: _loaded,
          child: ListView.builder(
              itemCount: _issues.length, itemBuilder: _createItem),
        ));
  }
}
