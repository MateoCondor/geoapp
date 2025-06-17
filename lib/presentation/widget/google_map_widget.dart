import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../presentation/provider/location_provider.dart';

class GoogleMapWidget extends StatelessWidget {
  const GoogleMapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final location = context.watch<LocationProvider>().location;

    if (location == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final LatLng latLng = LatLng(location.latitude, location.longitude);

    return GoogleMap(
      initialCameraPosition: CameraPosition(target: latLng, zoom: 15),
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      markers: {
        Marker(
          markerId: const MarkerId('currentLocation'),
          position: latLng,
        ),
      },
    );
  }
}
