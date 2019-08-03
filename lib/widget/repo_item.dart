import 'package:flutter/material.dart';
import 'package:github/server.dart';
import 'package:github/src/const/language_color.dart';
import '../common/emums.dart';

class RepoListItem extends StatelessWidget {
  final Repository _repo;

  RepoListItem(this._repo);

  Color _langColor(String lang) {
    var colorStr = languagesColor[lang];
    if (colorStr != null) {
      var r = colorStr.substring(1, 3);
      var g = colorStr.substring(3, 5);
      var b = colorStr.substring(5, 7);
      return Color.fromARGB(255, int.parse(r, radix: 16), int.parse(g, radix: 16),
          int.parse(b, radix: 16));
    }
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      leading: CircleAvatar(
        child: Image.network(_repo.owner.avatarUrl),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(_repo.name),
          Text(
            _repo.language ?? "",
            style: TextStyle(color: _langColor(_repo.language ?? "")),
          )
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(_repo.description?.trim() ?? "", softWrap: true),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(Icons.star, size: 14),
              Expanded(
                child: Text(_repo.stargazersCount?.toString() ?? "0"),
              ),
              Icon(Icons.call_split, size: 14),
              Expanded(
                child: Text(_repo.forksCount?.toString() ?? "0"),
              ),
              Icon(Icons.account_circle, size: 14),
              Text(_repo.owner?.login ?? "")
            ],
          )
        ],
      ),
      onTap: () {
        Navigator.of(context)
            .pushNamed(Pages.RepoDetail.toString(), arguments: _repo.slug());
      },
    ));
  }
}
