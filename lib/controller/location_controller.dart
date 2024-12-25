import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class LocationController extends GetxController {
  var currentPosition = const LatLng(0.0, 0.0).obs;
  var markers = <Marker>[].obs;
  late GoogleMapController mapController;
  var isTrackingEnabled = true.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeLocationTracking();
  }

  Future<void> _initializeLocationTracking() async {
    await _handlePermissions();

    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high, distanceFilter: 100),
    ).listen((Position? position) {
      if (isTrackingEnabled.value && position != null) {
        currentPosition.value = LatLng(position.latitude, position.longitude);
        _addMarker(currentPosition.value);
      }
    });
  }

  void setMapController(GoogleMapController controller) {
    mapController = controller;
  }

  void _addMarker(LatLng position) {
    markers.add(
      Marker(
        markerId: MarkerId(position.toString()),
        position: position,
        onTap: () => _showAddressDialog(position),
      ),
    );
  }

  Future<void> _showAddressDialog(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        String address = "${placemark.street}, ${placemark.locality}, "
            "${placemark.administrativeArea}, ${placemark.country}";
        Get.dialog(
          AlertDialog(
            title: const Text("Address Information"),
            content: Text(address),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      Get.dialog(
        AlertDialog(
          title: const Text("Error"),
          content: Text("Address information error: $e"),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text("Close"),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _handlePermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
    } 
  }
}
