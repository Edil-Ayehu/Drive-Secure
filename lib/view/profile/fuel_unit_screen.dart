import 'package:flutter/material.dart';

class FuelUnitScreen extends StatefulWidget {
  const FuelUnitScreen({super.key});

  @override
  State<FuelUnitScreen> createState() => _FuelUnitScreenState();
}

class _FuelUnitScreenState extends State<FuelUnitScreen> {
  String _selectedUnit = 'Liters'; // Default value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Default Fuel Unit')),
      body: ListView(
        children: [
          RadioListTile<String>(
            title: const Text('Liters'),
            value: 'Liters',
            groupValue: _selectedUnit,
            onChanged: (value) => setState(() => _selectedUnit = value!),
          ),
          RadioListTile<String>(
            title: const Text('Gallons'),
            value: 'Gallons',
            groupValue: _selectedUnit,
            onChanged: (value) => setState(() => _selectedUnit = value!),
          ),
        ],
      ),
    );
  }
}
