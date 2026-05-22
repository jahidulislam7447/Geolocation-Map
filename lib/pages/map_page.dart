import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final List<LatLng> _polylinePoints = [];
  LatLng? _currentLocation;
  Timer? _locationTimer;
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    await _requestLocationPermission();
    await _getCurrentLocation();
    _startLocationUpdates();
  }

  Future<void> _requestLocationPermission() async {
    final status = await Geolocator.requestPermission();
    if (status == LocationPermission.denied ||
        status == LocationPermission.deniedForever) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission is required')),
        );
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });

      if (_isFirstLoad && _currentLocation != null) {
        _animateToCurrentLocation();
        _isFirstLoad = false;
      }

      _updateMarker();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error getting location: $e')),
        );
      }
    }
  }

  void _startLocationUpdates() {
    _locationTimer = Timer.periodic(const Duration(seconds: 10), (_) async {
      await _getCurrentLocation();
    });
  }

  void _animateToCurrentLocation() {
    if (_currentLocation != null && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(_currentLocation!, 18),
      );
    }
  }

  void _updateMarker() {
    if (_currentLocation != null) {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: _currentLocation!,
          infoWindow: InfoWindow(
            title: 'My current location',
            snippet:
                'Lat: ${_currentLocation!.latitude.toStringAsFixed(6)}, Lng: ${_currentLocation!.longitude.toStringAsFixed(6)}',
          ),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );

      // Add current location to polyline points
      _polylinePoints.add(_currentLocation!);
      
      // Update the polyline with all accumulated points
      _updatePolyline();

      setState(() {});
    }
  }

  void _updatePolyline() {
    if (_polylinePoints.length >= 2) {
      _polylines.clear();
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('tracking_polyline'),
          points: List.from(_polylinePoints),
          color: Colors.blue,
          width: 5,
          geodesic: true,
        ),
      );
    }
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geolocator Map Tracker'),
        centerTitle: true,
        elevation: 0,
      ),
      body: _currentLocation == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GoogleMap(
              onMapCreated: (controller) {
                _mapController = controller;
                _animateToCurrentLocation();
              },
              initialCameraPosition: CameraPosition(
                target: _currentLocation ?? const LatLng(0, 0),
                zoom: 15,
              ),
              markers: _markers,
              polylines: _polylines,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: true,
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _animateToCurrentLocation,
        tooltip: 'Animate to current location',
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
