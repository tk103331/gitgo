import 'package:flutter/material.dart';
import 'package:gitgo/common/emums.dart';
import 'package:github/server.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class IssueDetailPage extends StatefulWidget {
  @override
  _IssueDetailPageState createState() => _IssueDetailPageState();
}

class _IssueDetailPageState extends State<IssueDetailPage> {
  Issue _issue;

  @override
  void didChangeDependencies() {
    var issue = ModalRoute.of(context).settings.arguments as Issue;
    setState(() {
      _issue = issue;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("问题#" + (_issue?.number?.toString() ?? "")),
      ),
      body: Column(
        children: <Widget>[
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Image.network(
                        _issue?.user?.avatarUrl,
                        height: 64,
                        width: 64,
                      ),
                      FlatButton(
                        child: Text(
                          _issue?.user?.login ?? "",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                              Pages.Profile.toString(),
                              arguments: _issue?.user?.login ?? "");
                        },
                      ),
                      Text(_issue.createdAt.toString())
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    _issue?.title ?? "",
                    softWrap: true,
                  ),
                ),
                Container(
                    height: 500,
                    child: Markdown(
                      data: _issue?.body ?? "",
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
