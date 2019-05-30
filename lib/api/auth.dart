import 'package:github/server.dart';

import '../common/config.dart';
import 'base.dart';

Future<bool> login(String username, String password) async {
  var client =
      createGitHubClient(auth: Authentication.basic(username, password));
  defaultClient = client;

  currentUser = await client.users.getCurrentUser();
  return defaultClient != null;
}
