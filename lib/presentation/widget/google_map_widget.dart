import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../domain/entitie/location.dart' as my_location;

class GoogleMapWidget extends StatefulWidget {
  final my_location.Location? currentLocation;
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
  int _customMarkerIdCounter = 1;

  @override
  void didUpdateWidget(covariant GoogleMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentLocation != oldWidget.currentLocation) {
      _updateLocationMarker();
      _animateToLocation();
    }
  }

  void _updateLocationMarker() {
    if (widget.currentLocation != null) {
      final marker = Marker(
        markerId: const MarkerId('current_location'),
        position: LatLng(
          widget.currentLocation!.latitude,
          widget.currentLocation!.longitude,
        ),
        infoWindow: InfoWindow(
          title: 'Mi ubicación',
          snippet:
          'Lat: ${widget.currentLocation!.latitude.toStringAsFixed(6)}, '
              'Lng: ${widget.currentLocation!.longitude.toStringAsFixed(6)}',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueBlue,
        ),
      );

      setState(() {
        _markers.removeWhere((m) => m.markerId.value == 'current_location');
        _markers.add(marker);
      });
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

  void _addCustomMarker(LatLng position) {
    final markerId = MarkerId('custom_marker_$_customMarkerIdCounter');
    _customMarkerIdCounter++;

    final marker = Marker(
      markerId: markerId,
      position: position,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(
        title: 'Marcador personalizado',
        snippet:
        'Lat: ${position.latitude.toStringAsFixed(6)}, Lng: ${position.longitude.toStringAsFixed(6)}',
      ),
    );

    setState(() {
      _markers.add(marker);
    });
  }

  // ✅ NUEVO MÉTODO: eliminar marcadores personalizados (rojos)
  void _clearCustomMarkers() {
    final removedCount = _markers
        .where((marker) => marker.markerId.value.startsWith('custom_marker_'))
        .length;

    setState(() {
      _markers.removeWhere(
              (marker) => marker.markerId.value.startsWith('custom_marker_'));
    });

    if (removedCount > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Se eliminaron $removedCount marcadores personalizados.'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hay marcadores personalizados para eliminar.'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _setMapStyle() async {
    try {
      final style = await DefaultAssetBundle.of(context)
          .loadString('assets/map_style.json');
      _controller?.setMapStyle(style);
    } catch (e) {
      debugPrint('No se pudo cargar el estilo del mapa: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final initialPosition = widget.currentLocation != null
        ? LatLng(
      widget.currentLocation!.latitude,
      widget.currentLocation!.longitude,
    )
        : const LatLng(19.4326, -99.1332); // Ciudad de México por defecto

    return Stack(
      children: [
        GoogleMap(
          onMapCreated: (GoogleMapController controller) {
            _controller = controller;
            _updateLocationMarker();
            _setMapStyle();
          },
          initialCameraPosition: CameraPosition(
            target: initialPosition,
            zoom: 15,
          ),
          markers: _markers,
          onTap: _addCustomMarker,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: true,
          mapToolbarEnabled: false,
        ),
        if (widget.showCurrentLocationButton)
          Positioned(
            bottom: 20,
            right: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  mini: true,
                  onPressed: widget.onLocationButtonPressed,
                  tooltip: 'Centrar ubicación',
                  child: const Icon(Icons.my_location),
                ),
                const SizedBox(height: 10),
                FloatingActionButton(
                  mini: true,
                  onPressed: _clearCustomMarkers,
                  tooltip: 'Eliminar marcadores',
                  backgroundColor: Colors.redAccent,
                  child: const Icon(Icons.delete_forever),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
