import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myfaster/data/provider.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';

class MyLocationScreen extends StatefulWidget {
  @override
  _MyLocationScreenState createState() => _MyLocationScreenState();
}

class _MyLocationScreenState extends State<MyLocationScreen> {
  late GoogleMapController _mapController;
  late Position _currentPosition;
  Set<Marker> _markers = {};

  String _currentAddres = '';
  String _destinationAddress = '';
  double _distanceInMeters = 0.0;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _restoreDestinationAddress();
  }

  void _restoreDestinationAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? currentAddress = prefs.getString('currentAddress');
    String? destinationAddress = prefs.getString('destinationAddress');
    double? distanceInMeters = prefs.getDouble('distanceInMeters');
    if (currentAddress != null &&
        destinationAddress != null &&
        distanceInMeters != null) {
      setState(() {
        _currentAddres = currentAddress;
        _destinationAddress = destinationAddress;
        _distanceInMeters = distanceInMeters;
      });
      LocationData locationData = LocationData(
        currentAddress: _currentAddres,
        destinationAddress: _destinationAddress,
        distanceInMeters: _distanceInMeters,
      );

      LocationService().updateLocationData(locationData);
    }
  }

  void _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    //Melakukan pengecekan jika gps disable
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return;
    }

    //Melakukan pengecekam
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

    //Mencari lokasi saat ini
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks != null && placemarks.isNotEmpty) {
      Placemark placemark = placemarks[0];
      String city = placemark.locality ?? '';
      String state = placemark.administrativeArea ?? '';
      String country = placemark.country ?? '';

      String currentAddress = ' $city, $state, $country';

      setState(() {
        _currentPosition = position;
        _markers.add(
          Marker(
            markerId: MarkerId('currentLocation'),
            position: LatLng(position.latitude, position.longitude),
          ),
        );
        _currentAddres = currentAddress;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('currentAddress', _currentAddres);
    }
    // Berpindah ke lokasi saat ini
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

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('destinationAddress', _destinationAddress);

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

    // Menghitung selisis jarak lokasi saat ini dan lokasi tujuan
    double distance = await Geolocator.distanceBetween(
      _currentPosition.latitude,
      _currentPosition.longitude,
      destinationCoordinates.latitude,
      destinationCoordinates.longitude,
    );

    // Menghitung harga berdasarkan jarak
    double pricePerKm = 2500; // Harga per kilometer
    double totalPrice = (distance / 1000) * pricePerKm; // Harga total
    totalPrice = double.parse(
        totalPrice.toStringAsFixed(2)); // Batasi 2 angka di belakang koma

    setState(() {
      _distanceInMeters = distance;
    });

    //simpan jarak ketika halaman keluar dari map
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('distanceInMeters', _distanceInMeters);
    await prefs.setDouble('totalPrice', totalPrice);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text('My Location', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange,
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
                    'Lokasi Sekarang: $_currentAddres',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
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
                  SizedBox(height: 8),
                  FutureBuilder<SharedPreferences>(
                    future: SharedPreferences.getInstance(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        SharedPreferences prefs = snapshot.data!;
                        return Text(
                          'Harga: ${prefs.getDouble('totalPrice')?.toStringAsFixed(2) ?? '0'} IDR',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        );
                      } else {
                        return SizedBox();
                      }
                    },
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
