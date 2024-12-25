import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationController extends GetxController {
  var currentPosition = const LatLng(0.0, 0.0).obs;
  var markers = <Marker>[].obs;
  late GoogleMapController mapController;

  @override
  void onInit() {
    super.onInit();
    _initializeLocationTracking();
  }

  Future<void> _initializeLocationTracking() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationEnabled) {
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

    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high, distanceFilter: 100),
    ).listen((Position? position) {
      if (position != null) {
        currentPosition.value = LatLng(position.latitude, position.longitude);
        markers.add(Marker(
            markerId: MarkerId(position.toString()),
            position: currentPosition.value));
      }
    });
  }

  void setMapController(GoogleMapController controller) {
    mapController = controller;
  }
}
