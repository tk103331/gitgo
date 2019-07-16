import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

final Size _defaultSize = Size.fromHeight(32);

class SizedTabBar extends TabBar {
  final Size size;

  SizedTabBar({
    Key key,
    @required List<Widget> tabs,
    this.size,
    TabController controller,
    bool isScrollable = false,
    Color indicatorColor,
    double indicatorWeight = 2.0,
    EdgeInsets indicatorPadding = EdgeInsets.zero,
    Decoration indicator,
    TabBarIndicatorSize indicatorSize,
    Color labelColor,
    TextStyle labelStyle,
    EdgeInsets labelPadding,
    Color unselectedLabelColor,
    TextStyle unselectedLabelStyle,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ValueChanged<int> onTap,
  }) : super(
            key: key,
            tabs: tabs,
            controller: controller,
            isScrollable: isScrollable,
            indicatorColor: indicatorColor,
            indicatorWeight: indicatorWeight,
            indicatorPadding: indicatorPadding,
            indicator: indicator,
            indicatorSize: indicatorSize,
            labelColor: labelColor,
            labelStyle: labelStyle,
            labelPadding: labelPadding,
            unselectedLabelColor: unselectedLabelColor,
            unselectedLabelStyle: unselectedLabelStyle,
            dragStartBehavior: dragStartBehavior,
            onTap: onTap);

  @override
  Size get preferredSize {
    if (size != null) {
      return size;
    }
    return _defaultSize;
  }
}

class SizedTab extends Tab {
  final Size size;

  SizedTab({
    Key key,
    this.size,
    String text,
    Widget icon,
    Widget child,
  }) : super(text: text, icon: icon, child: child);

  @override
  Widget build(BuildContext context) {
    var sizedBox = super.build(context) as SizedBox;
    var _size = _defaultSize;
    if (size != null) {
      _size = size;
    }
    return SizedBox(
        key: sizedBox.key,
        width: _size.width,
        height: _size.height,
        child: sizedBox.child);
  }
}
