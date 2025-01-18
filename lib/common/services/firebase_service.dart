import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_secure/model/vehicle.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _vehiclesCollection = 
      FirebaseFirestore.instance.collection('vehicles');

  String get _userId => _auth.currentUser?.uid ?? '';

  // Create
  Future<void> addVehicle(Vehicle vehicle) async {
    if (_userId.isEmpty) throw Exception('User not authenticated');
    await _vehiclesCollection.doc(vehicle.id).set({
      ...vehicle.toJson(),
      'userId': _userId,
    });
  }

  // Read
  Stream<List<Vehicle>> getVehicles() {
    if (_userId.isEmpty) return Stream.value([]);
    
    return _vehiclesCollection
        .where('userId', isEqualTo: _userId)
        .snapshots()
        .map((snapshot) {
      try {
        return snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
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
    if (_userId.isEmpty) throw Exception('User not authenticated');
    
    final doc = await _vehiclesCollection.doc(vehicle.id).get();
    if (doc.exists && (doc.data() as Map<String, dynamic>)['userId'] != _userId) {
      throw Exception('Not authorized to update this vehicle');
    }
    
    await _vehiclesCollection.doc(vehicle.id).update({
      ...vehicle.toJson(),
      'userId': _userId,
    });
  }

  // Delete
  Future<void> deleteVehicle(String id) async {
    if (_userId.isEmpty) throw Exception('User not authenticated');
    
    final doc = await _vehiclesCollection.doc(id).get();
    if (doc.exists && (doc.data() as Map<String, dynamic>)['userId'] != _userId) {
      throw Exception('Not authorized to delete this vehicle');
    }
    
    await _vehiclesCollection.doc(id).delete();
  }
}
