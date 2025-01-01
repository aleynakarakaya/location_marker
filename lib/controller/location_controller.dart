import 'package:flutter/material.dart';
import 'package:background_location/background_location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location_marker/config/constants.dart';

class LocationController extends GetxController {
  var currentPosition = const LatLng(0.0, 0.0).obs;
  var markers = <Marker>[].obs;
  late GoogleMapController mapController;
  var isTrackingEnabled = false.obs;
  Rx<LocationPermission> locationPermissionStatus =
      LocationPermission.denied.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeLocationTracking();
  }

  Future<void> _initializeLocationTracking() async {
    await handlePermissions();

    if (isTrackingEnabled.value) {
      if (locationPermissionStatus.value != LocationPermission.whileInUse) {
        BackgroundLocation.startLocationService();
      }
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
  }

  void setMapController(GoogleMapController controller) {
    mapController = controller;
  }

  void clearMarkers() {
    markers.clear();
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
            title: const Text(StringConstants.addressInformation),
            content: Text(address),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text(StringConstants.ok),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      Get.dialog(
        AlertDialog(
          title: const Text(StringConstants.error),
          content: Text("${StringConstants.addressInformationError}: $e"),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text(StringConstants.close),
            ),
          ],
        ),
      );
    }
  }

  void toggleTracking() {
    isTrackingEnabled.toggle();

    if (locationPermissionStatus.value != LocationPermission.whileInUse) {
      if (isTrackingEnabled.value) {
        BackgroundLocation.startLocationService();
      } else {
        BackgroundLocation.stopLocationService();
      }
    }
  }

  Future<void> handlePermissions() async {
    locationPermissionStatus.value = await Geolocator.checkPermission();
    if (locationPermissionStatus.value == LocationPermission.denied) {
      locationPermissionStatus.value = await Geolocator.requestPermission();
    }

    if (locationPermissionStatus.value == LocationPermission.always ||
        locationPermissionStatus.value == LocationPermission.whileInUse) {
      isTrackingEnabled.value = true;
    }
  }

  Future<void> openSettings() async {
    await Geolocator.openAppSettings();
  }
}
