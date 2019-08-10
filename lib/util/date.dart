String beforeNow(DateTime date) {
  if (date == null) {
    return "--";
  }
  var d = DateTime.now().difference(date);
  if (d.isNegative) {
    return date.toIso8601String();
  } else if (d.inMilliseconds < 1000) {
    return "刚刚";
  } else if (d.inSeconds < 60) {
    return d.inSeconds.toString() + "秒前";
  } else if (d.inMinutes < 60) {
    return d.inMinutes.toString() + "分钟前";
  } else if (d.inHours < 24) {
    return d.inHours.toString() + "小时前";
  } else if (d.inDays < 7) {
    return d.inDays.toString() + "天前";
  } else if (d.inDays < 30) {
    return (d.inDays ~/ 7).toString() + "周前";
  } else if (d.inDays < 180) {
    return (d.inDays ~/ 30).toString() + "个月前";
  } else {
    return date.day.toString() +
        "-" +
        date.month.toString() +
        "-" +
        date.day.toString();
  }
}
