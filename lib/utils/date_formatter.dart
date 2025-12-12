import 'package:intl/intl.dart';

class DateFormatter {
  static String formatHour(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  static String formatDayName(DateTime date) {
    final now = DateTime.now();
    if (date.day == now.day && date.month == now.month) {
      return 'Today';
    }
    if (date.day == now.day + 1 && date.month == now.month) {
      return 'Tomorrow';
    }
    return DateFormat('EEE').format(date);
  }

  static String formatFullDate(DateTime date) {
    return DateFormat('EEEE, dd MMMM').format(date);
  }

  static String formatShortDate(DateTime date) {
    return DateFormat('dd/MM').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  static String getTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }
}
