import 'dart:async';
import 'package:flutter/material.dart';
import '../../domain/entitie/location.dart';
import '../../application/usercase/get_location_stream.dart';
import '../../data/repository/location_repository_impl.dart';
import '../../data/datasource/location_datasource_impl.dart';

class LocationProvider extends ChangeNotifier {
  final GetLocationStream _getLocationStream;
  
  Location? _currentLocation;
  bool _isLoading = false;
  String? _error;
  StreamSubscription<Location>? _locationSubscription;

  LocationProvider()
      : _getLocationStream = GetLocationStream(
          LocationRepositoryImpl(LocationDatasourceImpl()),
        );

  // Getters
  Location? get currentLocation => _currentLocation;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasLocation => _currentLocation != null;

  // Inicializar seguimiento de ubicación
  Future<void> startLocationTracking() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Verificar permisos y servicios
      await _getLocationStream.execute();
      
      // Obtener ubicación actual
      _currentLocation = await _getLocationStream.getCurrentLocation();
      
      // Iniciar stream de ubicación
      _locationSubscription = _getLocationStream.call().listen(
        (location) {
          _currentLocation = location;
          notifyListeners();
        },
        onError: (error) {
          _error = error.toString();
          notifyListeners();
        },
      );
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Detener seguimiento
  void stopLocationTracking() {
    _locationSubscription?.cancel();
    _locationSubscription = null;
  }

  // Obtener ubicación una sola vez
  Future<void> getCurrentLocation() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _getLocationStream.execute();
      _currentLocation = await _getLocationStream.getCurrentLocation();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    stopLocationTracking();
    super.dispose();
  }
}