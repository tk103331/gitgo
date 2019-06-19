import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../common/config.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  List<Widget> _createColorItems(SettingModel model) {
    List<Widget> items = List();
    colors.forEach((name, color) {
      IconData iconData = Icons.radio_button_unchecked;
      if (color == model.themeColor) {
        iconData = Icons.radio_button_checked;
      }

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
          onChanged: (value) {},
        ),
        onTap: () {
          model.themeColor = color;
          sharedPreferences.setString("themeColor", name);
        },
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
                    decoration: BoxDecoration(color: model.themeColor)),
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
                onTap: () {},
              ),
              Divider(),
            ],
          );
        }));
  }
}
