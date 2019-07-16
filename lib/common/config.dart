import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gitgo/model/bookmark.dart';
import 'package:github/server.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widget/drawer.dart';
import 'emums.dart';

String appTitle = "Git Go!";
CurrentUser currentUser = null;
const Widget MainDrawer = const NavDrawer();
SharedPreferences sharedPreferences = null;
SettingModel settingModel = new SettingModel();
List<Bookmark> bookmarks = List();

void loadSharedPreferences() async {
  sharedPreferences = await SharedPreferences.getInstance();
  var themeColor = sharedPreferences.getString("themeColor");
  var firstPage = sharedPreferences.getString("firstPage");

  if (themeColor != null) {
    themeColors.forEach((color, name) {
      if (color.toString() == themeColor) {
        settingModel.themeColor = color;
      }
    });
  }

  if (firstPage != null) {
    firstPages.forEach((page, name) {
      if (page.toString() == firstPage) {
        settingModel.firstPage = page;
      }
    });
  }

  loadBookmarks();
}

void _removeBookmark(Bookmark bookmark) {
  bookmarks.removeWhere((item) {
    return bookmark == item ||
        (item.type == bookmark.type &&
            item.user == bookmark.user &&
            item.repo == bookmark.repo);
  });
}

void loadBookmarks() {
  String bookmarkJson = sharedPreferences.getString("bookmarks");
  if (bookmarkJson != null) {
    try {
      var list = jsonDecode(bookmarkJson) as List;
      list.forEach((item) {
        var input = jsonDecode(item) as Map<String, dynamic>;
        var bookmark = Bookmark.fromJson(input);
        if (bookmark != null) {
          _removeBookmark(bookmark);
          bookmarks.add(bookmark);
        }
      });
    } catch (e) {}
  }
}

void addBookmark(Bookmark bookmark) {
  _removeBookmark(bookmark);
  bookmarks.add(bookmark);
  sharedPreferences.setString("bookmarks", jsonEncode(bookmarks));
}

void delBookmark(Bookmark bookmark) {
  _removeBookmark(bookmark);
  sharedPreferences.setString("bookmarks", jsonEncode(bookmarks));
}

class SettingModel extends Model {
  Color _themeColor = Colors.blue;
  FirstPage _firstPage = FirstPage.Activity;

  set themeColor(Color color) {
    _themeColor = color;
    notifyListeners();
  }

  get themeColor {
    return _themeColor;
  }

  set firstPage(FirstPage firstPage) {
    _firstPage = firstPage;
    notifyListeners();
  }

  get firstPage {
    return _firstPage;
  }
}

final Map<Color, String> themeColors = <Color, String>{
  Colors.blue: "蓝色",
  Colors.red: "红色",
  Colors.green: "绿色",
  Colors.yellow: "黄色",
  Colors.purple: "紫色",
};

final Map<FirstPage, String> firstPages = <FirstPage, String>{
  FirstPage.Profile: "个人主页",
  FirstPage.Activity: "活动",
  FirstPage.Notification: "通知",
  FirstPage.Issue: "问题",
  FirstPage.MineRepo: "我的仓库",
  FirstPage.StarredRepo: "星标仓库",
  FirstPage.Bookmark: "书签",
  FirstPage.Topic: "精选主题",
};
