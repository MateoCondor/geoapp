import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import '../../domain/entitie/location.dart' as my_location;
import '../../application/usercase/get_location_stream.dart';
import '../../data/repository/location_repository_impl.dart';
import '../../data/datasource/location_datasource_impl.dart';

class LocationProvider extends ChangeNotifier {
  final GetLocationStream _getLocationStream;

  my_location.Location? _currentLocation;
  String? _address;
  bool _isLoading = false;
  String? _error;
  StreamSubscription<my_location.Location>? _locationSubscription;

  LocationProvider()
      : _getLocationStream = GetLocationStream(
    LocationRepositoryImpl(LocationDatasourceImpl()),
  );

  // Getters
  my_location.Location? get currentLocation => _currentLocation;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasLocation => _currentLocation != null;
  String? get address => _address;

  // Inicializar seguimiento de ubicación
  Future<void> startLocationTracking() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _getLocationStream.execute();

      final location = await _getLocationStream.getCurrentLocation();
      _currentLocation = location;
      await getAddressFromLocation(location);

      _locationSubscription = _getLocationStream.call().listen(
            (location) async {
          _currentLocation = location;
          await getAddressFromLocation(location);
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

  // Obtener ubicación una sola vez
  Future<void> getCurrentLocation() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _getLocationStream.execute();
      final location = await _getLocationStream.getCurrentLocation();
      _currentLocation = location;
      await getAddressFromLocation(location);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Obtener dirección textual desde coordenadas
  Future<void> getAddressFromLocation(my_location.Location location) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        _address = '${place.street}, ${place.locality}, '
            '${place.administrativeArea}, ${place.country}';
      } else {
        _address = 'Dirección no disponible';
      }
    } catch (e) {
      _address = 'Error al obtener dirección';
    }
    notifyListeners();
  }

  // Detener seguimiento
  void stopLocationTracking() {
    _locationSubscription?.cancel();
    _locationSubscription = null;
  }

  @override
  void dispose() {
    stopLocationTracking();
    super.dispose();
  }
}
