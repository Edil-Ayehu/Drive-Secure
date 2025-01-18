import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_secure/model/vehicle.dart';

class FirebaseService {
  final CollectionReference _vehiclesCollection = 
      FirebaseFirestore.instance.collection('vehicles');

  // Create
  Future<void> addVehicle(Vehicle vehicle) async {
    await _vehiclesCollection.doc(vehicle.id).set(vehicle.toJson());
  }

  // Read
Stream<List<Vehicle>> getVehicles() {
  return _vehiclesCollection.snapshots().map((snapshot) {
    try {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Ensure ID is included
        return Vehicle.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error parsing vehicles: $e');
      return <Vehicle>[];
    }
  });
}

  // Update
  Future<void> updateVehicle(Vehicle vehicle) async {
    await _vehiclesCollection.doc(vehicle.id).update(vehicle.toJson());
  }

  // Delete
  Future<void> deleteVehicle(String id) async {
    await _vehiclesCollection.doc(id).delete();
  }
}
