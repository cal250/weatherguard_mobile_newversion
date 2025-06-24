import 'package:flutter/material.dart';
import '../models/weather.dart';
import '../models/forecast.dart';
import '../services/weather_service.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();

  Weather? _currentWeather;
  List<Forecast>? _forecast;
  List<Weather>? _history;
  String _location = 'New York';
  String _historyRange = '24h';
  bool _loading = false;
  String? _error;

  Weather? get currentWeather => _currentWeather;
  List<Forecast>? get forecast => _forecast;
  List<Weather>? get history => _history;
  String get location => _location;
  String get historyRange => _historyRange;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> loadWeather() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _currentWeather = await _weatherService.fetchCurrentWeather(_location);
      _forecast = await _weatherService.fetchForecast(_location);
    } catch (e) {
      _error = 'Failed to load weather data';
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> loadHistory() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _history = await _weatherService.fetchHistory(_location, _historyRange);
    } catch (e) {
      _error = 'Failed to load history data';
    }
    _loading = false;
    notifyListeners();
  }

  void setLocation(String location) {
    _location = location;
    loadWeather();
    loadHistory();
  }

  void setHistoryRange(String range) {
    _historyRange = range;
    loadHistory();
  }
} 