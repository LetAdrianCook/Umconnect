String getTimeAgo(DateTime dateTime) {
  DateTime now = DateTime.now();
  Duration duration = now.difference(dateTime);
  String timeAgo;

  if (duration.inDays > 365) {
    timeAgo = '${duration.inDays ~/ 365} years ago';
  } else if (duration.inDays > 30) {
    timeAgo = '${duration.inDays ~/ 30} months ago';
  } else if (duration.inDays > 7) {
    timeAgo = '${duration.inDays ~/ 7} weeks ago';
  } else if (duration.inDays > 1) {
    timeAgo = '${duration.inDays} days ago';
  } else if (duration.inHours > 0) {
    timeAgo = '${duration.inHours} hours ago';
  } else if (duration.inMinutes > 0) {
    timeAgo = '${duration.inMinutes} minutes ago';
  } else {
    timeAgo = 'just now';
  }

  return timeAgo;
}
