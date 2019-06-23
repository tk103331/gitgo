import 'dart:convert';

import '../common/emums.dart';

class Bookmark {
  BookmarkType type;
  String repo;
  String user;

  Bookmark(this.type);

  static Bookmark fromJson(Map<String, dynamic> input) {
    var typeName = input["type"];
    if (typeName != null) {
      BookmarkType type = BookmarkType.values.firstWhere((t) {
        return t.toString() == typeName;
      });
      if (type != null) {
        Bookmark bookmark = Bookmark(type)
          ..repo = input["repo"]
          ..user = input["user"];
        return bookmark;
      }
    }
    return null;
  }

  static Bookmark fromJsonString(String input) {
    var json = jsonDecode(input) as Map<String, dynamic>;
    return fromJson(json);
  }

  String toJson() {
    return jsonEncode({
      "type": type.toString(),
      "repo": repo,
      "user": user,
    });
  }

}
