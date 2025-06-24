import 'package:flutter/material.dart';

class RadarScreen extends StatefulWidget {
  const RadarScreen({Key? key}) : super(key: key);

  @override
  State<RadarScreen> createState() => _RadarScreenState();
}

class _RadarScreenState extends State<RadarScreen> {
  int _currentFrame = 0;
  final int _totalFrames = 6;
  bool _playing = false;

  @override
  void dispose() {
    _playing = false;
    super.dispose();
  }

  void _playPause() async {
    setState(() {
      _playing = !_playing;
    });
    if (_playing) {
      while (_playing && _currentFrame < _totalFrames - 1) {
        await Future.delayed(const Duration(milliseconds: 400));
        if (!_playing) break;
        setState(() {
          _currentFrame++;
        });
      }
      setState(() {
        _playing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Radar Map')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Icon(Icons.map, size: 120, color: Colors.blueGrey),
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: 1.0,
                    duration: const Duration(milliseconds: 400),
                    child: Center(
                      child: Icon(
                        Icons.blur_on,
                        size: 120,
                        color: Colors.blue.withOpacity(0.2 + 0.13 * _currentFrame),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 16,
                    top: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('Frame ${_currentFrame + 1}/$_totalFrames'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                IconButton(
                  icon: Icon(_playing ? Icons.pause : Icons.play_arrow),
                  onPressed: _playPause,
                ),
                Expanded(
                  child: Slider(
                    value: _currentFrame.toDouble(),
                    min: 0,
                    max: (_totalFrames - 1).toDouble(),
                    divisions: _totalFrames - 1,
                    label: 'Frame ${_currentFrame + 1}',
                    onChanged: (value) {
                      setState(() {
                        _currentFrame = value.toInt();
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text('Radar animation (mocked, ready for real data integration)', style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
} 