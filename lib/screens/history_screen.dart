import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/weather_provider.dart';
import '../models/weather.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final List<String> _ranges = ['24h', '7d', '30d'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WeatherProvider>(context, listen: false).loadHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final history = weatherProvider.history;
    final loading = weatherProvider.loading;
    final error = weatherProvider.error;
    final selectedRange = weatherProvider.historyRange;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather History'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: _ranges.map((range) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ChoiceChip(
                  label: Text(range),
                  selected: selectedRange == range,
                  onSelected: (selected) {
                    if (selected) {
                      weatherProvider.setHistoryRange(range);
                    }
                  },
                ),
              )).toList(),
            ),
            const SizedBox(height: 24),
            if (loading)
              const Center(child: CircularProgressIndicator())
            else if (error != null)
              Center(child: Text(error, style: const TextStyle(color: Colors.red)))
            else if (history != null && history.isNotEmpty)
              Expanded(
                child: ListView(
                  children: [
                    _HistoryChart(
                      title: 'Temperature Trend',
                      color: Colors.blue,
                      spots: history.map((w) => FlSpot(w.timestamp.millisecondsSinceEpoch.toDouble(), w.temperature)).toList(),
                      minY: history.map((w) => w.temperature).reduce((a, b) => a < b ? a : b) - 2,
                      maxY: history.map((w) => w.temperature).reduce((a, b) => a > b ? a : b) + 2,
                      labelFormatter: (x) => _formatTimestamp(x, selectedRange),
                      valueFormatter: (y) => '${y.toStringAsFixed(1)}°C',
                    ),
                    const SizedBox(height: 32),
                    _HistoryChart(
                      title: 'Precipitation History',
                      color: Colors.indigo,
                      spots: history.map((w) => FlSpot(w.timestamp.millisecondsSinceEpoch.toDouble(), w.precipitation)).toList(),
                      minY: 0,
                      maxY: history.map((w) => w.precipitation).reduce((a, b) => a > b ? a : b) + 2,
                      labelFormatter: (x) => _formatTimestamp(x, selectedRange),
                      valueFormatter: (y) => '${y.toStringAsFixed(1)} mm',
                    ),
                    const SizedBox(height: 32),
                    _HistoryChart(
                      title: 'Wind Speed History',
                      color: Colors.teal,
                      spots: history.map((w) => FlSpot(w.timestamp.millisecondsSinceEpoch.toDouble(), w.windSpeed)).toList(),
                      minY: 0,
                      maxY: history.map((w) => w.windSpeed).reduce((a, b) => a > b ? a : b) + 2,
                      labelFormatter: (x) => _formatTimestamp(x, selectedRange),
                      valueFormatter: (y) => '${y.toStringAsFixed(1)} m/s',
                    ),
                  ],
                ),
              )
            else
              const Center(child: Text('No history data available.')),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(double millis, String range) {
    final dt = DateTime.fromMillisecondsSinceEpoch(millis.toInt());
    if (range == '24h') {
      return '${dt.hour}:00';
    } else {
      return '${dt.month}/${dt.day}';
    }
  }
}

class _HistoryChart extends StatelessWidget {
  final String title;
  final Color color;
  final List<FlSpot> spots;
  final double minY;
  final double maxY;
  final String Function(double) labelFormatter;
  final String Function(double) valueFormatter;

  const _HistoryChart({
    required this.title,
    required this.color,
    required this.spots,
    required this.minY,
    required this.maxY,
    required this.labelFormatter,
    required this.valueFormatter,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  minY: minY,
                  maxY: maxY,
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 40, getTitlesWidget: (value, meta) => Text(valueFormatter(value), style: const TextStyle(fontSize: 10))),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 32, getTitlesWidget: (value, meta) => Text(labelFormatter(value), style: const TextStyle(fontSize: 10))),
                    ),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(show: true, drawVerticalLine: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: color,
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(show: true, color: color.withOpacity(0.12)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 