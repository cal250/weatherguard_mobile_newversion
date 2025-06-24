class Weather {
  final String location;
  final DateTime timestamp;
  final double temperature;
  final double humidity;
  final double windSpeed;
  final double precipitation;
  final String condition;
  final String icon;

  Weather({
    required this.location,
    required this.timestamp,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.precipitation,
    required this.condition,
    required this.icon,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      location: json['location'] ?? '',
      timestamp: DateTime.parse(json['timestamp']),
      temperature: (json['temperature'] as num).toDouble(),
      humidity: (json['humidity'] as num).toDouble(),
      windSpeed: (json['windSpeed'] as num).toDouble(),
      precipitation: (json['precipitation'] as num).toDouble(),
      condition: json['condition'] ?? '',
      icon: json['icon'] ?? '',
    );
  }
} 