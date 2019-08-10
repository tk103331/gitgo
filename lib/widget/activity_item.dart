import 'package:flutter/material.dart';
import 'package:github/server.dart';
import 'package:gitgo/util/date.dart';

import '../common/emums.dart';

class ActivityListItem extends StatelessWidget {
  final Event _event;

  ActivityListItem(this._event);

  void _showPopupMenu(BuildContext context) async {
    RenderBox box = context.findRenderObject();

    Offset offset = box.localToGlobal(Offset.zero);
    var screenSize = MediaQuery.of(context).size;
    var size = box.paintBounds.size;

    var value = await showMenu(
        context: context,
        position: RelativeRect.fromLTRB(
            screenSize.width, offset.dy + size.height / 2, 0, 0),
        items: <PopupMenuItem>[
          PopupMenuItem(
            child: Text(
              "跳转到：",
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 14),
            ),
            enabled: false,
          ),
          PopupMenuItem(
            child: Text("仓库"),
            value: _event?.repo,
          ),
          PopupMenuItem(
            child: Text("用户"),
            value: _event?.actor,
          )
        ]);
    if (value is Repository) {
      Navigator.of(context).pushNamed(Pages.RepoDetail.toString(),
          arguments: RepositorySlug.full(value.name));
    } else if (value is User) {
      Navigator.of(context)
          .pushNamed(Pages.Profile.toString(), arguments: value.login);
    }
  }

  Widget _eventIcon(String eventType) {
    switch (eventType) {
      case "CreateEvent":
        return Icon(
          Icons.add_circle,
          size: 16,
        );
      case "WatchEvent":
        return Icon(Icons.star, size: 16);
      case "ForkEvent":
        return Icon(Icons.call_split, size: 16);
      case "IssuesEvent":
        return Icon(Icons.help, size: 16);
      case "IssueCommentEvent":
        return Icon(Icons.comment, size: 16);
      case "PullRequestEvent":
        return Icon(Icons.settings_ethernet, size: 16);
      default:
        return Text(eventType);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      leading: Image.network(_event?.actor?.avatarUrl ?? ""),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(_event?.actor?.login ?? ""),
          Text(beforeNow(_event?.createdAt))
        ],
      ),
      subtitle: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _eventIcon(_event?.type ?? ""),
          Text(_event?.repo?.name ?? "", style: TextStyle(fontSize: 10),)
        ],
      ),
      onLongPress: () {
        _showPopupMenu(context);
      },
      onTap: () {
        Navigator.of(context).pushNamed(Pages.RepoDetail.toString(),
            arguments: RepositorySlug.full(_event.repo.name));
      },
    ));
  }
}
