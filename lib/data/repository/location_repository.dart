import '../../domain/entitie/location.dart';

abstract class LocationRepository {
  Stream<Location> getLocationStream();
}
