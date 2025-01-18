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
  final List<String> _statusOptions = ['Active', 'Inactive', 'Maintenance', 'Out of Service'];

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
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          widget.vehicle == null ? 'Add Vehicle' : 'Edit Vehicle',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: theme.dividerColor.withOpacity(0.1),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vehicle Information',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Vehicle Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.directions_car),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _statusController.text.isEmpty ? _statusOptions[0] : _statusController.text,
                      decoration: InputDecoration(
                        labelText: 'Status',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.info_outline),
                      ),
                      items: _statusOptions.map((String status) {
                        return DropdownMenuItem<String>(
                          value: status,
                          child: Text(status),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _statusController.text = newValue;
                          });
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a status';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: theme.dividerColor.withOpacity(0.1),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vehicle Status',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildLevelIndicator(
                      'Fuel Level',
                      _fuelLevel,
                      Icons.local_gas_station,
                      Colors.blue,
                      (value) => setState(() => _fuelLevel = value),
                    ),
                    const SizedBox(height: 24),
                    _buildLevelIndicator(
                      'Battery Level',
                      _batteryLevel,
                      Icons.battery_charging_full,
                      Colors.green,
                      (value) => setState(() => _batteryLevel = value),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text(
                widget.vehicle == null ? 'Add Vehicle' : 'Update Vehicle',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelIndicator(
    String label,
    double value,
    IconData icon,
    Color color,
    ValueChanged<double> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const Spacer(),
            Text(
              '${(value * 100).toInt()}%',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: color,
            inactiveTrackColor: color.withOpacity(0.1),
            thumbColor: color,
            overlayColor: color.withOpacity(0.2),
          ),
          child: Slider(
            value: value,
            onChanged: onChanged,
          ),
        ),
      ],
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
