import 'package:flutter/material.dart';
import '../common/config.dart';
import '../common/emums.dart';
import '../widget/indicator.dart';

import '../api/service.dart';
import '../model/topic.dart';

class TopicPage extends StatefulWidget {
  @override
  _TopicPageState createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
  List<Topic> _topics = List();
  bool _loaded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData();
  }

  void _loadData() async {
    var result = await listFeaturedTopics();
    if (mounted) {
      setState(() {
        _topics.addAll(result.items);
        _loaded = true;
      });
    }
  }

  Widget _createItem(BuildContext context, int index) {
    if (index % 2 == 1) {
      return Divider();
    }
    var topic = _topics[index ~/ 2];
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(topic?.name ?? ""),
          Text(topic?.createBy ?? "")
        ],
      ),
      subtitle: Text(topic?.shortDescription ?? ""),
      onTap: () {
        Map<String, dynamic> args = Map();
        args["topic"] = topic.name;
        Navigator.of(context)
            .pushNamed(Pages.TopicRepo.toString(), arguments: args);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("主题"),
        ),
        drawer: MainDrawer,
        body: IndicatorContainer(
          showChild: _loaded,
          child: ListView.builder(
              itemCount: _topics.length * 2 - 1, itemBuilder: _createItem),
        ));
  }
}
