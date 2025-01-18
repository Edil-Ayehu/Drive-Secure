import 'package:drive_secure/view/bloc/vehicle_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drive_secure/model/vehicle.dart';
import 'package:uuid/uuid.dart';

class VehicleFormScreen extends StatefulWidget {
  final Vehicle? vehicle;

  const VehicleFormScreen({super.key, this.vehicle});

  @override
  State<VehicleFormScreen> createState() => _VehicleFormScreenState();
}

class _VehicleFormScreenState extends State<VehicleFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _statusController;
  late double _fuelLevel;
  late double _batteryLevel;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.vehicle?.name);
    _statusController = TextEditingController(text: widget.vehicle?.status);
    _fuelLevel = widget.vehicle?.fuelLevel ?? 1.0;
    _batteryLevel = widget.vehicle?.batteryLevel ?? 1.0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.vehicle == null ? 'Add Vehicle' : 'Edit Vehicle'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Vehicle Name'),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _statusController,
              decoration: const InputDecoration(labelText: 'Status'),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter a status';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            Text('Fuel Level', style: theme.textTheme.titleMedium),
            Slider(
              value: _fuelLevel,
              onChanged: (value) => setState(() => _fuelLevel = value),
            ),
            const SizedBox(height: 16),
            Text('Battery Level', style: theme.textTheme.titleMedium),
            Slider(
              value: _batteryLevel,
              onChanged: (value) => setState(() => _batteryLevel = value),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text(widget.vehicle == null ? 'Add Vehicle' : 'Update Vehicle'),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final vehicle = Vehicle(
        id: widget.vehicle?.id ?? const Uuid().v4(),
        name: _nameController.text,
        status: _statusController.text,
        fuelLevel: _fuelLevel,
        batteryLevel: _batteryLevel,
        lastLocation: widget.vehicle?.lastLocation ?? 
            {'latitude': 0.0, 'longitude': 0.0},
        lastUpdated: DateTime.now(),
      );

      if (widget.vehicle == null) {
        context.read<VehicleBloc>().add(AddVehicle(vehicle));
      } else {
        context.read<VehicleBloc>().add(UpdateVehicle(vehicle));
      }

      Navigator.pop(context);
    }
  }
}
