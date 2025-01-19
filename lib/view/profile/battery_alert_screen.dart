import 'package:flutter/material.dart';

class BatteryAlertScreen extends StatefulWidget {
  const BatteryAlertScreen({super.key});

  @override
  State<BatteryAlertScreen> createState() => _BatteryAlertScreenState();
}

class _BatteryAlertScreenState extends State<BatteryAlertScreen> {
  double _threshold = 20.0; // Default value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Battery Alert Threshold')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Alert me when battery is below ${_threshold.round()}%',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Slider(
              value: _threshold,
              min: 5,
              max: 50,
              divisions: 45,
              label: '${_threshold.round()}%',
              onChanged: (value) => setState(() => _threshold = value),
            ),
          ],
        ),
      ),
    );
  }
}