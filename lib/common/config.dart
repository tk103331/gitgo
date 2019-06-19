import 'package:flutter/material.dart';
import 'package:github/server.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widget/drawer.dart';

String appTitle = "Git Go!";
CurrentUser currentUser = null;
const Widget MainDrawer = const NavDrawer();
SharedPreferences sharedPreferences = null;
SettingModel settingModel = new SettingModel();

void loadSharedPreferences() async {
  sharedPreferences = await SharedPreferences.getInstance();
  var color = sharedPreferences.getString("themeColor");

  if (colors.containsKey(color)) {
    settingModel.themeColor = colors[color];
  }
}

class SettingModel extends Model {
  Color _themeColor = Colors.blue;

  set themeColor(Color color) {
    _themeColor = color;
    notifyListeners();
  }

  get themeColor {
    return _themeColor;
  }
}

final Map<String, Color> colors = <String, Color>{
  "blue": Colors.blue,
  "red": Colors.red,
  "green": Colors.green,
  "yellow": Colors.yellow,
  "purple": Colors.purple,
};
