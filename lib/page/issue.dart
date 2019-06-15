import 'package:flutter/material.dart';
import 'package:github/server.dart' as github;

import '../api/service.dart';
import '../common/config.dart';
import '../widget/indicator.dart';

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
    var list = await listUserOpenedIssues(currentUser.login);

    setState(() {
      _issues.addAll(list.items);
      _loaded = true;
    });
  }

  Widget _createItem(BuildContext context, int index) {
    var issue = _issues[index];
    return Card(
        child: ListTile(
      leading: Image.network(issue?.user?.avatarUrl ?? ""),
      title: Text(issue?.title),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
            Text(issue?.createdAt?.toString()??"")
          ],),
    ));
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
