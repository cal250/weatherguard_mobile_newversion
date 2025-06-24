import 'package:flutter/material.dart';
import '../models/notification.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<WeatherNotification> _notifications = [
    WeatherNotification(
      id: '1',
      title: 'Rain Alert',
      message: 'Rain expected in your area at 3 PM.',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      read: false,
    ),
    WeatherNotification(
      id: '2',
      title: 'High Wind Warning',
      message: 'Winds up to 40 km/h expected tomorrow.',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      read: false,
    ),
    WeatherNotification(
      id: '3',
      title: 'Clear Skies',
      message: 'No precipitation expected today.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      read: true,
    ),
  ];

  void _markAsRead(int index) {
    setState(() {
      _notifications[index] = WeatherNotification(
        id: _notifications[index].id,
        title: _notifications[index].title,
        message: _notifications[index].message,
        timestamp: _notifications[index].timestamp,
        read: true,
      );
    });
  }

  void _dismiss(int index) {
    setState(() {
      _notifications.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: _notifications.isEmpty
          ? const Center(child: Text('No notifications'))
          : ListView.builder(
              itemCount: _notifications.length,
              itemBuilder: (context, i) {
                final n = _notifications[i];
                return Dismissible(
                  key: ValueKey(n.id),
                  background: Container(
                    color: Colors.green,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 24),
                    child: const Icon(Icons.done, color: Colors.white),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 24),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    if (direction == DismissDirection.startToEnd) {
                      _markAsRead(i);
                    } else {
                      _dismiss(i);
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: n.read ? Colors.grey[100] : Colors.blue[50],
                      border: Border(
                        left: BorderSide(
                          color: n.read ? Colors.grey : Colors.blue,
                          width: 4,
                        ),
                      ),
                    ),
                    child: ListTile(
                      title: Text(n.title, style: TextStyle(fontWeight: n.read ? FontWeight.normal : FontWeight.bold)),
                      subtitle: Text(n.message),
                      trailing: Text(
                        _formatTime(n.timestamp),
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      onTap: () => _markAsRead(i),
                    ),
                  ),
                );
              },
            ),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    if (dt.day == now.day && dt.month == now.month && dt.year == now.year) {
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } else {
      return '${dt.month}/${dt.day}';
    }
  }
} 