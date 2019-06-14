import '../model/topic.dart';
import 'package:github/server.dart';
import 'base.dart';

Stream<Event> listPublicEventsReceivedByUser(String user) {
  return PaginationHelper(defaultClient).objects("GET", "/users/$user/received_events", Event.fromJSON);
}

Stream<Repository> listStarredRepositoriesByUser(String user) {
  return PaginationHelper(defaultClient).objects("GET", "/users/$user/starred", Repository.fromJSON);
}

Future<TopicResult> searchTopics(String query) {
  Map<String, String> params = Map();
  params['q'] = query;
  Map<String, String> headers = Map();
  headers['Accept'] = 'application/vnd.github.mercy-preview+json';
  return defaultClient.getJSON("/search/topics",convert: TopicResult.fromJson, params: params, headers: headers);
}

Future<TopicResult> listFeaturedTopics() {
  return searchTopics("is:featured");
}