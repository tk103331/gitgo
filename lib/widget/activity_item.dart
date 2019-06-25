import 'package:flutter/material.dart';
import 'package:github/server.dart';

import '../common/emums.dart';

class ActivityListItem extends StatelessWidget {
  final Event _event;

  ActivityListItem(this._event);

  void _showPopupMenu(BuildContext context) async {
    RenderBox box  = context.findRenderObject();

    Offset offset = box.localToGlobal(Offset.zero);
    var screenSize = MediaQuery.of(context).size;
    var size = box.paintBounds.size;

    var value = await showMenu(
        context: context,
        position: RelativeRect.fromLTRB(screenSize.width, offset.dy + size.height/2, 0,0),
        items: <PopupMenuItem>[
          PopupMenuItem(child: Text("跳转到：", style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 14),),enabled: false,),
          PopupMenuItem(
            child: Text("仓库"),
            value: _event?.repo,
          ),
          PopupMenuItem(
            child: Text("用户"),
            value: _event?.actor,
          )
        ]);
    if(value is Repository) {
      Navigator.of(context).pushNamed(Pages.RepoDetail.toString(), arguments: RepositorySlug.full(value.name));
    } else if (value is User) {
      Navigator.of(context).pushNamed(Pages.Profile.toString(), arguments: value.login);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.network(_event?.actor?.avatarUrl ?? "", width: 32, height: 32),
          Text(_event?.actor?.login ?? ""),
          Text(_event?.createdAt?.toLocal().toString() ?? "")
        ],
      ),
      subtitle: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(_event?.type ?? ""), Text(_event?.repo?.name ?? "")],
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
