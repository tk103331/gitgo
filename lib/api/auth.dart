import 'base.dart';
import 'package:github/server.dart';

bool login(String username, String password) {
  var client =
      createGitHubClient(auth: Authentication.basic(username, password));
  defaultClient = client;
  return defaultClient != null;
}
