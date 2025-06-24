import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../models/forecast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WeatherProvider>(context, listen: false).loadWeather();
    });
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final weather = weatherProvider.currentWeather;
    final forecast = weatherProvider.forecast;
    final loading = weatherProvider.loading;
    final error = weatherProvider.error;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Guard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => weatherProvider.loadWeather(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location search
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter location',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      weatherProvider.setLocation(_controller.text);
                    }
                  },
                  child: const Text('Search'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Current weather
            if (loading)
              const Center(child: CircularProgressIndicator())
            else if (error != null)
              Center(child: Text(error, style: const TextStyle(color: Colors.red)))
            else if (weather != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: Icon(
                          _getWeatherIcon(weather.icon),
                          key: ValueKey(weather.icon),
                          size: 64,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            weather.location,
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${weather.temperature.toStringAsFixed(1)}°C',
                            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            weather.condition,
                            style: const TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _WeatherStat(icon: Icons.water_drop, label: 'Humidity', value: '${weather.humidity.toStringAsFixed(0)}%'),
                      _WeatherStat(icon: Icons.air, label: 'Wind', value: '${weather.windSpeed.toStringAsFixed(1)} m/s'),
                      _WeatherStat(icon: Icons.grain, label: 'Precip.', value: '${weather.precipitation.toStringAsFixed(1)} mm'),
                    ],
                  ),
                ],
              ),
            const SizedBox(height: 32),
            // Forecast
            Text('Forecast', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            if (loading)
              const Center(child: CircularProgressIndicator())
            else if (forecast != null)
              SizedBox(
                height: 120,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: forecast.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, i) {
                    final Forecast f = forecast[i];
                    return _ForecastCard(forecast: f);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getWeatherIcon(String icon) {
    switch (icon) {
      case 'sunny':
        return Icons.wb_sunny;
      case 'cloudy':
        return Icons.cloud;
      case 'rainy':
        return Icons.grain;
      case 'clear':
        return Icons.nightlight_round;
      default:
        return Icons.wb_cloudy;
    }
  }
}

class _WeatherStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _WeatherStat({required this.icon, required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.blueAccent),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _ForecastCard extends StatelessWidget {
  final Forecast forecast;
  const _ForecastCard({required this.forecast});
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(_getWeatherIcon(forecast.icon), size: 32, color: Colors.blueAccent),
          const SizedBox(height: 8),
          Text('${forecast.temperature.toStringAsFixed(1)}°C', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text('${forecast.timestamp.hour}:00', style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  IconData _getWeatherIcon(String icon) {
    switch (icon) {
      case 'sunny':
        return Icons.wb_sunny;
      case 'cloudy':
        return Icons.cloud;
      case 'rainy':
        return Icons.grain;
      case 'clear':
        return Icons.nightlight_round;
      default:
        return Icons.wb_cloudy;
    }
  }
} 