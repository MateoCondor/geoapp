import 'package:geolocator/geolocator.dart';

class LocationDataSourceImpl {
  Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 10, // actualiza cada 10m
      ),
    );
  }
}
