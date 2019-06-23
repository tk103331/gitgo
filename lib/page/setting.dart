import 'package:flutter/material.dart';
import 'package:gitgo/common/emums.dart';
import 'package:scoped_model/scoped_model.dart';
import '../common/config.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  List<Widget> _createColorItems(SettingModel model) {
    List<Widget> items = List();
    themeColors.forEach((color, name) {
      items.add(ListTile(
        leading: Container(
          width: 60,
          height: 40,
          decoration: BoxDecoration(color: color),
        ),
        title: Text(
          name,
          style: TextStyle(color: color),
        ),
        trailing: Radio(
          value: color,
          groupValue: model.themeColor,
          onChanged: (value) {
            model.themeColor = value;
            sharedPreferences.setString("themeColor", color.toString());
          },
        ),
        onTap: () {
          model.themeColor = color;
          sharedPreferences.setString("themeColor", color.toString());
        },
      ));
    });
    return items;
  }

  List<Widget> _createPageItems(SettingModel model) {
    List<Widget> items = List();
    firstPages.forEach((page, name) {
      items.add(ListTile(
        title: Text(name),

        onTap: () {
          model.firstPage = page;
          sharedPreferences.setString("firstPage", page.toString());
        },
        trailing: Radio(
          value: page,
          groupValue: model.firstPage,
          onChanged: (value) {
            model.firstPage = value;
            sharedPreferences.setString("themeColor", page.toString());
          },
        ),
      ));
    });
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("设置"),
        ),
        drawer: MainDrawer,
        body: new ScopedModelDescendant<SettingModel>(
            builder: (context, child, model) {
          return ListView(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.brush),
                title: Text("主题"),
                trailing: Container(
                    width: 60,
                    height: 40,
                    decoration:
                        BoxDecoration(color: model.themeColor ?? Colors.blue)),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                            child: Container(
                                height: 300,
                                child: ListView(
                                    children: _createColorItems(model))));
                      });
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.home),
                title: Text("起始页"),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                            child: Container(
                                height: 400,
                                child: ListView(
                                    children: _createPageItems(model))));
                      });
                },
                trailing: Text(
                  firstPages[model.firstPage] ?? "",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
              Divider(),
            ],
          );
        }));
  }
}
