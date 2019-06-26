import 'package:flutter/widgets.dart';

import './emums.dart';
import '../page/activity.dart';
import '../page/bookmark.dart';
import '../page/code.dart';
import '../page/issue.dart';
import '../page/notification.dart';
import '../page/profile.dart';
import '../page/repo_detail.dart';
import '../page/repository.dart';
import '../page/search.dart';
import '../page/setting.dart';
import '../page/topic.dart';
import '../page/user.dart';
import 'config.dart';

Map<String, WidgetBuilder> mainRoutes = <String, WidgetBuilder>{
  Pages.Activity.toString(): (context) => ActivityPage(),
  Pages.Bookmark.toString(): (context) => BookmarkPage(),
  Pages.Issue.toString(): (context) => IssuePage(),
  Pages.Notification.toString(): (context) => NotificationPage(),
  Pages.Profile.toString(): (context) => ProfilePage(),
  Pages.MineRepo.toString(): (context) => RepositoryPage(Repos.Mine),
  Pages.UserRepo.toString(): (context) => RepositoryPage(Repos.User),
  Pages.StarredRepo.toString(): (context) => RepositoryPage(Repos.Starred),
  Pages.Search.toString(): (context) => SearchPage(),
  Pages.RepoDetail.toString(): (context) => RepoDetailPage(),
  Pages.CodeView.toString(): (context) => CodeViewPage(),
  Pages.Topic.toString(): (context) => TopicPage(),
  Pages.TopicRepo.toString(): (context) => RepositoryPage(Repos.Topic),
  Pages.Setting.toString(): (context) => SettingPage(),
  Pages.User.toString(): (context) => UserPage(),
};

void routeToFirstPage(BuildContext context) {
  var page = settingModel.firstPage;

  switch (page) {
    case FirstPage.Activity:
      Navigator.of(context).pushReplacementNamed(Pages.Activity.toString());
      break;
    case FirstPage.Profile:
      Navigator.of(context).pushReplacementNamed(Pages.Profile.toString(),
          arguments: currentUser);
      break;
    case FirstPage.Notification:
      Navigator.of(context).pushReplacementNamed(Pages.Notification.toString());
      break;
    case FirstPage.Issue:
      Navigator.of(context).pushReplacementNamed(Pages.Issue.toString());
      break;
    case FirstPage.MineRepo:
      Navigator.of(context).pushReplacementNamed(Pages.MineRepo.toString());
      break;
    case FirstPage.StarredRepo:
      Navigator.of(context).pushReplacementNamed(Pages.StarredRepo.toString());
      break;
    case FirstPage.Bookmark:
      Navigator.of(context).pushReplacementNamed(Pages.Bookmark.toString());
      break;
    case FirstPage.Topic:
      Navigator.of(context).pushReplacementNamed(Pages.Topic.toString());
      break;
    default:
      Navigator.of(context).pushReplacementNamed(Pages.Activity.toString());
  }
}
