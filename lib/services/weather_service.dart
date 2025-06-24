import '../models/weather.dart';
import '../models/forecast.dart';

class WeatherService {
  // Simulate fetching current weather
  Future<Weather> fetchCurrentWeather(String location) async {
    await Future.delayed(const Duration(seconds: 1));
    return Weather(
      location: location,
      timestamp: DateTime.now(),
      temperature: 22.5,
      humidity: 60,
      windSpeed: 5.2,
      precipitation: 0.0,
      condition: 'Sunny',
      icon: 'sunny',
    );
  }

  // Simulate fetching forecast
  Future<List<Forecast>> fetchForecast(String location) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return List.generate(8, (i) => Forecast(
      timestamp: DateTime.now().add(Duration(hours: i)),
      temperature: 20 + i.toDouble(),
      precipitation: i % 2 == 0 ? 0.0 : 1.2,
      windSpeed: 4.0 + i,
      condition: i % 2 == 0 ? 'Sunny' : 'Cloudy',
      icon: i % 2 == 0 ? 'sunny' : 'cloudy',
    ));
  }

  // Simulate fetching historical weather data
  Future<List<Weather>> fetchHistory(String location, String range) async {
    await Future.delayed(const Duration(milliseconds: 900));
    int count = range == '24h' ? 24 : range == '7d' ? 7 : 30;
    return List.generate(count, (i) => Weather(
      location: location,
      timestamp: DateTime.now().subtract(Duration(hours: i * (range == '24h' ? 1 : 24))),
      temperature: 15 + (i % 10).toDouble(),
      humidity: 50 + (i % 20).toDouble(),
      windSpeed: 3.0 + (i % 5),
      precipitation: i % 3 == 0 ? 2.0 : 0.0,
      condition: i % 2 == 0 ? 'Rainy' : 'Clear',
      icon: i % 2 == 0 ? 'rainy' : 'clear',
    ));
  }
} 