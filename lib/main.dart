import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

import 'presentation/provider/location_provider.dart';
import 'presentation/views/map_page.dart';
import 'application/usercase/get_location_stream.dart';
import 'data/repository/location_repository_impl.dart';
import 'data/datasource/location_datasource_impl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Geolocator.requestPermission();

  final locationProvider = LocationProvider(
    GetLocationStream(
      LocationRepositoryImpl(LocationDataSourceImpl()),
    ),
  );

  runApp(MyApp(locationProvider));
}

class MyApp extends StatelessWidget {
  final LocationProvider provider;

  const MyApp(this.provider, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: provider,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'GeoApp',
        home: const MapPage(),
      ),
    );
  }
}
