import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_marker/controller/location_controller.dart';

class LocationPage extends StatelessWidget {
  LocationPage({super.key});

  final LocationController locationController = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return GoogleMap(
          initialCameraPosition: CameraPosition(
              target: locationController.currentPosition.value, zoom: 14.0),
              onMapCreated: locationController.setMapController,
              markers: Set<Marker>.of(locationController.markers),
              myLocationEnabled: true,
        );
      }),
    );
  }
}
