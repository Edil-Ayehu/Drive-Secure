import 'package:drive_secure/view/bloc/vehicle_bloc.dart';
import 'package:drive_secure/view/vehicle_form_screen.dart';
import 'package:drive_secure/view/widgets/vehicle_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:drive_secure/common/services/auth_service.dart';
import 'package:drive_secure/common/utils/dialog_utils.dart';

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
  final AuthService _authService = AuthService();

  Future<void> _handleLogout() async {
    final confirmed = await DialogUtils.showLogoutConfirmationDialog(context);

    if (confirmed ?? false) {
      try {
        await _authService.signOut();
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/login');
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error logging out: $e')),
        );
      }
    }
  }

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
          style: theme.appBarTheme.titleTextStyle!.copyWith(
            fontSize: 17,
          ),
        ),
        actions: [
          // IconButton(
          //   icon: Icon(
          //     isDarkMode ? Icons.light_mode : Icons.dark_mode,
          //     color: theme.appBarTheme.iconTheme?.color,
          //   ),
          //   onPressed: widget.onThemeToggle,
          // ),
          IconButton(
            icon: Icon(
              Icons.logout,
              color: theme.appBarTheme.iconTheme?.color,
            ),
            onPressed: _handleLogout,
          ),
          // IconButton(
          //   icon: Icon(
          //     Icons.add,
          //     color: theme.appBarTheme.iconTheme?.color,
          //   ),
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => const VehicleFormScreen(),
          //       ),
          //     );
          //   },
          // ),
        ],
      ),
      body: BlocBuilder<VehicleBloc, VehicleState>(
        builder: (context, state) {
          if (state is VehicleLoading) {
            return _buildShimmerLoading(context);
          } else if (state is VehicleError) {
            return Center(child: Text(state.message));
          } else if (state is VehicleLoaded) {
            if (state.vehicles.isEmpty) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<VehicleBloc>().add(LoadVehicles());
                },
                child: ListView(
                  children: [_buildEmptyState()],
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<VehicleBloc>().add(LoadVehicles());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.vehicles.length,
                itemBuilder: (context, index) {
                  return VehicleCard(vehicle: state.vehicles[index]);
                },
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              context.read<VehicleBloc>().add(LoadVehicles());
            },
            child: ListView(
              children: [_buildEmptyState()],
            ),
          );
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
          child: Column(
            children: [
              // Image placeholder with shimmer
              Shimmer.fromColors(
                baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                  ),
                ),
              ),
              // Content placeholder with shimmer
              Shimmer.fromColors(
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
                            child: _buildShimmerIndicator(),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildShimmerIndicator(),
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
            ],
          ),
        );
      },
    );
  }

  Widget _buildShimmerIndicator() {
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
          height: 6,
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

  Widget _buildEmptyState() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/vehicle.png',
            width: 200,
            height: 200,
            color: Colors.grey.withOpacity(0.5),
          ),
          const SizedBox(height: 24),
          Text(
            'No Vehicles Yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first vehicle to start monitoring',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey,
                ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VehicleFormScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Vehicle'),
            ),
          ),
        ],
      ),
    );
  }
}
