import 'package:flutter/material.dart';

class IndicatorContainer extends StatefulWidget {
  Widget child;
  bool showChild = false;

  IndicatorContainer({@required this.child, @required this.showChild});

  @override
  _IndicatorContainerState createState() => _IndicatorContainerState();
}

class _IndicatorContainerState extends State<IndicatorContainer> {
  @override
  Widget build(BuildContext context) {
    return widget.showChild
        ? widget.child
        : Center(child: CircularProgressIndicator());
  }
}
