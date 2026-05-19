/// ============================================================
/// Notification Model - Data class for Notifications
/// ============================================================
/// Holds notification information for the notification system.
/// ============================================================

class NotificationModel {
  // Unique ID
  final String id;

  // Notification title
  final String title;

  // Notification message
  final String message;

  // Notification icon
  final String icon;

  // Timestamp
  final DateTime timestamp;

  // Whether notification has been read
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.icon,
    required this.timestamp,
    this.isRead = false,
  });

  /// Create copy with updated fields
  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    String? icon,
    DateTime? timestamp,
    bool? isRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      icon: icon ?? this.icon,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );
  }
}
