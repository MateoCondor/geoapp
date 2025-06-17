import '../../domain/entitie/location.dart';
import '../../data/repository/location_repository.dart';
import '../datasource/location_datasource_impl.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationDataSourceImpl dataSource;

  LocationRepositoryImpl(this.dataSource);

  @override
  Stream<Location> getLocationStream() {
    return dataSource.getPositionStream().map(
          (position) => Location(
        latitude: position.latitude,
        longitude: position.longitude,
      ),
    );
  }
}
