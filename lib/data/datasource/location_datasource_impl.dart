import 'dart:async';
import 'package:geolocator/geolocator.dart';
import '../../domain/entitie/location.dart';

abstract class LocationDatasource {
  Future<Location> getCurrentLocation();
  Stream<Location> getLocationStream();
  Future<bool> requestPermissions();
  Future<bool> isLocationServiceEnabled();
}

class LocationDatasourceImpl implements LocationDatasource {
  @override
  Future<Location> getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      return Location(
        latitude: position.latitude,
        longitude: position.longitude,
        timestamp: position.timestamp ?? DateTime.now(),
        accuracy: position.accuracy,
        altitude: position.altitude,
        speed: position.speed,
      );
    } catch (e) {
      throw Exception('Error al obtener la ubicación: $e');
    }
  }

  @override
  Stream<Location> getLocationStream() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Actualizar cada 10 metros
    );

    return Geolocator.getPositionStream(locationSettings: locationSettings)
        .map((position) => Location(
              latitude: position.latitude,
              longitude: position.longitude,
              timestamp: position.timestamp ?? DateTime.now(),
              accuracy: position.accuracy,
              altitude: position.altitude,
              speed: position.speed,
            ));
  }

  @override
  Future<bool> requestPermissions() async {
    LocationPermission permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    
    return permission == LocationPermission.always ||
           permission == LocationPermission.whileInUse;
  }

  @override
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }
}