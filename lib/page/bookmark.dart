import 'package:flutter/material.dart';
import 'package:github/server.dart';

import '../api/base.dart';
import '../common/config.dart';
import '../common/emums.dart';
import '../model/bookmark.dart';

class BookmarkPage extends StatefulWidget {
  @override
  _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  List<Bookmark> _bookmarks = new List();

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  void _loadData() async {
    loadBookmarks();
    setState(() {
      _bookmarks.addAll(bookmarks);
    });
  }

  void _routeTo(Bookmark bookmark) async {
    switch (bookmark.type) {
      case BookmarkType.User:
        var user = await defaultClient.users.getUser(bookmark.user);
        Navigator.of(context)
            .pushNamed(Pages.Profile.toString(), arguments: user);
        break;
      case BookmarkType.Repository:
        var slug = RepositorySlug.full(bookmark.repo);
        Navigator.of(context)
            .pushNamed(Pages.RepoDetail.toString(), arguments: slug);
        break;
    }
  }

  Widget _createItem(BuildContext context, int index) {
    var bookmark = _bookmarks[index];
    IconData iconData;
    switch (bookmark.type) {
      case BookmarkType.Repository:
        iconData = Icons.book;
        break;
      case BookmarkType.User:
        iconData = Icons.account_box;
        break;
    }
    return Dismissible(
        key: Key(bookmark.toJson()),
        onDismissed: (direction) {
          _bookmarks.removeAt(index);
          delBookmark(bookmark);
          _loadData();
        },
        child: Card(
          child: ListTile(
            leading: Icon(iconData),
            title: Text(bookmark.user),
            onTap: () {
              _routeTo(bookmark);
            },
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("书签"),
      ),
      drawer: MainDrawer,
      body: ListView.builder(
        itemCount: _bookmarks.length,
        itemBuilder: _createItem,
      ),
    );
  }
}
