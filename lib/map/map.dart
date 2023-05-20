import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class MyLocationScreen extends StatefulWidget {
  @override
  _MyLocationScreenState createState() => _MyLocationScreenState();
}

class _MyLocationScreenState extends State<MyLocationScreen> {
  late GoogleMapController _mapController;
  late Position _currentPosition;
  Set<Marker> _markers = {};

  String _destinationAddress = '';
  double _distanceInMeters = 0.0;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return;
    }

    // Check if location permission is granted
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print(
          'Location permissions are permanently denied, we cannot request permissions.');
      return;
    }

    // Get the current position
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
      _markers.add(
        Marker(
          markerId: MarkerId('currentLocation'),
          position: LatLng(position.latitude, position.longitude),
        ),
      );
    });

    // Move the map camera to the current location
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 15,
        ),
      ),
    );
  }

  void _setDestinationLocation(LatLng destinationCoordinates) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      destinationCoordinates.latitude,
      destinationCoordinates.longitude,
    );

    if (placemarks.isNotEmpty) {
      Placemark destinationPlacemark = placemarks.first;
      setState(() {
        _destinationAddress =
            '${destinationPlacemark.thoroughfare}, ${destinationPlacemark.locality}';
      });

      _markers.add(
        Marker(
          markerId: MarkerId('destinationLocation'),
          position: destinationCoordinates,
          infoWindow: InfoWindow(
            title: 'Destination',
            snippet: _destinationAddress,
          ),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    }

    // Calculate the distance between current location and destination
    double distance = await Geolocator.distanceBetween(
      _currentPosition.latitude,
      _currentPosition.longitude,
      destinationCoordinates.latitude,
      destinationCoordinates.longitude,
    );

    setState(() {
      _distanceInMeters = distance;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Location'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(0, 0),
            ),
            markers: _markers,
            onMapCreated: (controller) {
              _mapController = controller;
            },
            onTap: (position) {
              setState(() {
                _markers.removeWhere(
                    (marker) => marker.markerId.value == 'destinationLocation');
              });
              _setDestinationLocation(position);
            },
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lokasi Tujuan: $_destinationAddress',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Jarak: ${_distanceInMeters.toStringAsFixed(2)} meters',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
