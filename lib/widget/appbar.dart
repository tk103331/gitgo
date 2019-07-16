import 'package:flutter/material.dart';

class AppBarTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  final TextStyle subtitleStyle;

  AppBarTitle(
      {@required this.title, @required this.subtitle, this.subtitleStyle});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(this.title),
        Text(
          this.subtitle,
          style: this.subtitleStyle ??
              TextStyle(
                  fontSize: 10, color: Theme.of(context).primaryColorLight),
        )
      ],
    );
  }
}
