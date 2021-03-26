import 'package:flutter/material.dart';
import 'package:gitgo/api/base.dart';
import 'package:gitgo/common/config.dart';
import 'package:gitgo/common/emums.dart';
import 'package:github/server.dart';

class GistPage extends StatefulWidget {
  final Gists _gists;

  GistPage(this._gists);

  @override
  _GistPageState createState() => _GistPageState(this._gists);
}

class _GistPageState extends State<GistPage> {
  Gists _gistsType;
  List<Gist> _gists = [];
  
  String _user = "";

  _GistPageState(this._gistsType);

  @override
  void didChangeDependencies() {
    _user = ModalRoute.of(context).settings.arguments as String;
    _initData();
    super.didChangeDependencies();
  }

  void _initData() async {
    setState(() {
      _gists.clear();
    });
    List<Gist> list = [];

    switch (_gistsType) {
      case Gists.Mine:
        list = await defaultClient.gists.listCurrentUserGists().toList();
        break;
      case Gists.User:
        list = await defaultClient.gists.listUserGists(_user).toList();
    }
    setState(() {
      _gists.addAll(list);
    });
  }

  Widget _createItem(BuildContext context, int index) {
    var gist = _gists[index];

    return Card(
      child: ListTile(
        title: Text(gist.description),
        onTap: () {
          Navigator.of(context).pushNamed(Pages.GistDetail.toString(), arguments: gist);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gist"),
      ),
      body: ListView.builder(
        itemCount: _gists.length,
        itemBuilder: _createItem,
      ),
      drawer: MainDrawer,
    );
  }
}
