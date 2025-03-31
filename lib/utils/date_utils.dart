/// Utility functions for date handling in the application
class DateUtils {
  /// Calculate days left until a deadline
  /// Returns a descriptive string about the deadline status
  static String calculateDaysLeft(String? deadlineStr) {
    if (deadlineStr == null) return "No deadline";
    
    try {
      final deadline = DateTime.parse(deadlineStr);
      final now = DateTime.now();
      final difference = deadline.difference(now).inDays;
      
      if (difference < 0) {
        return "Deadline passed";
      } else if (difference == 0) {
        return "Last day to apply";
      } else {
        return "$difference days left";
      }
    } catch (e) {
      return "Invalid deadline";
    }
  }

  /// Format a DateTime object to a readable string
  static String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  /// Format a DateTime object to a time string
  static String formatTime(DateTime date) {
    return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }
  
  /// Format a DateTime object to a full datetime string
  static String formatDateTime(DateTime date) {
    return "${formatDate(date)} ${formatTime(date)}";
  }
  
  /// Check if a date is in the past
  static bool isPast(DateTime date) {
    final now = DateTime.now();
    return date.isBefore(now);
  }
  
  /// Check if a date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && 
           date.month == now.month && 
           date.day == now.day;
  }
  
  /// Get relative time description (e.g., "2 days ago", "in 3 days")
  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;
    
    if (difference == 0) {
      return "Today";
    } else if (difference < 0) {
      return "${-difference} day${-difference != 1 ? 's' : ''} ago";
    } else {
      return "in $difference day${difference != 1 ? 's' : ''}";
    }
  }
}
