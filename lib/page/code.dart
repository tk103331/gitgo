import 'package:flutter/material.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'package:gitgo/api/base.dart';
import 'package:github/server.dart';

class CodeViewPage extends StatefulWidget {
  @override
  _CodeViewPageState createState() => _CodeViewPageState();
}

class _CodeViewPageState extends State<CodeViewPage> {
  GitHubFile _file;
  String _name = "";
  String _text = "";
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _file = ModalRoute.of(context).settings.arguments as GitHubFile;
    _getFileContent();
    setState(() {
      _name = _file.name;
    });
  }

  void _getFileContent() async {
    if (_file != null) {
      var contents = await defaultClient.repositories
          .getContents(_file.sourceRepository, _file.path);
      if (contents.isFile) {
        setState(() {
          _text = contents.file.text;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_name ?? ""),
        ),
        body: SyntaxView(
          code: _text ?? "",
          withZoom: true,
          syntax: Syntax.DART,
          syntaxTheme: SyntaxTheme.dracula(),
        ));
  }
}
