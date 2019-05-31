import 'package:flutter/widgets.dart';
import '../page/activity.dart';
import '../page/bookmark.dart';
import '../page/issue.dart';
import '../page/notification.dart';
import '../page/profile.dart';
import '../page/repository.dart';
import '../page/search.dart';

import './emums.dart';

Map<String, WidgetBuilder> Routes = <String, WidgetBuilder>{
  Pages.Activity.toString(): (context) => ActivityPage(),
  Pages.Bookmark.toString(): (context) => BookmarkPage(),
  Pages.Issue.toString(): (context) => IssuePage(),
  Pages.Notification.toString(): (context) => NotificationPage(),
  Pages.Profile.toString(): (context) => ProfilePage(),
  Pages.MineRepo.toString(): (context) => RepositoryPage(Repos.Mine),
  Pages.StarredRepo.toString(): (context) => RepositoryPage(Repos.Starred),
  Pages.TrendingRepo.toString(): (context) => RepositoryPage(Repos.Trending),
  Pages.Search.toString(): (context) => SearchPage(),
};
