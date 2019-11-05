class Utils {
  /// 日期信息转换，距离当前时间
  /// [dateTime] 时间
  static getTimeInfo(DateTime dateTime) {
    final DateTime now = DateTime.now();
    final int diff = now.millisecondsSinceEpoch - dateTime.millisecondsSinceEpoch;
    if (diff < 0) return '';
    if (diff / 1000 < 60) return '刚刚';
    if (diff / 60000 < 60) return '${(diff / 60000).floor()}分钟前';
    if (diff / 3600000 < 24) return '${(diff / 3600000).floor()}小时前';
    if (diff / 86400000 < 31) return '${(diff / 86400000).floor()}天前';
    if (diff / 2592000000 < 12) return '${(diff / 2592000000).floor()}月前';
    return '${(diff / 31536000000).floor()}年前';
  }
}