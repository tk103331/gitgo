import 'package:flutter/material.dart';
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

void loadSharedPreferences() async {
  sharedPreferences = await SharedPreferences.getInstance();
  var themeColor = sharedPreferences.getString("themeColor");
  var firstPage = sharedPreferences.getString("firstPage");

  if(themeColor != null) {
    themeColors.forEach((color, name){
      if(color.toString() == themeColor) {
        settingModel.themeColor = color;
      }
    });
  }

  if(firstPage != null) {
    firstPages.forEach((page, name) {
      if (page.toString() == firstPage) {
        settingModel.firstPage = page;
      }
    });
  }

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
