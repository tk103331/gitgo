

String beforeNow(DateTime dateTime) {
  var d = dateTime.difference(DateTime.now());
  if(d.isNegative) {
    return dateTime.toIso8601String();
  } else if(d.inMilliseconds < 1000) {
    return "1秒前";
  } else if(d.inSeconds < 60) {
    return "1分钟前";
  } else if(d.inMinutes < 60) {
    return "1小时前";
  }
}