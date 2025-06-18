import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../domain/entitie/location.dart';

class GoogleMapWidget extends StatefulWidget {
  final Location? currentLocation;
  final bool showCurrentLocationButton;
  final VoidCallback? onLocationButtonPressed;

  const GoogleMapWidget({
    super.key,
    this.currentLocation,
    this.showCurrentLocationButton = true,
    this.onLocationButtonPressed,
  });

  @override
  State<GoogleMapWidget> createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  GoogleMapController? _controller;
  Set<Marker> _markers = {};

  @override
  void didUpdateWidget(GoogleMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentLocation != oldWidget.currentLocation) {
      _updateMarkers();
      _animateToLocation();
    }
  }

  void _updateMarkers() {
    if (widget.currentLocation != null) {
      _markers = {
        Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(
            widget.currentLocation!.latitude,
            widget.currentLocation!.longitude,
          ),
          infoWindow: InfoWindow(
            title: 'Mi ubicación',
            snippet: 'Lat: ${widget.currentLocation!.latitude.toStringAsFixed(6)}, '
                    'Lng: ${widget.currentLocation!.longitude.toStringAsFixed(6)}',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      };
    }
  }

  void _animateToLocation() {
    if (_controller != null && widget.currentLocation != null) {
      _controller!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(
            widget.currentLocation!.latitude,
            widget.currentLocation!.longitude,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          onMapCreated: (GoogleMapController controller) {
            _controller = controller;
            _updateMarkers();
          },
          initialCameraPosition: CameraPosition(
            target: widget.currentLocation != null
                ? LatLng(
                    widget.currentLocation!.latitude,
                    widget.currentLocation!.longitude,
                  )
                : const LatLng(19.4326, -99.1332), // Ciudad de México por defecto
            zoom: 15,
          ),
          markers: _markers,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: true,
          mapToolbarEnabled: false,
        ),
        if (widget.showCurrentLocationButton)
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              mini: true,
              onPressed: widget.onLocationButtonPressed,
              child: const Icon(Icons.my_location),
            ),
          ),
      ],
    );
  }
}