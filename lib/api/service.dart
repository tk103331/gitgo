import 'package:github/server.dart';

import '../model/search.dart';
import 'base.dart';

Stream<Event> listPublicEventsReceivedByUser(String user) {
  return PaginationHelper(defaultClient)
      .objects("GET", "/users/$user/received_events", Event.fromJSON);
}

Stream<Repository> listStarredRepositoriesByUser(String user) {
  return PaginationHelper(defaultClient)
      .objects("GET", "/users/$user/starred", Repository.fromJSON);
}

Future<TopicResult> searchTopics(String query) {
  Map<String, String> params = Map();
  params['q'] = query;
  Map<String, String> headers = Map();
  headers['Accept'] = 'application/vnd.github.mercy-preview+json';
  return defaultClient.getJSON("/search/topics",
      convert: TopicResult.fromJson, params: params, headers: headers);
}

Future<TopicResult> listFeaturedTopics() {
  return searchTopics("is:featured");
}

Future<IssueResult> searchIssues(String query) {
  Map<String, String> params = Map();
  params['q'] = query;
  Map<String, String> headers = Map();
  headers['Accept'] = 'application/vnd.github.symmetra-preview+json';
  return defaultClient.getJSON("/search/issues",
      convert: IssueResult.fromJson, params: params, headers: headers);
}

Future<IssueResult> listUserOpenedIssues(String user) {
  return searchIssues("author:$user");
}

Stream<Issue> _listIssues(Map<String, String> params) {
  Map<String, String> headers = Map();
  headers['Accept'] = 'application/vnd.github.machine-man-preview';
  return new PaginationHelper(defaultClient).objects(
      "GET", "/user/issues", Issue.fromJSON,
      params: params, headers: headers);
}

Stream<Issue> listOpenedIssues() {
  Map<String, String> params = Map();
  params["filter"] = "all";
  params["state"] = "open";
  return _listIssues(params);
}

Stream<Issue> listClosedIssues() {
  Map<String, String> params = Map();
  params["filter"] = "all";
  params["state"] = "closed";
  return _listIssues(params);
}

Stream<User> listUserFollowing(String user) {
  return PaginationHelper(defaultClient)
      .objects("GET", "/users/$user/following", User.fromJson);
}

/// Lists the commits of the provided repository [slug].
///
/// API docs: https://developer.github.com/v3/repos/commits/#list-commits-on-a-repository
Stream<RepositoryCommit> listRepositoryCommits(RepositorySlug slug) {
  return new PaginationHelper(defaultClient).objects(
      "GET", "/repos/${slug.fullName}/commits", _parseRepositoryCommitFromJSON);
}

RepositoryCommit _parseRepositoryCommitFromJSON(Map<String, dynamic> input) {
  if (input == null) return null;

  var commit = new RepositoryCommit()
    ..url = input['url']
    ..sha = input['sha']
    ..htmlUrl = input['html_url']
    ..commentsUrl = input['comments_url']
    ..commit = GitCommit.fromJSON(input['commit'] as Map<String, dynamic>)
    ..author = User.fromJson(input['author'] as Map<String, dynamic>)
    ..committer = User.fromJson(input['committer'] as Map<String, dynamic>)
    ..stats = CommitStats.fromJSON(input['stats'] as Map<String, dynamic>);

  if (input['parents'] != null) {
    commit.parents = (input['parents'] as List)
        .map((parent) => GitCommit.fromJson(parent))
        .toList();
  }

  if (input['files'] != null) {
    commit.files = (input['files'] as List)
        .map((file) => CommitFile.fromJSON(file))
        .toList();
  }

  return commit;
}
