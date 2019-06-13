import 'package:github/server.dart';
import 'base.dart';

Stream<Event> listPublicEventsReceivedByUser(String user) {
  return PaginationHelper(defaultClient).objects("GET", "/users/$user/received_events", Event.fromJSON);
}

