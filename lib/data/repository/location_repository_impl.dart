import 'dart:async';
import '../../domain/entitie/location.dart';
import '../datasource/location_datasource_impl.dart';

abstract class LocationRepository {
  Future<Location> getCurrentLocation();
  Stream<Location> getLocationStream();
  Future<bool> requestPermissions();
  Future<bool> isLocationServiceEnabled();
}

class LocationRepositoryImpl implements LocationRepository {
  final LocationDatasource _datasource;

  LocationRepositoryImpl(this._datasource);

  @override
  Future<Location> getCurrentLocation() async {
    return await _datasource.getCurrentLocation();
  }

  @override
  Stream<Location> getLocationStream() {
    return _datasource.getLocationStream();
  }

  @override
  Future<bool> requestPermissions() async {
    return await _datasource.requestPermissions();
  }

  @override
  Future<bool> isLocationServiceEnabled() async {
    return await _datasource.isLocationServiceEnabled();
  }
}