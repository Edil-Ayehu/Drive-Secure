import 'package:drive_secure/model/vehicle.dart';
import 'package:drive_secure/view/bloc/vehicle_bloc.dart';
import 'package:drive_secure/view/vehicle_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class DashboardScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;

  const DashboardScreen({
    super.key,
    required this.onThemeToggle,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<VehicleBloc>().add(LoadVehicles());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: Text(
          'Vehicle Monitor',
          style: theme.appBarTheme.titleTextStyle,
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: theme.appBarTheme.iconTheme?.color,
            ),
            onPressed: widget.onThemeToggle,
          ),
          IconButton(
            icon: Icon(
              Icons.add,
              color: theme.appBarTheme.iconTheme?.color,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const VehicleFormScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<VehicleBloc, VehicleState>(
        builder: (context, state) {
          if (state is VehicleLoading) {
            return _buildShimmerLoading(context);
          } else if (state is VehicleError) {
            return Center(child: Text(state.message));
          } else if (state is VehicleLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.vehicles.length,
              itemBuilder: (context, index) {
                return VehicleCard(vehicle: state.vehicles[index]);
              },
            );
          }
          return const Center(child: Text('No vehicles found'));
        },
      ),
    );
  }

  Widget _buildShimmerLoading(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Card(
          elevation: theme.cardTheme.elevation,
          shape: theme.cardTheme.shape,
          child: Shimmer.fromColors(
            baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
            highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 180,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Container(
                        width: 80,
                        height: 32,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildShimmerIndicator(
                          'Fuel Level',
                          Icons.local_gas_station,
                          Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildShimmerIndicator(
                          'Battery',
                          Icons.battery_charging_full,
                          Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: 220,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmerIndicator(String label, IconData icon, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Container(
              width: 70,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 35,
          height: 16,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}

class VehicleCard extends StatelessWidget {
  final Vehicle vehicle;

  const VehicleCard({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isActive = vehicle.status == 'Active';
    final statusColor = isActive ? Colors.green : Colors.red;

    return Card(
      elevation: theme.cardTheme.elevation,
      shape: theme.cardTheme.shape,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VehicleFormScreen(vehicle: vehicle),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    vehicle.name,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      vehicle.status,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildStatusIndicator(
                      context,
                      'Fuel Level',
                      vehicle.fuelLevel,
                      Icons.local_gas_station,
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatusIndicator(
                      context,
                      'Battery',
                      vehicle.batteryLevel,
                      Icons.battery_charging_full,
                      Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Last Updated: ${_formatDateTime(vehicle.lastUpdated)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(
    BuildContext context,
    String label,
    double value,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: value,
          backgroundColor: color.withOpacity(0.1),
          valueColor: AlwaysStoppedAnimation<Color>(color),
          borderRadius: BorderRadius.circular(10),
        ),
        const SizedBox(height: 4),
        Text(
          '${(value * 100).toInt()}%',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
  }
}
