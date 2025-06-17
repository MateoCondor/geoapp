import '../../domain/entitie/location.dart';
import '../../data/repository/location_repository.dart';

class GetLocationStream {
  final LocationRepository repository;

  GetLocationStream(this.repository);

  Stream<Location> call() {
    return repository.getLocationStream();
  }
}
