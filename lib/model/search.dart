import 'package:github/server.dart';
import 'topic.dart';

abstract class SearchResult<T> {
  int totalCount;
  bool incompleteResults;
  List<T> items;
}

SearchResult<T> _fromJson<T>(SearchResult<T> result, Map<String, dynamic> input,
    JSONConverter<Map<String, dynamic>, T> converter) {
  result.totalCount = input["total_count"];
  result.incompleteResults = input["incomplete_results"];

  var items = input['items'] as List;
  if (items != null) {
    items.forEach((it) {
      var json = it as Map<String, dynamic>;
      result.items.add(converter(json));
    });
  }

  return result;
}

class TopicResult extends SearchResult<Topic> {
  static TopicResult fromJson(Map<String, dynamic> input) {
    SearchResult result = TopicResult();
    result.items = List<Topic>();
    return _fromJson(result, input, Topic.fromJson);
  }
}

class IssueResult extends SearchResult<Issue> {
  static IssueResult fromJson(Map<String, dynamic> input) {
    SearchResult result = IssueResult();
    result.items = List<Issue>();
    return _fromJson(result, input, Issue.fromJSON);
  }
}
