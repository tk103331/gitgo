class Topic {
  String name;
  String displayName;
  String description;
  String shortDescription;
  String createBy;

  static Topic fromJson(Map<String, dynamic> input) {
    if (input == null) return null;
    return new Topic()
      ..name = input['name']
      ..displayName = input['display_name']
      ..description = input['description']
      ..shortDescription = input['short_description']
      ..createBy = input["created_by"];
  }

}

class TopicResult {
  int totalCount;
  bool incompleteResults;
  List<Topic> items;

  static TopicResult fromJson(Map<String, dynamic> input) {
    var result = new TopicResult()
        ..totalCount = input["total_count"]
        ..incompleteResults = input["incomplete_results"];

    var items = input['items'] as List;
    items.map((it){
      var json = it as Map<String, dynamic>;
      return Topic.fromJson(json);
    });
    return result;
  }
}
