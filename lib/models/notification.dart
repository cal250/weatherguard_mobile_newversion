class WeatherNotification {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final bool read;

  WeatherNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.read,
  });

  factory WeatherNotification.fromJson(Map<String, dynamic> json) {
    return WeatherNotification(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      timestamp: DateTime.parse(json['timestamp']),
      read: json['read'] ?? false,
    );
  }
} 