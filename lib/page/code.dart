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
  Syntax _syntax = Syntax.DART;
  SyntaxTheme _syntaxTheme = SyntaxTheme.standard();
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
          _syntax = mappingSyntax(contents.file.type);
        });
      }
    }
  }

  Syntax mappingSyntax(String type) {
    switch(type.toLowerCase()) {
      case "java":
        return Syntax.JAVA;
      case "javascript":
        return Syntax.JAVASCRIPT;
      case "kotlin":
        return Syntax.KOTLIN;
      case "swift":
        return Syntax.SWIFT;
      default:
        return Syntax.DART;
    }
  }

  List<PopupMenuItem<SyntaxTheme>> _syntaxThemes() {
    return <PopupMenuItem<SyntaxTheme>>[
      PopupMenuItem(value: SyntaxTheme.standard(),child: Text("Standard"),),
      PopupMenuItem(value: SyntaxTheme.ayuDark(),child: Text("Ayu Dark"),),
      PopupMenuItem(value: SyntaxTheme.ayuLight(),child: Text("Ayu Light"),),
      PopupMenuItem(value: SyntaxTheme.dracula(),child: Text("Dracula"),),
      PopupMenuItem(value: SyntaxTheme.gravityDark(),child: Text("Dravity Dark"),),
      PopupMenuItem(value: SyntaxTheme.gravityLight(),child: Text("Gravity Light"),),
      PopupMenuItem(value: SyntaxTheme.monokaiSublime(),child: Text("Monokai Sublime"),),
      PopupMenuItem(value: SyntaxTheme.obsidian(),child: Text("Obsidian"),),
      PopupMenuItem(value: SyntaxTheme.oceanSunset(),child: Text("Ocean Sunset"),),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_name ?? ""),
          actions: <Widget>[
            PopupMenuButton<SyntaxTheme>(
              onSelected: (SyntaxTheme theme) {
                setState(() {
                  _syntaxTheme = theme;
                });
              },
              itemBuilder: (BuildContext context) {
                return _syntaxThemes();
              },
            )
          ],
        ),
        body: SyntaxView(
          code: _text ?? "",
          withZoom: true,
          syntax: _syntax,
          syntaxTheme: _syntaxTheme,
        ));
  }
}
