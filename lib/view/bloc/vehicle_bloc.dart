import 'package:drive_secure/common/services/firebase_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drive_secure/model/vehicle.dart';

// Events
abstract class VehicleEvent {}

class LoadVehicles extends VehicleEvent {}
class AddVehicle extends VehicleEvent {
  final Vehicle vehicle;
  AddVehicle(this.vehicle);
}
class UpdateVehicle extends VehicleEvent {
  final Vehicle vehicle;
  UpdateVehicle(this.vehicle);
}
class DeleteVehicle extends VehicleEvent {
  final String id;
  DeleteVehicle(this.id);
}

// States
abstract class VehicleState {}

class VehicleInitial extends VehicleState {}
class VehicleLoading extends VehicleState {}
class VehicleLoaded extends VehicleState {
  final List<Vehicle> vehicles;
  VehicleLoaded(this.vehicles);
}
class VehicleError extends VehicleState {
  final String message;
  VehicleError(this.message);
}

// Bloc
class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final FirebaseService _firebaseService;

  VehicleBloc(this._firebaseService) : super(VehicleInitial()) {
    on<LoadVehicles>(_onLoadVehicles);
    on<AddVehicle>(_onAddVehicle);
    on<UpdateVehicle>(_onUpdateVehicle);
    on<DeleteVehicle>(_onDeleteVehicle);
  }

  void _onLoadVehicles(LoadVehicles event, Emitter<VehicleState> emit) {
    _firebaseService.getVehicles().listen(
      (vehicles) => emit(VehicleLoaded(vehicles)),
      onError: (error) => emit(VehicleError(error.toString())),
    );
  }

  Future<void> _onAddVehicle(AddVehicle event, Emitter<VehicleState> emit) async {
    try {
      await _firebaseService.addVehicle(event.vehicle);
    } catch (e) {
      emit(VehicleError(e.toString()));
    }
  }

  Future<void> _onUpdateVehicle(UpdateVehicle event, Emitter<VehicleState> emit) async {
    try {
      await _firebaseService.updateVehicle(event.vehicle);
    } catch (e) {
      emit(VehicleError(e.toString()));
    }
  }

  Future<void> _onDeleteVehicle(DeleteVehicle event, Emitter<VehicleState> emit) async {
    try {
      await _firebaseService.deleteVehicle(event.id);
    } catch (e) {
      emit(VehicleError(e.toString()));
    }
  }
}
