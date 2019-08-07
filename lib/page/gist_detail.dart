import 'package:flutter/material.dart';
import 'package:gitgo/api/base.dart';
import 'package:gitgo/common/emums.dart';
import 'package:gitgo/widget/indicator.dart';
import 'package:github/server.dart';

class GistDetailPage extends StatefulWidget {
  @override
  _GistDetailPageState createState() => _GistDetailPageState();
}

class _GistDetailPageState extends State<GistDetailPage> {
  Gist _gist;
  List<GistFile> _files = new List();
  bool _starred = false;
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    _gist = ModalRoute.of(context).settings.arguments as Gist;
    _loadData();
    super.didChangeDependencies();
  }

  void _loadData() async {
    var starred = await defaultClient.gists.isGistStarred(_gist.id);
    setState(() {
      this._starred = starred;
    });
  }

  Widget _createItem(BuildContext context, int index) {
    var file = _files[index];

    return Card(
        child: ListTile(
      title: Text(file.name),
      onTap: () {
        Navigator.of(context)
            .pushNamed(Pages.CodeView.toString(), arguments: file);
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gist"),
        actions: <Widget>[
          FlatButton(
            child: Icon(_starred ? Icons.star : Icons.star_border),
            onPressed: () {
              if (_starred) {
                defaultClient.gists.unstarGist(_gist.id).then((result) {
                  _loadData();
                });
              } else {
                defaultClient.gists.starGist(_gist.id).then((result) {
                  _loadData();
                });
              }
            },
          )
        ],
      ),
      body: IndicatorContainer(
        showChild: _loaded,
        child: ListView.builder(
          itemCount: _files.length,
          itemBuilder: _createItem,
        ),
      ),
    );
  }
}
