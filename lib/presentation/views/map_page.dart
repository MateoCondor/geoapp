import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../presentation/provider/location_provider.dart';
import '../widget/google_map_widget.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final location = context.watch<LocationProvider>().location;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Geolocalización'),
      ),
      body: Column(
        children: [
          const Expanded(child: GoogleMapWidget()),
          if (location != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text('Latitud: ${location.latitude}'),
                  Text('Longitud: ${location.longitude}'),
                ],
              ),
            )
        ],
      ),
    );
  }
}
