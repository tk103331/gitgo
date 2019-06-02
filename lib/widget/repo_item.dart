import 'package:flutter/material.dart';
import 'package:github/server.dart';

class RepoListItem extends StatelessWidget {
  Repository _repo;

  RepoListItem(this._repo);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      leading: CircleAvatar(
        child: Image.network(_repo.owner.avatarUrl),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[Text(_repo.name), Text(_repo.language ?? "")],
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
      onTap: () {},
    );
  }
}
