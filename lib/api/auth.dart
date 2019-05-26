import 'base.dart';
import 'package:github/server.dart';
import '../common/config.dart';

Future<bool> login(String username, String password) async {
  var client =
      createGitHubClient(auth: Authentication.basic(username, password));
  defaultClient = client;
  currentUser = await client.users.getCurrentUser();
  return defaultClient != null;
}
