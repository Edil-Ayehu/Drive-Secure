class Vehicle {
  final String id;
  final String name;
  final String status;
  final double fuelLevel;
  final double batteryLevel;
  final Map<String, double> lastLocation; // {latitude, longitude}
  final DateTime lastUpdated;
  final String userId;
  final String? imageUrl;

  Vehicle({
    required this.id,
    required this.name,
    required this.status,
    required this.fuelLevel,
    required this.batteryLevel,
    required this.lastLocation,
    required this.lastUpdated,
    this.userId = '',
    this.imageUrl,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      fuelLevel: json['fuelLevel'].toDouble(),
      batteryLevel: json['batteryLevel'].toDouble(),
      lastLocation: Map<String, double>.from(json['lastLocation']),
      lastUpdated: DateTime.parse(json['lastUpdated']),
      userId: json['userId'] as String? ?? '',
       imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'fuelLevel': fuelLevel,
      'batteryLevel': batteryLevel,
      'lastLocation': lastLocation,
      'lastUpdated': lastUpdated.toIso8601String(),
      'userId': userId,
      'imageUrl': imageUrl,
    };
  }
}
