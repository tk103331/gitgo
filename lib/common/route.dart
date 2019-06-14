import 'package:flutter/widgets.dart';

import './emums.dart';
import '../page/activity.dart';
import '../page/bookmark.dart';
import '../page/code.dart';
import '../page/issue.dart';
import '../page/notification.dart';
import '../page/profile.dart';
import '../page/repository.dart';
import '../page/search.dart';
import '../page/topic.dart';

Map<String, WidgetBuilder> mainRoutes = <String, WidgetBuilder>{
  Pages.Activity.toString(): (context) => ActivityPage(),
  Pages.Bookmark.toString(): (context) => BookmarkPage(),
  Pages.Issue.toString(): (context) => IssuePage(),
  Pages.Notification.toString(): (context) => NotificationPage(),
  Pages.Profile.toString(): (context) => ProfilePage(),
  Pages.MineRepo.toString(): (context) => RepositoryPage(Repos.Mine),
  Pages.StarredRepo.toString(): (context) => RepositoryPage(Repos.Starred),
  Pages.TrendingRepo.toString(): (context) => RepositoryPage(Repos.Trending),
  Pages.Search.toString(): (context) => SearchPage(),
  Pages.RepoDetail.toString(): (context) => RepoDetailPage(),
  Pages.CodeView.toString(): (context) => CodeViewPage(),
  Pages.Topic.toString(): (context) => TopicPage(),
  Pages.TopicRepo.toString(): (context) => RepositoryPage(Repos.Topic),
};
