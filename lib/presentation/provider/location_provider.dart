import 'package:flutter/material.dart';
import '../../domain/entitie/location.dart';
import '../../application/usercase/get_location_stream.dart';

class LocationProvider with ChangeNotifier {
  final GetLocationStream getLocationStream;

  LocationProvider(this.getLocationStream) {
    _listenToLocation();
  }

  Location? _location;
  Location? get location => _location;

  void _listenToLocation() {
    getLocationStream().listen((newLocation) {
      _location = newLocation;
      notifyListeners();
    });
  }
}
