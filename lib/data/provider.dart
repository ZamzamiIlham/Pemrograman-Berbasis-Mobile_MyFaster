import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationData {
  final String currentAddress;
  final String destinationAddress;
  final double distanceInMeters;

  LocationData({
    required this.currentAddress,
    required this.destinationAddress,
    required this.distanceInMeters,
  });
}

class LocationService {
  static final LocationService _instance = LocationService._internal();

  factory LocationService() {
    return _instance;
  }

  LocationService._internal();

  LocationData? _locationData;

  LocationData? get locationData => _locationData;

  Future<void> updateLocationData(LocationData data) async {
    _locationData = data;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentAddress', data.currentAddress);
    await prefs.setString('destinationAddress', data.destinationAddress);
    await prefs.setDouble('distanceInMeters', data.distanceInMeters);
  }

  Future<void> restoreLocationData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? currentAddress = prefs.getString('currentAddress');
    String? destinationAddress = prefs.getString('destinationAddress');
    double? distanceInMeters = prefs.getDouble('distanceInMeters');
    if (currentAddress != null &&
        destinationAddress != null &&
        distanceInMeters != null) {
      _locationData = LocationData(
        currentAddress: currentAddress,
        destinationAddress: destinationAddress,
        distanceInMeters: distanceInMeters,
      );
    }
  }
}
