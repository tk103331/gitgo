import 'package:flutter/material.dart';
import 'package:github/server.dart' as github;

import '../api/base.dart';

class IssuePage extends StatefulWidget {
  @override
  _IssuePageState createState() => _IssuePageState();
}

class _IssuePageState extends State<IssuePage> {
  List<github.Issue> _issues = new List();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() {
    defaultClient.issues.listAll().listen((n) {
      setState(() {
        _issues.add(n);
      });
    });
  }

  Widget _createItem(BuildContext context, int index) {
    var issue = _issues[index];
    return ListTile(title: Text(issue.title));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child:
          ListView.builder(itemCount: _issues.length, itemBuilder: _createItem),
    );
  }
}
