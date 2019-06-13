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
  return defaultClient.getJSON("/search/topics",convert: TopicResult.fromJson);
}

