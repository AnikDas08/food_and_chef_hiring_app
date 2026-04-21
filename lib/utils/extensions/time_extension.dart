import 'package:intl/intl.dart';

extension StringExtension on String? {
  String get checkTime {
    if (this == null || this!.isEmpty) return '';

    try {
      // Parse the ISO 8601 string to DateTime
      final DateTime dateTime = DateTime.parse(this!).toLocal();
      final DateTime now = DateTime.now();
      final Duration difference = now.difference(dateTime);

      if (difference.inSeconds < 60) {
        return 'Just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else {
        // For older dates, show the actual date (e.g., 03 Mar 2026)
        return DateFormat('dd MMM yyyy').format(dateTime);
      }
    } catch (e) {
      return '';
    }
  }
}