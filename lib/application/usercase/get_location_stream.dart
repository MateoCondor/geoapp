import 'dart:async';
import '../../domain/entitie/location.dart';
import '../../data/repository/location_repository_impl.dart';

class GetLocationStream {
  final LocationRepository _repository;

  GetLocationStream(this._repository);

  Future<bool> execute() async {
    // Verificar si el servicio de ubicación está habilitado
    final isEnabled = await _repository.isLocationServiceEnabled();
    if (!isEnabled) {
      throw Exception('El servicio de ubicación está deshabilitado');
    }

    // Solicitar permisos
    final hasPermission = await _repository.requestPermissions();
    if (!hasPermission) {
      throw Exception('Permisos de ubicación denegados');
    }

    return true;
  }

  Stream<Location> call() {
    return _repository.getLocationStream();
  }

  Future<Location> getCurrentLocation() async {
    return await _repository.getCurrentLocation();
  }
}