import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/location_provider.dart';
import '../widget/google_map_widget.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LocationProvider>().startLocationTracking();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa en Tiempo Real'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<LocationProvider>().getCurrentLocation();
            },
          ),
        ],
      ),
      body: Consumer<LocationProvider>(
        builder: (context, locationProvider, child) {
          if (locationProvider.isLoading && !locationProvider.hasLocation) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Obteniendo ubicación...'),
                ],
              ),
            );
          }

          if (locationProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${locationProvider.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      locationProvider.startLocationTracking();
                    },
                    child: const Text('Intentar de nuevo'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Información de ubicación
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: Theme.of(context).colorScheme.surface,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ubicación Actual',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    if (locationProvider.currentLocation != null) ...[
                      Text(
                        'Latitud: ${locationProvider.currentLocation!.latitude.toStringAsFixed(6)}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        'Longitud: ${locationProvider.currentLocation!.longitude.toStringAsFixed(6)}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      if (locationProvider.currentLocation!.accuracy != null)
                        Text(
                          'Precisión: ${locationProvider.currentLocation!.accuracy!.toStringAsFixed(1)} m',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      if (locationProvider.address != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Dirección: ${locationProvider.address!}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                    ] else
                      const Text('Sin ubicación disponible'),
                  ],
                ),
              ),
              // Mapa
              Expanded(
                child: GoogleMapWidget(
                  currentLocation: locationProvider.currentLocation,
                  onLocationButtonPressed: () {
                    locationProvider.getCurrentLocation();
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
