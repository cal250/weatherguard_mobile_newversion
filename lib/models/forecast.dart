class Forecast {
  final DateTime timestamp;
  final double temperature;
  final double precipitation;
  final double windSpeed;
  final String condition;
  final String icon;

  Forecast({
    required this.timestamp,
    required this.temperature,
    required this.precipitation,
    required this.windSpeed,
    required this.condition,
    required this.icon,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      timestamp: DateTime.parse(json['timestamp']),
      temperature: (json['temperature'] as num).toDouble(),
      precipitation: (json['precipitation'] as num).toDouble(),
      windSpeed: (json['windSpeed'] as num).toDouble(),
      condition: json['condition'] ?? '',
      icon: json['icon'] ?? '',
    );
  }
} 